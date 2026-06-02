Class {
	#name : #GtChromaDbGetDatabasesEndpoint,
	#superclass : #GtChromaDbEndpoint,
	#category : #'Gt4Llm-ChromaDb-Client'
}

{ #category : #accessing }
GtChromaDbGetDatabasesEndpoint >> path [

	^ '/api/v2/tenants/{tenant}/databases'
]

{ #category : #'as yet unclassified' }
GtChromaDbGetDatabasesEndpoint >> resultFrom: aGtRequestResponse parameters: parametersDictionary query: queryDictionary [
	| databases |
	databases := GtChromaDbDatabases withAll: (aGtRequestResponse result collect: [ :jsonObject |
		GtChromaDbDatabase new
			requestResponse: aGtRequestResponse;
			rawData: jsonObject ]).
	databases tenant: (parametersDictionary at: 'tenant').
	^ databases
]
