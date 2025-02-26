Class {
	#name : #GtOpenAICreateVectorStoreAPIClient,
	#superclass : #GtLlmEndpointClient,
	#instVars : [
		'name',
		'files'
	],
	#category : #Gt4OpenAI
}

{ #category : #accessing }
GtOpenAICreateVectorStoreAPIClient >> files [
	^ files
]

{ #category : #accessing }
GtOpenAICreateVectorStoreAPIClient >> files: anObject [
	files := anObject
]

{ #category : #accessing }
GtOpenAICreateVectorStoreAPIClient >> name [
	^ name
]

{ #category : #accessing }
GtOpenAICreateVectorStoreAPIClient >> name: anObject [
	name := anObject
]

{ #category : #'as yet unclassified' }
GtOpenAICreateVectorStoreAPIClient >> request [
	^ self client
		post: 'vector_stores'
		withEntity: {'name' -> self name.
				'file_ids' -> self files} asDictionary
]

{ #category : #'as yet unclassified' }
GtOpenAICreateVectorStoreAPIClient >> serializationClass [
	^ GtOpenAIVectorStore
]
