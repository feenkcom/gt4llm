Class {
	#name : #GtLVectorDbEmbedding,
	#superclass : #Object,
	#instVars : [
		'embedding',
		'key'
	],
	#category : #'Gt4Llm-VectorDb-Model'
}

{ #category : #accessing }
GtLVectorDbEmbedding >> embedding [
	^ embedding
]

{ #category : #accessing }
GtLVectorDbEmbedding >> embedding: anObject [
	embedding := anObject
]

{ #category : #accessing }
GtLVectorDbEmbedding >> key [
	^ key
]

{ #category : #accessing }
GtLVectorDbEmbedding >> key: anObject [
	key := anObject
]
