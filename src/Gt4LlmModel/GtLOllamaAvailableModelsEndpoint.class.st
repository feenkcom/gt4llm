Class {
	#name : #GtLOllamaAvailableModelsEndpoint,
	#superclass : #GtLEndpoint,
	#category : #'Gt4LlmModel-Model'
}

{ #category : #accessing }
GtLOllamaAvailableModelsEndpoint >> path [

	^ '/api/tags'
]

{ #category : #api }
GtLOllamaAvailableModelsEndpoint >> resultWithClient: aClient model: aGtLModel [

	^ (aClient get: self path) result
]
