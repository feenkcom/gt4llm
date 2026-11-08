"
Executable examples for ACP session state objects, explicit state installation, state-dependent lifecycle dispatch, owner references and late asynchronous prompt outcomes.
"
Class {
	#name : #GtLACPSessionStateExamples,
	#superclass : #Object,
	#category : #'Gt4Llm-ACP-Examples'
}

{ #category : #examples }
GtLACPSessionStateExamples >> closedStateAuthorizesReopening [
	<gtExample>
	| client session turn |
	client := GtLACPReopenExamples new client.
	session := client startSessionIn: FileLocator temp.
	[ turn := session prompt: 'Keep history'.
	GtLACPExamples new assertRaisesError: [ session reopen ] raise: Error.
	session close.
	self assert: session state class equals: GtLACPSessionClosedState.
	self assert: session reopen == session.
	self assert: session state class equals: GtLACPSessionReadyState.
	self assert: session turns first == turn ] ensure: [ client stop ].
	^ session
]

{ #category : #examples }
GtLACPSessionStateExamples >> closedStateIgnoresLatePromptFailure [
	<gtExample>
	| session sibling turn connection |
	session := GtLACPExamples new session.
	connection := session connection.
	sibling := session client newSessionIn: FileLocator temp connection: connection.
	sibling create.
	[ turn := session prompt: 'Pending'.
	session close.
	connection transport
		receive: {'jsonrpc' -> '2.0'.
				'id' -> turn request id.
				'error'
					-> {'code' -> -32603.
							'message' -> 'Late failure'} asDictionary} asDictionary.
	self assert: session isClosed.
	self assert: turn isClosed.
	self assert: sibling isReady.
	self assert: connection isReady ] ensure: [ session client stop ].
	^ session
]

{ #category : #examples }
GtLACPSessionStateExamples >> closedStateIgnoresLatePromptSuccess [
	<gtExample>
	| session sibling turn connection |
	session := GtLACPExamples new session.
	connection := session connection.
	sibling := session client newSessionIn: FileLocator temp connection: connection.
	sibling create.
	[ turn := session prompt: 'Pending'.
	session close.
	self assert: turn isClosed.
	connection transport
		replyTo: turn request asDictionary
		result: {'stopReason' -> 'end_turn'} asDictionary.
	self assert: session isClosed.
	self assert: turn isClosed.
	self assert: sibling isReady.
	self assert: connection isReady ] ensure: [ session client stop ].
	^ session
]

{ #category : #examples }
GtLACPSessionStateExamples >> connectionLossDelegatesToState [
	<gtExample>
	| session |
	session := GtLACPExamples new session.
	session connection failed: 'Disconnected'.
	self assert: session state class equals: GtLACPSessionFailedState.
	self assert: session canPrompt not.
	session close.
	self assert: session isClosed.
	session connectionClosed: 'Already closed'.
	self assert: session isClosed.
	^ session
]

{ #category : #examples }
GtLACPSessionStateExamples >> initialStateIsAnObject [
	<gtExample>
	| session |
	session := GtLACPSession new.
	self assert: session state class equals: GtLACPSessionNewState.
	self assert: session state session == session.
	self assert: session isNew.
	self assert: session canPrompt not.
	self assert: session canClose.
	self assert: session canCancel not.
	self assert: session stateName equals: #new.
	self assert: session presentationState equals: #new.
	^ session
]

{ #category : #examples }
GtLACPSessionStateExamples >> lifecycleRequestsObserveStateObjects [
	<gtExample>
	| client phases session loaded |
	phases := OrderedCollection new.
	client := GtLACPCodexClient new.
	client
		transportFactory: [ :configuration :directory | 
			| transport responder |
			transport := GtLACPExamples new transport.
			responder := transport responder.
			transport
				responder: [ :message :memory | 
					(#('session/new' 'session/load') includes: (message at: 'method'))
						ifTrue: [ phases add: client sessions last state class ].
					responder value: message value: memory ].
			transport ].
	[ session := client startSessionIn: FileLocator temp.
	loaded := client loadSession: 'existing' in: FileLocator temp.
	self
		assert: phases asArray
		equals: {GtLACPSessionStartingState.
				GtLACPSessionLoadingState}.
	self assert: session isReady.
	self assert: loaded isReady ] ensure: [ client stop ].
	^ phases
]

{ #category : #examples }
GtLACPSessionStateExamples >> promptLifecycleDelegatesToStates [
	<gtExample>
	| session turn |
	session := GtLACPExamples new session.
	[ self assert: session state class equals: GtLACPSessionReadyState.
	self assert: session canPrompt.
	turn := session prompt: 'Hello'.
	self assert: session state class equals: GtLACPSessionPromptingState.
	self assert: session canPrompt not.
	self assert: session canCancel.
	GtLACPExamples new
		assertRaisesError: [ session prompt: 'Too soon' ]
		raise: Error.
	self assert: session turns size equals: 1.
	session cancelTurn.
	self assert: session canCancel not.
	session connection transport
		replyTo: turn request asDictionary
		result: {'stopReason' -> 'cancelled'} asDictionary.
	self assert: session state class equals: GtLACPSessionReadyState.
	self assert: session canPrompt.
	session close.
	self assert: session state class equals: GtLACPSessionClosedState.
	self assert: session canPrompt not.
	GtLACPExamples new assertRaisesError: [ session prompt: 'Closed' ] raise: Error.
	self assert: session isClosed ] ensure: [ session client stop ].
	^ session
]

{ #category : #examples }
GtLACPSessionStateExamples >> stalePromptOutcomeDoesNotFinishCurrentPrompt [
	<gtExample>
	| session oldTurn currentTurn |
	session := GtLACPExamples new session.
	[ oldTurn := session prompt: 'First'.
	session connection transport
		replyTo: oldTurn request asDictionary
		result: {'stopReason' -> 'end_turn'} asDictionary.
	currentTurn := session prompt: 'Second'.
	session
		promptSucceeded: {'stopReason' -> 'end_turn'} asDictionary
		turn: oldTurn.
	self assert: session isPrompting.
	self assert: currentTurn isActive.
	session promptFailed: 'Old failure' turn: oldTurn.
	self assert: session isPrompting.
	self assert: currentTurn isActive.
	self assert: oldTurn isCompleted ] ensure: [ session close ].
	^ session
]

{ #category : #examples }
GtLACPSessionStateExamples >> stateAccessorsUseInstalledObject [
	<gtExample>
	| session state |
	session := GtLACPSession new.
	state := GtLACPSessionReadyState new.
	session state: state.
	self assert: session state == state.
	self assert: state session == session.
	self assert: session canPrompt.
	session state: GtLACPSessionClosedState new.
	self assert: session isClosed.
	self assert: session canClose not.
	session state: GtLACPSessionLoadingState new.
	self assert: session isReplaying.
	^ session
]

{ #category : #examples }
GtLACPSessionStateExamples >> stateOwnerFollowsTransitions [
	<gtExample>
	| session initial restored |
	session := GtLACPSession new.
	initial := session state.
	self assert: initial session == session.
	session state operationSucceeded.
	self assert: session isReady.
	self assert: session state session == session.
	self assert: initial session == session.
	session state operationFailed.
	self assert: session isFailed.
	self assert: session state session == session.
	restored := GtLACPSessionClosedState new.
	session state: restored.
	self assert: session state == restored.
	self assert: restored session == session.
	^ session
]

{ #category : #examples }
GtLACPSessionStateExamples >> statesHaveIndependentOwners [
	<gtExample>
	| first second |
	first := GtLACPSession new.
	second := GtLACPSession new.
	self assert: first state ~~ second state.
	first state operationSucceeded.
	self assert: first isReady.
	self assert: second isNew.
	self assert: first state session == first.
	self assert: second state session == second.
	^ {first.
		second}
]

{ #category : #examples }
GtLACPSessionStateExamples >> unknownStatesKeepTheirLabel [
	<gtExample>
	| session |
	session := GtLACPSession new
			state: (GtLACPSessionUnknownState new
					name: #futureState;
					yourself);
			yourself.
	self assert: session isUnknown.
	self assert: session state class equals: GtLACPSessionUnknownState.
	self assert: session presentationState equals: #futureState.
	self assert: session state asString equals: 'futureState'.
	self assert: session canPrompt not.
	self assert: session canCancel not.
	GtLACPExamples new assertRaisesError: [ session reopen ] raise: Error.
	^ session
]
