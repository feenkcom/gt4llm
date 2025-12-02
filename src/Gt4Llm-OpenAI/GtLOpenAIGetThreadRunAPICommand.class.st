Class {
	#name : #GtLOpenAIGetThreadRunAPICommand,
	#superclass : #GtLAPICommand,
	#instVars : [
		'run',
		'thread'
	],
	#category : #'Gt4Llm-OpenAI'
}

{ #category : #accessing }
GtLOpenAIGetThreadRunAPICommand >> request [
	^ self client get: 'threads/' , self thread , '/runs/' , self run
]

{ #category : #accessing }
GtLOpenAIGetThreadRunAPICommand >> run [
	^ run
]

{ #category : #accessing }
GtLOpenAIGetThreadRunAPICommand >> run: anObject [
	run := anObject
]

{ #category : #accessing }
GtLOpenAIGetThreadRunAPICommand >> serializationClass [
	^ GtLOpenAIThreadRun
]

{ #category : #accessing }
GtLOpenAIGetThreadRunAPICommand >> thread [
	^ thread
]

{ #category : #accessing }
GtLOpenAIGetThreadRunAPICommand >> thread: anObject [
	thread := anObject
]
