Class {
	#name : #GtLACPPromptTurnFailedState,
	#superclass : #GtLACPPromptTurnFinishedState,
	#category : #'Gt4Llm-ACP-Turn states'
}

{ #category : #testing }
GtLACPPromptTurnFailedState >> isFailed [
	^ true
]

{ #category : #accessing }
GtLACPPromptTurnFailedState >> name [
	^ #failed
]
