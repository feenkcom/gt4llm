Class {
	#name : #GtLlmInstructionComposite,
	#superclass : #GtLlmInstruction,
	#instVars : [
		'items'
	],
	#category : #'Gt4Llm-Instructions'
}

{ #category : #accessing }
GtLlmInstructionComposite >> addItem: anItem [
	items add: (anItem asInstruction parent: self)
]

{ #category : #accessing }
GtLlmInstructionComposite >> children [
	^ items
]

{ #category : #accessing }
GtLlmInstructionComposite >> gtDisplayOn: stream [
	stream nextPutAll: '--Composite--'
]

{ #category : #accessing }
GtLlmInstructionComposite >> initialize [
	super initialize.
	
	items := OrderedCollection new
]

{ #category : #accessing }
GtLlmInstructionComposite >> instructionString [
	^ (String cr, String cr) join: (items collect: #instructionString)
]

{ #category : #accessing }
GtLlmInstructionComposite >> items: anObject [
	items := anObject
			collect: [ :anInstruction | anInstruction asInstruction parent: self ]
]
