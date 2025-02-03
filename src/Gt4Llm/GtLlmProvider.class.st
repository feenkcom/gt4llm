Class {
	#name : #GtLlmProvider,
	#superclass : #Object,
	#instVars : [
		'isActionBased',
		'chat',
		'userMessageClass',
		'assistantMessageClass',
		'format'
	],
	#category : #'Gt4Llm-Providers'
}

{ #category : #accessing }
GtLlmProvider >> assistantMessageClass [
	^ assistantMessageClass
]

{ #category : #accessing }
GtLlmProvider >> assistantMessageClass: anObject [
	assistantMessageClass := anObject
]

{ #category : #'as yet unclassified' }
GtLlmProvider >> beActionBased [
	isActionBased := true
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
GtLlmProvider >> initialize [
	super initialize.

	isActionBased := false.

	userMessageClass := self defaultUserMessageClass.
	assistantMessageClass := self defaultAssistantMessageClass
]

{ #category : #'as yet unclassified' }
GtLlmProvider >> isActionBased [
	^ isActionBased
]

{ #category : #'as yet unclassified' }
GtLlmProvider >> messageFromString: aString [
	self isActionBased ifFalse: [ ^ aString ].

	^ STONJSON toString: {'Action' -> aString} asDictionary
]

{ #category : #'as yet unclassified' }
GtLlmProvider >> sendAssistantMessage: anObject [ 
	^ self subclassResponsibility
]

{ #category : #'as yet unclassified' }
GtLlmProvider >> sendMessage: aMessage [
	self
		sendAssistantMessage: (userMessageClass new
				content: (self messageFromString: aMessage);
				chat: self)
]

{ #category : #'as yet unclassified' }
GtLlmProvider >> status [
	^ self subclassResponsibility
]

{ #category : #accessing }
GtLlmProvider >> userMessageClass [
	^ userMessageClass
]

{ #category : #accessing }
GtLlmProvider >> userMessageClass: anObject [
	userMessageClass := anObject
]
