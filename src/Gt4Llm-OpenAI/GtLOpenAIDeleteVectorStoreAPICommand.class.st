Class {
	#name : #GtLOpenAIDeleteVectorStoreAPICommand,
	#superclass : #GtLAPICommand,
	#instVars : [
		'vectorStore'
	],
	#category : #'Gt4Llm-OpenAI'
}

{ #category : #'as yet unclassified' }
GtLOpenAIDeleteVectorStoreAPICommand >> request [
	^ self client
		delete: 'vector_stores/', vectorStore
]

{ #category : #'as yet unclassified' }
GtLOpenAIDeleteVectorStoreAPICommand >> serializationClass [
	^ GtLOpenAIDeletion
]

{ #category : #accessing }
GtLOpenAIDeleteVectorStoreAPICommand >> vectorStore [
	^ vectorStore
]

{ #category : #accessing }
GtLOpenAIDeleteVectorStoreAPICommand >> vectorStore: anObject [
	vectorStore := anObject
]
