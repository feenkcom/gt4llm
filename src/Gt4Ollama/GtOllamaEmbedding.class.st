Class {
	#name : #GtOllamaEmbedding,
	#superclass : #GtLlmEntity,
	#instVars : [
		'embedding'
	],
	#category : #'Gt4Ollama-Models'
}

{ #category : #accessing }
GtOllamaEmbedding class >> serializationProperties [
	^ {#embedding -> #embedding}
]

{ #category : #accessing }
GtOllamaEmbedding >> embedding [
	^ embedding
]

{ #category : #accessing }
GtOllamaEmbedding >> embedding: anObject [
	embedding := anObject
]
