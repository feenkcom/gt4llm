Class {
	#name : #Gt4OpenAIListThreadMessagesAPIClient,
	#superclass : #Gt4OpenAIEndpointClient,
	#instVars : [
		'thread'
	],
	#category : #'Gt4OpenAI-Client'
}

{ #category : #accessing }
Gt4OpenAIListThreadMessagesAPIClient >> request [
	^ self client get: 'threads/' , self thread id , '/messages'
]

{ #category : #accessing }
Gt4OpenAIListThreadMessagesAPIClient >> serializationClass [
	^ Gt4OpenAIThreadMessagesGroup
]

{ #category : #accessing }
Gt4OpenAIListThreadMessagesAPIClient >> thread [
	^ thread
]

{ #category : #accessing }
Gt4OpenAIListThreadMessagesAPIClient >> thread: anObject [
	thread := anObject
]
