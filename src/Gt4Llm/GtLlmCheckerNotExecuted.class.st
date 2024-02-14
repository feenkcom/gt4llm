Class {
	#name : #GtLlmCheckerNotExecuted,
	#superclass : #GtLlmCheckerResult,
	#category : #'Gt4Llm-Checker'
}

{ #category : #accessing }
GtLlmCheckerNotExecuted >> asString [
	^ 'Not executed'
]

{ #category : #accessing }
GtLlmCheckerNotExecuted >> color [
	^ BrGlamorousColors disabledButtonTextColor
]
