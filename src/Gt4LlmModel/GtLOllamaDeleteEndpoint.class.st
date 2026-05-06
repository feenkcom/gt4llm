Class {
	#name : #GtLOllamaDeleteEndpoint,
	#superclass : #GtLEndpoint,
	#category : #'Gt4LlmModel-Model'
}

{ #category : #'encoding - decoding' }
GtLOllamaDeleteEndpoint >> entityFromContext: aGtLContext [

	^ {
			'model' -> aGtLContext model name.
		} asDictionary.
]

{ #category : #accessing }
GtLOllamaDeleteEndpoint >> path [

	^ '/api/delete'
]

{ #category : #api }
GtLOllamaDeleteEndpoint >> resultFrom: aRequestResponse context: aGtLContext [

	^ aRequestResponse response isSuccess
		ifTrue: [ 'success' ]
		ifFalse: [ 'Unable to delete model' ]
]
