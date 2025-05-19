Class {
	#name : #GtLlmInstructionWithSections,
	#superclass : #GtLlmInstructionPiece,
	#instVars : [
		'introduction',
		'sections'
	],
	#category : #Gt4Llm
}

{ #category : #accessing }
GtLlmInstructionWithSections >> addSection: aSection [
	sections add: (aSection asInstructionPiece parent: self)
]

{ #category : #accessing }
GtLlmInstructionWithSections >> addSections: aListOfSections [
	sections
		addAll: (aListOfSections collect: [ :aSection | aSection asInstructionPiece parent: self ])
]

{ #category : #accessing }
GtLlmInstructionWithSections >> children [
	^ {introduction} , sections
]

{ #category : #accessing }
GtLlmInstructionWithSections >> gtDisplayOn: aStream [
	aStream
		nextPutAll: self introduction instructionString
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
	
'
		, ('
			
' join: (self sections collect: [ :aSection | aSection instructionString ]))
]

{ #category : #accessing }
GtLlmInstructionWithSections >> introduction [
	^ introduction
]

{ #category : #accessing }
GtLlmInstructionWithSections >> introduction: anObject [
	introduction := anObject asInstructionPiece
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
			collect: [ :aSection | aSection asInstructionPiece parent: self ]
]
