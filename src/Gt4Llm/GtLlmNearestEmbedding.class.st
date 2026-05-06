Class {
	#name : #GtLlmNearestEmbedding,
	#superclass : #Object,
	#instVars : [
		'distance',
		'embedding'
	],
	#category : #Gt4Llm
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

{ #category : #printing }
GtLlmNearestEmbedding >> printOn: aStream [

	super printOn: aStream.
	aStream parenthesize:
		[ distance ifNotNil:
			[ aStream print: distance ].
		aStream << ': '.
		self input ifNotNil:
			[ aStream << self input asString ] ]
]
