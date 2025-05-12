Class {
	#name : #GtLlmStaticProvider,
	#superclass : #GtLlmNullProvider,
	#instVars : [
		'messages',
		'index'
	],
	#category : #Gt4Llm
}

{ #category : #'as yet unclassified' }
GtLlmStaticProvider >> initialize [
	super initialize.
	
	index := 1.
	messages := {}
]

{ #category : #accessing }
GtLlmStaticProvider >> messages [
	^ messages
]

{ #category : #accessing }
GtLlmStaticProvider >> messages: anObject [
	messages := anObject
]

{ #category : #'as yet unclassified' }
GtLlmStaticProvider >> nextMessage [
	| message |
	index > messages size ifTrue: [ ^ String loremIpsum ].

	message := messages at: index.

	index := index + 1.

	^ message
]

{ #category : #'as yet unclassified' }
GtLlmStaticProvider >> printOn: aStream [
	aStream
		nextPutAll: 'Static'
]

{ #category : #'as yet unclassified' }
GtLlmStaticProvider >> sendMessage: aMessage [
	self chat
		addMessage: (self userMessageClass new
				role: 'user';
				content: aMessage).

	self chat
		addMessage: (self assistantMessageClass new
				role: 'assistant';
				content: self nextMessage).
				
	self chat signalRunIsDone
]
