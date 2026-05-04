Class {
	#name : #GtLOllamaAvailableModelsEndpoint,
	#superclass : #GtLEndpoint,
	#category : #'Gt4LlmModel-Model'
}

{ #category : #accessing }
GtLOllamaAvailableModelsEndpoint >> path [

	^ '/api/tags'
]
