Class {
	#name : #GtChromaDbCreateCollectionEndpoint,
	#superclass : #GtChromaDbEndpoint,
	#category : #'Gt4Llm-ChromaDb-Client'
}

{ #category : #accessing }
GtChromaDbCreateCollectionEndpoint >> path [

	^ '/api/v2/tenants/{tenant}/databases/{database}/collections'
]

{ #category : #processing }
GtChromaDbCreateCollectionEndpoint >> resultFrom: aGtRequestResponse parameters: parametersDictionary entity: entityDictionary [

	^ GtChromaDbCollection requestResponse: aGtRequestResponse
]
