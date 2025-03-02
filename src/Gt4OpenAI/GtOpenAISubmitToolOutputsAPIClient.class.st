Class {
	#name : #GtOpenAISubmitToolOutputsAPIClient,
	#superclass : #GtLlmEndpointClient,
	#instVars : [
		'thread',
		'run',
		'outputs'
	],
	#category : #Gt4OpenAI
}

{ #category : #accessing }
GtOpenAISubmitToolOutputsAPIClient >> outputs [
	^ outputs
]

{ #category : #accessing }
GtOpenAISubmitToolOutputsAPIClient >> outputs: anObject [
	outputs := anObject
]

{ #category : #'as yet unclassified' }
GtOpenAISubmitToolOutputsAPIClient >> request [
	^ self client
		post: 'threads/' , self thread , '/runs/' , self run , '/submit_tool_outputs'
		withEntity: {'tool_outputs' -> self outputs} asDictionary
]

{ #category : #accessing }
GtOpenAISubmitToolOutputsAPIClient >> run [
	^ run
]

{ #category : #accessing }
GtOpenAISubmitToolOutputsAPIClient >> run: anObject [
	run := anObject
]

{ #category : #'as yet unclassified' }
GtOpenAISubmitToolOutputsAPIClient >> serializationClass [
	^ GtOpenAIThreadRun
]

{ #category : #accessing }
GtOpenAISubmitToolOutputsAPIClient >> thread [
	^ thread
]

{ #category : #accessing }
GtOpenAISubmitToolOutputsAPIClient >> thread: anObject [
	thread := anObject
]
