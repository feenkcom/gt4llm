Class {
	#name : #GtOpenAIEmbeddingsGroup,
	#superclass : #GtOpenAIGroup,
	#category : #'Gt4OpenAI-Models'
}

{ #category : #accessing }
GtOpenAIEmbeddingsGroup class >> from: aList [
	^ self
		withAll: ((aList at: 'data')
				collect: [ :aModel | GtOpenAIEmbedding from: (aModel at: 'embedding') ])
]

{ #category : #accessing }
GtOpenAIEmbeddingsGroup >> gtEmbeddingsFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Embeddings';
		priority: 1;
		items: [ self items ];
		column: 'Size' text: #size
]
