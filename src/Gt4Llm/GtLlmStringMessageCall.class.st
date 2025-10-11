Class {
	#name : #GtLlmStringMessageCall,
	#superclass : #GtLlmMessageCall,
	#instVars : [
		'string'
	],
	#category : #Gt4Llm
}

{ #category : #'as yet unclassified' }
GtLlmStringMessageCall >> serialize [
	^ string
]

{ #category : #accessing }
GtLlmStringMessageCall >> string: anObject [
	string := anObject
]
