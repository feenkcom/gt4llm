Class {
	#name : #GtOpenAIDeleteVectorStoreAPIClient,
	#superclass : #GtLlmEndpointClient,
	#instVars : [
		'vectorStore'
	],
	#category : #'Gt4OpenAI-Client'
}

{ #category : #'as yet unclassified' }
GtOpenAIDeleteVectorStoreAPIClient >> request [
	^ self client
		delete: 'vector_stores/', vectorStore
]

{ #category : #'as yet unclassified' }
GtOpenAIDeleteVectorStoreAPIClient >> serializationClass [
	^ GtOpenAIDeletion
]

{ #category : #accessing }
GtOpenAIDeleteVectorStoreAPIClient >> vectorStore [
	^ vectorStore
]

{ #category : #accessing }
GtOpenAIDeleteVectorStoreAPIClient >> vectorStore: anObject [
	vectorStore := anObject
]
