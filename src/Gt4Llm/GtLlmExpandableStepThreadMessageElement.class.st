Class {
	#name : #GtLlmExpandableStepThreadMessageElement,
	#superclass : #GtLlmExpandableThreadMessageElement,
	#category : #'Gt4Llm-Examples'
}

{ #category : #accessing }
GtLlmExpandableStepThreadMessageElement >> initializeThreadMessageElement [
	threadMessageElement := GtLlmStepThreadMessageElement new
]
