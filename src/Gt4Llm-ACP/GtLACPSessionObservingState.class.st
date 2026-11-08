Class {
	#name : #GtLACPSessionObservingState,
	#superclass : #GtLACPSessionState,
	#category : #'Gt4Llm-ACP-Session states'
}

{ #category : #testing }
GtLACPSessionObservingState >> isObserving [
	^ true
]

{ #category : #accessing }
GtLACPSessionObservingState >> name [
	^ #observing
]
