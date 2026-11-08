"
Executable examples for prompt turn state objects, explicit state installation, execution and cancellation transitions, final-reply selection, connection loss, closing, owner references and late outcomes.
"
Class {
	#name : #GtLACPPromptTurnStateExamples,
	#superclass : #Object,
	#category : #'Gt4Llm-ACP-Examples'
}

{ #category : #examples }
GtLACPPromptTurnStateExamples >> cancellationIsAnActiveState [
	<gtExample>
	| turn |
	turn := GtLACPPromptTurn new.
	turn cancel.
	self assert: turn state class equals: GtLACPPromptTurnCancellingState.
	self assert: turn isActive.
	self assert: turn canCancel not.
	self assert: turn finishedAt isNil.
	turn cancel.
	self assert: turn isCancelling.
	turn complete: 'cancelled'.
	self assert: turn state class equals: GtLACPPromptTurnCancelledState.
	self assert: (turn state isKindOf: GtLACPPromptTurnFinishedState).
	self assert: turn isActive not.
	self assert: turn isFinished.
	self assert: turn stopReason equals: 'cancelled'.
	self assert: turn finishedAt notNil.
	^ turn
]

{ #category : #examples }
GtLACPPromptTurnStateExamples >> cancellationResolvesPendingInteractions [
	<gtExample>
	| permission session turn |
	permission := GtLACPExamples new pendingPermission.
	session := permission session.
	turn := session currentTurn.
	[ session cancelTurn.
	self assert: turn state class equals: GtLACPPromptTurnCancellingState.
	self assert: permission state equals: #cancelled.
	self assert: session canCancel not ] ensure: [ session close ].
	^ turn
]

{ #category : #examples }
GtLACPPromptTurnStateExamples >> childDisconnectionIsDistinctFromFailure [
	<gtExample>
	| turn |
	turn := GtLACPPromptTurn new.
	turn disconnect.
	self assert: turn state class equals: GtLACPPromptTurnDisconnectedState.
	self assert: turn isFinished.
	self assert: turn isActive not.
	self assert: turn error isNil.
	self assert: turn stopReason isNil.
	self assert: turn finishedAt notNil.
	^ turn
]

{ #category : #examples }
GtLACPPromptTurnStateExamples >> closingKeepsCompletedHistory [
	<gtExample>
	| turn reply finished |
	turn := GtLACPPromptTurn new.
	reply := turn
			addMessageWithRole: #agent
			content: {GtLACPContentBlock text: 'Answer'}.
	turn complete: 'end_turn'.
	finished := turn finishedAt.
	turn close.
	self assert: turn isCompleted.
	self assert: turn finalMessage == reply.
	self assert: turn finishedAt equals: finished.
	^ turn
]

{ #category : #examples }
GtLACPPromptTurnStateExamples >> closingProtectsTheOutcome [
	<gtExample>
	| turn finished |
	turn := GtLACPPromptTurn new.
	turn close.
	finished := turn finishedAt.
	self assert: turn state class equals: GtLACPPromptTurnClosedState.
	turn complete: 'end_turn'.
	turn fail: 'Late failure'.
	turn cancel.
	self assert: turn isClosed.
	self assert: turn stopReason isNil.
	self assert: turn error isNil.
	self assert: turn finishedAt equals: finished.
	^ turn
]

{ #category : #examples }
GtLACPPromptTurnStateExamples >> completionExposesFinalReply [
	<gtExample>
	| turn reply |
	turn := GtLACPPromptTurn new.
	reply := turn
			addMessageWithRole: #agent
			content: {GtLACPContentBlock text: 'Answer'}.
	self assert: turn finalMessage isNil.
	turn complete: 'end_turn'.
	self assert: turn state class equals: GtLACPPromptTurnCompletedState.
	self assert: (turn state isKindOf: GtLACPPromptTurnAnsweredState).
	self assert: turn finalMessage == reply.
	self assert: turn assistantMessage hasCompletedReply.
	self assert: turn assistantMessage finalMessages first == reply.
	^ turn
]

{ #category : #examples }
GtLACPPromptTurnStateExamples >> connectionLossFinishesOnlyActiveWork [
	<gtExample>
	| active finished |
	active := GtLACPPromptTurn new.
	active connectionClosed: 'Connection lost'.
	self assert: active state class equals: GtLACPPromptTurnFailedState.
	self assert: active error equals: 'Connection lost'.
	self assert: active finishedAt notNil.
	finished := GtLACPPromptTurn new.
	finished complete: 'end_turn'.
	finished connectionClosed: 'Connection lost'.
	self assert: finished isCompleted.
	self assert: finished error isNil.
	^ {active.
		finished}
]

{ #category : #examples }
GtLACPPromptTurnStateExamples >> initialStateIsAnObject [
	<gtExample>
	| turn |
	turn := GtLACPPromptTurn new.
	self assert: turn state class equals: GtLACPPromptTurnRunningState.
	self assert: (turn state isKindOf: GtLACPPromptTurnActiveState).
	self assert: turn state turn == turn.
	self assert: turn isRunning.
	self assert: turn isActive.
	self assert: turn isFinished not.
	self assert: turn canCancel.
	self assert: turn finalMessage isNil.
	^ turn
]

{ #category : #examples }
GtLACPPromptTurnStateExamples >> observedWorkCanResume [
	<gtExample>
	| turn started |
	turn := GtLACPPromptTurn new.
	started := turn startedAt.
	turn observe.
	self assert: turn isObserved.
	self assert: turn isActive not.
	self assert: turn isFinished not.
	turn start.
	self assert: turn isRunning.
	self assert: turn canCancel.
	self assert: turn startedAt equals: started.
	turn finishIdle.
	self assert: turn state class equals: GtLACPPromptTurnIdleState.
	self assert: turn isFinished.
	self assert: turn stopReason isNil.
	self assert: turn finishedAt notNil.
	^ turn
]

{ #category : #examples }
GtLACPPromptTurnStateExamples >> onlyAnsweredStatesExposeFinalReply [
	<gtExample>
	| turns |
	turns := OrderedCollection new.
	{GtLACPPromptTurnCompletedState.
		GtLACPPromptTurnReplayedState.
		GtLACPPromptTurnIdleState}
		do: [ :stateClass | 
			| turn reply |
			turn := GtLACPPromptTurn new
					state: stateClass new;
					yourself.
			reply := turn
					addMessageWithRole: #agent
					content: {GtLACPContentBlock text: 'Answer'}.
			self assert: turn finalMessage == reply.
			self assert: turn assistantMessage hasCompletedReply.
			turns add: turn ].
	{GtLACPPromptTurnRunningState.
		GtLACPPromptTurnCancellingState.
		GtLACPPromptTurnCancelledState.
		GtLACPPromptTurnFailedState.
		GtLACPPromptTurnObservedState.
		GtLACPPromptTurnClosedState.
		GtLACPPromptTurnDisconnectedState}
		do: [ :stateClass | 
			| turn |
			turn := GtLACPPromptTurn new
					state: stateClass new;
					yourself.
			turn
				addMessageWithRole: #agent
				content: {GtLACPContentBlock text: 'Partial answer'}.
			self assert: turn finalMessage isNil.
			self assert: turn assistantMessage hasCompletedReply not.
			turns add: turn ].
	^ turns
]

{ #category : #examples }
GtLACPPromptTurnStateExamples >> presentationUsesTheStateLabel [
	<gtExample>
	| turn |
	turn := GtLACPPromptTurn new.
	turn complete: 'end_turn'.
	self assert: turn stateName equals: #completed.
	self assert: turn state asString equals: 'completed'.
	self assert: (turn printString includesSubstring: 'completed').
	self assert: turn assistantMessage state == turn state.
	^ turn
]

{ #category : #examples }
GtLACPPromptTurnStateExamples >> stateOwnerFollowsTransitions [
	<gtExample>
	| turn initial restored |
	turn := GtLACPPromptTurn new.
	initial := turn state.
	self assert: initial turn == turn.
	turn state cancel.
	self assert: turn isCancelling.
	self assert: turn state turn == turn.
	self assert: initial turn == turn.
	turn state complete: 'cancelled'.
	self assert: turn isCancelled.
	self assert: turn state turn == turn.
	restored := GtLACPPromptTurnObservedState new.
	turn state: restored.
	self assert: turn state == restored.
	self assert: restored turn == turn.
	turn state start.
	self assert: turn isRunning.
	self assert: turn state turn == turn.
	^ turn
]

{ #category : #examples }
GtLACPPromptTurnStateExamples >> statesHaveIndependentOwners [
	<gtExample>
	| first second |
	first := GtLACPPromptTurn new.
	second := GtLACPPromptTurn new.
	self assert: first state ~~ second state.
	first state cancel.
	self assert: first isCancelling.
	self assert: second isRunning.
	self assert: first state turn == first.
	self assert: second state turn == second.
	^ {first.
		second}
]
