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
GtLlmInstruction >> asInstruction [
	^ self
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
		text: [ self instructionString ];
		styler: (GtLlmMessageStyler new
				threadMessageViewModel: (GtLlmNewThreadMessageViewModel new threadMessage: GtLlmNewThreadMessage new))
]

{ #category : #accessing }
GtLlmInstruction >> gtParentsFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Parents';
		priority: 3;
		items: [ self allParents withIndexCollect: [:aParent :i | i -> aParent] ];
		column: 'Position' text: #key width: 60;
		column: 'Parent' text: #value
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
