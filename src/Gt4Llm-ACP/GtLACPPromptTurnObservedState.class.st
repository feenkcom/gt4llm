Class {
	#name : #GtLACPPromptTurnObservedState,
	#superclass : #GtLACPPromptTurnState,
	#category : #'Gt4Llm-ACP-Turn states'
}

{ #category : #testing }
GtLACPPromptTurnObservedState >> isObserved [
	^ true
]

{ #category : #accessing }
GtLACPPromptTurnObservedState >> name [
	^ #observed
]
