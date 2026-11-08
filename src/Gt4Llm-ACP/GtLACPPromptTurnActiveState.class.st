Class {
	#name : #GtLACPPromptTurnActiveState,
	#superclass : #GtLACPPromptTurnState,
	#category : #'Gt4Llm-ACP-Turn states'
}

{ #category : #testing }
GtLACPPromptTurnActiveState class >> isAbstract [
	^ self == GtLACPPromptTurnActiveState
]

{ #category : #lifecycle }
GtLACPPromptTurnActiveState >> close [
	^ turn performClose
]

{ #category : #lifecycle }
GtLACPPromptTurnActiveState >> connectionClosed: aReason [
	^ turn performFail: aReason
]

{ #category : #lifecycle }
GtLACPPromptTurnActiveState >> disconnect [
	^ turn performDisconnect
]

{ #category : #testing }
GtLACPPromptTurnActiveState >> isActive [
	^ true
]

{ #category : #lifecycle }
GtLACPPromptTurnActiveState >> observe [
	turn state: GtLACPPromptTurnObservedState new
]
