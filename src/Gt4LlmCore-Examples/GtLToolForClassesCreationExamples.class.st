Class {
	#name : #GtLToolForClassesCreationExamples,
	#superclass : #Object,
	#instVars : [
		'environment'
	],
	#category : #'Gt4LlmCore-Examples'
}

{ #category : #'as yet unclassified' }
GtLToolForClassesCreationExamples >> cleanUpEnvironment [
	environment ifNotNil: [ :anEnvironment | anEnvironment removeFromSystem ]
]

{ #category : #examples }
GtLToolForClassesCreationExamples >> createClassesThatAlreadyExist [
	<gtExample>
	<after: #cleanUpEnvironment>
	| tool call result className aDummyClass |
	tool := GtLToolForClassesCreation new.
	environment := GtPharoDummyEnvironment withPackages: 1 classes: 1.
	aDummyClass := environment anyDummyClass.
	className := aDummyClass className.
	[ call := GtLFunctionToolCall new.
	call function: {
		'name' -> tool name.
		'arguments' -> {'classes' -> {
			{'className' -> className.
				'superclassName' -> #Object.
				'instanceVariables' -> ''.
				'classVariables' -> ''.
				'package' -> 'Gt4LlmCoreNewPackage'} asDictionary
		} asArray} asDictionary
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: result isErrorDomainObject not.
	self assert: result classes first isErrorDomainObject.
	self assert: result classes first objectName equals: className ]
		ensure: [].
	^ call
]

{ #category : #examples }
GtLToolForClassesCreationExamples >> createClassesWithClassVariables [
	<gtExample>
	| tool call result baseClassName subclassName baseClass subclass sources |
	baseClassName := #GtLToolForClassesCreationExamplesBase.
	subclassName := #GtLToolForClassesCreationExamplesGeneratedWithClassVars.
	[ self removeClassNamedIfPresent: subclassName.
	self removeClassNamedIfPresent: baseClassName.
	baseClass := Object
			subclass: baseClassName
			instanceVariableNames: ''
			classVariableNames: ''
			package: 'Gt4LlmCoreNewPackage'.
	sources := {{'className' -> subclassName.
				'superclassName' -> baseClassName.
				'instanceVariables' -> 'value'.
				'classVariables' -> #('SharedCounter').
				'package' -> 'Gt4LlmCoreNewPackage'} asDictionary} asArray.
	tool := GtLToolForClassesCreation new.
	call := GtLFunctionToolCall new.
	call
		function: {'name' -> tool name.
				'arguments' -> {'classes' -> sources} asDictionary} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: result isErrorDomainObject not.
	self assert: result classes first isErrorDomainObject not.
	subclass := Smalltalk globals at: subclassName ifAbsent: [ nil ].
	self assert: subclass notNil.
	self assert: subclass superclass == baseClass.
	self assert: (subclass classVariables collect: #name) = #('SharedCounter') ]
		ensure: [ self removeClassNamedIfPresent: subclassName.
			self removeClassNamedIfPresent: baseClassName ].
	^ call
]

{ #category : #examples }
GtLToolForClassesCreationExamples >> createClassesWithInstanceVariables [
	<gtExample>
	| tool call result classNames createdClasses sources |
	[ tool := GtLToolForClassesCreation new.
	classNames := {#GtLToolForClassesCreationExamplesGenerated1.
			#GtLToolForClassesCreationExamplesGenerated2}.
	classNames do: [ :className | self removeClassNamedIfPresent: className ].
	sources := {{'className' -> classNames first.
				'superclassName' -> #Object.
				'instanceVariables' -> #('firstSlot' 'secondSlot').
				'classVariables' -> #().
				'package' -> 'Gt4LlmCoreNewPackage'} asDictionary.
			{'className' -> classNames second.
				'superclassName' -> #Object.
				'instanceVariables' -> 'value'.
				'classVariables' -> #().
				'package' -> 'Gt4LlmCoreNewPackage'} asDictionary} asArray.
	call := GtLFunctionToolCall new.
	call
		function: {'name' -> tool name.
				'arguments' -> {'classes' -> sources} asDictionary} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: result isErrorDomainObject not.
	self assert: result classes size equals: 2.
	createdClasses := classNames
			collect: [ :each | Smalltalk globals at: each ifAbsent: [ nil ] ].
	self assert: (createdClasses allSatisfy: #notNil).
	self
		assert: (createdClasses first instanceVariables collect: #name)
				= #('firstSlot' 'secondSlot').
	self
		assert: (createdClasses second instanceVariables collect: #name) = #('value') ]
		ensure: [ classNames do: [ :each | self removeClassNamedIfPresent: each ] ].
	^ call
]

{ #category : #examples }
GtLToolForClassesCreationExamples >> createClassesWithMultipleResults [
	<gtExample>
	| tool call result className sources |
	[ tool := GtLToolForClassesCreation new.
	className := #GtLToolForClassesCreationExamplesGeneratedMultiple.
	self removeClassNamedIfPresent: className.
	sources := {{'className' -> className.
				'superclassName' -> #Object.
				'instanceVariables' -> ''.
				'classVariables' -> ''.
				'package' -> 'Gt4LlmCoreNewPackage'} asDictionary.
			{'className' -> #GtLToolForClassesCreationExamplesMissingSuperclass.
				'superclassName' -> 'ClassThatDoesNotExistForClassesCreation'.
				'instanceVariables' -> ''.
				'classVariables' -> ''.
				'package' -> 'Gt4LlmCoreNewPackage'} asDictionary} asArray.
	call := GtLFunctionToolCall new.
	call
		function: {'name' -> tool name.
				'arguments' -> {'classes' -> sources} asDictionary} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: result isErrorDomainObject not.
	self assert: result classes size equals: 2.
	self assert: result classes first isErrorDomainObject not.
	self assert: result classes second isErrorDomainObject.
	self assert: (Smalltalk globals includesKey: className) ]
		ensure: [ self removeClassNamedIfPresent: className ].
	^ call
]

{ #category : #examples }
GtLToolForClassesCreationExamples >> createClassesWithUnknownSuperclass [
	<gtExample>
	| tool call result className sources |
	[ tool := GtLToolForClassesCreation new.
	className := #GtLToolForClassesCreationExamplesUnknownSuperclass.
	self removeClassNamedIfPresent: className.
	sources := {{'className' -> className.
				'superclassName' -> 'ClassThatDoesNotExistForClassesCreation'.
				'instanceVariables' -> ''.
				'classVariables' -> ''.
				'package' -> 'Gt4LlmCoreNewPackage'} asDictionary} asArray.
	call := GtLFunctionToolCall new.
	call
		function: {'name' -> tool name.
				'arguments' -> {'classes' -> sources} asDictionary} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: result isErrorDomainObject not.
	self assert: result classes first isErrorDomainObject.
	self
		assert: result classes first objectName
		equals: 'ClassThatDoesNotExistForClassesCreation' ]
		ensure: [ self removeClassNamedIfPresent: className ].
	^ call
]

{ #category : #helpers }
GtLToolForClassesCreationExamples >> removeClassNamedIfPresent: aSymbol [
	Smalltalk globals
		at: aSymbol asSymbol
		ifPresent: [ :cls | cls removeFromSystem ]
]
