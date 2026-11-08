Class {
	#name : #GtLACPSessionFailedState,
	#superclass : #GtLACPSessionState,
	#category : #'Gt4Llm-ACP-Session states'
}

{ #category : #testing }
GtLACPSessionFailedState >> isFailed [
	^ true
]

{ #category : #accessing }
GtLACPSessionFailedState >> name [
	^ #failed
]
