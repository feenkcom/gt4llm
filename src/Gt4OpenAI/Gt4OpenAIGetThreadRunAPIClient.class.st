Class {
	#name : #Gt4OpenAIGetThreadRunAPIClient,
	#superclass : #Gt4OpenAIEndpointClient,
	#instVars : [
		'run',
		'thread'
	],
	#category : #'Gt4OpenAI-Client'
}

{ #category : #accessing }
Gt4OpenAIGetThreadRunAPIClient >> request [
	^ self client get: 'threads/' , self thread , '/runs/' , self run
]

{ #category : #accessing }
Gt4OpenAIGetThreadRunAPIClient >> run [
	^ run
]

{ #category : #accessing }
Gt4OpenAIGetThreadRunAPIClient >> run: anObject [
	run := anObject
]

{ #category : #accessing }
Gt4OpenAIGetThreadRunAPIClient >> serializationClass [
	^ Gt4OpenAIThreadRun
]

{ #category : #accessing }
Gt4OpenAIGetThreadRunAPIClient >> thread [
	^ thread
]

{ #category : #accessing }
Gt4OpenAIGetThreadRunAPIClient >> thread: anObject [
	thread := anObject
]
