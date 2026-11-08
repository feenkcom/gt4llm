Class {
	#name : #GtLACPPromptTurnFinishedState,
	#superclass : #GtLACPPromptTurnState,
	#category : #'Gt4Llm-ACP-Turn states'
}

{ #category : #testing }
GtLACPPromptTurnFinishedState class >> isAbstract [
	^ self == GtLACPPromptTurnFinishedState
]

{ #category : #testing }
GtLACPPromptTurnFinishedState >> isFinished [
	^ true
]
