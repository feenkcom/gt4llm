Class {
	#name : #GtOpenAIGetThreadRunAPIClient,
	#superclass : #GtLlmEndpointClient,
	#instVars : [
		'run',
		'thread'
	],
	#category : #'Gt4OpenAI-Client'
}

{ #category : #accessing }
GtOpenAIGetThreadRunAPIClient >> request [
	^ self client get: 'threads/' , self thread , '/runs/' , self run
]

{ #category : #accessing }
GtOpenAIGetThreadRunAPIClient >> run [
	^ run
]

{ #category : #accessing }
GtOpenAIGetThreadRunAPIClient >> run: anObject [
	run := anObject
]

{ #category : #accessing }
GtOpenAIGetThreadRunAPIClient >> serializationClass [
	^ GtOpenAIThreadRun
]

{ #category : #accessing }
GtOpenAIGetThreadRunAPIClient >> thread [
	^ thread
]

{ #category : #accessing }
GtOpenAIGetThreadRunAPIClient >> thread: anObject [
	thread := anObject
]
