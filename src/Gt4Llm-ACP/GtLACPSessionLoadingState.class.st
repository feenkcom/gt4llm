Class {
	#name : #GtLACPSessionLoadingState,
	#superclass : #GtLACPSessionState,
	#category : #'Gt4Llm-ACP-Session states'
}

{ #category : #testing }
GtLACPSessionLoadingState >> isLoading [
	^ true
]

{ #category : #accessing }
GtLACPSessionLoadingState >> name [
	^ #loading
]
