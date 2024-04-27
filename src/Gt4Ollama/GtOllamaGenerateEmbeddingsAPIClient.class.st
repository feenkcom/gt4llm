Class {
	#name : #GtOllamaGenerateEmbeddingsAPIClient,
	#superclass : #GtLlmEndpointClient,
	#instVars : [
		'input',
		'model'
	],
	#category : #'Gt4Ollama-Chat'
}

{ #category : #accessing }
GtOllamaGenerateEmbeddingsAPIClient >> input [
	^ input
]

{ #category : #accessing }
GtOllamaGenerateEmbeddingsAPIClient >> input: anObject [
	input := anObject
]

{ #category : #accessing }
GtOllamaGenerateEmbeddingsAPIClient >> model [
	^ model
]

{ #category : #accessing }
GtOllamaGenerateEmbeddingsAPIClient >> model: anObject [
	model := anObject
]

{ #category : #accessing }
GtOllamaGenerateEmbeddingsAPIClient >> request [
	^ self client
		post: '/embeddings'
		withEntity: {'model' -> self model.
				'prompt' -> self input} asDictionary
]

{ #category : #accessing }
GtOllamaGenerateEmbeddingsAPIClient >> serializationClass [
	^ GtOllamaEmbedding
]
