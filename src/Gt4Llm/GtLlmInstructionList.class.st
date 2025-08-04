Class {
	#name : #GtLlmInstructionList,
	#superclass : #GtLlmInstructionPiece,
	#instVars : [
		'items'
	],
	#category : #Gt4Llm
}

{ #category : #other }
GtLlmInstructionList class >> new [
	^ self basicNew initialize
]

{ #category : #accessing }
GtLlmInstructionList >> addItem: anItem [
	items add: (anItem asInstructionPiece parent: self)
]

{ #category : #accessing }
GtLlmInstructionList >> children [
	^ items
]

{ #category : #accessing }
GtLlmInstructionList >> gtDisplayOn: stream [
	stream nextPutAll: '--List--'
]

{ #category : #accessing }
GtLlmInstructionList >> initialize [
	super initialize.
	
	items := OrderedCollection new
]

{ #category : #accessing }
GtLlmInstructionList >> instructionString [
	^ Character cr
		join: (self items collect: [ :anItem | '- ' , anItem instructionString ])
]

{ #category : #accessing }
GtLlmInstructionList >> items [
	^ items
]

{ #category : #accessing }
GtLlmInstructionList >> items: anObject [
	items := anObject collect: #asInstructionPiece
]
