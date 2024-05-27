Class {
	#name : #GtLlmInstructionWithSections,
	#superclass : #GtLlmInstruction,
	#instVars : [
		'introduction',
		'sections'
	],
	#category : #'Gt4Llm-Instructions'
}

{ #category : #accessing }
GtLlmInstructionWithSections >> addSection: aSection [
	sections add: (aSection asInstruction parent: self)
]

{ #category : #accessing }
GtLlmInstructionWithSections >> children [
	^ {introduction} , sections
]

{ #category : #accessing }
GtLlmInstructionWithSections >> initialize [
	super initialize.
	
	sections := OrderedCollection new
]

{ #category : #accessing }
GtLlmInstructionWithSections >> instructionString [
	^ self introduction instructionString
		, '
	
' , (Character cr join: (self sections collect: #instructionString))
]

{ #category : #accessing }
GtLlmInstructionWithSections >> introduction [
	^ introduction
]

{ #category : #accessing }
GtLlmInstructionWithSections >> introduction: anObject [
	introduction := anObject asInstruction
]

{ #category : #accessing }
GtLlmInstructionWithSections >> printOn: aStream [
	super printOn: aStream.

	aStream
		nextPut: $(;
		nextPutAll: self introduction instructionString;
		nextPut: $)
]

{ #category : #accessing }
GtLlmInstructionWithSections >> sections [
	^ sections
]

{ #category : #accessing }
GtLlmInstructionWithSections >> sections: anObject [
	sections := anObject asOrderedCollection
			collect: [ :aSection | aSection asInstruction parent: self ]
]
