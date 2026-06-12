Class {
	#name : #GtChromaDbDeleteRecordsEndpoint,
	#superclass : #GtChromaDbEndpoint,
	#category : #'Gt4Llm-ChromaDb-Client'
}

{ #category : #accessing }
GtChromaDbDeleteRecordsEndpoint >> path [

	^ '/api/v2/tenants/{tenant}/databases/{database}/collections/{collectionId}/delete'
]

{ #category : #'as yet unclassified' }
GtChromaDbDeleteRecordsEndpoint >> resultFrom: aGtRequestResponse parameters: parametersDictionary entity: entity [
	"Answer the number of records deleted"

	^ aGtRequestResponse result at: 'deleted'
]
