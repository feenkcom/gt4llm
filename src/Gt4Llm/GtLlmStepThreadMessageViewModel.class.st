Class {
	#name : #GtLlmStepThreadMessageViewModel,
	#superclass : #GtLlmThreadMessageViewModel,
	#category : #'Gt4Llm-Widgets'
}

{ #category : #accessing }
GtLlmStepThreadMessageViewModel >> elementClass [
	^ self threadMessage step elementClass
]
