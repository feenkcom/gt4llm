Class {
	#name : #Gt4OpenAIAddMessageToThreadAPIClient,
	#superclass : #Gt4OpenAIEndpointClient,
	#instVars : [
		'message',
		'thread'
	],
	#category : #'Gt4OpenAI-Client'
}

{ #category : #accessing }
Gt4OpenAIAddMessageToThreadAPIClient >> message [
	^ message
]

{ #category : #accessing }
Gt4OpenAIAddMessageToThreadAPIClient >> message: anObject [
	message := anObject
]

{ #category : #accessing }
Gt4OpenAIAddMessageToThreadAPIClient >> request [
	^ self client
		post: 'threads/' , self thread , '/messages'
		withEntity: self message serialize
]

{ #category : #accessing }
Gt4OpenAIAddMessageToThreadAPIClient >> serializationClass [
	^ Gt4OpenAIThreadMessage
]

{ #category : #accessing }
Gt4OpenAIAddMessageToThreadAPIClient >> thread [
	^ thread
]

{ #category : #accessing }
Gt4OpenAIAddMessageToThreadAPIClient >> thread: anObject [
	thread := anObject
]
