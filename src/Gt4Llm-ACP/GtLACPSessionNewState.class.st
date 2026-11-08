Class {
	#name : #GtLACPSessionNewState,
	#superclass : #GtLACPSessionState,
	#category : #'Gt4Llm-ACP-Session states'
}

{ #category : #testing }
GtLACPSessionNewState >> isNew [
	^ true
]

{ #category : #accessing }
GtLACPSessionNewState >> name [
	^ #new
]
