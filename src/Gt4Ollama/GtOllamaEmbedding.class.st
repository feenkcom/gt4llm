Class {
	#name : #GtOllamaEmbedding,
	#superclass : #GtLlmEntity,
	#instVars : [
		'embedding'
	],
	#category : #Gt4Ollama
}

{ #category : #accessing }
GtOllamaEmbedding class >> leJsonV4Name [

	^ #gtOllamaEmbedding
]

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

{ #category : #accessing }
GtOllamaEmbedding >> size [
	^ self embedding size
]
