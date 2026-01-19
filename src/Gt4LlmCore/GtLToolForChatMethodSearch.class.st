Class {
	#name : #GtLToolForChatMethodSearch,
	#superclass : #GtLAbstractFunctionTool,
	#instVars : [
		'provider'
	],
	#category : #'Gt4LlmCore-Tools'
}

{ #category : #'as yet unclassified' }
GtLToolForChatMethodSearch class >> leJsonV4Name [
	^ #gtLToolForChatMethodSearch
]

{ #category : #'as yet unclassified' }
GtLToolForChatMethodSearch >> chat [
	| chat |
	chat := GtLChat new.
	provider ifNotNil: [ chat provider: provider ].
	chat
		addResponseFormatForMagrite: GtLPharoScript named: 'PharoScript';
		lepiterExplanations: #('Querying with GT search filters by example').
	^ chat
]

{ #category : #'as yet unclassified' }
GtLToolForChatMethodSearch >> description [
	^ 'Search for methods that match a searchPrompt.
	
Examples can be:

```
methods that are in {{gtClass:BlElement}} and also refer to `assert:description:`
```

```
methods that are annotated with `gtView` pragmas
```'
]

{ #category : #'as yet unclassified' }
GtLToolForChatMethodSearch >> name [
	^ 'promptedMethodSearch'
]

{ #category : #'as yet unclassified' }
GtLToolForChatMethodSearch >> parameters [
	^ #('searchPrompt')
]

{ #category : #'as yet unclassified' }
GtLToolForChatMethodSearch >> privatePerformToolCall: aToolCall [
	| argument chat semaphore timeout |
	argument := aToolCall arguments anyOne.
	chat := self chat.
	semaphore := Semaphore new.
	chat announcer
		when: GtLlmThreadRunIsDoneAnnouncement
		send: #signal
		to: semaphore.
	chat
		sendWith: [ :msg | 
			msg
				markdown: 'Produce a PharoScript with the following search filter: ' , argument ].	"weak"
	timeout := semaphore waitTimeoutSeconds: 120.
	chat announcer unsubscribe: semaphore.
	timeout
		ifTrue: [ ^ GtLProblemDomainObject new
				description: 'Could not produce a PharoScript with a search filter on time' ].

	[ | filter result promise |
	filter := Object compiler
			evaluate: (chat messages last finalMessage responseModels at: 'PharoScript') content.
	promise := filter result toArray
			await: GtLSettings futureExecutionConfiguration.
	result := promise wait.
	^ GtLMethodsDomainObject new
		methods: (result first: (100 min: result size));
		mayHaveMore: result size > 100 ]
		on: Error
		do: [ :anException | ^ GtLExceptionDomainObject new freeze: anException ]
]

{ #category : #'as yet unclassified' }
GtLToolForChatMethodSearch >> provider: aProvider [ 
	"useful for stubbing purposes"
	provider := aProvider
]
