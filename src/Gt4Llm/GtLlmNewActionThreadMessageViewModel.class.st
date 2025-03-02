Class {
	#name : #GtLlmNewActionThreadMessageViewModel,
	#superclass : #GtLlmNewThreadMessageViewModel,
	#category : #Gt4Llm
}

{ #category : #accessing }
GtLlmNewActionThreadMessageViewModel >> actions [
	^ self threadMessage actions
]

{ #category : #'as yet unclassified' }
GtLlmNewActionThreadMessageViewModel >> currentAction [
	^ threadMessage currentAction
]

{ #category : #accessing }
GtLlmNewActionThreadMessageViewModel >> currentAction: anObject [
	threadMessage currentAction: anObject
]

{ #category : #accessing }
GtLlmNewActionThreadMessageViewModel >> elementClass [
	^ GtLlmNewActionThreadMessageElement
]
