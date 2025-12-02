Class {
	#name : #GtLOpenAIGenerateEmbeddingAPICommand,
	#superclass : #GtLAPICommand,
	#instVars : [
		'input',
		'model'
	],
	#category : #'Gt4Llm-OpenAI'
}

{ #category : #accessing }
GtLOpenAIGenerateEmbeddingAPICommand >> input [
	^ input
]

{ #category : #accessing }
GtLOpenAIGenerateEmbeddingAPICommand >> input: anObject [
	input := anObject
]

{ #category : #accessing }
GtLOpenAIGenerateEmbeddingAPICommand >> model [
	^ model
]

{ #category : #accessing }
GtLOpenAIGenerateEmbeddingAPICommand >> model: anObject [
	model := anObject
]

{ #category : #accessing }
GtLOpenAIGenerateEmbeddingAPICommand >> request [
	^ self client
		post: 'embeddings'
		withEntity: {'model' -> self model.
				'input' -> self input} asDictionary
]

{ #category : #accessing }
GtLOpenAIGenerateEmbeddingAPICommand >> serializationClass [
	^ GtLOpenAIEmbeddingsGroup
]
