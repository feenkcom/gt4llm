Class {
	#name : #GtLlmNearestEmbeddingsGroup,
	#superclass : #GtLlmGroup,
	#category : #'Gt4Llm-Embeddings'
}

{ #category : #accessing }
GtLlmNearestEmbeddingsGroup >> gtEmbeddingsFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Embeddings';
		priority: 1;
		items: [ self items ];
		column: 'Distance' text: #distance width: 150;
		column: 'Input' text: #input
]
