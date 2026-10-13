Class {
	#name : #GtLEmbedding,
	#superclass : #Object,
	#instVars : [
		'input',
		'embedding'
	],
	#category : #'Gt4Llm-VectorDb'
}

{ #category : #accessing }
GtLEmbedding >> embedding [
	^ embedding
]

{ #category : #accessing }
GtLEmbedding >> embedding: anObject [
	embedding := anObject
]

{ #category : #accessing }
GtLEmbedding >> gtEmbeddingFor: aView [
	<gtView>
	^ aView list
		title: 'Embedding';
		priority: 2;
		items: [ self embedding ]
]

{ #category : #accessing }
GtLEmbedding >> gtInputFor: aView [
	<gtView>
	^ aView textEditor
		title: 'Input';
		priority: 1;
		text: [ self input ]
]

{ #category : #accessing }
GtLEmbedding >> input [
	^ input
]

{ #category : #accessing }
GtLEmbedding >> input: anObject [
	input := anObject
]
