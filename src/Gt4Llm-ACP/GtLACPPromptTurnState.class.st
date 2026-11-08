"
I define the execution behavior of one ACP prompt turn and hold a back-reference to that turn. My hierarchy handles activity, cancellation, completion, failure, observation, disconnection, closing and final-reply selection. The turn attaches me when it installs me. My name is a presentation label.
"
Class {
	#name : #GtLACPPromptTurnState,
	#superclass : #GtLACPObject,
	#instVars : [
		'turn'
	],
	#category : #'Gt4Llm-ACP-Turn states'
}

{ #category : #'instance creation' }
GtLACPPromptTurnState class >> forStopReason: aReason [
	"Translate the protocol stop reason into an execution state."

	^ aReason = 'cancelled'
		ifTrue: [ GtLACPPromptTurnCancelledState new ]
		ifFalse: [ GtLACPPromptTurnCompletedState new ]
]

{ #category : #testing }
GtLACPPromptTurnState class >> isAbstract [
	^ self == GtLACPPromptTurnState
]

{ #category : #converting }
GtLACPPromptTurnState >> asString [
	^ self name asString
]

{ #category : #testing }
GtLACPPromptTurnState >> canCancel [
	^ false
]

{ #category : #lifecycle }
GtLACPPromptTurnState >> cancel [
	^ turn
]

{ #category : #lifecycle }
GtLACPPromptTurnState >> close [
	turn cancelPendingInteractions
]

{ #category : #lifecycle }
GtLACPPromptTurnState >> complete: aReason [
	^ turn performComplete: aReason
]

{ #category : #lifecycle }
GtLACPPromptTurnState >> connectionClosed: aReason [
	turn abandonPendingInteractions
]

{ #category : #lifecycle }
GtLACPPromptTurnState >> disconnect [
	turn abandonPendingInteractions
]

{ #category : #lifecycle }
GtLACPPromptTurnState >> fail: aReason [
	^ turn performFail: aReason
]

{ #category : #accessing }
GtLACPPromptTurnState >> finalMessage [
	^ nil
]

{ #category : #lifecycle }
GtLACPPromptTurnState >> finishIdle [
	^ turn performFinishIdle
]

{ #category : #testing }
GtLACPPromptTurnState >> isActive [
	^ false
]

{ #category : #testing }
GtLACPPromptTurnState >> isCancelled [
	^ false
]

{ #category : #testing }
GtLACPPromptTurnState >> isCancelling [
	^ false
]

{ #category : #testing }
GtLACPPromptTurnState >> isClosed [
	^ false
]

{ #category : #testing }
GtLACPPromptTurnState >> isCompleted [
	^ false
]

{ #category : #testing }
GtLACPPromptTurnState >> isDisconnected [
	^ false
]

{ #category : #testing }
GtLACPPromptTurnState >> isFailed [
	^ false
]

{ #category : #testing }
GtLACPPromptTurnState >> isFinished [
	^ false
]

{ #category : #testing }
GtLACPPromptTurnState >> isIdle [
	^ false
]

{ #category : #testing }
GtLACPPromptTurnState >> isObserved [
	^ false
]

{ #category : #testing }
GtLACPPromptTurnState >> isReplayed [
	^ false
]

{ #category : #testing }
GtLACPPromptTurnState >> isRunning [
	^ false
]

{ #category : #accessing }
GtLACPPromptTurnState >> name [
	^ self subclassResponsibility
]

{ #category : #lifecycle }
GtLACPPromptTurnState >> observe [
	^ turn
]

{ #category : #printing }
GtLACPPromptTurnState >> printOn: aStream [
	aStream nextPutAll: self asString
]

{ #category : #lifecycle }
GtLACPPromptTurnState >> start [
	turn state: GtLACPPromptTurnRunningState new
]

{ #category : #accessing }
GtLACPPromptTurnState >> turn [
	^ turn
]

{ #category : #accessing }
GtLACPPromptTurnState >> turn: anOwner [
	turn := anOwner
]
