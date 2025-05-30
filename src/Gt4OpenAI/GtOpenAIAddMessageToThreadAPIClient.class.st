Class {
	#name : #GtOpenAIAddMessageToThreadAPIClient,
	#superclass : #GtLlmEndpointClient,
	#instVars : [
		'message',
		'thread'
	],
	#category : #Gt4OpenAI
}

{ #category : #accessing }
GtOpenAIAddMessageToThreadAPIClient >> message [
	^ message
]

{ #category : #accessing }
GtOpenAIAddMessageToThreadAPIClient >> message: anObject [
	message := anObject
]

{ #category : #accessing }
GtOpenAIAddMessageToThreadAPIClient >> request [
	^ self client
		post: 'threads/' , self thread , '/messages'
		withEntity: self message serialize
]

{ #category : #accessing }
GtOpenAIAddMessageToThreadAPIClient >> serializationClass [
	^ GtOpenAIMessage
]

{ #category : #accessing }
GtOpenAIAddMessageToThreadAPIClient >> thread [
	^ thread
]

{ #category : #accessing }
GtOpenAIAddMessageToThreadAPIClient >> thread: anObject [
	thread := anObject
]
