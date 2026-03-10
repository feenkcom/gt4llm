Class {
	#name : #GtLClassModificationResult,
	#superclass : #Object,
	#instVars : [
		'originalClass',
		'updatedClass'
	],
	#category : 'Gt4LlmCore-Magritte Objects'
}

{ #category : #'accessing - delegated' }
GtLClassModificationResult >> classSlotNames [
	^ self updatedClass classSlotNames
]

{ #category : #'accessing - delegated' }
GtLClassModificationResult >> classSlotNames: aCollection [
	self updatedClass classSlotNames: aCollection
]

{ #category : #'magritte-description' }
GtLClassModificationResult >> classSlotNamesDescription [
	<magritteDescription>
	^ MAToManyScalarRelationDescription new
		label: 'Class slots';
		accessor: #classSlotNames;
		classes: { String };
		yourself
]

{ #category : #'accessing - delegated' }
GtLClassModificationResult >> classVariableNames [
	^ self updatedClass classVariableNames
]

{ #category : #'accessing - delegated' }
GtLClassModificationResult >> classVariableNames: aCollection [
	self updatedClass classVariableNames: aCollection
]

{ #category : #'magritte-description' }
GtLClassModificationResult >> classVariableNamesDescription [
	<magritteDescription>
	^ MAToManyScalarRelationDescription new
		label: 'Class variables';
		accessor: #classVariableNames;
		classes: { String };
		yourself
]

{ #category : #'accessing - delegated' }
GtLClassModificationResult >> comment [
	^ self updatedClass comment
]

{ #category : #'accessing - delegated' }
GtLClassModificationResult >> comment: aString [
	self updatedClass comment: aString
]

{ #category : #'magritte-description' }
GtLClassModificationResult >> commentDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Comment';
		accessor: #comment;
		yourself
]

{ #category : #'accessing - delegated' }
GtLClassModificationResult >> currentClassName [
	^ self updatedClass currentClassName
]

{ #category : #'accessing - delegated' }
GtLClassModificationResult >> currentClassName: aString [
	self updatedClass currentClassName: aString
]

{ #category : #'magritte-description' }
GtLClassModificationResult >> currentClassNameDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Class';
		accessor: #currentClassName;
		beRequired;
		yourself
]

{ #category : #views }
GtLClassModificationResult >> gtClassCoderViewFor: aView [
	<gtView>
	<gtLlmView>
	| aClass |
	aClass := self currentClassName asClassIfAbsent: [ ^ aView empty ].
	^ aView explicit
		title: 'Class';
		priority: 0;
		stencil: [ | container |
			container := BrVerticalPane new
					matchParent;
					background: BrGlamorousColors backdropColor.
			container
				addAptitude: (BrLayoutResizerAptitude new common: [ container children ]);
				addChild: ((GtCoderElement forClass: aClass)
						disablePlayPage;
						margin: (BlInsets all: 10);
						background: Color white;
						addAptitude: BrShadowAptitude).
			container ]
]

{ #category : #views }
GtLClassModificationResult >> gtDetailsFor: aView [
	<gtView>
	<gtLlmView>
	^ aView columnedList
		title: 'Details';
		priority: 1;
		items: [ {
			{ 'Class'. self currentClassName }.
			{ 'Superclass'. self superclassName }.
			{ 'Package'. self packageName }.
			{ 'Instance slots'. ', ' join: self instanceSlotNames }.
			{ 'Class slots'. ', ' join: self classSlotNames }.
			{ 'Class variables'. ', ' join: self classVariableNames }.
			{ 'Trait composition'. self traitCompositionString }.
			{ 'Comment'. self comment }
		} ];
		column: 'Field' text: [ :each | each first ];
		column: 'Value' text: [ :each | each second printString ]
]

{ #category : #views }
GtLClassModificationResult >> gtDiffFor: aView [
	<gtView>
	<gtLlmView>
	(self originalClass isNil or: [ self updatedClass isNil ]) ifTrue: [ ^ aView empty ].
	^ aView diff
		title: 'Diff';
		priority: 2;
		from: [ self originalClass asDefinitionString ];
		to: [ self updatedClass asDefinitionString ]
]

{ #category : #'accessing - delegated' }
GtLClassModificationResult >> instanceSlotNames [
	^ self updatedClass instanceSlotNames
]

{ #category : #'accessing - delegated' }
GtLClassModificationResult >> instanceSlotNames: aCollection [
	self updatedClass instanceSlotNames: aCollection
]

{ #category : #'magritte-description' }
GtLClassModificationResult >> instanceSlotNamesDescription [
	<magritteDescription>
	^ MAToManyScalarRelationDescription new
		label: 'Instance slots';
		accessor: #instanceSlotNames;
		classes: { String };
		yourself
]

{ #category : #accessing }
GtLClassModificationResult >> originalClass [
	^ originalClass
]

{ #category : #accessing }
GtLClassModificationResult >> originalClass: aGtLClassDefinitionDescription [
	originalClass := aGtLClassDefinitionDescription
]

{ #category : #'accessing - delegated' }
GtLClassModificationResult >> packageName [
	^ self updatedClass packageName
]

{ #category : #'accessing - delegated' }
GtLClassModificationResult >> packageName: aString [
	self updatedClass packageName: aString
]

{ #category : #'magritte-description' }
GtLClassModificationResult >> packageNameDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Package';
		accessor: #packageName;
		beRequired;
		yourself
]

{ #category : #printing }
GtLClassModificationResult >> printOn: aStream [
	super printOn: aStream.
	aStream parenthesize: [
		aStream nextPutAll: (self updatedClass 
			ifNil: [ 'unnamed' ] 
			ifNotNil: [ :uc | uc currentClassName ifNil: [ 'unnamed' ] ]).
		self updatedClass ifNotNil: [ :uc |
			uc superclassName ifNotNil: [ :sn |
				aStream nextPutAll: ' < ';
					nextPutAll: sn ].
			uc packageName ifNotNil: [ :pn |
				aStream nextPutAll: ' — ';
					nextPutAll: pn ] ] ]
]

{ #category : #'accessing - delegated' }
GtLClassModificationResult >> superclassName [
	^ self updatedClass superclassName
]

{ #category : #'accessing - delegated' }
GtLClassModificationResult >> superclassName: aString [
	self updatedClass superclassName: aString
]

{ #category : #'magritte-description' }
GtLClassModificationResult >> superclassNameDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Superclass';
		accessor: #superclassName;
		yourself
]

{ #category : #'accessing - delegated' }
GtLClassModificationResult >> traitCompositionString [
	^ self updatedClass traitCompositionString
]

{ #category : #'accessing - delegated' }
GtLClassModificationResult >> traitCompositionString: aString [
	self updatedClass traitCompositionString: aString
]

{ #category : #'magritte-description' }
GtLClassModificationResult >> traitCompositionStringDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Trait composition';
		accessor: #traitCompositionString;
		yourself
]

{ #category : #accessing }
GtLClassModificationResult >> updatedClass [
	^ updatedClass
]

{ #category : #accessing }
GtLClassModificationResult >> updatedClass: aGtLClassDefinitionDescription [
	updatedClass := aGtLClassDefinitionDescription
]
