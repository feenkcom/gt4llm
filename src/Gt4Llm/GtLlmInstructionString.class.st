Class {
	#name : #GtLlmInstructionString,
	#superclass : #GtLlmInstructionPiece,
	#instVars : [
		'string'
	],
	#category : #Gt4Llm
}

{ #category : #accessing }
GtLlmInstructionString >> children [
	^ {}
]

{ #category : #accessing }
GtLlmInstructionString >> gtDisplayOn: aStream [
	aStream
		nextPutAll: string
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
