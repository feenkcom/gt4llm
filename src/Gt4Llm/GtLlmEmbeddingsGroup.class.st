Class {
	#name : #GtLlmEmbeddingsGroup,
	#superclass : #GtLlmGroup,
	#category : #'Gt4Llm-Embeddings'
}

{ #category : #accessing }
GtLlmEmbeddingsGroup >> gtEmbeddingsFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Embeddings';
		priority: 1;
		items: [ self items ];
		column: 'Input' text: #input
]
