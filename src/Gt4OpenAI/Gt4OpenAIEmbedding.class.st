Class {
	#name : #Gt4OpenAIEmbedding,
	#superclass : #Gt4OpenAIEntity,
	#instVars : [
		'embedding'
	],
	#category : #'Gt4OpenAI-Models'
}

{ #category : #accessing }
Gt4OpenAIEmbedding class >> from: anArray [
	^ self new
		rawData: anArray;
		embedding: (anArray collect: [ :aNumber | aNumber ] as: FloatArray)
]

{ #category : #accessing }
Gt4OpenAIEmbedding >> embedding [
	^ embedding
]

{ #category : #accessing }
Gt4OpenAIEmbedding >> embedding: anObject [
	embedding := anObject
]

{ #category : #accessing }
Gt4OpenAIEmbedding >> serialize [
	^ self embedding
]

{ #category : #accessing }
Gt4OpenAIEmbedding >> size [
	^ self embedding size
]
