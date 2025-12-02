Class {
	#name : #GtLOpenAICreateVectorStoreAPICommand,
	#superclass : #GtLAPICommand,
	#instVars : [
		'name',
		'files'
	],
	#category : #'Gt4Llm-OpenAI'
}

{ #category : #accessing }
GtLOpenAICreateVectorStoreAPICommand >> files [
	^ files
]

{ #category : #accessing }
GtLOpenAICreateVectorStoreAPICommand >> files: anObject [
	files := anObject
]

{ #category : #accessing }
GtLOpenAICreateVectorStoreAPICommand >> name [
	^ name
]

{ #category : #accessing }
GtLOpenAICreateVectorStoreAPICommand >> name: anObject [
	name := anObject
]

{ #category : #'as yet unclassified' }
GtLOpenAICreateVectorStoreAPICommand >> request [
	^ self client
		post: 'vector_stores'
		withEntity: {'name' -> self name.
				'file_ids' -> self files} asDictionary
]

{ #category : #'as yet unclassified' }
GtLOpenAICreateVectorStoreAPICommand >> serializationClass [
	^ GtLOpenAIVectorStore
]
