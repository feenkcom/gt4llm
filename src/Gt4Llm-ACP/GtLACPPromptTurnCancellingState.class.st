Class {
	#name : #GtLACPPromptTurnCancellingState,
	#superclass : #GtLACPPromptTurnActiveState,
	#category : #'Gt4Llm-ACP-Turn states'
}

{ #category : #testing }
GtLACPPromptTurnCancellingState >> isCancelling [
	^ true
]

{ #category : #accessing }
GtLACPPromptTurnCancellingState >> name [
	^ #cancelling
]
