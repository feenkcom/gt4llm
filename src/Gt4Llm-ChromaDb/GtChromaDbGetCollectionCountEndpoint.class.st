Class {
	#name : #GtChromaDbGetCollectionCountEndpoint,
	#superclass : #GtChromaDbEndpoint,
	#category : #'Gt4Llm-ChromaDb-Client'
}

{ #category : #accessing }
GtChromaDbGetCollectionCountEndpoint >> path [

	^ '/api/v2/tenants/{tenant}/databases/{database}/collections/{collectionId}/count'
]

{ #category : #'as yet unclassified' }
GtChromaDbGetCollectionCountEndpoint >> resultFrom: aGtRequestResponse parameters: parametersDictionary query: queryDictionary [

	^ aGtRequestResponse result
]
