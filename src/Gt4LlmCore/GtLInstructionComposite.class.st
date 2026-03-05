Class {
	#name : #GtLInstructionComposite,
	#superclass : #GtLInstructionPiece,
	#instVars : [
		'items'
	],
	#category : #'Gt4LlmCore-Instructions'
}

{ #category : #other }
GtLInstructionComposite class >> new [
	^ self basicNew initialize
]

{ #category : #accessing }
GtLInstructionComposite >> addItem: anItem [
	items add: (anItem asInstructionPiece parent: self)
]

{ #category : #accessing }
GtLInstructionComposite >> children [
	^ items
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

{ #category : #accessing }
GtLInstructionComposite >> items: anObject [
	items := anObject
			collect: [ :anInstruction | anInstruction asInstructionPiece parent: self ]
]
