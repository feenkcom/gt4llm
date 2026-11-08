Class {
	#name : #GtLACPSessionStartingState,
	#superclass : #GtLACPSessionState,
	#category : #'Gt4Llm-ACP-Session states'
}

{ #category : #testing }
GtLACPSessionStartingState >> isStarting [
	^ true
]

{ #category : #accessing }
GtLACPSessionStartingState >> name [
	^ #starting
]
