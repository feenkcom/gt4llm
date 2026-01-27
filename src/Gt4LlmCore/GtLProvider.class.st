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

{ #category : #actions }
GtLProvider >> executeWait [
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

{ #category : #actions }
GtLProvider >> sendMessage: aMessage [
	self chat signalRunHasStarted.
	providerWorking := true.
	self executeWait
]

{ #category : #accessing }
GtLProvider >> status [
	^ self subclassResponsibility
]
