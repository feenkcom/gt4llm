"
Examples for GtLMagritteToolForClassesCreation.
"
Class {
	#name : #GtLMagritteToolForClassesCreationExamples,
	#superclass : #GtLAbstractMagritteFunctionToolExamples,
	#instVars : [
		'environment'
	],
	#category : #'Gt4LlmCore-Examples-Tools'
}

{ #category : #private }
GtLMagritteToolForClassesCreationExamples >> cleanUpEnvironment [
	environment ifNotNil: [ :anEnvironment | anEnvironment removeFromSystem ]
]

{ #category : #examples }
GtLMagritteToolForClassesCreationExamples >> createClassWithMissingTargetClassName [
	<gtExample>
	| call |
	
	call := self
		executeTool: GtLMagritteToolForClassesCreation new
		withArguments: {
			'classes' -> {
				{ 'superclassName' -> #Object.
				  'package' -> 'Gt4LlmCoreNewPackage' } asDictionary
			} asArray.
			'traits' -> {}
		} asDictionary.
	
	self
		assertMissingRequiredProperties: call result targetObject
		withPropertyNames: #('targetClassName')
		path: #(#classes 1)
		errorMessage: '@[classes/1] required properties missing [targetClassName]'.
		
	^ call
]

{ #category : #examples }
GtLMagritteToolForClassesCreationExamples >> createClassesThatAlreadyExist [
	<gtExample>
	<after: #cleanUpEnvironment>
	| className call |
	
	environment := GtPharoDummyEnvironment withPackages: 1 classes: 1.
	className := environment anyDummyClass className.
	[
		| targetObject |
		call := self
			executeTool: GtLMagritteToolForClassesCreation new
			withArguments: {
				'classes' -> {
					{ 'targetClassName' -> className.
					  'superclassName' -> #Object.
					  'package' -> 'Gt4LlmCoreNewPackage' } asDictionary
				} asArray.
				'traits' -> {}
			} asDictionary.
		targetObject := call result targetObject.
		
		self assert: (targetObject isKindOf: GtLClassesCreationResult).
		self assert: targetObject classes first isErrorDomainObject.
		self
			assertUnexpectedObject: targetObject classes first
			withObjectName: className asString
			errorMessage: className asString, ' already exists'
	] ensure: [ ].
		
	^ call
]

{ #category : #examples }
GtLMagritteToolForClassesCreationExamples >> createClassesWithInstanceVariables [
	<gtExample>
	| classNames call |
	
	classNames := {
		#GtLMagritteToolForClassesCreationExamplesGenerated1.
		#GtLMagritteToolForClassesCreationExamplesGenerated2 }.
	classNames do: [ :className | self removeClassNamedIfPresent: className ].
	[
		| createdClasses targetObject |
		call := self
			executeTool: GtLMagritteToolForClassesCreation new
			withArguments: {
				'classes' -> {
					{ 'targetClassName' -> classNames first.
					  'superclassName' -> #Object.
					  'instanceVariables' -> 'firstSlot secondSlot'.
					  'package' -> 'Gt4LlmCoreNewPackage' } asDictionary.
					{ 'targetClassName' -> classNames second.
					  'superclassName' -> #Object.
					  'instanceVariables' -> 'value'.
					  'package' -> 'Gt4LlmCoreNewPackage' } asDictionary
				} asArray.
				'traits' -> {}
			} asDictionary.
		targetObject := call result targetObject.
		
		self assert: (targetObject isKindOf: GtLClassesCreationResult).
		self assert: targetObject classes size equals: 2.
		createdClasses := classNames collect: [ :each |
			Smalltalk globals at: each ifAbsent: [ nil ] ].
		self assert: (createdClasses allSatisfy: #notNil).
		self assert: (createdClasses first instanceVariables collect: #name) equals: #('firstSlot' 'secondSlot').
		self assert: (createdClasses second instanceVariables collect: #name) equals: #('value')
	] ensure: [ classNames do: [ :each | self removeClassNamedIfPresent: each ] ].
		
	^ call
]

{ #category : #examples }
GtLMagritteToolForClassesCreationExamples >> createClassesWithMissingArguments [
	<gtExample>
	| call |
	
	call := self
		executeTool: GtLMagritteToolForClassesCreation new
		withArguments: Dictionary new.
	
	self
		assertMissingRequiredProperties: call result targetObject
		withPropertyNames: #('classes' 'traits')
		path: #(nil)
		errorMessage: 'required properties missing [classes, traits]'.
		
	^ call
]

{ #category : #examples }
GtLMagritteToolForClassesCreationExamples >> createClassesWithNilClasses [
	<gtExample>
	| call |
	
	call := self
		executeTool: GtLMagritteToolForClassesCreation new
		withArguments: {
			'classes' -> nil.
			'traits' -> {}
		} asDictionary.
	
	self
		assertJSONSchemaValidationError: call result targetObject
		withPath: #('classes')
		errorMessage: '@[classes] array expected'.
		
	^ call
]

{ #category : #examples }
GtLMagritteToolForClassesCreationExamples >> createClassesWithNilTraits [
	<gtExample>
	| call |
	
	call := self
		executeTool: GtLMagritteToolForClassesCreation new
		withArguments: {
			'classes' -> {}.
			'traits' -> nil
		} asDictionary.
	
	self
		assertJSONSchemaValidationError: call result targetObject
		withPath: #('traits')
		errorMessage: '@[traits] array expected'.
		
	^ call
]

{ #category : #examples }
GtLMagritteToolForClassesCreationExamples >> createClassesWithUnknownSuperclass [
	<gtExample>
	| className call |
	
	className := #GtLMagritteToolForClassesCreationExamplesUnknownSuperclass.
	self removeClassNamedIfPresent: className.
	[
		| targetObject |
		call := self
			executeTool: GtLMagritteToolForClassesCreation new
			withArguments: {
				'classes' -> {
					{ 'targetClassName' -> className.
					  'superclassName' -> 'ClassThatDoesNotExistForClassesCreation'.
					  'package' -> 'Gt4LlmCoreNewPackage' } asDictionary
				} asArray.
				'traits' -> {}
			} asDictionary.
		targetObject := call result targetObject.
		
		self assert: (targetObject isKindOf: GtLClassesCreationResult).
		self assert: targetObject classes first isErrorDomainObject.
		self
			assertMissingObject: targetObject classes first
			withObjectName: 'ClassThatDoesNotExistForClassesCreation'
			errorMessage: 'ClassThatDoesNotExistForClassesCreation is not found'
	] ensure: [ self removeClassNamedIfPresent: className ].
		
	^ call
]

{ #category : #examples }
GtLMagritteToolForClassesCreationExamples >> createEmptyClassesAndTraits [
	<gtExample>
	| call targetObject |
	
	call := self
		executeTool: GtLMagritteToolForClassesCreation new
		withArguments: {
			'classes' -> {}.
			'traits' -> {}
		} asDictionary.
	targetObject := call result targetObject.
	
	self assert: (targetObject isKindOf: GtLClassesCreationResult).
	self assert: targetObject classes isEmpty.
		
	^ call
]

{ #category : #examples }
GtLMagritteToolForClassesCreationExamples >> createTraitWithMissingTargetTraitName [
	<gtExample>
	| call |
	
	call := self
		executeTool: GtLMagritteToolForClassesCreation new
		withArguments: {
			'classes' -> {}.
			'traits' -> {
				{ 'instanceVariables' -> 'value'.
				  'package' -> 'Gt4LlmCoreNewPackage' } asDictionary
			} asArray
		} asDictionary.
	
	self
		assertMissingRequiredProperties: call result targetObject
		withPropertyNames: #('targetTraitName')
		path: #(#traits 1)
		errorMessage: '@[traits/1] required properties missing [targetTraitName]'.
		
	^ call
]

{ #category : #examples }
GtLMagritteToolForClassesCreationExamples >> createTraitsWithInstanceVariables [
	<gtExample>
	| traitsNames call |
	
	traitsNames := {
		#TGtLMagritteToolForClassesCreationExamplesGeneratedTrait1.
		#TGtLMagritteToolForClassesCreationExamplesGeneratedTrait2 }.
	traitsNames do: [ :traitName | self removeClassNamedIfPresent: traitName ].
	[
		| createdTraits targetObject |
		call := self
			executeTool: GtLMagritteToolForClassesCreation new
			withArguments: {
				'classes' -> {}.
				'traits' -> {
					{ 'targetTraitName' -> traitsNames first.
					  'instanceVariables' -> 'firstSlot secondSlot'.
					  'package' -> 'Gt4LlmCoreNewPackage'.
					  'packageTag' -> 'TagOne' } asDictionary.
					{ 'targetTraitName' -> traitsNames second.
					  'instanceVariables' -> 'value'.
					  'classInstanceVariables' -> 'classValue'.
					  'package' -> 'Gt4LlmCoreNewPackage'.
					  'packageTag' -> 'TagTwo' } asDictionary
				} asArray
			} asDictionary.
		targetObject := call result targetObject.
		
		self assert: (targetObject isKindOf: GtLClassesCreationResult).
		self assert: targetObject classes size equals: 2.
		createdTraits := traitsNames collect: [ :each |
			Smalltalk globals at: each ifAbsent: [ nil ] ].
		self assert: (createdTraits allSatisfy: #notNil).
		self assert: (createdTraits allSatisfy: #isTrait).
		self assert: (createdTraits first instanceVariables collect: #name) equals: #('firstSlot' 'secondSlot').
		self assert: (createdTraits second instanceVariables collect: #name) equals: #('value').
		self assert: (createdTraits second classSide instanceVariables collect: #name as: Array) equals: #('classValue').
		self assert: createdTraits first package name equals: 'Gt4LlmCoreNewPackage'.
		self assert: createdTraits second package name equals: 'Gt4LlmCoreNewPackage'.
		self assert: createdTraits second packageTag name equals: 'TagTwo'
	] ensure: [ traitsNames do: [ :each | self removeClassNamedIfPresent: each ] ].
		
	^ call
]

{ #category : #private }
GtLMagritteToolForClassesCreationExamples >> removeClassNamedIfPresent: aSymbol [
	Smalltalk globals
		at: aSymbol asSymbol
		ifPresent: [ :cls | cls removeFromSystem ]
]
