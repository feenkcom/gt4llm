Class {
	#name : #GtLlmInstructionString,
	#superclass : #GtLlmInstruction,
	#instVars : [
		'string'
	],
	#category : #'Gt4Llm-Instructions'
}

{ #category : #accessing }
GtLlmInstructionString >> children [
	^ {}
]

{ #category : #accessing }
GtLlmInstructionString >> instructionString [
	^ string
]

{ #category : #accessing }
GtLlmInstructionString >> printOn: aStream [
	super printOn: aStream.

	aStream
		nextPut: $(;
		nextPutAll: string;
		nextPut: $)
]

{ #category : #accessing }
GtLlmInstructionString >> string [
	^ string
]

{ #category : #accessing }
GtLlmInstructionString >> string: anObject [
	string := anObject
]
