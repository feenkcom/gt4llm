Class {
	#name : #GtLlmStepStringError,
	#superclass : #GtLlmStepError,
	#category : #'Gt4Llm-Code'
}

{ #category : #accessing }
GtLlmStepStringError >> content [
	^ self contentString
]
