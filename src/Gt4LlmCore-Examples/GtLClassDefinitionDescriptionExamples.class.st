"
Examples for GtLClassDefinitionDescription domain object.
"
Class {
	#name : #GtLClassDefinitionDescriptionExamples,
	#superclass : #GtLDomainObjectExamples,
	#category : #'Gt4LlmCore-Examples-Domain Objects'
}

{ #category : #examples }
GtLClassDefinitionDescriptionExamples >> classDefinitionDescriptionCreation [
	<gtExample>
	| description |
	description := GtLClassDefinitionDescription new
		currentClassName: 'MyClass';
		superclassName: 'Object';
		comment: 'A test class';
		packageName: 'MyPackage';
		instanceSlotNames: #('slot1' 'slot2');
		classSlotNames: #();
		classVariableNames: #('SharedValue');
		traitCompositionString: '{}';
		yourself.
	self assert: description currentClassName equals: 'MyClass'.
	self assert: description superclassName equals: 'Object'.
	self assert: description comment equals: 'A test class'.
	self assert: description packageName equals: 'MyPackage'.
	self assert: description instanceSlotNames equals: #('slot1' 'slot2').
	self assert: description classSlotNames equals: #().
	self assert: description classVariableNames equals: #('SharedValue').
	self assert: description traitCompositionString equals: '{}'.
	^ description
]

{ #category : #examples }
GtLClassDefinitionDescriptionExamples >> classDefinitionDescriptionSerialization [
	<gtExample>
	| description json |
	description := self classDefinitionDescriptionCreation.
	
	json := GtMagritteJSONDataExporter exportObject: description.
	self assert: (json at: 'currentClassName') equals: 'MyClass'.
	self assert: (json at: 'superclassName') equals: 'Object'.
	self assert: (json at: 'comment') equals: 'A test class'.
	self assert: (json at: 'packageName') equals: 'MyPackage'.
	self assert: (json at: 'instanceSlotNames') asArray equals: #('slot1' 'slot2').
	self assert: (json at: 'classSlotNames') asArray equals: #().
	self assert: (json at: 'classVariableNames') asArray equals: #('SharedValue').
	self assert: (json at: 'traitCompositionString') equals: '{}'.
	^ json
]

{ #category : #examples }
GtLClassDefinitionDescriptionExamples >> fluidDefinitionFromClassIsLikePharos [
	"Without traits or class-side slots, and with few slots, the definition of a class or trait is the one Pharo prints"

	<gtExample>
	<return: #GtLClassDefinitionDescription>
	| aDescription |
	aDescription := GtLClassDefinitionDescription fromClass: GtLAgent.
	self assert: aDescription isTrait not.
	self
		assert: aDescription asDefinitionString
		equals: (ClassDefinitionPrinter fluid for: GtLAgent) definitionString.
	self
		assert: (GtLClassDefinitionDescription fromClass: TGtLWithChat) asDefinitionString
		equals: (ClassDefinitionPrinter fluid for: TGtLWithChat) definitionString.
	^ aDescription
]

{ #category : #examples }
GtLClassDefinitionDescriptionExamples >> fromClassWithClassVariables [
	"The class variables of the class are in the description and in its definition"

	<gtExample>
	| description |
	description := GtLClassDefinitionDescription fromClass: GtLMcpServer.
	self
		assert: (description classVariableNames collect: [ :each | each asString ]) asArray
		equals: #('Current').
	self assert: description packageTagName equals: 'Mcp'.
	self
		assert: (description asDefinitionString
				includesSubstring: 'sharedVariables: { #Current };').
	^ description
]

{ #category : #examples }
GtLClassDefinitionDescriptionExamples >> fromClassWithTraits [
	"The trait composition of the class is in the description and in its definition"

	<gtExample>
	| description |
	description := GtLClassDefinitionDescription fromClass: GtLChat.
	self assert: description isTrait not.
	self
		assert: description traitCompositionString
		equals: 'TGtLWithInstructionSectionAPI'.
	self
		assert: (description asDefinitionString
				includesSubstring: 'traits: TGtLWithInstructionSectionAPI;').
	^ description
]

{ #category : #examples }
GtLClassDefinitionDescriptionExamples >> fromConcreteClass [
	<gtExample>
	| description aClass |
	aClass := GtLClassDefinitionDescription.
	description := GtLClassDefinitionDescription fromClass: aClass.
	self assert: description currentClassName equals: aClass name.
	self assert: description superclassName equals: aClass superclass name.
	self assert: description packageName equals: aClass package name.
	self assert: description instanceSlotNames asArray equals: (aClass instanceVariables collect: #name) asArray.
	self assert: description classSlotNames asArray equals: aClass class slotNames asArray.
	self assert: description classVariableNames asArray equals: (aClass classVariables collect: #name) asArray.
	self assert: description traitCompositionString equals: aClass traitCompositionString.
	^ description
]
