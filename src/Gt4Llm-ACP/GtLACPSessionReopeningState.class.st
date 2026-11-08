Class {
	#name : #GtLACPSessionReopeningState,
	#superclass : #GtLACPSessionState,
	#category : #'Gt4Llm-ACP-Session states'
}

{ #category : #testing }
GtLACPSessionReopeningState >> isReopening [
	^ true
]

{ #category : #accessing }
GtLACPSessionReopeningState >> name [
	^ #reopening
]
