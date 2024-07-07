Class {
	#name : #GtOllamaPushModelClient,
	#superclass : #GtLlmEndpointClient,
	#instVars : [
		'model'
	],
	#category : #'Gt4Ollama-Chat'
}

{ #category : #accessing }
GtOllamaPushModelClient >> model [
	^ model
]

{ #category : #accessing }
GtOllamaPushModelClient >> model: anObject [
	model := anObject
]

{ #category : #accessing }
GtOllamaPushModelClient >> request [
	^ self client postStreaming: '/push' withEntity: {'model' -> self model} asDictionary
]

{ #category : #accessing }
GtOllamaPushModelClient >> serializationClass [
	^ GtOllamaStatusSteps
]
