Class {
	#name : #GtLlmStepThreadMessageViewModel,
	#superclass : #GtLlmThreadMessageViewModel,
	#category : #'Gt4Llm-Widgets'
}

{ #category : #accessing }
GtLlmStepThreadMessageViewModel >> elementClass [
	^ self threadMessage hasStep
		ifTrue: [ self threadMessage step elementClass ]
		ifFalse: [ self threadMessage elementClass ]
]

{ #category : #accessing }
GtLlmStepThreadMessageViewModel >> step [
	^ self threadMessage step
]
