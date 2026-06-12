Class {
	#name : #GtLLepiterVectorDb,
	#superclass : #Object,
	#instVars : [
		'vectorDb'
	],
	#category : #'Gt4Llm-VectorDb-Support'
}

{ #category : #accessing }
GtLLepiterVectorDb >> size [

	^ vectorDb size
]

{ #category : #accessing }
GtLLepiterVectorDb >> vectorDb [
	^ vectorDb
]

{ #category : #accessing }
GtLLepiterVectorDb >> vectorDb: anObject [
	vectorDb := anObject
]
