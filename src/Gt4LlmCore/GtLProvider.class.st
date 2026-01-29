Class {
	#name : #GtLProvider,
	#superclass : #Object,
	#instVars : [
		'chat',
		'assistantMessageClass',
		'providerWorking',
		'executionState'
	],
	#category : #'Gt4LlmCore-Core'
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
		priority: 1;
		object: [ self client ];
		view: #gtCallsFor:
]

{ #category : #initialization }
GtLProvider >> initialize [
	super initialize.
	
	"This instance variable should be removed 
	and executionState used instead."
	providerWorking := false.
	
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
	<return: #TAsyncPromise>
	self chat signalRunHasStarted.
	providerWorking := true.
	self executeAsyncMessage: aMessage
]

{ #category : #'api - execution' }
GtLProvider >> state [
	"Provide an information in which state this provider is, e.g, idle, working.
	
	Replaces #status message"

	<return: #GtLProviderState>
	^ executionState
]

{ #category : #accessing }
GtLProvider >> status [
	self deprecated: 'Use #state instead'.

	^ self subclassResponsibility
]

{ #category : #'api - execution' }
GtLProvider >> stopOngoingMessageExecution [
	self privateExecutionState: executionState stop
]
