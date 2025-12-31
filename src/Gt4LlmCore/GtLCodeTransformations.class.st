Class {
	#name : #GtLCodeTransformations,
	#superclass : #Object,
	#instVars : [
		'transformations'
	],
	#category : #'Gt4LlmCore-Formats'
}

{ #category : #accessing }
GtLCodeTransformations >> applyRefactoring [
	| namespace composite |
	namespace := GtRBNamespace new.
	composite := self asRefactoringIn: namespace.
	composite primitiveExecute.
	^ namespace
]

{ #category : #accessing }
GtLCodeTransformations >> asRefactoringIn: namespace [
	| composite |
	composite := GtRBCompositeTransformation new
			model: namespace;
			refactorings: (transformations collect: [ :each | each asRefactoringIn: namespace ]).
	^ composite
]

{ #category : #views }
GtLCodeTransformations >> gtChangesFor: aView [
	<gtView>
	<gtLlmView>
	^ aView forward
		title: 'Changes';
		priority: 2;
		object: [ self applyRefactoring ];
		view: #gtApplyingChangesFor:;
		actionButtonIcon: BrGlamorousVectorIcons inspect tooltip: 'Inspect the changes' action: [ :b | b phlow spawnObject: self applyRefactoring  ]
]

{ #category : #views }
GtLCodeTransformations >> gtViewTransformationsFor: aView [
	<gtView>
	transformations ifNil: [ ^ aView empty ].
	^ aView columnedList
		title: 'Transformations';
		priority: 10;
		items: [ transformations ];
		column: 'Value' text: [ :each | each gtDisplayString ]
]

{ #category : #printing }
GtLCodeTransformations >> printOn: aStream [
	super printOn: aStream.

	aStream 
		<< ' [';
		print: self transformations size;
		<< ' ';
		<< (self transformations size = 1 
			ifTrue: [ 'transformation' ]
			ifFalse: [ 'transformations' ]);
		<< ']'
]

{ #category : #accessing }
GtLCodeTransformations >> transformations [
	^ transformations
]

{ #category : #accessing }
GtLCodeTransformations >> transformations: anObject [
	transformations := anObject
]

{ #category : #accessing }
GtLCodeTransformations >> transformationsDescription [
	<magritteDescription>
	
	 ^ MAToManyRelationDescription new
			accessor: #transformations;
			classes: (GtLCodeTransformationSpecification allSubclasses select: #isConcrete);
			beRequired
]
