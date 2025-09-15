Class {
	#name : #GtOllamaEmbeddingsGroup,
	#superclass : #GtLlmGroup,
	#instVars : [
		'client'
	],
	#category : #Gt4Ollama
}

{ #category : #accessing }
GtOllamaEmbeddingsGroup class >> from: aList [
	^ self
		withAll: ((aList at: 'embeddings')
				collect: [ :anArray | GtOllamaEmbedding new embedding: anArray ])
]

{ #category : #accessing }
GtOllamaEmbeddingsGroup class >> leJsonV4Name [

	^ #gtOllamaEmbeddingsGroup
]

{ #category : #accessing }
GtOllamaEmbeddingsGroup >> client [
	^ client
]

{ #category : #'as yet unclassified' }
GtOllamaEmbeddingsGroup >> client: aGtOllamaClient [
	client := aGtOllamaClient.
	self items do: [ :anItem | anItem client: aGtOllamaClient ]
]
