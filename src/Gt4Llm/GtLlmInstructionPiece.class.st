Class {
	#name : #GtLlmInstructionPiece,
	#superclass : #Object,
	#instVars : [
		'parent',
		'source'
	],
	#category : #Gt4Llm
}

{ #category : #accessing }
GtLlmInstructionPiece >> allParents [
	| parents following |
	parents := OrderedCollection new.
	following := self.

	[ following parent isNotNil ]
		whileTrue: [ following := following parent.
			parents add: following ].

	^ parents
]

{ #category : #accessing }
GtLlmInstructionPiece >> asInstructionPiece [
	^ self
]

{ #category : #accessing }
GtLlmInstructionPiece >> children [
	^ self subclassResponsibility
]

{ #category : #accessing }
GtLlmInstructionPiece >> gtParentsFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Parents';
		priority: 3;
		items: [ self allParents withIndexCollect: [:aParent :i | i -> aParent] ];
		column: 'Position' text: #key width: 60;
		column: 'Parent' text: #value
]

{ #category : #accessing }
GtLlmInstructionPiece >> instructionString [
	^ self subclassResponsibility
]

{ #category : #accessing }
GtLlmInstructionPiece >> parent [
	^ parent
]

{ #category : #accessing }
GtLlmInstructionPiece >> parent: anObject [
	parent := anObject.

	self source ifNil: [ self source: parent source ]
]

{ #category : #accessing }
GtLlmInstructionPiece >> source [
	^ source
]

{ #category : #accessing }
GtLlmInstructionPiece >> source: anObject [
	source := anObject
]
