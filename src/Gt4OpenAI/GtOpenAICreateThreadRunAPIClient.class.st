Class {
	#name : #GtOpenAICreateThreadRunAPIClient,
	#superclass : #GtLlmEndpointClient,
	#instVars : [
		'assistant',
		'thread',
		'responseFormat'
	],
	#category : #'Gt4OpenAI-Client'
}

{ #category : #accessing }
GtOpenAICreateThreadRunAPIClient >> assistant [
	^ assistant
]

{ #category : #accessing }
GtOpenAICreateThreadRunAPIClient >> assistant: anObject [
	assistant := anObject
]

{ #category : #accessing }
GtOpenAICreateThreadRunAPIClient >> request [
	^ self client
		post: 'threads/' , self thread , '/runs'
		withEntity: {'assistant_id' -> self assistant.
				'response_format' -> self responseFormat} asDictionary
]

{ #category : #accessing }
GtOpenAICreateThreadRunAPIClient >> responseFormat [
	^ responseFormat
]

{ #category : #accessing }
GtOpenAICreateThreadRunAPIClient >> responseFormat: anObject [
	responseFormat := anObject
]

{ #category : #accessing }
GtOpenAICreateThreadRunAPIClient >> serializationClass [
	^ GtOpenAIThreadRun
]

{ #category : #accessing }
GtOpenAICreateThreadRunAPIClient >> thread [
	^ thread
]

{ #category : #accessing }
GtOpenAICreateThreadRunAPIClient >> thread: anObject [
	thread := anObject
]
