Class {
	#name : #GtLACPPromptTurnAnsweredState,
	#superclass : #GtLACPPromptTurnFinishedState,
	#category : #'Gt4Llm-ACP-Turn states'
}

{ #category : #testing }
GtLACPPromptTurnAnsweredState class >> isAbstract [
	^ self == GtLACPPromptTurnAnsweredState
]

{ #category : #accessing }
GtLACPPromptTurnAnsweredState >> finalMessage [
	^ turn lastAgentMessage
]
