Class {
	#name : #GtChromaDbGetIdentityEndpoint,
	#superclass : #GtChromaDbEndpoint,
	#category : #'Gt4Llm-ChromaDb-Client'
}

{ #category : #accessing }
GtChromaDbGetIdentityEndpoint >> path [

	^ '/api/v2/auth/identity'
]

{ #category : #'as yet unclassified' }
GtChromaDbGetIdentityEndpoint >> resultFrom: aGtRequestResponse parameters: parametersDictionary query: queryDictionary [

	^ GtChromaDbIdentity requestResponse: aGtRequestResponse
]
