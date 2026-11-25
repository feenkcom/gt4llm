"
I print the fluid definition of a class or trait for LLM responses, such as `Object << #Name slots: { #a }; package: 'Package'`, from its names: the class name, the superclass name, the trait composition, the slots, class variables and class-side slots, the tag and the package.

As in the definitions Pharo prints, I write the traits, class variables, class-side slots and tag only when there are some, and the slots of a trait only when it has some. Unlike Pharo, I write the class-side slots in the same definition, with classSlots:, so that one definition describes the whole class.

I work from names only, so that a definition can be printed for a class that does not exist yet, such as the class an RB change adds ({{gtMethod:RBAddClassChange>>#gtLlmNewSource}}), and for one that is described ({{gtMethod:GtLClassDefinitionDescription>>#asDefinitionString}}). See {{gtClass:GtLClassDefinitionPrinterExamples}}.
"
Class {
	#name : #GtLClassDefinitionPrinter,
	#superclass : #Object,
	#instVars : [
		'className',
		'superclassName',
		'isTrait',
		'traitCompositionString',
		'slotNames',
		'classVariableNames',
		'classSlotNames',
		'tagName',
		'packageName'
	],
	#category : #'Gt4LlmCore-Support'
}

{ #category : #accessing }
GtLClassDefinitionPrinter >> className: aString [
	className := aString
]

{ #category : #accessing }
GtLClassDefinitionPrinter >> classSlotNames: aCollectionOfStrings [
	classSlotNames := aCollectionOfStrings ifNil: [ #() ]
]

{ #category : #accessing }
GtLClassDefinitionPrinter >> classVariableNames: aCollectionOfStrings [
	classVariableNames := aCollectionOfStrings ifNil: [ #() ]
]

{ #category : #printing }
GtLClassDefinitionPrinter >> definitionString [
	"Return the fluid definition, such as Object << #Name slots: { #a }; package: 'Package'"

	<return: #String>
	^ String
		streamContents: [ :aStream | 
			self writeHeaderOn: aStream.
			self hasTraits ifTrue: [ self writeTraitsOn: aStream ].
			(isTrait not or: [ slotNames isEmpty not ])
				ifTrue: [ self
						write: 'slots:'
						names: slotNames
						on: aStream ].
			classVariableNames isEmpty
				ifFalse: [ self
						write: 'sharedVariables:'
						names: classVariableNames
						on: aStream ].
			classSlotNames isEmpty
				ifFalse: [ self
						write: 'classSlots:'
						names: classSlotNames
						on: aStream ].
			self hasTag ifTrue: [ self writeTagOn: aStream ].
			self writePackageOn: aStream ]
]

{ #category : #views }
GtLClassDefinitionPrinter >> gtDefinitionFor: aView [
	<gtView>
	className ifNil: [ ^ aView empty ].
	^ aView forward
		title: 'Definition';
		priority: 5;
		object: [ self definitionString ];
		view: #gtStringFor:
]

{ #category : #testing }
GtLClassDefinitionPrinter >> hasTag [
	^ tagName notNil and: [ tagName isEmpty not ]
]

{ #category : #testing }
GtLClassDefinitionPrinter >> hasTraits [
	^ traitCompositionString isEmpty not and: [ traitCompositionString ~= '{}' ]
]

{ #category : #initialization }
GtLClassDefinitionPrinter >> initialize [
	super initialize.
	isTrait := false.
	traitCompositionString := '{}'.
	slotNames := #().
	classVariableNames := #().
	classSlotNames := #()
]

{ #category : #accessing }
GtLClassDefinitionPrinter >> isTrait: aBoolean [
	isTrait := aBoolean = true
]

{ #category : #accessing }
GtLClassDefinitionPrinter >> packageName: aString [
	packageName := aString
]

{ #category : #printing }
GtLClassDefinitionPrinter >> printOn: aStream [
	super printOn: aStream.
	aStream
		nextPut: $(;
		nextPutAll: className asString;
		nextPut: $)
]

{ #category : #accessing }
GtLClassDefinitionPrinter >> slotNames: aCollectionOfStrings [
	slotNames := aCollectionOfStrings ifNil: [ #() ]
]

{ #category : #accessing }
GtLClassDefinitionPrinter >> superclassName: aStringOrNil [
	superclassName := aStringOrNil
]

{ #category : #accessing }
GtLClassDefinitionPrinter >> tagName: aStringOrNil [
	"The package tag, or nil for the root tag"

	tagName := aStringOrNil
]

{ #category : #accessing }
GtLClassDefinitionPrinter >> traitCompositionString: aString [
	"A composition such as TFoo + TBar, or {} without traits"

	traitCompositionString := aString ifNil: [ '{}' ]
]

{ #category : #printing }
GtLClassDefinitionPrinter >> write: aKeyword names: aCollectionOfNames on: aStream [
	"Write a part such as slots: { #a . #b };"

	aStream
		cr;
		tab;
		nextPutAll: aKeyword;
		nextPutAll: ' {'.
	aCollectionOfNames isEmpty ifTrue: [ ^ aStream nextPutAll: '};' ].
	aCollectionOfNames
		do: [ :each | 
			aStream
				space;
				store: each asSymbol ]
		separatedBy: [ aStream nextPutAll: ' .' ].
	aStream nextPutAll: ' };'
]

{ #category : #printing }
GtLClassDefinitionPrinter >> writeHeaderOn: aStream [
	aStream
		nextPutAll: (isTrait
				ifTrue: [ 'Trait' ]
				ifFalse: [ (superclassName ifNil: [ 'nil' ]) asString ]);
		nextPutAll: ' << ';
		store: className asSymbol
]

{ #category : #printing }
GtLClassDefinitionPrinter >> writePackageOn: aStream [
	aStream
		cr;
		tab;
		nextPutAll: 'package: ';
		store: packageName asString
]

{ #category : #printing }
GtLClassDefinitionPrinter >> writeTagOn: aStream [
	aStream
		cr;
		tab;
		nextPutAll: 'tag: ';
		store: tagName asString;
		nextPut: $;
]

{ #category : #printing }
GtLClassDefinitionPrinter >> writeTraitsOn: aStream [
	aStream
		cr;
		tab;
		nextPutAll: 'traits: ';
		nextPutAll: traitCompositionString;
		nextPut: $;
]
