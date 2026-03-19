Class {
	#name : #GtLClassDefinitionDescription,
	#superclass : #Object,
	#instVars : [
		'currentClassName',
		'superclassName',
		'comment',
		'packageName',
		'instanceSlotNames',
		'classSlotNames',
		'classVariableNames',
		'traitCompositionString',
		'packageTagName'
	],
	#category : #'Gt4LlmCore-Magritte Objects'
}

{ #category : #'instance creation' }
GtLClassDefinitionDescription class >> fromClass: aClass [
	^ self new initializeFromClass: aClass
]

{ #category : #converting }
GtLClassDefinitionDescription >> asDefinitionString [
	"Return a string representing the class definition."
	<return: #String>
	^ String streamContents: [ :stream |
		stream nextPutAll: (self superclassName ifNil: [ 'nil' ]).
		stream nextPutAll: ' subclass: '.
		stream store: self currentClassName asSymbol.
		self traitCompositionString = '{}' ifFalse: [
			stream cr; tab.
			stream nextPutAll: 'uses: '.
			stream nextPutAll: self traitCompositionString ].
		stream cr; tab.
		stream nextPutAll: 'instanceVariableNames: '.
		stream store: (' ' join: self instanceSlotNames).
		stream cr; tab.
		stream nextPutAll: 'classVariableNames: '.
		stream store: (' ' join: self classVariableNames).
		stream cr; tab.
		stream nextPutAll: 'package: '.
		stream store: self packageName ]
]

{ #category : #accessing }
GtLClassDefinitionDescription >> classSlotNames [
	^ classSlotNames ifNil: [ #() ]
]

{ #category : #accessing }
GtLClassDefinitionDescription >> classSlotNames: aCollection [
	classSlotNames := aCollection
]

{ #category : #magritte }
GtLClassDefinitionDescription >> classSlotNamesDescription [
	<magritteDescription>
	^ MAToManyScalarRelationDescription new
		label: 'Class slots';
		accessor: #classSlotNames;
		classes: { String };
		beRequired;
		yourself
]

{ #category : #accessing }
GtLClassDefinitionDescription >> classVariableNames [
	^ classVariableNames ifNil: [ #() ]
]

{ #category : #accessing }
GtLClassDefinitionDescription >> classVariableNames: aCollection [
	classVariableNames := aCollection
]

{ #category : #magritte }
GtLClassDefinitionDescription >> classVariableNamesDescription [
	<magritteDescription>
	^ MAToManyScalarRelationDescription new
		label: 'Class variables';
		accessor: #classVariableNames;
		classes: { String };
		beRequired;
		yourself
]

{ #category : #accessing }
GtLClassDefinitionDescription >> comment [
	^ comment
]

{ #category : #accessing }
GtLClassDefinitionDescription >> comment: aString [
	comment := aString
]

{ #category : #magritte }
GtLClassDefinitionDescription >> commentDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Comment';
		accessor: #comment;
		beRequired;
		yourself
]

{ #category : #accessing }
GtLClassDefinitionDescription >> currentClassName [
	^ currentClassName
]

{ #category : #accessing }
GtLClassDefinitionDescription >> currentClassName: aString [
	currentClassName := aString
]

{ #category : #'magritte-description' }
GtLClassDefinitionDescription >> currentClassNameDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Class';
		accessor: #currentClassName;
		beRequired;
		yourself
]

{ #category : #views }
GtLClassDefinitionDescription >> gtClassCoderViewFor: aView [
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
GtLClassDefinitionDescription >> gtDetailsFor: aView [
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

{ #category : #initialization }
GtLClassDefinitionDescription >> initializeFromClass: aClass [
	self
		currentClassName: aClass name;
		superclassName: (aClass superclass 
			ifNil: [ nil ] 
			ifNotNil: [ :aSuperclass | aSuperclass name ]);
		comment: aClass instanceSide gtComment;
		packageName: aClass package name;
		packageTagName: (aClass packageTag isRoot ifTrue: [ nil ] ifFalse: [ aClass packageTag name ]);
		instanceSlotNames: (aClass instanceVariables collect: [:each | each name]);
		classSlotNames: (aClass class slotNames);
		classVariableNames: (aClass classVariables collect: [:each | each name ]);
		traitCompositionString: aClass traitCompositionString
]

{ #category : #accessing }
GtLClassDefinitionDescription >> instanceSlotNames [
	^ instanceSlotNames ifNil: [ #() ]
]

{ #category : #accessing }
GtLClassDefinitionDescription >> instanceSlotNames: aCollection [
	instanceSlotNames := aCollection
]

{ #category : #magritte }
GtLClassDefinitionDescription >> instanceSlotNamesDescription [
	<magritteDescription>
	^ MAToManyScalarRelationDescription new
		label: 'Instance slots';
		accessor: #instanceSlotNames;
		classes: { String };
		beRequired;
		yourself
]

{ #category : #accessing }
GtLClassDefinitionDescription >> packageName [
	^ packageName
]

{ #category : #accessing }
GtLClassDefinitionDescription >> packageName: aString [
	packageName := aString
]

{ #category : #'magritte-description' }
GtLClassDefinitionDescription >> packageNameDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Package';
		accessor: #packageName;
		beRequired;
		yourself
]

{ #category : #accessing }
GtLClassDefinitionDescription >> packageTagName [
	^ packageTagName
]

{ #category : #accessing }
GtLClassDefinitionDescription >> packageTagName: aString [
	packageTagName := aString
]

{ #category : #'magritte-description' }
GtLClassDefinitionDescription >> packageTagNameDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Package tag';
		accessor: #packageTagName;
		beRequired;
		yourself
]

{ #category : #printing }
GtLClassDefinitionDescription >> printOn: aStream [
	super printOn: aStream.
	aStream parenthesize: [
		aStream nextPutAll: (currentClassName ifNil: [ 'unnamed' ]).
		superclassName ifNotNil: [ 
			aStream nextPutAll: ' < ';
				nextPutAll: superclassName ].
		packageName ifNotNil: [ 
			aStream nextPutAll: ' — ';
				nextPutAll: packageName ] ]
]

{ #category : #accessing }
GtLClassDefinitionDescription >> superclassName [
	^ superclassName
]

{ #category : #accessing }
GtLClassDefinitionDescription >> superclassName: aString [
	superclassName := aString
]

{ #category : #magritte }
GtLClassDefinitionDescription >> superclassNameDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Superclass';
		accessor: #superclassName;
		beRequired;
		yourself
]

{ #category : #accessing }
GtLClassDefinitionDescription >> traitCompositionString [
	^ traitCompositionString ifNil: [ '{}' ]
]

{ #category : #accessing }
GtLClassDefinitionDescription >> traitCompositionString: aString [
	traitCompositionString := aString
]

{ #category : #magritte }
GtLClassDefinitionDescription >> traitCompositionStringDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Trait composition';
		accessor: #traitCompositionString;
		beRequired;
		yourself
]
