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
GtLMagritteToolForClassesCreationExamples >> createClassAlongsideTrait [
	<gtExample>
	| className traitName call result created |
	className := #GtLMagritteToolForClassesCreationExamplesMixedClass.
	traitName := #TGtLMagritteToolForClassesCreationExamplesMixedTrait.
	self removeClassNamedIfPresent: className.
	self removeClassNamedIfPresent: traitName.
	[
		call := self executeTool: GtLMagritteToolForClassesCreation new
			withArguments: {
				'classes' -> { {
					'targetClassName' -> className.
					'superclassName' -> 'Object'.
					'package' -> 'Gt4LlmCoreNewPackage'.
					'packageTag' -> 'IgnoredByGemStone'.
					'instanceVariables' -> 'value'.
					'classVariables' -> 'SharedValue'.
					'classInstanceVariables' -> 'classValue'.
					'comment' -> 'A class created alongside a Trait request'
				} asDictionary }.
				'traits' -> { {
					'targetTraitName' -> traitName.
					'package' -> 'Gt4LlmCoreNewPackage'
				} asDictionary }
			} asDictionary.
		result := call result targetObject.
		self assert: result classes size equals: 2.
		self assert: result classes last isClassAdditionResult.
		self assert: result classes last instanceSlotNames equals: #('value').
		self assert: result classes last classVariableNames equals: #('SharedValue').
		self assert: result classes last classSlotNames equals: #('classValue').
		self assert: result classes last packageName equals: 'Gt4LlmCoreNewPackage'.
		self assert: result classes last comment equals: 'A class created alongside a Trait request'.
		created := Smalltalk globals at: className.
		self gtDo: [
			self assert: (Smalltalk globals at: traitName) isTrait.
			self assert: result classes first isClassAdditionResult ]
		gemstoneDo: [
			self assert: result classes first isErrorDomainObject.
			self assert: result classes first errorMessage equals: 'GemStone does not support Trait creation'.
			self assert: (Smalltalk globals includesKey: traitName) not.
			self assert: ((ClassOrganizer gtDefault classNamesInClassCategoryNamed: created category dictionaryName: nil)
				includes: className asString) ]
	] ensure: [
		self removeClassNamedIfPresent: className.
		self removeClassNamedIfPresent: traitName ].
	^ call
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
		path: (self gtDo: [ #(#classes 1) ] gemstoneDo: [ #('classes' 1) ])
		errorMessage: '@[classes/1] required properties missing [targetClassName]'.
		
	^ call
]

{ #category : #examples }
GtLMagritteToolForClassesCreationExamples >> createClassesThatAlreadyExist [
	<gtExample>
	<after: #cleanUpEnvironment>
	| className call |
	
	className := self
		gtDo: [ environment := GtPharoDummyEnvironment withPackages: 1 classes: 1.
			environment anyDummyClass className ]
		gemstoneDo: [ #Object ].
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
		self assert: (self gtDo: [ createdClasses first instanceVariables collect: #name ]
			gemstoneDo: [ createdClasses first instVarNames collect: [ :each | each asString ] ]) equals: #('firstSlot' 'secondSlot').
		self assert: (self gtDo: [ createdClasses second instanceVariables collect: #name ]
			gemstoneDo: [ createdClasses second instVarNames collect: [ :each | each asString ] ]) equals: #('value')
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
		path: (self gtDo: [ #(#traits 1) ] gemstoneDo: [ #('traits' 1) ])
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
		self
			gtDo: [
		createdTraits := traitsNames collect: [ :each |
			Smalltalk globals at: each ifAbsent: [ nil ] ].
		self assert: (createdTraits allSatisfy: #notNil).
		self assert: (createdTraits allSatisfy: #isTrait).
		self assert: (createdTraits first instanceVariables collect: #name) equals: #('firstSlot' 'secondSlot').
		self assert: (createdTraits second instanceVariables collect: #name) equals: #('value').
		self assert: (createdTraits second classSide instanceVariables collect: #name as: Array) equals: #('classValue').
		self assert: createdTraits first package name equals: 'Gt4LlmCoreNewPackage'.
		self assert: createdTraits second package name equals: 'Gt4LlmCoreNewPackage'.
		self assert: createdTraits second packageTag name equals: 'TagTwo' ]
			gemstoneDo: [
				self assert: (targetObject classes allSatisfy: [ :each |
					each isErrorDomainObject and: [ each errorMessage = 'GemStone does not support Trait creation' ] ]).
				self assert: (traitsNames allSatisfy: [ :each | (Smalltalk globals includesKey: each) not ]) ]
	] ensure: [ traitsNames do: [ :each | self removeClassNamedIfPresent: each ] ].
		
	^ call
]

{ #category : #private }
GtLMagritteToolForClassesCreationExamples >> removeClassNamedIfPresent: aSymbol [
	self
		gtDo: [ Smalltalk globals at: aSymbol asSymbol ifPresent: [ :cls | cls removeFromSystem ] ]
		gemstoneDo: [
			System myUserProfile symbolList do: [ :dictionary |
				dictionary removeKey: aSymbol asSymbol ifAbsent: [ ] ].
			SessionTemps current removeKey: #GtGs_ClassOrganizer_Cache ifAbsent: [ ] ]
]
