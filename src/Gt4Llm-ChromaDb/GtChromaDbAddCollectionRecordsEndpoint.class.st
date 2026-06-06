Class {
	#name : #GtChromaDbAddCollectionRecordsEndpoint,
	#superclass : #GtChromaDbEndpoint,
	#category : #'Gt4Llm-ChromaDb-Client'
}

{ #category : #accessing }
GtChromaDbAddCollectionRecordsEndpoint >> path [

	^ '/api/v2/tenants/{tenant}/databases/{database}/collections/{collectionId}/add'
]

{ #category : #processing }
GtChromaDbAddCollectionRecordsEndpoint >> resultFrom: aGtRequestResponse parameters: parametersDictionary entity: entityDictionary [
	"The result is always an empty object.
	The post will fail on error."

	^ aGtRequestResponse result
]
