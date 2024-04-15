Class {
	#name : #GtLlmStepNotExecuted,
	#superclass : #GtLlmStepResult,
	#category : #'Gt4Llm-Code'
}

{ #category : #accessing }
GtLlmStepNotExecuted >> asString [
	^ 'Not executed'
]

{ #category : #accessing }
GtLlmStepNotExecuted >> backgroundColor [
	^ BrGlamorousColors disabledButtonTextColor
]

{ #category : #accessing }
GtLlmStepNotExecuted >> foregroundColor [
	^ Color black
]

{ #category : #accessing }
GtLlmStepNotExecuted >> isExecuted [
	^ false
]
