"
Examples for GtLMagritteToolForClassesCreation.
"
Class {
	#name : #GtLMagritteToolForClassesCreationExamples,
	#superclass : #Object,
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
GtLMagritteToolForClassesCreationExamples >> createClassesThatAlreadyExist [
	<gtExample>
	<after: #cleanUpEnvironment>
	| tool call result model className aDummyClass |
	tool := GtLMagritteToolForClassesCreation new.
	environment := GtPharoDummyEnvironment withPackages: 1 classes: 1.
	aDummyClass := environment anyDummyClass.
	className := aDummyClass className.
	[ call := GtLFunctionToolCall new.
	call rawArguments: {
		'classes' -> {
			{ 'targetClassName' -> className.
			  'superclassName' -> #Object.
			  'package' -> 'Gt4LlmCoreNewPackage' } asDictionary
		} asArray
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GtLMagritteBasedModel).
	model := result model.
	self assert: model classes first isErrorDomainObject.
	self assert: model classes first objectName equals: className ]
	ensure: [].
	^ call
]

{ #category : #examples }
GtLMagritteToolForClassesCreationExamples >> createClassesWithInstanceVariables [
	<gtExample>
	| tool call result model classNames createdClasses |
	[ tool := GtLMagritteToolForClassesCreation new.
	classNames := {
		#GtLMagritteToolForClassesCreationExamplesGenerated1.
		#GtLMagritteToolForClassesCreationExamplesGenerated2 }.
	classNames do: [ :className | self removeClassNamedIfPresent: className ].
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
		} asArray
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GtLMagritteBasedModel).
	model := result model.
	self assert: (model isKindOf: GtLClassesCreationResult).
	self assert: model classes size equals: 2.
	createdClasses := classNames collect: [ :each |
		Smalltalk globals at: each ifAbsent: [ nil ] ].
	self assert: (createdClasses allSatisfy: #notNil).
	self assert: (createdClasses first instanceVariables collect: #name) = #('firstSlot' 'secondSlot').
	self assert: (createdClasses second instanceVariables collect: #name) = #('value') ]
	ensure: [ classNames do: [ :each | self removeClassNamedIfPresent: each ] ].
	^ call
]

{ #category : #examples }
GtLMagritteToolForClassesCreationExamples >> createClassesWithMissingArguments [
	<gtExample>
	| tool call result model |
	tool := GtLMagritteToolForClassesCreation new.
	call := GtLFunctionToolCall new.
	call rawArguments: Dictionary new.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GtLMagritteBasedModel).
	model := result model.
	self assert: model isErrorDomainObject.
	self assert: model class equals: GtLMissingRequiredPropertiesDomainObject.
	self assert: model missingPropertyNames equals: #('classes').
	^ call
]

{ #category : #examples }
GtLMagritteToolForClassesCreationExamples >> createClassesWithUnknownSuperclass [
	<gtExample>
	| tool call result model className |
	[ tool := GtLMagritteToolForClassesCreation new.
	className := #GtLMagritteToolForClassesCreationExamplesUnknownSuperclass.
	self removeClassNamedIfPresent: className.
	call := GtLFunctionToolCall new.
	call rawArguments: {
		'classes' -> {
			{ 'targetClassName' -> className.
			  'superclassName' -> 'ClassThatDoesNotExistForClassesCreation'.
			  'package' -> 'Gt4LlmCoreNewPackage' } asDictionary
		} asArray
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GtLMagritteBasedModel).
	model := result model.
	self assert: model classes first isErrorDomainObject.
	self assert: model classes first objectName equals: 'ClassThatDoesNotExistForClassesCreation' ]
	ensure: [ self removeClassNamedIfPresent: className ].
	^ call
]

{ #category : #examples }
GtLMagritteToolForClassesCreationExamples >> createTraitsWithInstanceVariables [
	<gtExample>
	| tool call result model traitsNames createdTraits |
	[ tool := GtLMagritteToolForClassesCreation new.
	traitsNames := {#TGtLMagritteToolForClassesCreationExamplesGeneratedTrait1.
			#TGtLMagritteToolForClassesCreationExamplesGeneratedTrait2}.
	traitsNames do: [ :traitName | self removeClassNamedIfPresent: traitName ].
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
	self assert: (result isKindOf: GtLMagritteBasedModel).
	model := result model.
	self assert: (model isKindOf: GtLClassesCreationResult).
	self assert: model classes size equals: 2.
	createdTraits := traitsNames
			collect: [ :each | Smalltalk globals at: each ifAbsent: [ nil ] ].
	self assert: (createdTraits allSatisfy: #notNil).
	self assert: (createdTraits allSatisfy: #isTrait).
	self
		assert: (createdTraits first instanceVariables collect: #name)
				= #('firstSlot' 'secondSlot').
	self
		assert: (createdTraits second instanceVariables collect: #name) = #('value').
	self
		assert: (createdTraits second classSide instanceVariables collect: #name as: Array)
		equals: #('classValue').
	self assert: createdTraits first package name equals: 'Gt4LlmCoreNewPackage'.
	self assert: createdTraits second package name equals: 'Gt4LlmCoreNewPackage'.
	self assert: createdTraits second packageTag name equals: 'TagTwo' ]
		ensure: [ traitsNames do: [ :each | self removeClassNamedIfPresent: each ] ].
	^ call
]

{ #category : #private }
GtLMagritteToolForClassesCreationExamples >> removeClassNamedIfPresent: aSymbol [
	Smalltalk globals
		at: aSymbol asSymbol
		ifPresent: [ :cls | cls removeFromSystem ]
]
