Class {
	#name : #GtOllamaListRunningModelsClient,
	#superclass : #GtLlmEndpointClient,
	#category : #'Gt4Ollama-Chat'
}

{ #category : #accessing }
GtOllamaListRunningModelsClient >> request [
	^ self client get: '/ps'
]

{ #category : #accessing }
GtOllamaListRunningModelsClient >> serializationClass [
	^ GtOllamaRunningModelsGroup
]
