Class {
	#name : #GtLlmWardleyMapResettingConnectionStep,
	#superclass : #GtLlmWardleyMapConnectionStep,
	#category : #'Gt4Llm-Examples'
}

{ #category : #accessing }
GtLlmWardleyMapResettingConnectionStep >> runStep: aContext [
	aContext instance clearEdges.
	
	super runStep: aContext
]
