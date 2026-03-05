Class {
	#name : #GtLInstructionList,
	#superclass : #GtLInstructionPiece,
	#instVars : [
		'items'
	],
	#category : #'Gt4LlmCore-Instructions'
}

{ #category : #other }
GtLInstructionList class >> new [
	^ self basicNew initialize
]

{ #category : #accessing }
GtLInstructionList >> addItem: anItem [
	items add: (anItem asInstructionPiece parent: self)
]

{ #category : #accessing }
GtLInstructionList >> children [
	^ items
]

{ #category : #accessing }
GtLInstructionList >> gtDisplayOn: stream [
	stream nextPutAll: '--List--'
]

{ #category : #accessing }
GtLInstructionList >> initialize [
	super initialize.
	
	items := OrderedCollection new
]

{ #category : #accessing }
GtLInstructionList >> instructionString [
	^ Character cr
		join: (self items collect: [ :anItem | '- ' , anItem instructionString ])
]

{ #category : #accessing }
GtLInstructionList >> items [
	^ items
]

{ #category : #accessing }
GtLInstructionList >> items: anObject [
	items := anObject collect: #asInstructionPiece
]
