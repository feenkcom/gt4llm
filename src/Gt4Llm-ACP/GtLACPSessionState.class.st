"
I define the behavior of one ACP session in a lifecycle state and hold a back-reference to that session. Concrete states authorize prompting and reopening, determine cancellation and close availability, and handle lifecycle and prompt outcomes. The session attaches me when it installs me. My name is a presentation label.
"
Class {
	#name : #GtLACPSessionState,
	#superclass : #GtLACPObject,
	#instVars : [
		'session'
	],
	#category : #'Gt4Llm-ACP-Session states'
}

{ #category : #converting }
GtLACPSessionState >> asString [
	^ self name asString
]

{ #category : #testing }
GtLACPSessionState >> canCancel [
	^ false
]

{ #category : #testing }
GtLACPSessionState >> canClose [
	^ true
]

{ #category : #testing }
GtLACPSessionState >> canPrompt [
	^ false
]

{ #category : #lifecycle }
GtLACPSessionState >> close [
	^ session performClose
]

{ #category : #lifecycle }
GtLACPSessionState >> connectionClosed [
	session
		state: (session isSubagent
				ifTrue: [ GtLACPSessionDisconnectedState new ]
				ifFalse: [ GtLACPSessionFailedState new ])
]

{ #category : #lifecycle }
GtLACPSessionState >> create [
	^ session performCreate
]

{ #category : #testing }
GtLACPSessionState >> isClosed [
	^ false
]

{ #category : #testing }
GtLACPSessionState >> isDisconnected [
	^ false
]

{ #category : #testing }
GtLACPSessionState >> isFailed [
	^ false
]

{ #category : #testing }
GtLACPSessionState >> isLoading [
	^ false
]

{ #category : #testing }
GtLACPSessionState >> isNew [
	^ false
]

{ #category : #testing }
GtLACPSessionState >> isObserving [
	^ false
]

{ #category : #testing }
GtLACPSessionState >> isPrompting [
	^ false
]

{ #category : #testing }
GtLACPSessionState >> isReady [
	^ false
]

{ #category : #testing }
GtLACPSessionState >> isReopening [
	^ false
]

{ #category : #testing }
GtLACPSessionState >> isStarting [
	^ false
]

{ #category : #testing }
GtLACPSessionState >> isUnknown [
	^ false
]

{ #category : #lifecycle }
GtLACPSessionState >> load: anId [
	^ session performLoad: anId
]

{ #category : #accessing }
GtLACPSessionState >> name [
	^ self subclassResponsibility
]

{ #category : #lifecycle }
GtLACPSessionState >> operationFailed [
	session state: GtLACPSessionFailedState new
]

{ #category : #lifecycle }
GtLACPSessionState >> operationSucceeded [
	session state: GtLACPSessionReadyState new
]

{ #category : #printing }
GtLACPSessionState >> printOn: aStream [
	aStream nextPutAll: self asString
]

{ #category : #prompting }
GtLACPSessionState >> promptContent: blocks [
	self error: 'Session must be ready before prompting'
]

{ #category : #prompting }
GtLACPSessionState >> promptFailed: aReason turn: aTurn [
	^ session
]

{ #category : #prompting }
GtLACPSessionState >> promptSucceeded: result turn: aTurn [
	"Ignore a response for a prompt that no longer owns the session."

	^ session
]

{ #category : #lifecycle }
GtLACPSessionState >> reopen [
	self error: 'Only a closed session can be reopened'
]

{ #category : #accessing }
GtLACPSessionState >> session [
	^ session
]

{ #category : #accessing }
GtLACPSessionState >> session: anOwner [
	session := anOwner
]
