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
GtLlmCheckerNotExecuted >> backgroundColor [
	^ BrGlamorousColors disabledButtonTextColor
]

{ #category : #accessing }
GtLlmCheckerNotExecuted >> foregroundColor [
	^ Color black
]

{ #category : #accessing }
GtLlmCheckerNotExecuted >> isExecuted [
	^ false
]
