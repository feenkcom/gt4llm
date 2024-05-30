Class {
	#name : #GtLlmExpandableActionThreadMessageElement,
	#superclass : #GtLlmExpandableThreadMessageElement,
	#category : #'Gt4OpenAI-Widgets'
}

{ #category : #accessing }
GtLlmExpandableActionThreadMessageElement >> initializeThreadMessageElement [
	threadMessageElement := GtLlmActionThreadMessageElement new
]
