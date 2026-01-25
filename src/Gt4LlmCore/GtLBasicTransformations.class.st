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
	
	^ aView explicit
		title: 'Changes';
		priority: 2;
		stencil: [ | pane changesElement applyButton progress changes |
			pane := BrVerticalPane new.
			pane matchParent.
			changesElement := GtChangesElement new.
			changes := self applyRefactoring changes.
			changesElement changes: changes.
			pane addChild: changesElement.
			pane addAptitude: (BrLayoutResizerAptitude new inherit: changesElement).
			progress := BrProgress new.
			progress aptitude: BrGlamorousProgressBarAptitude.
			progress
				margin: (BlInsets
						top: 5
						left: 10
						bottom: 15
						right: 10).
			progress
				constraintsDo: [ :c | 
					c horizontal matchParent.
					c vertical matchParent ].
			progress visibility: BlVisibility hidden.
			applyButton := BrButton new
					icon: BrGlamorousVectorIcons accept;
					beSmallSize;
					aptitude: BrGlamorousButtonWithIconAptitude new;
					label: 'Save';
					margin: (BlInsets
							top: 0
							left: 10
							bottom: 10
							right: 0);
					action: [ applyButton disable.
						changes changesSize > 1 ifTrue: [ progress visibility: BlVisibility visible ].
						progress fraction: 0.
						(changesElement
							applyChangesWithProgress: [ :fraction | progress enqueueTask: (BlTaskAction new action: [ progress fraction: fraction ]) ])
							then: [ :undo | 
								pane
									enqueueTask: (BlTaskAction new
											action: [ progress visibility: BlVisibility hidden.
												applyButton enable ]) ] ];
					yourself.
			pane
				addChild: (BrHorizontalPane new
						vFitContent;
						hMatchParent;
						addChild: applyButton as: #applyButton;
						addChild: progress).
			pane ]
	
	
"	^ aView forward
		title: 'Changes';
		priority: 5;
		object: [ self applyRefactoring ];
		view: #gtApplyingChangesFor:;
		actionButtonIcon: BrGlamorousVectorIcons inspect tooltip: 'Inspect the changes' action: [ :b | b phlow spawnObject: self applyRefactoring  ]"
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
	<gtLlmView>
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
