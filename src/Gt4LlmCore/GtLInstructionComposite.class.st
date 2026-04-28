Class {
	#name : #GtLInstructionComposite,
	#superclass : #GtLInstructionPiece,
	#instVars : [
		'items'
	],
	#category : #'Gt4LlmCore-Instructions'
}

{ #category : #accessing }
GtLInstructionComposite >> addItem: anItem [
	items add: (anItem asGtLInstructionPiece parent: self)
]

{ #category : #accessing }
GtLInstructionComposite >> children [
	^ items
]

{ #category : #'as yet unclassified' }
GtLInstructionComposite >> ensureSectionNamed: aSectionTitle [
	^ items
			detect: [ :aSection | aSection title = aSectionTitle ] 
			ifFound: [ :each | each ] 
			ifNone: [
				| newSection|
				newSection := GtLInstructionSection new
					title: aSectionTitle;
					body: GtLInstructionComposite new.
				self addItem: newSection.
				newSection ]
]

{ #category : #accessing }
GtLInstructionComposite >> gtDisplayOn: stream [
	stream nextPutAll: '--Composite--'
]

{ #category : #accessing }
GtLInstructionComposite >> initialize [
	super initialize.
	
	items := OrderedCollection new
]

{ #category : #accessing }
GtLInstructionComposite >> instructionString [
	^ (String cr, String cr) join: (items collect: [:anItem | anItem instructionString])
]

{ #category : #'as yet unclassified' }
GtLInstructionComposite >> isEmpty [
	^ items isEmpty
]

{ #category : #accessing }
GtLInstructionComposite >> items: anObject [
	items := anObject
			collect: [ :anInstruction | anInstruction asInstructionPiece parent: self ]
]

{ #category : #'as yet unclassified' }
GtLInstructionComposite >> postCopy [
	super postCopy.
	items := items copy.
]

{ #category : #'as yet unclassified' }
GtLInstructionComposite >> sectionNamed: aSectionTitle ifAbsent: aBlock [
	^ items
			detect: [ :aSection | aSection title = aSectionTitle ] 
			ifFound: [ :each | each ] 
			ifNone: [
				| newSection|
				newSection := GtLInstructionSection new
					title: aSectionTitle.
				self addItem: newSection.
				aBlock value: newSection.
				newSection ]
]

{ #category : #accessing }
GtLInstructionComposite >> size [
	^ items size
]
