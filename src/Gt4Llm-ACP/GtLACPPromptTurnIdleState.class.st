Class {
	#name : #GtLACPPromptTurnIdleState,
	#superclass : #GtLACPPromptTurnAnsweredState,
	#category : #'Gt4Llm-ACP-Turn states'
}

{ #category : #testing }
GtLACPPromptTurnIdleState >> isIdle [
	^ true
]

{ #category : #accessing }
GtLACPPromptTurnIdleState >> name [
	^ #idle
]
