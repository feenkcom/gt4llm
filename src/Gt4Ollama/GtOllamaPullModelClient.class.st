Class {
	#name : #GtOllamaPullModelClient,
	#superclass : #GtLlmEndpointClient,
	#instVars : [
		'model'
	],
	#category : #Gt4Ollama
}

{ #category : #accessing }
GtOllamaPullModelClient >> model [
	^ model
]

{ #category : #accessing }
GtOllamaPullModelClient >> model: anObject [
	model := anObject
]

{ #category : #accessing }
GtOllamaPullModelClient >> request [
	^ self client postStreaming: '/pull' withEntity: {'model' -> self model} asDictionary
]

{ #category : #accessing }
GtOllamaPullModelClient >> serializationClass [
	^ GtOllamaStatusSteps
]
