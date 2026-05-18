Class {
	#name : #GtLModelEmbeddings,
	#superclass : #Object,
	#instVars : [
		'input',
		'embeddings',
		'rawData',
		'model'
	],
	#category : #'Gt4LlmModel-Embeddings'
}

{ #category : #accessing }
GtLModelEmbeddings >> embeddings [
	^ embeddings
]

{ #category : #accessing }
GtLModelEmbeddings >> embeddings: anObject [
	embeddings := anObject
]

{ #category : #accessing }
GtLModelEmbeddings >> input [
	^ input
]

{ #category : #accessing }
GtLModelEmbeddings >> input: anObject [
	input := anObject
]

{ #category : #accessing }
GtLModelEmbeddings >> model [
	^ model
]

{ #category : #accessing }
GtLModelEmbeddings >> model: anObject [
	model := anObject
]

{ #category : #accessing }
GtLModelEmbeddings >> rawData [
	^ rawData
]

{ #category : #accessing }
GtLModelEmbeddings >> rawData: anObject [
	rawData := anObject
]
