Class {
	#name : #GtLToolForChatMethodSearch,
	#superclass : #GtLAbstractFunctionTool,
	#category : #'Gt4LlmCore-Tools'
}

{ #category : #'as yet unclassified' }
GtLToolForChatMethodSearch class >> leJsonV4Name [
	^ #gtLToolForChatMethodSearch
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
	chat := GtLChat new
			addResponseFormatForMagrite: GtLPharoScript named: 'PharoScript';
			sendWith: [ :msg | 
				msg
					lepiterExplanations: #('Querying with GT search filters by example');
					markdown: 'Produce a PharoScript with the following search filter:', argument ].	"			markdownResponse;"
	semaphore := Semaphore new.

	chat announcer weak
		when: GtLlmThreadRunIsDoneAnnouncement
		send: #signal
		to: semaphore.
	timeout := semaphore waitTimeoutSeconds: 120.
	chat announcer unsubscribe: semaphore.
	^ timeout not
		ifTrue: [ [ | filter result |
			filter := Object compiler
					evaluate: (chat messages last assistantMessage responseModels at: 'PharoScript') content.
			result := filter result toArray wait collect: #name.
			result isEmpty ifTrue: [ ^ 'No references found' ].
			^ Character cr join: (result first: (100 min: result size)) ]
				on: Error
				do: [ :e | 'Error' ] ]
		ifFalse: [ 'Error' ]
]
