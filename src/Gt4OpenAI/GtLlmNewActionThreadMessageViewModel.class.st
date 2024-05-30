Class {
	#name : #GtLlmNewActionThreadMessageViewModel,
	#superclass : #GtLlmNewThreadMessageViewModel,
	#category : #'Gt4OpenAI-Widgets'
}

{ #category : #accessing }
GtLlmNewActionThreadMessageViewModel >> actions [
	^ self threadMessage actions
]

{ #category : #accessing }
GtLlmNewActionThreadMessageViewModel >> currentAction: anObject [
	threadMessage currentAction: anObject
]

{ #category : #accessing }
GtLlmNewActionThreadMessageViewModel >> elementClass [
	^ GtLlmNewActionThreadMessageElement
]
