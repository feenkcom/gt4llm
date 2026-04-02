Class {
	#name : #GtLToolForChatMethodSearch,
	#superclass : #GtLAbstractMagritteFunctionTool,
	#instVars : [
		'provider'
	],
	#category : 'Gt4LlmCore-Tools'
}

{ #category : #'as yet unclassified' }
GtLToolForChatMethodSearch >> chat [
	| chat |
	chat := GtLChat new.
	provider ifNotNil: [ chat provider: provider ].
	chat
		addResponseFormatForMagritte: GtLPharoScript named: 'PharoScript';
		pageExplanation: 'Querying with GT search filters by example'.
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

{ #category : #accessing }
GtLToolForChatMethodSearch >> isUsingDataViews [
	^ true
]

{ #category : #'as yet unclassified' }
GtLToolForChatMethodSearch >> name [
	^ 'promptedMethodSearch'
]

{ #category : #private }
GtLToolForChatMethodSearch >> privatePerformToolCall: aToolCall inContext: anExecutionContext [
	| argument chat semaphore timeout |
	argument := aToolCall arguments anyOne.
	chat := self chat.
	aToolCall at: #innerChat putRuntimeValue: chat.
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
	^ GtLMethodsSearchResult fromReferences: (result first: (100 min: result size)) ]
		on: Error
		do: [ :anException | ^ GtLExceptionDomainObject freeze: anException ]
]

{ #category : #'as yet unclassified' }
GtLToolForChatMethodSearch >> provider: aProvider [ 
	"useful for stubbing purposes"
	provider := aProvider
]

{ #category : #'as yet unclassified' }
GtLToolForChatMethodSearch >> searchPromptDescription [
	<magritteDescription>

	^ MAStringDescription new
		label: 'Search prompt';
		accessor: #searchPrompt;
		beRequired
]
