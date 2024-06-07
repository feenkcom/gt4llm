Class {
	#name : #GtLlmExpandableStepThreadMessageElement,
	#superclass : #GtLlmExpandableThreadMessageElement,
	#category : #'Gt4Llm-Widgets'
}

{ #category : #accessing }
GtLlmExpandableStepThreadMessageElement >> initializeThreadMessageElement [
	threadMessageElement := GtLlmStepThreadMessageElement new
]
