Class {
	#name : #GtLACPSessionClosedState,
	#superclass : #GtLACPSessionState,
	#category : #'Gt4Llm-ACP-Session states'
}

{ #category : #testing }
GtLACPSessionClosedState >> canClose [
	^ false
]

{ #category : #lifecycle }
GtLACPSessionClosedState >> connectionClosed [
	session isSubagent
		ifTrue: [ session state: GtLACPSessionDisconnectedState new ]
]

{ #category : #testing }
GtLACPSessionClosedState >> isClosed [
	^ true
]

{ #category : #accessing }
GtLACPSessionClosedState >> name [
	^ #closed
]

{ #category : #lifecycle }
GtLACPSessionClosedState >> operationFailed [
	^ session
]

{ #category : #lifecycle }
GtLACPSessionClosedState >> operationSucceeded [
	^ session
]

{ #category : #lifecycle }
GtLACPSessionClosedState >> reopen [
	^ session performReopen
]
