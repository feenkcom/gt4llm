Class {
	#name : #GtLACPSessionPromptingState,
	#superclass : #GtLACPSessionState,
	#category : #'Gt4Llm-ACP-Session states'
}

{ #category : #testing }
GtLACPSessionPromptingState >> canCancel [
	^ session currentTurn notNil and: [ session currentTurn canCancel ]
]

{ #category : #testing }
GtLACPSessionPromptingState >> isPrompting [
	^ true
]

{ #category : #accessing }
GtLACPSessionPromptingState >> name [
	^ #prompting
]

{ #category : #prompting }
GtLACPSessionPromptingState >> promptFailed: aReason turn: aTurn [
	session currentTurn == aTurn ifFalse: [ ^ session ].
	aTurn fail: aReason.
	session
		state: (session connection isReady
				ifTrue: [ GtLACPSessionReadyState new ]
				ifFalse: [ GtLACPSessionFailedState new ])
]

{ #category : #prompting }
GtLACPSessionPromptingState >> promptSucceeded: result turn: aTurn [
	session currentTurn == aTurn ifFalse: [ ^ session ].
	aTurn complete: (result at: 'stopReason').
	session state: GtLACPSessionReadyState new
]
