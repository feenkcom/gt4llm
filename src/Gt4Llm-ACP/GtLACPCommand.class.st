"
I represent an advertised ACP command. I share metadata, invocation and session behavior with skills through GtLACPInvocable.
"
Class {
	#name : #GtLACPCommand,
	#superclass : #GtLACPInvocable,
	#category : #'Gt4Llm-ACP-Core'
}

{ #category : #testing }
GtLACPCommand >> isSkill [
	^ false
]
