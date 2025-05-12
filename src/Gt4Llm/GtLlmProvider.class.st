Class {
	#name : #GtLlmProvider,
	#superclass : #Object,
	#instVars : [
		'chat',
		'userMessageClass',
		'assistantMessageClass',
		'format'
	],
	#category : #Gt4Llm
}

{ #category : #'as yet unclassified' }
GtLlmProvider class >> defaultProviders [
	^ self allSubclasses
		select: [ :aSubclass | aSubclass class canUnderstand: #default ]
]

{ #category : #'as yet unclassified' }
GtLlmProvider class >> isConnectable [
	^ false
]

{ #category : #'as yet unclassified' }
GtLlmProvider class >> new [
	^ self basicNew initialize
]

{ #category : #accessing }
GtLlmProvider >> assistantMessageClass [
	^ assistantMessageClass
		ifNil: [ assistantMessageClass := self defaultAssistantMessageClass ]
]

{ #category : #accessing }
GtLlmProvider >> assistantMessageClass: anObject [
	assistantMessageClass := anObject
]

{ #category : #accessing }
GtLlmProvider >> chat [
	^ chat
]

{ #category : #accessing }
GtLlmProvider >> chat: anObject [
	chat := anObject
]

{ #category : #'as yet unclassified' }
GtLlmProvider >> defaultAssistantMessageClass [
	^ GtLlmAssistantMessage
]

{ #category : #'as yet unclassified' }
GtLlmProvider >> defaultUserMessageClass [
	^ GtLlmUserMessage
]

{ #category : #accessing }
GtLlmProvider >> format [
	^ format
]

{ #category : #accessing }
GtLlmProvider >> format: anObject [
	format := anObject
]

{ #category : #'as yet unclassified' }
GtLlmProvider >> sendAssistantMessage: anObject [ 
	^ self subclassResponsibility
]

{ #category : #'as yet unclassified' }
GtLlmProvider >> sendMessage: aMessage [
	self
		sendAssistantMessage: (self userMessageClass new
				content: aMessage;
				role: 'user';
				chat: self)
]

{ #category : #'as yet unclassified' }
GtLlmProvider >> status [
	^ self subclassResponsibility
]

{ #category : #accessing }
GtLlmProvider >> userMessageClass [
	^ userMessageClass ifNil: [ userMessageClass := self defaultUserMessageClass ]
]

{ #category : #accessing }
GtLlmProvider >> userMessageClass: anObject [
	userMessageClass := anObject
]
