Class {
	#name : #GtChromaDbGetCollectionsEndpoint,
	#superclass : #GtChromaDbEndpoint,
	#category : #'Gt4Llm-ChromaDb-Client'
}

{ #category : #accessing }
GtChromaDbGetCollectionsEndpoint >> path [

	^ '/api/v2/tenants/{tenant}/databases/{database}/collections'
]

{ #category : #'as yet unclassified' }
GtChromaDbGetCollectionsEndpoint >> resultFrom: aGtRequestResponse parameters: parametersDictionary query: queryDictionary [
	| collections |
	collections := GtChromaDbCollections withAll: (aGtRequestResponse result collect: [ :jsonObject |
		GtChromaDbCollection new
			requestResponse: aGtRequestResponse;
			rawData: jsonObject ]).
	collections databaseName: (parametersDictionary at: 'database').
	^ collections
]
