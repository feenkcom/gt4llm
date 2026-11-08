Class {
	#name : #GtLACPPromptTurnReplayedState,
	#superclass : #GtLACPPromptTurnAnsweredState,
	#category : #'Gt4Llm-ACP-Turn states'
}

{ #category : #testing }
GtLACPPromptTurnReplayedState >> isReplayed [
	^ true
]

{ #category : #accessing }
GtLACPPromptTurnReplayedState >> name [
	^ #replayed
]
