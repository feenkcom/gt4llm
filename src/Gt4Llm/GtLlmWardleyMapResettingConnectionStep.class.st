Class {
	#name : #GtLlmWardleyMapResettingConnectionStep,
	#superclass : #GtLlmWardleyMapConnectionStep,
	#category : #'Gt4Llm-Domain - Wardley Map'
}

{ #category : #accessing }
GtLlmWardleyMapResettingConnectionStep >> runStep: aContext [
	aContext instance clearEdges.
	
	super runStep: aContext
]
