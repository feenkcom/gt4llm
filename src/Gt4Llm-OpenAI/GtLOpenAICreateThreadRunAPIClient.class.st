Class {
	#name : #GtLOpenAICreateThreadRunAPIClient,
	#superclass : #GtLAPICommand,
	#instVars : [
		'assistant',
		'thread',
		'responseFormat'
	],
	#category : #'Gt4Llm-OpenAI'
}

{ #category : #accessing }
GtLOpenAICreateThreadRunAPIClient >> assistant [
	^ assistant
]

{ #category : #accessing }
GtLOpenAICreateThreadRunAPIClient >> assistant: anObject [
	assistant := anObject
]

{ #category : #accessing }
GtLOpenAICreateThreadRunAPIClient >> request [
	^ self client
		post: 'threads/' , self thread , '/runs'
		withEntity: {'assistant_id' -> self assistant.
				'response_format' -> self responseFormat} asDictionary
]

{ #category : #accessing }
GtLOpenAICreateThreadRunAPIClient >> responseFormat [
	^ responseFormat
]

{ #category : #accessing }
GtLOpenAICreateThreadRunAPIClient >> responseFormat: anObject [
	responseFormat := anObject
]

{ #category : #accessing }
GtLOpenAICreateThreadRunAPIClient >> serializationClass [
	^ GtLOpenAIThreadRun
]

{ #category : #accessing }
GtLOpenAICreateThreadRunAPIClient >> thread [
	^ thread
]

{ #category : #accessing }
GtLOpenAICreateThreadRunAPIClient >> thread: anObject [
	thread := anObject
]
