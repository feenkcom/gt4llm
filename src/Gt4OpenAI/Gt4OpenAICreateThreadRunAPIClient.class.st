Class {
	#name : #Gt4OpenAICreateThreadRunAPIClient,
	#superclass : #Gt4OpenAIEndpointClient,
	#instVars : [
		'assistant',
		'thread'
	],
	#category : #'Gt4OpenAI-Client'
}

{ #category : #accessing }
Gt4OpenAICreateThreadRunAPIClient >> assistant [
	^ assistant
]

{ #category : #accessing }
Gt4OpenAICreateThreadRunAPIClient >> assistant: anObject [
	assistant := anObject
]

{ #category : #accessing }
Gt4OpenAICreateThreadRunAPIClient >> request [
	^ self client
		post: 'threads/' , self thread id , '/runs'
		withEntity: {'assistant_id' -> self assistant id} asDictionary
]

{ #category : #accessing }
Gt4OpenAICreateThreadRunAPIClient >> serializationClass [
	^ Gt4OpenAIThreadRun
]

{ #category : #accessing }
Gt4OpenAICreateThreadRunAPIClient >> thread [
	^ thread
]

{ #category : #accessing }
Gt4OpenAICreateThreadRunAPIClient >> thread: anObject [
	thread := anObject
]
