Class {
	#name : #GtLOpenAICreateThreadAPICommand,
	#superclass : #GtLAPICommand,
	#instVars : [
		'messages'
	],
	#category : #'Gt4Llm-OpenAI'
}

{ #category : #accessing }
GtLOpenAICreateThreadAPICommand >> messages [
	^ messages
]

{ #category : #accessing }
GtLOpenAICreateThreadAPICommand >> messages: anObject [
	messages := anObject
]

{ #category : #accessing }
GtLOpenAICreateThreadAPICommand >> request [
	^ self client
		post: 'threads'
		withEntity: {'messages' -> (self messages collect: #serialize)} asDictionary
]

{ #category : #accessing }
GtLOpenAICreateThreadAPICommand >> serializationClass [
	^ GtLOpenAIThread
]
