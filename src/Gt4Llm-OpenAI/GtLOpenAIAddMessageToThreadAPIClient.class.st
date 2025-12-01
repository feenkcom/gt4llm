Class {
	#name : #GtLOpenAIAddMessageToThreadAPIClient,
	#superclass : #GtLlmEndpointClient,
	#instVars : [
		'message',
		'thread'
	],
	#category : #'Gt4Llm-OpenAI'
}

{ #category : #accessing }
GtLOpenAIAddMessageToThreadAPIClient >> message [
	^ message
]

{ #category : #accessing }
GtLOpenAIAddMessageToThreadAPIClient >> message: anObject [
	message := anObject
]

{ #category : #accessing }
GtLOpenAIAddMessageToThreadAPIClient >> request [
	^ self client
		post: 'threads/' , self thread , '/messages'
		withEntity: self message serialize
]

{ #category : #accessing }
GtLOpenAIAddMessageToThreadAPIClient >> serializationClass [
	^ GtOpenAIMessage
]

{ #category : #accessing }
GtLOpenAIAddMessageToThreadAPIClient >> thread [
	^ thread
]

{ #category : #accessing }
GtLOpenAIAddMessageToThreadAPIClient >> thread: anObject [
	thread := anObject
]
