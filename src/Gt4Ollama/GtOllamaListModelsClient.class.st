Class {
	#name : #GtOllamaListModelsClient,
	#superclass : #GtLlmEndpointClient,
	#category : #'Gt4Ollama-Chat'
}

{ #category : #accessing }
GtOllamaListModelsClient >> request [
	^ self client get: '/tags'
]
