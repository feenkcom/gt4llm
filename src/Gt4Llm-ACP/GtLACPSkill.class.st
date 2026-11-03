"
I represent an advertised ACP skill, alongside commands under GtLACPInvocable. I preserve Codex's dollar-prefixed invocation.
"
Class {
	#name : #GtLACPSkill,
	#superclass : #GtLACPInvocable,
	#category : #'Gt4Llm-ACP-Core'
}

{ #category : #accessing }
GtLACPSkill >> invocation [
	^ (self name beginsWith: '$')
		ifTrue: [ self name ]
		ifFalse: [ super invocation ]
]

{ #category : #testing }
GtLACPSkill >> isSkill [
	^ true
]
