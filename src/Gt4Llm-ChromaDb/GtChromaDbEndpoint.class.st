Class {
	#name : #GtChromaDbEndpoint,
	#superclass : #Object,
	#category : #'Gt4Llm-ChromaDb-Client'
}

{ #category : #entities }
GtChromaDbEndpoint >> entityFromContext: aGtChromaDbContext [

	^ self subclassResponsibility
]

{ #category : #'as yet unclassified' }
GtChromaDbEndpoint >> newContextForModel: model [

	^ GtLEndpointContext new
		model: model;
		provider: model provider.
]

{ #category : #accessing }
GtChromaDbEndpoint >> path [
	^ self subclassResponsibility
]

{ #category : #processing }
GtChromaDbEndpoint >> resultFrom: aGtRequestResponse parameters: aDictionary [

	^ aGtRequestResponse result
]
