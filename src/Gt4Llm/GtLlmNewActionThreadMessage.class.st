Class {
	#name : #GtLlmNewActionThreadMessage,
	#superclass : #GtLlmNewThreadMessage,
	#instVars : [
		'currentAction'
	],
	#category : #'Gt4Llm-Widgets'
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
	^ assistantChat messageFromString: (currentAction format format: {contents})
]
