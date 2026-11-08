Class {
	#name : #GtLACPPromptTurnClosedState,
	#superclass : #GtLACPPromptTurnFinishedState,
	#category : #'Gt4Llm-ACP-Turn states'
}

{ #category : #lifecycle }
GtLACPPromptTurnClosedState >> complete: aReason [
	^ turn
]

{ #category : #lifecycle }
GtLACPPromptTurnClosedState >> fail: aReason [
	^ turn
]

{ #category : #testing }
GtLACPPromptTurnClosedState >> isClosed [
	^ true
]

{ #category : #accessing }
GtLACPPromptTurnClosedState >> name [
	^ #closed
]
