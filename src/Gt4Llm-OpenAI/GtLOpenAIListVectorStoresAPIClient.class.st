Class {
	#name : #GtLOpenAIListVectorStoresAPIClient,
	#superclass : #GtLAPICommand,
	#category : #'Gt4Llm-OpenAI'
}

{ #category : #'as yet unclassified' }
GtLOpenAIListVectorStoresAPIClient >> request [
	^ self client get: '/vector_stores'
]

{ #category : #'as yet unclassified' }
GtLOpenAIListVectorStoresAPIClient >> serializationClass [
	^ GtLOpenAIVectorStoresGroup
]
