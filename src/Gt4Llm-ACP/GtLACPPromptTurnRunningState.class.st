Class {
	#name : #GtLACPPromptTurnRunningState,
	#superclass : #GtLACPPromptTurnActiveState,
	#category : #'Gt4Llm-ACP-Turn states'
}

{ #category : #testing }
GtLACPPromptTurnRunningState >> canCancel [
	^ true
]

{ #category : #lifecycle }
GtLACPPromptTurnRunningState >> cancel [
	^ turn performCancel
]

{ #category : #testing }
GtLACPPromptTurnRunningState >> isRunning [
	^ true
]

{ #category : #accessing }
GtLACPPromptTurnRunningState >> name [
	^ #running
]
