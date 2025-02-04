Class {
	#name : #GtLlmInstructionComponent,
	#superclass : #Object,
	#instVars : [
		'parent',
		'source'
	],
	#category : #'Gt4Llm-Instructions'
}

{ #category : #accessing }
GtLlmInstructionComponent >> allParents [
	| parents following |
	parents := OrderedCollection new.
	following := self.

	[ following parent isNotNil ]
		whileTrue: [ following := following parent.
			parents add: following ].

	^ parents
]

{ #category : #accessing }
GtLlmInstructionComponent >> asInstruction [
	^ self
]

{ #category : #accessing }
GtLlmInstructionComponent >> children [
	^ self subclassResponsibility
]

{ #category : #accessing }
GtLlmInstructionComponent >> gtInstructionFor: aView [
	<gtView>
	^ aView textEditor
		title: 'Instruction';
		priority: 1;
		text: [ self instructionString ];
		styler: (GtLlmMessageStyler new
				threadMessageViewModel: (GtLlmNewThreadMessageViewModel new threadMessage: GtLlmNewThreadMessage new))
]

{ #category : #accessing }
GtLlmInstructionComponent >> gtParentsFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Parents';
		priority: 3;
		items: [ self allParents withIndexCollect: [:aParent :i | i -> aParent] ];
		column: 'Position' text: #key width: 60;
		column: 'Parent' text: #value
]

{ #category : #accessing }
GtLlmInstructionComponent >> gtTreeFor: aView [
	<gtView>
	^ aView columnedTree
		title: 'Tree';
		priority: 2;
		items: [ {self} ];
		children: #children;
		column: 'Text' text: [:each | each gtDisplayString ];
		column: 'Type' text: [:each | (each class name removePrefix: 'GtLlmInstruction') asRopedText foreground: Color gray ] width: 100;
		expandAll
]

{ #category : #accessing }
GtLlmInstructionComponent >> instructionString [
	^ self subclassResponsibility
]

{ #category : #accessing }
GtLlmInstructionComponent >> parent [
	^ parent
]

{ #category : #accessing }
GtLlmInstructionComponent >> parent: anObject [
	parent := anObject.

	self source ifNil: [ self source: parent source ]
]

{ #category : #accessing }
GtLlmInstructionComponent >> source [
	^ source
]

{ #category : #accessing }
GtLlmInstructionComponent >> source: anObject [
	source := anObject
]
