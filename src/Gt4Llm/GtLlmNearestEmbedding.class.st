Class {
	#name : #GtLlmNearestEmbedding,
	#superclass : #Object,
	#instVars : [
		'distance',
		'embedding'
	],
	#category : #'Gt4Llm-Embeddings'
}

{ #category : #accessing }
GtLlmNearestEmbedding >> distance [
	^ distance
]

{ #category : #accessing }
GtLlmNearestEmbedding >> distance: anObject [
	distance := anObject
]

{ #category : #accessing }
GtLlmNearestEmbedding >> embedding [
	^ embedding
]

{ #category : #accessing }
GtLlmNearestEmbedding >> embedding: anObject [
	embedding := anObject
]

{ #category : #accessing }
GtLlmNearestEmbedding >> input [
	^ self embedding input
]
