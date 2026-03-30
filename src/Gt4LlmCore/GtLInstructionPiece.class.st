Class {
	#name : #GtLInstructionPiece,
	#superclass : #Object,
	#instVars : [
		'parent'
	],
	#category : 'Gt4LlmCore-Instructions'
}

{ #category : #accessing }
GtLInstructionPiece >> allParents [
	| parents following |
	parents := OrderedCollection new.
	following := self.

	[ following parent isNotNil ]
		whileTrue: [ following := following parent.
			parents add: following ].

	^ parents
]

{ #category : #'as yet unclassified' }
GtLInstructionPiece >> asGtLInstructionPiece [
	^ self
]

{ #category : #accessing }
GtLInstructionPiece >> children [
	^ self subclassResponsibility
]

{ #category : #ui }
GtLInstructionPiece >> gtInstructionFor: aView [
	<gtView>
	^ aView textEditor
		title: 'Instruction';
		priority: 1;
		text: [ self instructionString trimBoth ];
		styler: GtLMessageStyler new
]

{ #category : #accessing }
GtLInstructionPiece >> gtParentsFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Parents';
		priority: 3;
		items: [ self allParents withIndexCollect: [:aParent :i | i -> aParent] ];
		column: 'Position' text: #key width: 60;
		column: 'Parent' text: #value
]

{ #category : #ui }
GtLInstructionPiece >> gtTreeFor: aView [
	<gtView>
	^ aView columnedTree
		title: 'Tree';
		priority: 2;
		items: [ {self} ];
		children: #children;
		column: 'Text' text: [:each | each gtDisplayString ];
		column: 'Type' text: [:each | (each class name removePrefix: 'GtLlmInstruction') asRopedText foreground: Color gray ] width: 200;
		expandAll
]

{ #category : #accessing }
GtLInstructionPiece >> instructionString [
	^ self subclassResponsibility
]

{ #category : #accessing }
GtLInstructionPiece >> parent [
	^ parent
]

{ #category : #accessing }
GtLInstructionPiece >> parent: anObject [
	parent := anObject.
]

{ #category : #'as yet unclassified' }
GtLInstructionPiece >> title [
	^ ''
]
