Class {
	#name : #Gt4OpenAICreateThreadAPIClient,
	#superclass : #Gt4OpenAIEndpointClient,
	#instVars : [
		'messages'
	],
	#category : #'Gt4OpenAI-Client'
}

{ #category : #accessing }
Gt4OpenAICreateThreadAPIClient >> messages [
	^ messages
]

{ #category : #accessing }
Gt4OpenAICreateThreadAPIClient >> messages: anObject [
	messages := anObject
]

{ #category : #accessing }
Gt4OpenAICreateThreadAPIClient >> request [
	^ self client
		post: 'threads'
		withEntity: {'messages' -> (self messages collect: #serialize)} asDictionary
]

{ #category : #accessing }
Gt4OpenAICreateThreadAPIClient >> serializationClass [
	^ Gt4OpenAIThread
]
