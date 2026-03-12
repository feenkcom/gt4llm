Class {
	#name : #GtLInstructionString,
	#superclass : #GtLInstructionPiece,
	#instVars : [
		'string'
	],
	#category : #'Gt4LlmCore-Instructions'
}

{ #category : #accessing }
GtLInstructionString >> children [
	^ {}
]

{ #category : #accessing }
GtLInstructionString >> gtDisplayOn: aStream [
	aStream
		nextPutAll: string
]

{ #category : #accessing }
GtLInstructionString >> instructionString [
	^ string
]

{ #category : #accessing }
GtLInstructionString >> printOn: aStream [
	super printOn: aStream.

	aStream
		nextPut: $(;
		nextPutAll: string;
		nextPut: $)
]

{ #category : #accessing }
GtLInstructionString >> string [
	^ string
]

{ #category : #accessing }
GtLInstructionString >> string: anObject [
	string := anObject
]
