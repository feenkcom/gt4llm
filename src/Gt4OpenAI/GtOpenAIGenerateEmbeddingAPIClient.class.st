Class {
	#name : #GtOpenAIGenerateEmbeddingAPIClient,
	#superclass : #GtLlmEndpointClient,
	#instVars : [
		'input',
		'model'
	],
	#category : #'Gt4OpenAI-Client'
}

{ #category : #accessing }
GtOpenAIGenerateEmbeddingAPIClient >> input [
	^ input
]

{ #category : #accessing }
GtOpenAIGenerateEmbeddingAPIClient >> input: anObject [
	input := anObject
]

{ #category : #accessing }
GtOpenAIGenerateEmbeddingAPIClient >> model [
	^ model
]

{ #category : #accessing }
GtOpenAIGenerateEmbeddingAPIClient >> model: anObject [
	model := anObject
]

{ #category : #accessing }
GtOpenAIGenerateEmbeddingAPIClient >> request [
	^ self client
		post: 'embeddings'
		withEntity: {'model' -> self model.
				'input' -> self input} asDictionary
]

{ #category : #accessing }
GtOpenAIGenerateEmbeddingAPIClient >> serializationClass [
	^ GtOpenAIEmbeddingsGroup
]
