"
Examples for GtLClassDefinitionDescription domain object.
"
Class {
	#name : #GtLClassDefinitionDescriptionExamples,
	#superclass : #Object,
	#category : 'Gt4LlmCore-Examples-Domain Objects'
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
GtLClassDefinitionDescriptionExamples >> fromClassWithClassVariables [
	<gtExample>
	| description aClass |
	"Use a class with class variables"
	aClass := Boolean.
	description := GtLClassDefinitionDescription fromClass: aClass.
	self assert: description currentClassName equals: aClass name.
	self assert: description superclassName equals: aClass superclass name.
	self assert: description packageName equals: aClass package name.
	self assert: description classVariableNames isCollection.
	^ description
]

{ #category : #examples }
GtLClassDefinitionDescriptionExamples >> fromClassWithTraits [
	<gtExample>
	| description aClass |
	"Use a class that uses traits to test trait composition"
	aClass := TGtAssert users anyOne.
	description := GtLClassDefinitionDescription fromClass: aClass.
	self assert: description currentClassName equals: aClass name.
	self assert: description superclassName equals: aClass superclass name.
	self assert: description packageName equals: aClass package name.
	self assert: description traitCompositionString isString.
	self assert: description traitCompositionString notEmpty.
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
