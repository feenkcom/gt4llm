Class {
	#name : #GtOpenAICreateThreadAPIClient,
	#superclass : #GtLlmEndpointClient,
	#instVars : [
		'messages'
	],
	#category : #Gt4OpenAI
}

{ #category : #accessing }
GtOpenAICreateThreadAPIClient >> messages [
	^ messages
]

{ #category : #accessing }
GtOpenAICreateThreadAPIClient >> messages: anObject [
	messages := anObject
]

{ #category : #accessing }
GtOpenAICreateThreadAPIClient >> request [
	^ self client
		post: 'threads'
		withEntity: {'messages' -> (self messages collect: #serialize)} asDictionary
]

{ #category : #accessing }
GtOpenAICreateThreadAPIClient >> serializationClass [
	^ GtOpenAIThread
]
