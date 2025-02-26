Class {
	#name : #GtLlmNewActionThreadMessage,
	#superclass : #GtLlmNewThreadMessage,
	#instVars : [
		'currentAction'
	],
	#category : #Gt4Llm
}

{ #category : #accessing }
GtLlmNewActionThreadMessage >> currentAction [
	^ currentAction
]

{ #category : #accessing }
GtLlmNewActionThreadMessage >> currentAction: anObject [
	currentAction := anObject
]

{ #category : #'as yet unclassified' }
GtLlmNewActionThreadMessage >> treatString [
	^ currentAction format format: {contents}
]
