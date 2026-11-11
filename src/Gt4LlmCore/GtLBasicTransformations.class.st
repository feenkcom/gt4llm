Class {
	#name : #GtLBasicTransformations,
	#superclass : #Object,
	#instVars : [
		'transformations'
	],
	#category : #'Gt4LlmCore-Formats'
}

{ #category : #accessing }
GtLBasicTransformations >> allowedTransformationClasses [
	^ #()
]

{ #category : #accessing }
GtLBasicTransformations >> applyRefactoring [
	| composite |
	composite := self asRefactoring.
	composite primitiveExecute.
	^ composite model
]

{ #category : #accessing }
GtLBasicTransformations >> asRefactoring [
	| namespace composite |
	namespace := GtRBNamespace new.
	composite := self asRefactoringIn: namespace.
	^ composite
]

{ #category : #accessing }
GtLBasicTransformations >> asRefactoringIn: namespace [
	| composite |
	composite := GtRBCompositeTransformation new
			model: namespace;
			refactorings: ((transformations collect: [ :each | 
				each asRefactoringIn: namespace ]) reject: [ :each | each isNil]).
	^ composite
]

{ #category : #views }
GtLBasicTransformations >> gtChangesFor: aView [
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
GtLBasicTransformations >> gtRefactoringsFor: aView [
	<gtView>
	^ aView forward
		title: 'Refactorings';
		priority: 2;
		object: [ self asRefactoring ];
		view: #gtRefactoringsFor:
]

{ #category : #views }
GtLBasicTransformations >> gtViewTransformationsFor: aView [
	<gtView>
	transformations ifNil: [ ^ aView empty ].
	^ aView columnedList
		title: 'Transformation specifications';
		priority: 1;
		items: [ transformations ];
		column: 'Value' text: [ :each | each gtDisplayString ]
]

{ #category : #printing }
GtLBasicTransformations >> printOn: aStream [
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
GtLBasicTransformations >> refactoringDescription [
	"Return the descriptions of my transformations separated by semicolons"

	^ '; '
		join: ((self transformations ifNil: [ #() ])
				collect: [ :each | each refactoringDescription ])
]

{ #category : #accessing }
GtLBasicTransformations >> refactoringName [
	"Return the distinct names of my transformations, in order, separated by commas, for example 'Push up instance variable, Push up method'"

	| names |
	names := OrderedCollection new.
	(self transformations ifNil: [ #() ])
		do: [ :each | names addIfNotPresent: each refactoringName ].
	^ ', ' join: names
]

{ #category : #accessing }
GtLBasicTransformations >> transformations [
	^ transformations
]

{ #category : #accessing }
GtLBasicTransformations >> transformations: anObject [
	transformations := anObject
]

{ #category : #descriptions }
GtLBasicTransformations >> transformationsDescription [
	<magritteDescription>
	
	 ^ MAToManyRelationDescription new
			accessor: #transformations;
			classes: self allowedTransformationClasses;
			useExplicitContainerForChildren;
			beRequired
]
