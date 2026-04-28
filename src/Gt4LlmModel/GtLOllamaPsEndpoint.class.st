Class {
	#name : #GtLOllamaPsEndpoint,
	#superclass : #GtLEndpoint,
	#category : #'Gt4LlmModel-Model'
}

{ #category : #accessing }
GtLOllamaPsEndpoint >> path [

	^ '/api/ps'
]

{ #category : #accessing }
GtLOllamaPsEndpoint >> resultWithClient: aClient model: aGtLModel [

	^ aClient get: self path
]
