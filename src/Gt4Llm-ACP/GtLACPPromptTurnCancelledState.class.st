Class {
	#name : #GtLACPPromptTurnCancelledState,
	#superclass : #GtLACPPromptTurnFinishedState,
	#category : #'Gt4Llm-ACP-Turn states'
}

{ #category : #testing }
GtLACPPromptTurnCancelledState >> isCancelled [
	^ true
]

{ #category : #accessing }
GtLACPPromptTurnCancelledState >> name [
	^ #cancelled
]
