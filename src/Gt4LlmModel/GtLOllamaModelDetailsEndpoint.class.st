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
GtLOllamaModelDetailsEndpoint >> resultFrom: aRequestResponse context: aGtLContext [

	^ NeoJSONReader fromString: aRequestResponse response contents
]
