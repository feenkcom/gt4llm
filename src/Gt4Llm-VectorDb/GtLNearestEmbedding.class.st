Class {
	#name : #GtLNearestEmbedding,
	#superclass : #Object,
	#instVars : [
		'distance',
		'embedding'
	],
	#category : #'Gt4Llm-VectorDb-Support'
}

{ #category : #accessing }
GtLNearestEmbedding >> distance [
	^ distance
]

{ #category : #accessing }
GtLNearestEmbedding >> distance: anObject [
	distance := anObject
]

{ #category : #accessing }
GtLNearestEmbedding >> embedding [
	^ embedding
]

{ #category : #accessing }
GtLNearestEmbedding >> embedding: anObject [
	embedding := anObject
]
