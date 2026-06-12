Class {
	#name : #GtChromaDbGetRecordsEndpoint,
	#superclass : #GtChromaDbEndpoint,
	#category : #'Gt4Llm-ChromaDb-Client'
}

{ #category : #accessing }
GtChromaDbGetRecordsEndpoint >> path [

	^ '/api/v2/tenants/{tenant}/databases/{database}/collections/{collectionId}/get'
]

{ #category : #'as yet unclassified' }
GtChromaDbGetRecordsEndpoint >> resultFrom: aGtRequestResponse parameters: parametersDictionary entity: entity [

	^ GtChromaDbRecords collection: nil columns: aGtRequestResponse result
]
