Class {
	#name : #GtChromaDbGetCollectionEndpoint,
	#superclass : #GtChromaDbEndpoint,
	#category : #'Gt4Llm-ChromaDb-Client'
}

{ #category : #accessing }
GtChromaDbGetCollectionEndpoint >> path [

	^ '/api/v2/tenants/{tenant}/databases/{database}/collections/{collectionId}'
]

{ #category : #'as yet unclassified' }
GtChromaDbGetCollectionEndpoint >> resultFrom: aGtRequestResponse parameters: parametersDictionary query: queryDictionary [

	^ GtChromaDbCollection new
			requestResponse: aGtRequestResponse
]
