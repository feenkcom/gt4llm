Class {
	#name : #GtOllamaEmbeddingsGroup,
	#superclass : #GtLlmGroup,
	#instVars : [
		'client'
	],
	#category : #'Gt4Ollama-Models'
}

{ #category : #accessing }
GtOllamaEmbeddingsGroup class >> from: aList [
	^ self
		withAll: ((aList at: 'embeddings')
				collect: [ :anArray | GtOllamaEmbedding new embedding: anArray ])
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

{ #category : #accessing }
GtOllamaEmbeddingsGroup >> gtEmbeddingsFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Embeddings';
		priority: 1;
		items: [ self items withIndexCollect: [ :anItem :anIndex | anIndex -> anItem ] ];
		column: 'Index'
			text: [ :aPair | aPair key asRopedText foreground: BrGlamorousColors disabledButtonTextColor ]
			width: 50;
		column: 'Size' text: [ :aPair | aPair value size ];
		send: #value
]
