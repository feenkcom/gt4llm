Class {
	#name : #GtOllamaListModelsClient,
	#superclass : #GtLlmEndpointClient,
	#category : #Gt4Ollama
}

{ #category : #accessing }
GtOllamaListModelsClient >> request [
	^ self client get: '/tags'
]

{ #category : #accessing }
GtOllamaListModelsClient >> serializationClass [
	^ GtOllamaModelsGroup
]
