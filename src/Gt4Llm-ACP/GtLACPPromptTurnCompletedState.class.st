Class {
	#name : #GtLACPPromptTurnCompletedState,
	#superclass : #GtLACPPromptTurnAnsweredState,
	#category : #'Gt4Llm-ACP-Turn states'
}

{ #category : #testing }
GtLACPPromptTurnCompletedState >> isCompleted [
	^ true
]

{ #category : #accessing }
GtLACPPromptTurnCompletedState >> name [
	^ #completed
]
