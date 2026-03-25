"
Holds a class description for the lookupClass tool.
"
Class {
	#name : #GtLClassDescription,
	#superclass : #Object,
	#instVars : [
		'currentClassName',
		'superclassName',
		'comment',
		'packageName',
		'instanceSlotNames',
		'classSlotNames',
		'allInstanceMethodNames',
		'allClassMethodNames',
		'packageTagName'
	],
	#category : 'Gt4LlmCore-Magritte Objects'
}

{ #category : #'instance creation' }
GtLClassDescription class >> fromClass: aClass [
	^ self new
		currentClassName: aClass name;
		superclassName: (aClass superclass ifNil: [ nil ] ifNotNil: [ :aSuperclass | aSuperclass name ]);
		comment: aClass instanceSide gtComment;
		packageName: aClass package name;
		packageTagName: (aClass packageTag isRoot ifTrue: [ nil ] ifFalse: [ aClass packageTag name ]);
		instanceSlotNames: aClass slotNames;
		classSlotNames: aClass class slotNames;
		allInstanceMethodNames: (aClass methods asArray collect: [ :aMethod | aMethod selector ]);
		allClassMethodNames: (aClass class methods asArray collect: [ :aMethod | aMethod selector ]);
		yourself
]

{ #category : #accessing }
GtLClassDescription >> allClassMethodNames [
	^ allClassMethodNames ifNil: [ #() ]
]

{ #category : #accessing }
GtLClassDescription >> allClassMethodNames: aCollection [
	allClassMethodNames := aCollection
]

{ #category : #magritte }
GtLClassDescription >> allClassMethodNamesDescription [
	<magritteDescription>
	^ MAToManyScalarRelationDescription new
		label: 'All class methods';
		accessor: #allClassMethodNames;
		classes: {String};
		beRequired;
		yourself
]

{ #category : #accessing }
GtLClassDescription >> allInstanceMethodNames [
	^ allInstanceMethodNames ifNil: [ #() ]
]

{ #category : #accessing }
GtLClassDescription >> allInstanceMethodNames: aCollection [
	allInstanceMethodNames := aCollection
]

{ #category : #magritte }
GtLClassDescription >> allInstanceMethodNamesDescription [
	<magritteDescription>
	^ MAToManyScalarRelationDescription new
		label: 'All instance methods';
		accessor: #allInstanceMethodNames;
		classes: {String};
		beRequired;
		yourself
]

{ #category : #accessing }
GtLClassDescription >> classSlotNames [
	^ classSlotNames ifNil: [ #() ]
]

{ #category : #accessing }
GtLClassDescription >> classSlotNames: aCollection [
	classSlotNames := aCollection
]

{ #category : #magritte }
GtLClassDescription >> classSlotNamesDescription [
	<magritteDescription>
	^ MAToManyScalarRelationDescription new
		label: 'Class slots';
		accessor: #classSlotNames;
		classes: {String};
		beRequired;
		yourself
]

{ #category : #accessing }
GtLClassDescription >> comment [
	^ comment
]

{ #category : #accessing }
GtLClassDescription >> comment: aString [
	comment := aString
]

{ #category : #magritte }
GtLClassDescription >> commentDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Comment';
		accessor: #comment;
		beRequired
]

{ #category : #accessing }
GtLClassDescription >> currentClassName [
	^ currentClassName
]

{ #category : #accessing }
GtLClassDescription >> currentClassName: aString [
	currentClassName := aString
]

{ #category : #magritte }
GtLClassDescription >> currentClassNameDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Class';
		accessor: #currentClassName;
		name: #currentClassName;
		beRequired;
		yourself
]

{ #category : #'as yet unclassified' }
GtLClassDescription >> gtClassCoderViewFor: aView [
	<gtView>
	<gtLlmView>
	| aClass |
	aClass := self currentClassName asClassIfAbsent: [^ aView empty].
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

{ #category : #'gt-views' }
GtLClassDescription >> gtClassMethodsFor: aView [
	<gtView>
	<gtLlmView>
	self allClassMethodNames ifNil: [ ^ aView empty ].
	^ aView list
		title: 'Class methods';
		priority: 3;
		items: [ self allClassMethodNames ];
		itemText: [ :each | each asString ]
]

{ #category : #'gt-views' }
GtLClassDescription >> gtDetailsFor: aView [
	<gtView>
	<gtLlmView>
	^ aView columnedList
		title: 'Details';
		priority: 1;
		items: [ {
			{'Class'. self currentClassName}.
			{'Superclass'. self superclassName}.
			{'Package'. self packageName}.
			{'Comment'. self comment}
		} ];
		column: 'Field' text: [ :each | each first ];
		column: 'Value' text: [ :each | each second printString ]
]

{ #category : #'gt-views' }
GtLClassDescription >> gtInstanceMethodsFor: aView [
	<gtView>
	<gtLlmView>
	self allInstanceMethodNames ifNil: [ ^ aView empty ].
	^ aView list
		title: 'Instance methods';
		priority: 2;
		items: [ self allInstanceMethodNames ];
		itemText: [ :each | each asString ]
]

{ #category : #accessing }
GtLClassDescription >> instanceSlotNames [
	^ instanceSlotNames ifNil: [ #() ]
]

{ #category : #accessing }
GtLClassDescription >> instanceSlotNames: aCollection [
	instanceSlotNames := aCollection
]

{ #category : #magritte }
GtLClassDescription >> instanceSlotNamesDescription [
	<magritteDescription>
	^ MAToManyScalarRelationDescription new
		label: 'Instance slots';
		accessor: #instanceSlotNames;
		classes: {String};
		beRequired;
		yourself
]

{ #category : #accessing }
GtLClassDescription >> packageName [
	^ packageName
]

{ #category : #accessing }
GtLClassDescription >> packageName: aString [
	packageName := aString
]

{ #category : #magritte }
GtLClassDescription >> packageNameDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Package';
		accessor: #packageName;
		name: #packageName;
		beRequired;
		yourself
]

{ #category : #accessing }
GtLClassDescription >> packageTagName [
	^ packageTagName
]

{ #category : #accessing }
GtLClassDescription >> packageTagName: aString [
	packageTagName := aString
]

{ #category : #magritte }
GtLClassDescription >> packageTagNameDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Package tag';
		accessor: #packageTagName;
		name: #packageTagName;
		beRequired;
		yourself
]

{ #category : #printing }
GtLClassDescription >> printOn: aStream [
	super printOn: aStream.
	aStream parenthesize: [
		self currentClassName ifNotNil: [ :aName |
			aStream nextPutAll: aName ].
		self packageName ifNotNil: [ :aPackage |
			aStream nextPutAll: ' — ';
				nextPutAll: aPackage ] ]
]

{ #category : #accessing }
GtLClassDescription >> superclassName [
	^ superclassName
]

{ #category : #accessing }
GtLClassDescription >> superclassName: aStringOrNil [
	superclassName := aStringOrNil
]

{ #category : #magritte }
GtLClassDescription >> superclassNameDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Superclass';
		accessor: #superclassName;
		name: #superclassName;
		yourself
]
