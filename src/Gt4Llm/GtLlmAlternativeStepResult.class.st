Class {
	#name : #GtLlmAlternativeStepResult,
	#superclass : #GtLlmCompositeStepResult,
	#category : #'Gt4Llm-Code'
}

{ #category : #accessing }
GtLlmAlternativeStepResult >> content [
	^ self lastResult content
]

{ #category : #accessing }
GtLlmAlternativeStepResult >> lastResult [
	^ results detect: #isExecuted ifNone: [ input ]
]

{ #category : #accessing }
GtLlmAlternativeStepResult >> results [
	^ results select: #isExecuted
]
