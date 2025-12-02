Class {
	#name : #GtLOpenAICreateThreadRunAPICommand,
	#superclass : #GtLAPICommand,
	#instVars : [
		'assistant',
		'thread',
		'responseFormat'
	],
	#category : #'Gt4Llm-OpenAI'
}

{ #category : #accessing }
GtLOpenAICreateThreadRunAPICommand >> assistant [
	^ assistant
]

{ #category : #accessing }
GtLOpenAICreateThreadRunAPICommand >> assistant: anObject [
	assistant := anObject
]

{ #category : #accessing }
GtLOpenAICreateThreadRunAPICommand >> request [
	^ self client
		post: 'threads/' , self thread , '/runs'
		withEntity: {'assistant_id' -> self assistant.
				'response_format' -> self responseFormat} asDictionary
]

{ #category : #accessing }
GtLOpenAICreateThreadRunAPICommand >> responseFormat [
	^ responseFormat
]

{ #category : #accessing }
GtLOpenAICreateThreadRunAPICommand >> responseFormat: anObject [
	responseFormat := anObject
]

{ #category : #accessing }
GtLOpenAICreateThreadRunAPICommand >> serializationClass [
	^ GtLOpenAIThreadRun
]

{ #category : #accessing }
GtLOpenAICreateThreadRunAPICommand >> thread [
	^ thread
]

{ #category : #accessing }
GtLOpenAICreateThreadRunAPICommand >> thread: anObject [
	thread := anObject
]
