"
Reusable bounded retry policy. Equal jitter is applied to a capped exponential delay; a server-provided minimum is never capped. Each execution has its own retry counter. Inject random and wait blocks for deterministic, non-sleeping examples.
"
Class {
	#name : #GtLExponentialBackoff,
	#superclass : #Object,
	#instVars : [
		'initialDelay',
		'maximumDelay',
		'maxRetries',
		'randomBlock',
		'waitBlock'
	],
	#category : #'Gt4LlmModel-Client'
}

{ #category : #calculating }
GtLExponentialBackoff >> delayForRetry: retryNumber minimum: minimumSeconds [
	"Equal jitter: half the capped exponential delay plus up to another half.
	Server minima are floors, not subject to the exponential cap. Add jitter above
	the floor so clients do not all wake at the reset instant. Retry numbers start at 1."

	| exponential half sample |
	self assert: (retryNumber isInteger and: [ retryNumber > 0 ]).
	exponential := initialDelay.
	2
		to: retryNumber
		do: [ :index | exponential := exponential * 2 min: maximumDelay ].
	half := exponential / 2.
	sample := randomBlock value.
	self assert: (sample isNumber and: [ sample >= 0 and: [ sample <= 1 ] ]).
	^ (half max: (minimumSeconds max: 0)) + (half * sample)
]

{ #category : #executing }
GtLExponentialBackoff >> execute: anOperation on: anExceptionClass retryIf: retryPredicate minimumDelay: minimumBlock [
	"Retry only exceptions accepted by the caller. Exhaustion passes the last
	exception unchanged. All counters are local to this execution."

	| retries |
	retries := 0.
	^ [ anOperation value ]
		on: anExceptionClass
		do: [ :error | 
			((retryPredicate value: error) and: [ retries < maxRetries ])
				ifFalse: [ error pass ].
			retries := retries + 1.
			waitBlock
				value: (self delayForRetry: retries minimum: (minimumBlock value: error)).
			error retry ]
]

{ #category : #accessing }
GtLExponentialBackoff >> initialDelay: seconds [
	self
		assert: (seconds isNumber and: [ seconds > 0 and: [ seconds <= maximumDelay ] ]).
	initialDelay := seconds
]

{ #category : #initialization }
GtLExponentialBackoff >> initialize [
	| random |
	super initialize.
	initialDelay := 1.
	maximumDelay := 60.
	maxRetries := 5.
	random := Random new.
	randomBlock := [ random next ].
	waitBlock := [ :seconds | (Delay forMilliseconds: (seconds * 1000) ceiling) wait ]
]

{ #category : #accessing }
GtLExponentialBackoff >> maxRetries: anInteger [
	self assert: (anInteger isInteger and: [ anInteger >= 0 ]).
	maxRetries := anInteger
]

{ #category : #accessing }
GtLExponentialBackoff >> maximumDelay: seconds [
	self assert: (seconds isNumber and: [ seconds >= initialDelay ]).
	maximumDelay := seconds
]

{ #category : #accessing }
GtLExponentialBackoff >> randomBlock: aBlock [
	randomBlock := aBlock
]

{ #category : #accessing }
GtLExponentialBackoff >> waitBlock: aBlock [
	waitBlock := aBlock
]
