Class {
	#name : #Gt4OpenAIEmbeddingsGroup,
	#superclass : #Gt4OpenAIGroup,
	#category : #'Gt4OpenAI-Models'
}

{ #category : #accessing }
Gt4OpenAIEmbeddingsGroup class >> from: aList [
	^ self
		withAll: ((aList at: 'data')
				collect: [ :aModel | Gt4OpenAIEmbedding from: (aModel at: 'embedding') ])
]

{ #category : #accessing }
Gt4OpenAIEmbeddingsGroup >> gtEmbeddingsFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Embeddings';
		priority: 1;
		items: [ self items ];
		column: 'Size' text: #size
]
