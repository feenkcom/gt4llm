"
I show how {{gtClass:GtLClassDefinitionPrinter}} prints fluid class and trait definitions: the parts that are left out when they are absent, a trait, and the definitions of classes that RB changes add.
"
Class {
	#name : #GtLClassDefinitionPrinterExamples,
	#superclass : #Object,
	#category : #'Gt4LlmCore-Examples-Support'
}

{ #category : #support }
GtLClassDefinitionPrinterExamples >> addClassChangeFrom: aDefinitionString [
	| aChange |
	aChange := GtRBAddClassChange new.
	aChange definitionString: aDefinitionString.
	aChange fillOutDefinition.
	^ aChange
]

{ #category : #examples }
GtLClassDefinitionPrinterExamples >> addedClassDefinition [
	"The class an RB change adds is printed with all the parts of its definition, also its traits, which the change does not keep"

	<gtExample>
	<return: #GtRBAddClassChange>
	| aChange |
	aChange := self
			addClassChangeFrom: 'Object << #MyClass traits: TMyTrait; slots: { #a . #b }; sharedVariables: { #D }; classSlots: { #c }; tag: ''MyTag''; package: ''MyPackage'''.
	self
		assert: aChange gtLlmNewSource
		equals: (self
				definitionFromLines: #('Object << #MyClass' 'traits: TMyTrait;' 'slots: { #a . #b };' 'sharedVariables: { #D };' 'classSlots: { #c };' 'tag: ''MyTag'';' 'package: ''MyPackage''')).
	^ aChange
]

{ #category : #examples }
GtLClassDefinitionPrinterExamples >> addedClassDefinitionFromOldFormat [
	"A class added with the old definition format is printed in the fluid format, with its tag split from its category"

	<gtExample>
	<return: #GtRBAddClassChange>
	| aChange |
	aChange := self
			addClassChangeFrom: 'Object subclass: #MyClass uses: TGtLWithChat instanceVariableNames: ''x y'' classVariableNames: ''Z'' package: ''Gt4LlmCore-Support'''.
	self
		assert: aChange gtLlmNewSource
		equals: (self
				definitionFromLines: #('Object << #MyClass' 'traits: TGtLWithChat;' 'slots: { #x . #y };' 'sharedVariables: { #Z };' 'tag: ''Support'';' 'package: ''Gt4LlmCore''')).
	^ aChange
]

{ #category : #examples }
GtLClassDefinitionPrinterExamples >> addedTraitDefinition [
	"A trait added with a fluid definition from Trait is printed as a trait"

	<gtExample>
	<return: #GtRBAddClassChange>
	| aChange |
	aChange := self
			addClassChangeFrom: 'Trait << #TMyTrait traits: {}; slots: {}; tag: ''MyTag''; package: ''MyPackage'''.
	self
		assert: aChange gtLlmNewSource
		equals: (self
				definitionFromLines: #('Trait << #TMyTrait' 'tag: ''MyTag'';' 'package: ''MyPackage''')).
	^ aChange
]

{ #category : #support }
GtLClassDefinitionPrinterExamples >> definitionFromLines: someLines [
	"The first line, then each part on its own line, indented by a tab"

	^ String
		streamContents: [ :aStream | 
			aStream nextPutAll: someLines first.
			someLines allButFirst
				do: [ :each | 
					aStream
						cr;
						tab;
						nextPutAll: each ] ]
]

{ #category : #examples }
GtLClassDefinitionPrinterExamples >> definitionLeavesOutMissingParts [
	"Without traits, class variables, class-side slots and tag, a class definition has its superclass, name, slots and package"

	<gtExample>
	<return: #GtLClassDefinitionPrinter>
	| aPrinter |
	aPrinter := GtLClassDefinitionPrinter new
			className: 'MyClass';
			superclassName: 'Object';
			packageName: 'MyPackage';
			yourself.
	self
		assert: aPrinter definitionString
		equals: (self
				definitionFromLines: #('Object << #MyClass' 'slots: {};' 'package: ''MyPackage''')).
	^ aPrinter
]

{ #category : #examples }
GtLClassDefinitionPrinterExamples >> definitionWithAllParts [
	"The parts are written in the order of the definitions Pharo prints; the class-side slots are in the same definition"

	<gtExample>
	<return: #GtLClassDefinitionPrinter>
	| aPrinter |
	aPrinter := GtLClassDefinitionPrinter new
			className: 'MyClass';
			superclassName: 'MySuperclass';
			traitCompositionString: 'TMyTrait';
			slotNames: #('a' 'b');
			classVariableNames: #('D');
			classSlotNames: #('c');
			tagName: 'MyTag';
			packageName: 'MyPackage';
			yourself.
	self
		assert: aPrinter definitionString
		equals: (self
				definitionFromLines: #('MySuperclass << #MyClass' 'traits: TMyTrait;' 'slots: { #a . #b };' 'sharedVariables: { #D };' 'classSlots: { #c };' 'tag: ''MyTag'';' 'package: ''MyPackage''')).
	self
		assert: (CDFluidClassDefinitionParser parse: aPrinter definitionString)
				isClassDefinition.
	^ aPrinter
]

{ #category : #examples }
GtLClassDefinitionPrinterExamples >> traitDefinition [
	"A trait is defined from Trait, and without slots it has none in its definition"

	<gtExample>
	<return: #GtLClassDefinitionPrinter>
	| aPrinter |
	aPrinter := GtLClassDefinitionPrinter new
			className: 'TMyTrait';
			isTrait: true;
			tagName: 'MyTag';
			packageName: 'MyPackage';
			yourself.
	self
		assert: aPrinter definitionString
		equals: (self
				definitionFromLines: #('Trait << #TMyTrait' 'tag: ''MyTag'';' 'package: ''MyPackage''')).
	^ aPrinter
]
