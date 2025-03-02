Class {
	#name : #GtOpenAIListVectorStoresAPIClient,
	#superclass : #GtLlmEndpointClient,
	#category : #Gt4OpenAI
}

{ #category : #'as yet unclassified' }
GtOpenAIListVectorStoresAPIClient >> request [
	^ self client get: '/vector_stores'
]

{ #category : #'as yet unclassified' }
GtOpenAIListVectorStoresAPIClient >> serializationClass [
	^ GtOpenAIVectorStoresGroup
]
