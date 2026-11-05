"
I ask the enclosing ACP session tool to reveal a pending interaction without opening another tool.
"
Class {
	#name : #GtLACPRevealInteractionWish,
	#superclass : #BrWish,
	#instVars : [
		'request'
	],
	#category : #'Gt4Llm-ACP-UI'
}

{ #category : #accessing }
GtLACPRevealInteractionWish >> request [
	^ request
]

{ #category : #accessing }
GtLACPRevealInteractionWish >> request: aRequest [
	request := aRequest
]
