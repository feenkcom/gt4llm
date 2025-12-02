Class {
	#name : #GtLOpenAIListVectorStoresAPICommand,
	#superclass : #GtLAPICommand,
	#category : #'Gt4Llm-OpenAI'
}

{ #category : #'as yet unclassified' }
GtLOpenAIListVectorStoresAPICommand >> request [
	^ self client get: '/vector_stores'
]

{ #category : #'as yet unclassified' }
GtLOpenAIListVectorStoresAPICommand >> serializationClass [
	^ GtLOpenAIVectorStoresGroup
]
