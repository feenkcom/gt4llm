Class {
	#name : #GtChromaDbQueryCollectionEndpoint,
	#superclass : #GtChromaDbEndpoint,
	#category : #'Gt4Llm-ChromaDb-Client'
}

{ #category : #accessing }
GtChromaDbQueryCollectionEndpoint >> path [

	^ '/api/v2/tenants/{tenant}/databases/{database}/collections/{collectionId}/query'
]

{ #category : #processing }
GtChromaDbQueryCollectionEndpoint >> resultFrom: aGtRequestResponse parameters: parametersDictionary entity: entityDictionary [

	^ aGtRequestResponse
]
