Class {
	#name : #GtLlmInstruction,
	#superclass : #Object,
	#instVars : [
		'parent'
	],
	#category : #'Gt4Llm-Instructions'
}

{ #category : #accessing }
GtLlmInstruction >> allParents [
	| parents following |
	parents := OrderedCollection new.
	following := self.

	[ following parent isNotNil ]
		whileTrue: [ following := following parent.
			parents add: following ].

	^ parents
]

{ #category : #accessing }
GtLlmInstruction >> children [
	^ self subclassResponsibility
]

{ #category : #accessing }
GtLlmInstruction >> gtInstructionFor: aView [
	<gtView>
	^ aView textEditor
		title: 'Instruction';
		priority: 1;
		text: [ self instructionString ]
]

{ #category : #accessing }
GtLlmInstruction >> gtTreeFor: aView [
	<gtView>
	^ aView tree
		title: 'Tree';
		priority: 2;
		items: [ {self} ];
		children: #children;
		expandAll
]

{ #category : #accessing }
GtLlmInstruction >> instructionString [
	^ self subclassResponsibility
]

{ #category : #accessing }
GtLlmInstruction >> parent [
	^ parent
]

{ #category : #accessing }
GtLlmInstruction >> parent: anObject [
	parent := anObject
]
