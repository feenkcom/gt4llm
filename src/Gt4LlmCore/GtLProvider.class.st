Class {
	#name : #GtLProvider,
	#superclass : #Object,
	#instVars : [
		'chat',
		'assistantMessageClass',
		'providerWorking'
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
GtLProvider >> defaultAssistantMessageClass [
	^ GtLChatMessage
]

{ #category : #accessing }
GtLProvider >> defaultUserMessageClass [
	^ GtLChatMessage
]

{ #category : #'private - execution' }
GtLProvider >> executeAsyncMessage: anInputMessage [
	"The #executeWait should be removed and this message used instead."

	<return: #TAsyncPromise>
	self flag: #todo.

	self executeWait
]

{ #category : #'private - execution' }
GtLProvider >> executeWait [
	self deprecated: 'Use (or implement) #executeAsyncMessage: instead'.

	self subclassResponsibility
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
	^ self subclassResponsibility
]

{ #category : #accessing }
GtLProvider >> status [
	self deprecated: 'Use #state instead'.

	^ self subclassResponsibility
]
