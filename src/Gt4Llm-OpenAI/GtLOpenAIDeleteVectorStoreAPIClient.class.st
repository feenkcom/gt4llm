Class {
	#name : #GtLOpenAIDeleteVectorStoreAPIClient,
	#superclass : #GtLAPICommand,
	#instVars : [
		'vectorStore'
	],
	#category : #'Gt4Llm-OpenAI'
}

{ #category : #'as yet unclassified' }
GtLOpenAIDeleteVectorStoreAPIClient >> request [
	^ self client
		delete: 'vector_stores/', vectorStore
]

{ #category : #'as yet unclassified' }
GtLOpenAIDeleteVectorStoreAPIClient >> serializationClass [
	^ GtLOpenAIDeletion
]

{ #category : #accessing }
GtLOpenAIDeleteVectorStoreAPIClient >> vectorStore [
	^ vectorStore
]

{ #category : #accessing }
GtLOpenAIDeleteVectorStoreAPIClient >> vectorStore: anObject [
	vectorStore := anObject
]
