Class {
	#name : #GtLACPSessionDisconnectedState,
	#superclass : #GtLACPSessionState,
	#category : #'Gt4Llm-ACP-Session states'
}

{ #category : #testing }
GtLACPSessionDisconnectedState >> isDisconnected [
	^ true
]

{ #category : #accessing }
GtLACPSessionDisconnectedState >> name [
	^ #disconnected
]
