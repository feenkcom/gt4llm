Class {
	#name : #GtLInstructionWithSections,
	#superclass : #GtLInstructionPiece,
	#instVars : [
		'introduction',
		'sections',
		'title'
	],
	#category : #'Gt4LlmCore-Instructions'
}

{ #category : #accessing }
GtLInstructionWithSections >> addSection: aSection [
	sections add: (aSection asGtLInstructionPiece parent: self)
]

{ #category : #accessing }
GtLInstructionWithSections >> addSections: aListOfSections [
	sections
		addAll: (aListOfSections collect: [ :aSection | aSection asInstructionPiece parent: self ])
]

{ #category : #accessing }
GtLInstructionWithSections >> children [
	^ {introduction} , sections
]

{ #category : #accessing }
GtLInstructionWithSections >> ensureSectionNamed: aSectionTitle [
	^sections
			detect: [ :aSection | aSection title = aSectionTitle ] 
			ifFound: [ :each | each ] 
			ifNone: [
				| newSection|
				newSection := GtLInstructionSection new
					title: aSectionTitle;
					body: (GtLInstructionComposite new).
				self addSection: newSection.
				newSection ]
]

{ #category : #accessing }
GtLInstructionWithSections >> initialize [
	super initialize.
	
	sections := OrderedCollection new.
	title := ''  
]

{ #category : #accessing }
GtLInstructionWithSections >> instructionString [
	| string |
	string := self introduction instructionString.
	^ self sections notEmpty
		ifTrue: [ string , String lf
				, (String lf
						join: (self sections collect: [ :aSection | aSection instructionString ])) ]
		ifFalse: [ string ]
]

{ #category : #accessing }
GtLInstructionWithSections >> introduction [
	^ introduction
]

{ #category : #accessing }
GtLInstructionWithSections >> introduction: anObject [
	introduction := anObject asGtLInstructionPiece
]

{ #category : #testing }
GtLInstructionWithSections >> isEmpty [ 
	^ self instructionString isEmpty
]

{ #category : #accessing }
GtLInstructionWithSections >> printOn: aStream [
	super printOn: aStream.

	aStream
		nextPut: $(;
		nextPutAll: (self instructionString trimBoth 
			copyReplaceAll: String cr with: '') ;
		nextPut: $)
]

{ #category : #accessing }
GtLInstructionWithSections >> sections [
	^ sections
]

{ #category : #accessing }
GtLInstructionWithSections >> sections: anObject [
	sections := anObject asOrderedCollection
			collect: [ :aSection | aSection asInstructionPiece parent: self ]
]

{ #category : #accessing }
GtLInstructionWithSections >> title [
	^title
]

{ #category : #accessing }
GtLInstructionWithSections >> title: aSectionTitle [ 
	title := aSectionTitle 
]
