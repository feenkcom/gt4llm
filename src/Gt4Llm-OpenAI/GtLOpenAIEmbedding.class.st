Class {
	#name : #GtLOpenAIEmbedding,
	#superclass : #GtLEntity,
	#instVars : [
		'embedding'
	],
	#category : #'Gt4Llm-OpenAI'
}

{ #category : #accessing }
GtLOpenAIEmbedding class >> from: anArray [
	^ self new
		rawData: anArray;
		embedding: (anArray collect: [ :aNumber | aNumber ] as: OrderedCollection)
]

{ #category : #accessing }
GtLOpenAIEmbedding class >> leJsonV4Name [

	^ #gtOpenAIEmbedding
]

{ #category : #accessing }
GtLOpenAIEmbedding >> embedding [
	^ embedding
]

{ #category : #accessing }
GtLOpenAIEmbedding >> embedding: anObject [
	embedding := anObject
]

{ #category : #accessing }
GtLOpenAIEmbedding >> serialize [
	^ self embedding
]

{ #category : #accessing }
GtLOpenAIEmbedding >> size [
	^ self embedding size
]
