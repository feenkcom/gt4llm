Class {
	#name : #GtOpenAIEmbedding,
	#superclass : #GtOpenAIEntity,
	#instVars : [
		'embedding'
	],
	#category : #'Gt4OpenAI-Models'
}

{ #category : #accessing }
GtOpenAIEmbedding class >> from: anArray [
	^ self new
		rawData: anArray;
		embedding: (anArray collect: [ :aNumber | aNumber ] as: FloatArray)
]

{ #category : #accessing }
GtOpenAIEmbedding >> embedding [
	^ embedding
]

{ #category : #accessing }
GtOpenAIEmbedding >> embedding: anObject [
	embedding := anObject
]

{ #category : #accessing }
GtOpenAIEmbedding >> serialize [
	^ self embedding
]

{ #category : #accessing }
GtOpenAIEmbedding >> size [
	^ self embedding size
]
