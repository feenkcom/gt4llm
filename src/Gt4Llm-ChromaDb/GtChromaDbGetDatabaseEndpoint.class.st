Class {
	#name : #GtChromaDbGetDatabaseEndpoint,
	#superclass : #GtChromaDbEndpoint,
	#category : #'Gt4Llm-ChromaDb-Client'
}

{ #category : #accessing }
GtChromaDbGetDatabaseEndpoint >> path [

	^ '/api/v2/tenants/{tenant}/databases/{database}'
]

{ #category : #processing }
GtChromaDbGetDatabaseEndpoint >> resultFrom: aGtRequestResponse parameters: parametersDictionary query: queryDictionary [

	^ GtChromaDbDatabase new
			requestResponse: aGtRequestResponse
]
