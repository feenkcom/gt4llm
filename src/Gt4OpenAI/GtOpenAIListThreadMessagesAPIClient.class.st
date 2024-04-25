Class {
	#name : #GtOpenAIListThreadMessagesAPIClient,
	#superclass : #GtLlmEndpointClient,
	#instVars : [
		'thread'
	],
	#category : #'Gt4OpenAI-Client'
}

{ #category : #accessing }
GtOpenAIListThreadMessagesAPIClient >> request [
	^ self client get: 'threads/' , self thread , '/messages'
]

{ #category : #accessing }
GtOpenAIListThreadMessagesAPIClient >> serializationClass [
	^ GtOpenAIThreadMessagesGroup
]

{ #category : #accessing }
GtOpenAIListThreadMessagesAPIClient >> thread [
	^ thread
]

{ #category : #accessing }
GtOpenAIListThreadMessagesAPIClient >> thread: anObject [
	thread := anObject
]
