Class {
	#name : #GtLOpenAIGenerateEmbeddingAPIClient,
	#superclass : #GtLAPICommand,
	#instVars : [
		'input',
		'model'
	],
	#category : #'Gt4Llm-OpenAI'
}

{ #category : #accessing }
GtLOpenAIGenerateEmbeddingAPIClient >> input [
	^ input
]

{ #category : #accessing }
GtLOpenAIGenerateEmbeddingAPIClient >> input: anObject [
	input := anObject
]

{ #category : #accessing }
GtLOpenAIGenerateEmbeddingAPIClient >> model [
	^ model
]

{ #category : #accessing }
GtLOpenAIGenerateEmbeddingAPIClient >> model: anObject [
	model := anObject
]

{ #category : #accessing }
GtLOpenAIGenerateEmbeddingAPIClient >> request [
	^ self client
		post: 'embeddings'
		withEntity: {'model' -> self model.
				'input' -> self input} asDictionary
]

{ #category : #accessing }
GtLOpenAIGenerateEmbeddingAPIClient >> serializationClass [
	^ GtLOpenAIEmbeddingsGroup
]
