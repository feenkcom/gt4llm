Class {
	#name : #GtLOpenAICreateVectorStoreAPIClient,
	#superclass : #GtLlmEndpointClient,
	#instVars : [
		'name',
		'files'
	],
	#category : #'Gt4Llm-OpenAI'
}

{ #category : #accessing }
GtLOpenAICreateVectorStoreAPIClient >> files [
	^ files
]

{ #category : #accessing }
GtLOpenAICreateVectorStoreAPIClient >> files: anObject [
	files := anObject
]

{ #category : #accessing }
GtLOpenAICreateVectorStoreAPIClient >> name [
	^ name
]

{ #category : #accessing }
GtLOpenAICreateVectorStoreAPIClient >> name: anObject [
	name := anObject
]

{ #category : #'as yet unclassified' }
GtLOpenAICreateVectorStoreAPIClient >> request [
	^ self client
		post: 'vector_stores'
		withEntity: {'name' -> self name.
				'file_ids' -> self files} asDictionary
]

{ #category : #'as yet unclassified' }
GtLOpenAICreateVectorStoreAPIClient >> serializationClass [
	^ GtLOpenAIVectorStore
]
