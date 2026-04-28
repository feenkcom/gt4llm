Class {
	#name : #GtLOllamaVersionEndpoint,
	#superclass : #GtLEndpoint,
	#category : #'Gt4LlmModel-Model'
}

{ #category : #accessing }
GtLOllamaVersionEndpoint >> path [

	^ '/api/version'
]

{ #category : #api }
GtLOllamaVersionEndpoint >> resultWithClient: aClient [

	^ (aClient get: self path) result at: 'version'
]
