Class {
	#name : #GtLOpenAICreateThreadAPIClient,
	#superclass : #GtLAPICommand,
	#instVars : [
		'messages'
	],
	#category : #'Gt4Llm-OpenAI'
}

{ #category : #accessing }
GtLOpenAICreateThreadAPIClient >> messages [
	^ messages
]

{ #category : #accessing }
GtLOpenAICreateThreadAPIClient >> messages: anObject [
	messages := anObject
]

{ #category : #accessing }
GtLOpenAICreateThreadAPIClient >> request [
	^ self client
		post: 'threads'
		withEntity: {'messages' -> (self messages collect: #serialize)} asDictionary
]

{ #category : #accessing }
GtLOpenAICreateThreadAPIClient >> serializationClass [
	^ GtLOpenAIThread
]
