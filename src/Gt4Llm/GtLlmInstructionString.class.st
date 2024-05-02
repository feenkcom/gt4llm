Class {
	#name : #GtLlmInstructionString,
	#superclass : #GtLlmInstruction,
	#instVars : [
		'string'
	],
	#category : #'Gt4Llm-Instructions'
}

{ #category : #accessing }
GtLlmInstructionString >> instructionString [
	^ string
]

{ #category : #accessing }
GtLlmInstructionString >> string [
	^ string
]

{ #category : #accessing }
GtLlmInstructionString >> string: anObject [
	string := anObject
]
