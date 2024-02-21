Class {
	#name : #GtLlmCheckerStringError,
	#superclass : #GtLlmCheckerError,
	#category : #'Gt4Llm-Checker'
}

{ #category : #accessing }
GtLlmCheckerStringError >> content [
	^ self contentString
]
