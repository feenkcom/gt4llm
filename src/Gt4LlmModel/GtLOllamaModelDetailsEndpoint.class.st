Class {
	#name : #GtLOllamaModelDetailsEndpoint,
	#superclass : #GtLEndpoint,
	#category : #'Gt4LlmModel-Model'
}

{ #category : #'encoding - decoding' }
GtLOllamaModelDetailsEndpoint >> decodeContext: aGtL2Context [

	^ aGtL2Context response
]

{ #category : #'encoding - decoding' }
GtLOllamaModelDetailsEndpoint >> entityFromContext: aGtLContext [

	^ {
			'model' -> aGtLContext model name.
		} asDictionary.
]

{ #category : #accessing }
GtLOllamaModelDetailsEndpoint >> path [

	^ '/api/show'
]

{ #category : #api }
GtLOllamaModelDetailsEndpoint >> resultWithClient: aClient [

	^ (aClient
		post: self path
		withEntity: (self entityFromContext: aClient model))
			response
]

{ #category : #api }
GtLOllamaModelDetailsEndpoint >> resultWithClient: aClient model: aGtLModel [

	^ (aClient
		post: self path
		withEntity: (self entityFromContext: aGtLModel newEndpointContext))
			result
]
