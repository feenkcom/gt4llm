Class {
	#name : #GtLOllamaPullEndpoint,
	#superclass : #GtLEndpoint,
	#category : #'Gt4LlmModel-Model'
}

{ #category : #'encoding - decoding' }
GtLOllamaPullEndpoint >> decodeContext: aGtL2Context [

	^ aGtL2Context response
]

{ #category : #'encoding - decoding' }
GtLOllamaPullEndpoint >> entityFromContext: aGtLContext [

	^ {
			'model' -> aGtLContext model name.
			'stream' -> false.
		} asDictionary.
]

{ #category : #accessing }
GtLOllamaPullEndpoint >> path [

	^ '/api/pull'
]

{ #category : #api }
GtLOllamaPullEndpoint >> resultFrom: aRequestResponse context: aGtLContext [
	| response |
	
	response := NeoJSONReader fromString: aRequestResponse response contents.
	^ response at: 'status'
		ifAbsent: [ self error: 'Unexpected response' ].
]
