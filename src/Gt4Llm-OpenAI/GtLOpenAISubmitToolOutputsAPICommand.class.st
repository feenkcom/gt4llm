Class {
	#name : #GtLOpenAISubmitToolOutputsAPICommand,
	#superclass : #GtLAPICommand,
	#instVars : [
		'thread',
		'run',
		'outputs'
	],
	#category : #'Gt4Llm-OpenAI'
}

{ #category : #accessing }
GtLOpenAISubmitToolOutputsAPICommand >> outputs [
	^ outputs
]

{ #category : #accessing }
GtLOpenAISubmitToolOutputsAPICommand >> outputs: anObject [
	outputs := anObject
]

{ #category : #'as yet unclassified' }
GtLOpenAISubmitToolOutputsAPICommand >> request [
	^ self client
		post: 'threads/' , self thread , '/runs/' , self run , '/submit_tool_outputs'
		withEntity: {'tool_outputs' -> self outputs} asDictionary
]

{ #category : #accessing }
GtLOpenAISubmitToolOutputsAPICommand >> run [
	^ run
]

{ #category : #accessing }
GtLOpenAISubmitToolOutputsAPICommand >> run: anObject [
	run := anObject
]

{ #category : #'as yet unclassified' }
GtLOpenAISubmitToolOutputsAPICommand >> serializationClass [
	^ GtLOpenAIThreadRun
]

{ #category : #accessing }
GtLOpenAISubmitToolOutputsAPICommand >> thread [
	^ thread
]

{ #category : #accessing }
GtLOpenAISubmitToolOutputsAPICommand >> thread: anObject [
	thread := anObject
]
