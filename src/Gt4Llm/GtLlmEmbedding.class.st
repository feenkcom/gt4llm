Class {
	#name : #GtLlmEmbedding,
	#superclass : #Object,
	#instVars : [
		'input',
		'embedding'
	],
	#category : #'Gt4Llm-Embeddings'
}

{ #category : #accessing }
GtLlmEmbedding >> embedding [
	^ embedding
]

{ #category : #accessing }
GtLlmEmbedding >> embedding: anObject [
	embedding := anObject
]

{ #category : #accessing }
GtLlmEmbedding >> gtEmbeddingFor: aView [
	<gtView>
	^ aView list
		title: 'Embedding';
		priority: 2;
		items: [ self embedding ]
]

{ #category : #accessing }
GtLlmEmbedding >> gtInputFor: aView [
	<gtView>
	^ aView textEditor
		title: 'Input';
		priority: 1;
		text: [ self input ]
]

{ #category : #accessing }
GtLlmEmbedding >> input [
	^ input
]

{ #category : #accessing }
GtLlmEmbedding >> input: anObject [
	input := anObject
]
