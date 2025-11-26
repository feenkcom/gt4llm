Class {
	#name : #GtLProvider,
	#superclass : #Object,
	#instVars : [
		'chat',
		'userMessageClass',
		'assistantMessageClass'
	],
	#category : #Gt4LlmCore
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
	^ GtLlmAssistantMessage
]

{ #category : #accessing }
GtLProvider >> defaultUserMessageClass [
	^ GtLlmUserMessage
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
GtLProvider >> sendAssistantMessage: anObject [ 
	^ self subclassResponsibility
]

{ #category : #actions }
GtLProvider >> sendMessage: aMessageCall [
	| currentMessage |
	currentMessage := self userMessageClass new
			content: aMessageCall serialize;
			originMessageCall: aMessageCall;
			role: 'user';
			chat: self chat.
	self
		sendAssistantMessage: currentMessage.
]

{ #category : #accessing }
GtLProvider >> status [
	^ self subclassResponsibility
]

{ #category : #accessing }
GtLProvider >> userMessageClass [
	^ userMessageClass ifNil: [ userMessageClass := self defaultUserMessageClass ]
]

{ #category : #accessing }
GtLProvider >> userMessageClass: anObject [
	userMessageClass := anObject
]
