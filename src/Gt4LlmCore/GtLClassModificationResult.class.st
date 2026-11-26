Class {
	#name : #GtLClassModificationResult,
	#superclass : #GtLClassChangeResult,
	#instVars : [
		'originalClass',
		'updatedClass'
	],
	#category : #'Gt4LlmCore-Magritte Objects'
}

{ #category : #accessing }
GtLClassModificationResult >> addedVariableNamesFor: aVariableType [
	| originalNames |
	originalNames := self originalVariableNamesFor: aVariableType.
	^ (aVariableType namesIn: self updatedClass)
		reject: [ :each | originalNames includes: each ]
]

{ #category : #accessing }
GtLClassModificationResult >> affectedBehaviour [
	^ updatedClass
]

{ #category : #'accessing - delegated' }
GtLClassModificationResult >> asDiffElement [
	^ (self gtDiffFor: GtPhlowView empty) asElement
]

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

{ #category : #testing }
GtLClassModificationResult >> definitionChangedBeyondName [
	| renamedOriginal |
	renamedOriginal := self originalClass copy
			currentClassName: self updatedClass currentClassName;
			yourself.
	^ renamedOriginal asDefinitionString ~= self updatedDefinitionString
]

{ #category : #views }
GtLClassModificationResult >> gtClassCoderViewFor: aView [
	<gtView>
	<gtLlmView>
	<gtCodeChangeView>
	| aClass |
	aClass := self currentClassName asClassIfAbsent: [ ^ aView empty ].
	^ aView explicit
		title: 'Current class';
		priority: 5;
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
	<gtCodeChangeView>
	^ aView columnedList
		title: 'Details';
		priority: 2;
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
	<gtCodeChangeView>

	^ aView diff
		title: 'Diff';
		priority: 1;
		from: [ self originalClass 
			ifNil: [ '' ]
			ifNotNil: [ :each | each asDefinitionWithCommentString ] ];
		to: [ self updatedClass 
			ifNil: [ '' ]
			ifNotNil: [ :each | each asDefinitionWithCommentString ] ];
		fromLabel: 'Old content:';
		toLabel: 'New content:';
		styler: GtCodeDiffRBTextStyler new.
]

{ #category : #views }
GtLClassModificationResult >> gtViewChangeIcon [
	self isClassAdditionResult
		ifTrue: [ ^ self class additionIcon ].
	^ self class modificationIcon
]

{ #category : #accessing }
GtLClassModificationResult >> historyClassNames [
	"A rename belongs to the histories of both names: it removes the old name and adds the new one"

	self isClassRenameResult
		ifTrue: [ ^ {self originalClassName.
				self targetClassName asString} ].
	^ super historyClassNames
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

{ #category : #'as yet unclassified' }
GtLClassModificationResult >> isClassAdditionResult [
	^ self originalClass isNil
]

{ #category : #testing }
GtLClassModificationResult >> isClassModificationResult [
	"Return true if this is a class modification (not an addition)"
	^ self originalClass notNil
]

{ #category : #testing }
GtLClassModificationResult >> isClassRenameResult [
	^ self originalClass notNil
		and: [ self updatedClass notNil
				and: [ self originalClassName ~= self currentClassName asString ] ]
]

{ #category : #refactoring }
GtLClassModificationResult >> llmChangeEntry [
	"A renamed class is listed under both names. Its new definition is listed only when it changed by more than the name, as when the same refactoring also added a slot"

	| anEntry |
	self isClassRenameResult ifFalse: [ ^ super llmChangeEntry ].
	anEntry := GtLRefactoringClassChangeEntry new
			className: self originalClassName;
			newClassName: self targetClassName asString;
			kind: self llmChangeKind;
			yourself.
	self definitionChangedBeyondName
		ifTrue: [ anEntry newSource: self llmNewSource ].
	^ anEntry
]

{ #category : #refactoring }
GtLClassModificationResult >> llmChangeKind [
	self isClassAdditionResult ifTrue: [ ^ 'added class' ].
	self isClassRenameResult ifTrue: [ ^ 'renamed class' ].
	^ 'changed class'
]

{ #category : #refactoring }
GtLClassModificationResult >> llmChangeTarget [
	self isClassRenameResult
		ifTrue: [ ^ self originalClassName , ' to ' , self targetClassName asString ].
	^ super llmChangeTarget
]

{ #category : #refactoring }
GtLClassModificationResult >> llmNewSource [
	^ self updatedDefinitionString
]

{ #category : #'llm views' }
GtLClassModificationResult >> llmRawDataViewFor: aDataView [
	<gtLlmDataView>
	
	^ aDataView magritteObject: [ self ]
]

{ #category : #accessing }
GtLClassModificationResult >> originalClass [
	^ originalClass
]

{ #category : #accessing }
GtLClassModificationResult >> originalClass: aGtLClassDefinitionDescription [
	originalClass := aGtLClassDefinitionDescription
]

{ #category : #accessing }
GtLClassModificationResult >> originalClassName [
	^ self originalClass ifNotNil: [ :aClass | aClass currentClassName asString ]
]

{ #category : #accessing }
GtLClassModificationResult >> originalDefinitionString [
	^self originalClass 
		ifNil: [ '' ]
		ifNotNil: [ :each |
			each asDefinitionString ] 
]

{ #category : #accessing }
GtLClassModificationResult >> originalDefinitionWithCommentString [
	^self originalClass 
		ifNil: [ '' ]
		ifNotNil: [ :each |
			each asDefinitionWithCommentString ] 
]

{ #category : #accessing }
GtLClassModificationResult >> originalPackageName [
	"Return the package name before the modification, if available"
	^ self originalClass ifNotNil: [ :c | c packageName ]
]

{ #category : #accessing }
GtLClassModificationResult >> originalVariableNamesFor: aVariableType [
	^ self originalClass
		ifNil: [ #() ]
		ifNotNil: [ :aDescription | aVariableType namesIn: aDescription ]
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

{ #category : #accessing }
GtLClassModificationResult >> removedVariableNamesFor: aVariableType [
	| updatedNames |
	updatedNames := aVariableType namesIn: self updatedClass.
	^ (self originalVariableNamesFor: aVariableType)
		reject: [ :each | updatedNames includes: each ]
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
GtLClassModificationResult >> targetClassName [
	^ self currentClassName
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

{ #category : #accessing }
GtLClassModificationResult >> updatedDefinitionString [
	^self updatedClass 
		ifNil: [ '' ]
		ifNotNil: [ :each |
			each asDefinitionString ] 
]

{ #category : #accessing }
GtLClassModificationResult >> updatedDefinitionWithCommentString [
	^self updatedClass 
		ifNil: [ '' ]
		ifNotNil: [ :each |
			each asDefinitionWithCommentString ] 
]
