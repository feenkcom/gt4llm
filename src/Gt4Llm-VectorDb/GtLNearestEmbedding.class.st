Class {
	#name : #GtLNearestEmbedding,
	#superclass : #Object,
	#instVars : [
		'distance',
		'embedding',
		'document'
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
GtLNearestEmbedding >> document [
	^ document
]

{ #category : #accessing }
GtLNearestEmbedding >> document: anObject [
	document := anObject
]

{ #category : #accessing }
GtLNearestEmbedding >> embedding [
	^ embedding
]

{ #category : #accessing }
GtLNearestEmbedding >> embedding: anObject [
	embedding := anObject
]
