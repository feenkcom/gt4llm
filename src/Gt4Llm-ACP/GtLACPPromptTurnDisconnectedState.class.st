Class {
	#name : #GtLACPPromptTurnDisconnectedState,
	#superclass : #GtLACPPromptTurnFinishedState,
	#category : #'Gt4Llm-ACP-Turn states'
}

{ #category : #testing }
GtLACPPromptTurnDisconnectedState >> isDisconnected [
	^ true
]

{ #category : #accessing }
GtLACPPromptTurnDisconnectedState >> name [
	^ #disconnected
]
