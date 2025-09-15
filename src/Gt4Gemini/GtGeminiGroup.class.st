Class {
	#name : #GtGeminiGroup,
	#superclass : #GtLlmGroup,
	#instVars : [
		'client'
	],
	#category : #Gt4Gemini
}

{ #category : #'as yet unclassified' }
GtGeminiGroup class >> from: aList [
	^ self
		withAll: ((aList at: self property) collect: [ :aModel | self itemClass from: aModel ])
]

{ #category : #'as yet unclassified' }
GtGeminiGroup class >> itemClass [
	^ self subclassResponsibility
]

{ #category : #accessing }
GtGeminiGroup class >> leJsonV4Name [

	^ #gtGeminiGroup
]

{ #category : #'as yet unclassified' }
GtGeminiGroup class >> property [
	^ self subclassResponsibility
]

{ #category : #accessing }
GtGeminiGroup >> client [
	^ client
]

{ #category : #accessing }
GtGeminiGroup >> client: anObject [
	client := anObject
]
