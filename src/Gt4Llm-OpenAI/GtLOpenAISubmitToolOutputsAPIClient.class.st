Class {
	#name : #GtLOpenAISubmitToolOutputsAPIClient,
	#superclass : #GtLlmEndpointClient,
	#instVars : [
		'thread',
		'run',
		'outputs'
	],
	#category : #'Gt4Llm-OpenAI'
}

{ #category : #accessing }
GtLOpenAISubmitToolOutputsAPIClient >> outputs [
	^ outputs
]

{ #category : #accessing }
GtLOpenAISubmitToolOutputsAPIClient >> outputs: anObject [
	outputs := anObject
]

{ #category : #'as yet unclassified' }
GtLOpenAISubmitToolOutputsAPIClient >> request [
	^ self client
		post: 'threads/' , self thread , '/runs/' , self run , '/submit_tool_outputs'
		withEntity: {'tool_outputs' -> self outputs} asDictionary
]

{ #category : #accessing }
GtLOpenAISubmitToolOutputsAPIClient >> run [
	^ run
]

{ #category : #accessing }
GtLOpenAISubmitToolOutputsAPIClient >> run: anObject [
	run := anObject
]

{ #category : #'as yet unclassified' }
GtLOpenAISubmitToolOutputsAPIClient >> serializationClass [
	^ GtLOpenAIThreadRun
]

{ #category : #accessing }
GtLOpenAISubmitToolOutputsAPIClient >> thread [
	^ thread
]

{ #category : #accessing }
GtLOpenAISubmitToolOutputsAPIClient >> thread: anObject [
	thread := anObject
]
