Class {
	#name : #GtLProvider,
	#superclass : #Object,
	#instVars : [
		'chat',
		'assistantMessageClass',
		'providerWorking',
		'executionState'
	],
	#category : 'Gt4LlmCore-Core'
}

{ #category : #accessing }
GtLProvider class >> defaultProviders [
	^ self allSubclasses
		select: [ :aSubclass | aSubclass class canUnderstand: #default ]
]

{ #category : #testing }
GtLProvider class >> isConnectable [
	^ false
]

{ #category : #accessing }
GtLProvider >> assistantMessageClass [
	^ assistantMessageClass
		ifNil: [ assistantMessageClass := self defaultAssistantMessageClass ]
]

{ #category : #accessing }
GtLProvider >> assistantMessageClass: anObject [
	assistantMessageClass := anObject
]

{ #category : #accessing }
GtLProvider >> chat [
	^ chat
]

{ #category : #accessing }
GtLProvider >> chat: anObject [
	chat := anObject
]

{ #category : #accessing }
GtLProvider >> client [
	^ self subclassResponsibility
]

{ #category : #accessing }
GtLProvider >> compactionPrompt [
	^ 'Compact this chat for later continuation. Summarize:
- The initial and remaining goals
- Essential lessons and decisions
- Open questions
- Next steps'
]

{ #category : #accessing }
GtLProvider >> defaultAssistantMessageClass [
	^ GtLChatMessage
]

{ #category : #accessing }
GtLProvider >> defaultUserMessageClass [
	^ GtLChatMessage
]

{ #category : #'private - execution' }
GtLProvider >> executeAsyncMessage: anInputMessage [
	"Process a given user message."

	<return: #TAsyncPromise>
	^ self subclassResponsibility
]

{ #category : #'gt - extensions' }
GtLProvider >> gtCallsFor: aView [
	<gtView>
	^ aView forward
		title: 'API calls';
		priority: 5;
		object: [ self client ];
		view: #gtCallsFor:
]

{ #category : #initialization }
GtLProvider >> initialize [
	super initialize.
	
	executionState := GtLProviderState idle 
]

{ #category : #'private - notifying' }
GtLProvider >> notifyProviderStateChanged [
	self chat ifNotNil: [ :aChat | aChat signalExecutionStateChanged ]
]

{ #category : #'private - execution' }
GtLProvider >> privateExecutionState: aState [
	executionState = aState ifTrue: [ ^ self ].
	
	executionState := aState.
	self notifyProviderStateChanged
]

{ #category : #'api - execution' }
GtLProvider >> sendMessage: aMessage [
	self executeAsyncMessage: aMessage
]

{ #category : #accessing }
GtLProvider >> sendPromtCompactionMessage [  
	^self chat sendWith: [ :m |
		m
			addResponseFormatForMagritte: GtLChatCompactedSummary named: 'Compaction';
			markdown: self compactionPrompt ].
]

{ #category : #'api - execution' }
GtLProvider >> state [
	"Provide an information in which state this provider is, e.g, idle, working."

	<return: #GtLProviderState>
	^ executionState
]

{ #category : #accessing }
GtLProvider >> status [
	self
		deprecated: 'Please use #state instead.'
		transformWith: '`@receiver status' -> '`@receiver state'.

	^ self state
]

{ #category : #'api - execution' }
GtLProvider >> stopOngoingMessageExecution [
	self privateExecutionState: executionState stop
]
