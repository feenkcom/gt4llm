Class {
	#name : #GtLOpenAIAddMessageToThreadAPICommand,
	#superclass : #GtLAPICommand,
	#instVars : [
		'message',
		'thread'
	],
	#category : #'Gt4Llm-OpenAI'
}

{ #category : #accessing }
GtLOpenAIAddMessageToThreadAPICommand >> message [
	^ message
]

{ #category : #accessing }
GtLOpenAIAddMessageToThreadAPICommand >> message: anObject [
	message := anObject
]

{ #category : #accessing }
GtLOpenAIAddMessageToThreadAPICommand >> request [
	^ self client
		post: 'threads/' , self thread , '/messages'
		withEntity: self message serialize
]

{ #category : #accessing }
GtLOpenAIAddMessageToThreadAPICommand >> serializationClass [
	^ GtOpenAIMessage
]

{ #category : #accessing }
GtLOpenAIAddMessageToThreadAPICommand >> thread [
	^ thread
]

{ #category : #accessing }
GtLOpenAIAddMessageToThreadAPICommand >> thread: anObject [
	thread := anObject
]
