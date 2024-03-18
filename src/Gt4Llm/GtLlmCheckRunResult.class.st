Class {
	#name : #GtLlmCheckRunResult,
	#superclass : #Object,
	#instVars : [
		'checkers',
		'results',
		'threadMessage'
	],
	#category : #'Gt4Llm-Checker'
}

{ #category : #accessing }
GtLlmCheckRunResult >> addResult: aResult for: aChecker [
	self results at: aChecker put: aResult
]

{ #category : #accessing }
GtLlmCheckRunResult >> asString [
	^ self prefix
		, '
Output of checks:
'
		, ({Character lf.
				Character lf}
				join: (self checkers
						collect: [ :aChecker | 
							aChecker checkName
								, ':
' , (self results at: aChecker) asString ]))
]

{ #category : #accessing }
GtLlmCheckRunResult >> checkers [
	^ checkers
]

{ #category : #accessing }
GtLlmCheckRunResult >> checkers: anObject [
	checkers := anObject.
	self resetResults
]

{ #category : #accessing }
GtLlmCheckRunResult >> executionResult [
	<return: #GtLlmCheckerResult>
	^ self results at: self checkers executor
]

{ #category : #accessing }
GtLlmCheckRunResult >> executionResultObject [
	^ self executionResult content
]

{ #category : #accessing }
GtLlmCheckRunResult >> gtCheckersFor: aView [
	<gtView>
	^ aView forward
		title: 'Checkers';
		priority: 3;
		object: [ self checkers ];
		view: #gtCheckersFor:
]

{ #category : #accessing }
GtLlmCheckRunResult >> gtErrorsFor: aView [
	<gtView>
	self hasErrors ifFalse: [ ^ aView empty ].

	^ aView columnedList
		title: 'Errors';
		priority: 1;
		items: [ self checkers select: [ :aChecker | (self results at: aChecker) isError ] ];
		column: 'Check' text: #checkName;
		column: 'Exception'
			text: [ :aChecker | 
				| state |
				state := self results at: aChecker.
				state content ];
		send: [ :aChecker | self results at: aChecker ]
]

{ #category : #accessing }
GtLlmCheckRunResult >> gtExecutionResultFor: aView [
	<gtView>
	self hasErrors ifTrue: [ ^ aView empty ].

	^ aView forward
		title: 'Execution result';
		priority: 1;
		object: [ self executionResultObject ];
		view: #gtLiveFor:;
		actionButtonIcon: BrGlamorousVectorIcons inspect
			tooltip: 'Inspect result'
			action: [ :aButton | aButton phlow spawnObject: self executionResultObject ]
]

{ #category : #accessing }
GtLlmCheckRunResult >> gtResultsFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Results';
		priority: 2;
		items: [ self checkers ];
		column: 'Check' text: #checkName;
		column: 'State'
			stencil: [ :aChecker | 
				| state |
				state := self results at: aChecker.
				state asElement margin: (BlInsets left: 2) ]
			weight: 0.5;
		send: [ :aChecker | self results at: aChecker ]
]

{ #category : #accessing }
GtLlmCheckRunResult >> gtSendFor: anAction [
	<gtAction>
	self threadMessage ifNil: [ ^ anAction noAction ].

	^ anAction button
		priority: 1;
		icon: BrGlamorousVectorIcons play;
		tooltip: 'Send to chat';
		action: [ self sendToChat ]
]

{ #category : #accessing }
GtLlmCheckRunResult >> hasErrors [
	^ self results values anySatisfy: #isError
]

{ #category : #accessing }
GtLlmCheckRunResult >> lastResult [
	<return: #GtLlmCheckerResult>
	| aChecker |
	aChecker := self checkers reversed
			detect: [ :anotherChecker | (self results at: anotherChecker) isExecuted ]
			ifNone: [ self checkers first ].
	^ self results at: aChecker
]

{ #category : #accessing }
GtLlmCheckRunResult >> prefix [
	^ self hasErrors
		ifTrue: [ GtLlmCheckerError prefix ]
		ifFalse: [ GtLlmCheckerSuccess prefix ]
]

{ #category : #accessing }
GtLlmCheckRunResult >> resetResults [
	self
		results: (self checkers
				collect: [ :aChecker | aChecker -> (GtLlmCheckerNotExecuted new checker: aChecker) ])
				asDictionary
]

{ #category : #accessing }
GtLlmCheckRunResult >> results [
	^ results
]

{ #category : #accessing }
GtLlmCheckRunResult >> results: anObject [
	results := anObject
]

{ #category : #accessing }
GtLlmCheckRunResult >> sendToChat [
	self threadMessage chat sendMessage: self asString
]

{ #category : #accessing }
GtLlmCheckRunResult >> threadMessage [
	^ threadMessage
]

{ #category : #accessing }
GtLlmCheckRunResult >> threadMessage: anObject [
	threadMessage := anObject
]
