Class {
	#name : #GtLOpenAIGetThreadRunAPIClient,
	#superclass : #GtLlmEndpointClient,
	#instVars : [
		'run',
		'thread'
	],
	#category : #'Gt4Llm-OpenAI'
}

{ #category : #accessing }
GtLOpenAIGetThreadRunAPIClient >> request [
	^ self client get: 'threads/' , self thread , '/runs/' , self run
]

{ #category : #accessing }
GtLOpenAIGetThreadRunAPIClient >> run [
	^ run
]

{ #category : #accessing }
GtLOpenAIGetThreadRunAPIClient >> run: anObject [
	run := anObject
]

{ #category : #accessing }
GtLOpenAIGetThreadRunAPIClient >> serializationClass [
	^ GtLOpenAIThreadRun
]

{ #category : #accessing }
GtLOpenAIGetThreadRunAPIClient >> thread [
	^ thread
]

{ #category : #accessing }
GtLOpenAIGetThreadRunAPIClient >> thread: anObject [
	thread := anObject
]
