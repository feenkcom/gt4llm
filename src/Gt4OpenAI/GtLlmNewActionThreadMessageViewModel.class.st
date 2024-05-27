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
GtLlmNewActionThreadMessageViewModel >> elementClass [
	^ GtLlmNewActionThreadMessageElement
]
