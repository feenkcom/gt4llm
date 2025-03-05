Class {
	#name : 'GtLlmInstructionComposite',
	#superclass : 'GtLlmInstructionPiece',
	#instVars : [
		'items'
	],
	#category : 'Gt4Llm'
}

{ #category : 'other' }
GtLlmInstructionComposite class >> new [
	^ self basicNew initialize
]

{ #category : 'accessing' }
GtLlmInstructionComposite >> addItem: anItem [
	items add: (anItem asInstructionPiece parent: self)
]

{ #category : 'accessing' }
GtLlmInstructionComposite >> children [
	^ items
]

{ #category : 'accessing' }
GtLlmInstructionComposite >> gtDisplayOn: stream [
	stream nextPutAll: '--Composite--'
]

{ #category : 'accessing' }
GtLlmInstructionComposite >> initialize [
	super initialize.
	
	items := OrderedCollection new
]

{ #category : 'accessing' }
GtLlmInstructionComposite >> instructionString [
	^ (String cr, String cr) join: (items collect: [:anItem | anItem instructionString])
]

{ #category : 'accessing' }
GtLlmInstructionComposite >> items: anObject [
	items := anObject
			collect: [ :anInstruction | anInstruction asInstructionPiece parent: self ]
]
