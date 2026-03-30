"
Examples for GtLMagritteToolForClassesCreation.
"
Class {
	#name : #GtLMagritteToolForClassesCreationExamples,
	#superclass : #Object,
	#traits : 'TGtLInvalidInputDataAssertions',
	#classTraits : 'TGtLInvalidInputDataAssertions classTrait',
	#instVars : [
		'environment'
	],
	#category : 'Gt4LlmCore-Examples-Tools'
}

{ #category : #private }
GtLMagritteToolForClassesCreationExamples >> cleanUpEnvironment [
	environment ifNotNil: [ :anEnvironment | anEnvironment removeFromSystem ]
]

{ #category : #examples }
GtLMagritteToolForClassesCreationExamples >> createClassesThatAlreadyExist [
	<gtExample>
	<after: #cleanUpEnvironment>
	| className |
	environment := GtPharoDummyEnvironment withPackages: 1 classes: 1.
	className := environment anyDummyClass className.
	[
		| tool call result targetObject |
		tool := GtLMagritteToolForClassesCreation new.
		call := GtLFunctionToolCall new.
		call
			rawArguments: {'classes'
					-> {{'targetClassName' -> className.
								'superclassName' -> #Object.
								'package' -> 'Gt4LlmCoreNewPackage'} asDictionary} asArray.
				'traits' -> {}} asDictionary.
		result := tool performToolCall: call.
		self assert: call tool == tool.
		self assert: (result isKindOf: GTLDataViewWrapperModel).
		
		targetObject := result targetObject.
		self assert: (targetObject isKindOf: GtLClassesCreationResult).
		self assert: targetObject classes first isErrorDomainObject.
		self
			assertUnexpectedObject: targetObject classes first
			withObjectName: className asString
			errorMessage: className asString, ' already exists'.
		call
	] ensure: [  ]
]

{ #category : #examples }
GtLMagritteToolForClassesCreationExamples >> createClassesWithInstanceVariables [
	<gtExample>
	| classNames |
	classNames := {
		#GtLMagritteToolForClassesCreationExamplesGenerated1.
		#GtLMagritteToolForClassesCreationExamplesGenerated2 }.
	classNames do: [ :className | self removeClassNamedIfPresent: className ].
	[
		| tool call result targetObject createdClasses |
		tool := GtLMagritteToolForClassesCreation new.
		call := GtLFunctionToolCall new.
		call rawArguments: {
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
		result := tool performToolCall: call.
		self assert: call tool == tool.
		self assert: (result isKindOf: GTLDataViewWrapperModel).
		
		targetObject := result targetObject.
		self assert: (targetObject isKindOf: GtLClassesCreationResult).
		self assert: targetObject classes size equals: 2.
		createdClasses := classNames collect: [ :each |
			Smalltalk globals at: each ifAbsent: [ nil ] ].
		self assert: (createdClasses allSatisfy: #notNil).
		self assert: (createdClasses first instanceVariables collect: #name) equals: #('firstSlot' 'secondSlot').
		self assert: (createdClasses second instanceVariables collect: #name) equals: #('value').
		call
	] ensure: [ classNames do: [ :each | self removeClassNamedIfPresent: each ] ]
]

{ #category : #examples }
GtLMagritteToolForClassesCreationExamples >> createClassesWithMissingArguments [
	<gtExample>
	| tool call result targetObject |
	tool := GtLMagritteToolForClassesCreation new.
	call := GtLFunctionToolCall new.
	call rawArguments: Dictionary new.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	
	targetObject := result targetObject.
	self
		assertMissingRequiredProperties: targetObject
		withPropertyNames: #('classes' 'traits')
		path: #(nil)
		errorMessage: 'required properties missing [classes, traits]'.
	^ call
]

{ #category : #examples }
GtLMagritteToolForClassesCreationExamples >> createClassesWithNilClasses [
	<gtExample>
	| tool call result targetObject |
	tool := GtLMagritteToolForClassesCreation new.
	call := GtLFunctionToolCall new.
	call rawArguments: {
		'classes' -> nil.
		'traits' -> {}
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	
	targetObject := result targetObject.
	self
		assertJSONSchemaValidationError: targetObject
		withPath: #('classes')
		errorMessage: '@[classes] array expected'.
	^ call
]

{ #category : #examples }
GtLMagritteToolForClassesCreationExamples >> createClassesWithNilTraits [
	<gtExample>
	| tool call result targetObject |
	tool := GtLMagritteToolForClassesCreation new.
	call := GtLFunctionToolCall new.
	call rawArguments: {
		'classes' -> {}.
		'traits' -> nil
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	
	targetObject := result targetObject.
	self
		assertJSONSchemaValidationError: targetObject
		withPath: #('traits')
		errorMessage: '@[traits] array expected'.
	^ call
]

{ #category : #examples }
GtLMagritteToolForClassesCreationExamples >> createClassesWithUnknownSuperclass [
	<gtExample>
	| className |
	className := #GtLMagritteToolForClassesCreationExamplesUnknownSuperclass.
	self removeClassNamedIfPresent: className.
	[
		| tool call result targetObject |
		tool := GtLMagritteToolForClassesCreation new.
		call := GtLFunctionToolCall new.
		call
			rawArguments: {'classes'
					-> {{'targetClassName' -> className.
								'superclassName' -> 'ClassThatDoesNotExistForClassesCreation'.
								'package' -> 'Gt4LlmCoreNewPackage'} asDictionary} asArray.
				'traits' -> {}} asDictionary.
		result := tool performToolCall: call.
		self assert: call tool == tool.
		self assert: (result isKindOf: GTLDataViewWrapperModel).
		
		targetObject := result targetObject.
		self assert: (targetObject isKindOf: GtLClassesCreationResult).
		self assert: targetObject classes first isErrorDomainObject.
		self
			assertMissingObject: targetObject classes first
			withObjectName: 'ClassThatDoesNotExistForClassesCreation'
			errorMessage: 'ClassThatDoesNotExistForClassesCreation is not found'.
		call
	] ensure: [ self removeClassNamedIfPresent: className ]
]

{ #category : #examples }
GtLMagritteToolForClassesCreationExamples >> createClassWithMissingTargetClassName [
	<gtExample>
	| tool call result targetObject |
	tool := GtLMagritteToolForClassesCreation new.
	call := GtLFunctionToolCall new.
	call rawArguments: {
		'classes' -> {
			{ 'superclassName' -> #Object.
			  'package' -> 'Gt4LlmCoreNewPackage' } asDictionary
		} asArray.
		'traits' -> {}
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	
	targetObject := result targetObject.
	self
		assertMissingRequiredProperties: targetObject
		withPropertyNames: #('targetClassName')
		path: #(#classes 1)
		errorMessage: '@[classes/1] required properties missing [targetClassName]'.
	^ call
]

{ #category : #examples }
GtLMagritteToolForClassesCreationExamples >> createEmptyClassesAndTraits [
	<gtExample>
	| tool call result targetObject |
	tool := GtLMagritteToolForClassesCreation new.
	call := GtLFunctionToolCall new.
	call rawArguments: {
		'classes' -> {}.
		'traits' -> {}
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	
	targetObject := result targetObject.
	self assert: (targetObject isKindOf: GtLClassesCreationResult).
	self assert: targetObject classes isEmpty.
	^ call
]

{ #category : #examples }
GtLMagritteToolForClassesCreationExamples >> createTraitsWithInstanceVariables [
	<gtExample>
	| traitsNames |
	traitsNames := {#TGtLMagritteToolForClassesCreationExamplesGeneratedTrait1.
			#TGtLMagritteToolForClassesCreationExamplesGeneratedTrait2}.
	traitsNames do: [ :traitName | self removeClassNamedIfPresent: traitName ].
	[
		| tool call result targetObject createdTraits |
		tool := GtLMagritteToolForClassesCreation new.
		call := GtLFunctionToolCall new.
		call
			rawArguments: {'classes' -> {}.
				'traits'
					-> {{'targetTraitName' -> traitsNames first.
								'instanceVariables' -> 'firstSlot secondSlot'.
								'package' -> 'Gt4LlmCoreNewPackage'.
								'packageTag' -> 'TagOne'} asDictionary.
							{'targetTraitName' -> traitsNames second.
								'instanceVariables' -> 'value'.
								'classInstanceVariables' -> 'classValue'.
								'package' -> 'Gt4LlmCoreNewPackage'.
								'packageTag' -> 'TagTwo'} asDictionary} asArray} asDictionary.
		result := tool performToolCall: call.
		self assert: call tool == tool.
		self assert: (result isKindOf: GTLDataViewWrapperModel).
		
		targetObject := result targetObject.
		self assert: (targetObject isKindOf: GtLClassesCreationResult).
		self assert: targetObject classes size equals: 2.
		createdTraits := traitsNames
				collect: [ :each | Smalltalk globals at: each ifAbsent: [ nil ] ].
		self assert: (createdTraits allSatisfy: #notNil).
		self assert: (createdTraits allSatisfy: #isTrait).
		self
			assert: (createdTraits first instanceVariables collect: #name)
			equals: #('firstSlot' 'secondSlot').
		self
			assert: (createdTraits second instanceVariables collect: #name)
			equals: #('value').
		self
			assert: (createdTraits second classSide instanceVariables collect: #name as: Array)
			equals: #('classValue').
		self assert: createdTraits first package name equals: 'Gt4LlmCoreNewPackage'.
		self assert: createdTraits second package name equals: 'Gt4LlmCoreNewPackage'.
		self assert: createdTraits second packageTag name equals: 'TagTwo'.
		call
	] ensure: [ traitsNames do: [ :each | self removeClassNamedIfPresent: each ] ]
]

{ #category : #examples }
GtLMagritteToolForClassesCreationExamples >> createTraitWithMissingTargetTraitName [
	<gtExample>
	| tool call result targetObject |
	tool := GtLMagritteToolForClassesCreation new.
	call := GtLFunctionToolCall new.
	call rawArguments: {
		'classes' -> {}.
		'traits' -> {
			{ 'instanceVariables' -> 'value'.
			  'package' -> 'Gt4LlmCoreNewPackage' } asDictionary
		} asArray
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	
	targetObject := result targetObject.
	self
		assertMissingRequiredProperties: targetObject
		withPropertyNames: #('targetTraitName')
		path: #(#traits 1)
		errorMessage: '@[traits/1] required properties missing [targetTraitName]'.
	^ call
]

{ #category : #private }
GtLMagritteToolForClassesCreationExamples >> removeClassNamedIfPresent: aSymbol [
	Smalltalk globals
		at: aSymbol asSymbol
		ifPresent: [ :cls | cls removeFromSystem ]
]
