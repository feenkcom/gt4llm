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
	| composite |
	composite := self asRefactoring.
	composite primitiveExecute.
	^ composite model
]

{ #category : #accessing }
GtLCodeTransformations >> asRefactoring [
	| namespace composite |
	namespace := GtRBNamespace new.
	composite := self asRefactoringIn: namespace.
	^ composite
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
		priority: 5;
		object: [ self applyRefactoring ];
		view: #gtApplyingChangesFor:;
		actionButtonIcon: BrGlamorousVectorIcons inspect tooltip: 'Inspect the changes' action: [ :b | b phlow spawnObject: self applyRefactoring  ]
]

{ #category : #views }
GtLCodeTransformations >> gtRefactoringsFor: aView [
	<gtView>
	^ aView forward
		title: 'Refactorings';
		priority: 2;
		object: [ self asRefactoring ];
		view: #gtRefactoringsFor:
]

{ #category : #views }
GtLCodeTransformations >> gtViewTransformationsFor: aView [
	<gtView>
	<gtLlmView>
	transformations ifNil: [ ^ aView empty ].
	^ aView columnedList
		title: 'Transformation specifications';
		priority: 1;
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
			propertyAt: 'useExplicitContainerForChildren' put: true;
			beRequired
]
