Class {
	#name : #GtLToolForClassCreationExamples,
	#superclass : #Object,
	#category : 'Gt4LlmCore-Examples-Tools'
}

{ #category : #examples }
GtLToolForClassCreationExamples >> createClassThatAlreadyExists [
	<gtExample>
	| tool call result className |
	className := #GtLToolForClassCreationExamplesExisting.
	self removeClassNamedIfPresent: className.
	Object
		subclass: className
		instanceVariableNames: ''
		classVariableNames: ''
		package: 'Gt4LlmCore-Examples'.
	[ tool := GtLToolForClassCreation new.
	call := GtLFunctionToolCall new.
	call
		function: {'name' -> tool name.
				'arguments'
					-> {'className' -> className.
							'superclassName' -> #Object.
							'instanceVariables' -> ''.
							'classVariables' -> ''.
							'package' -> 'Gt4LlmCore-Examples'} asDictionary} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: result isErrorDomainObject.
	self
		assert: result objectName
		equals: 'GtLToolForClassCreationExamplesExisting' ]
		ensure: [ self removeClassNamedIfPresent: className ].
	^ call
]

{ #category : #examples }
GtLToolForClassCreationExamples >> createClassWithClassVariables [
	<gtExample>
	| tool call result baseClassName subclassName baseClass subclass |
	baseClassName := #GtLToolForClassCreationExamplesBase.
	subclassName := #GtLToolForClassCreationExamplesGenerated2.
	self removeClassNamedIfPresent: subclassName.
	self removeClassNamedIfPresent: baseClassName.
	baseClass := Object
			subclass: baseClassName
			instanceVariableNames: ''
			classVariableNames: ''
			package: 'Gt4LlmCore-Examples'.
	[ tool := GtLToolForClassCreation new.
	call := GtLFunctionToolCall new.
	call
		function: {'name' -> tool name.
				'arguments'
					-> {'className' -> subclassName.
							'superclassName' -> baseClassName.
							'instanceVariables' -> 'value'.
							'classVariables' -> #('SharedCounter').
							'package' -> 'Gt4LlmCore-Examples'} asDictionary} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: result isErrorDomainObject not.
	self assert: result foundClass name equals: subclassName.
	subclass := Smalltalk globals at: subclassName ifAbsent: [ nil ].
	self assert: subclass notNil.
	self assert: subclass superclass == baseClass.
	self assert: (subclass classVariables collect: #name) = #('SharedCounter') ]
		ensure: [ self removeClassNamedIfPresent: subclassName.
			self removeClassNamedIfPresent: baseClassName ].
	^ call
]

{ #category : #examples }
GtLToolForClassCreationExamples >> createClassWithInstanceVariables [
	<gtExample>
	| tool call result className createdClass |
	className := #GtLToolForClassCreationExamplesGenerated1.
	self removeClassNamedIfPresent: className.
	tool := GtLToolForClassCreation new.
	[
		call := GtLFunctionToolCall new.
		call function: {
			'name' -> tool name.
			'arguments' -> {
				'className' -> className.
				'superclassName' -> #Object.
				'instanceVariables' -> #('firstSlot' 'secondSlot').
				'classVariables' -> #().
				'package' -> 'Gt4LlmCore-Examples'
			} asDictionary
		} asDictionary.
		result := tool performToolCall: call.
		self assert: call tool == tool.
		self assert: result isErrorDomainObject not.
		createdClass := Smalltalk globals at: className ifAbsent: [ nil ].
		self assert: createdClass notNil.
		self assert: (createdClass instanceVariables collect: #name) = #('firstSlot' 'secondSlot').
		self assert: result foundClass equals: createdClass
	] ensure: [
		self removeClassNamedIfPresent: className
	].
	^ call
]

{ #category : #examples }
GtLToolForClassCreationExamples >> createClassWithUnknownSuperclass [
	<gtExample>
	| tool call result |
	tool := GtLToolForClassCreation new.
	call := GtLFunctionToolCall new.
	call
		function: {'name' -> tool name.
				'arguments'
					-> {'className' -> #GtLToolForClassCreationExamplesUnknownSuperclass.
							'superclassName' -> 'ClassThatDoesNotExist'.
							'instanceVariables' -> ''.
							'classVariables' -> ''.
							'package' -> 'Gt4LlmCore-Examples'} asDictionary} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: result isErrorDomainObject.
	self assert: result objectName equals: 'ClassThatDoesNotExist'.
	^ call
]

{ #category : #private }
GtLToolForClassCreationExamples >> removeClassNamedIfPresent: aSymbol [
	Smalltalk globals
		at: aSymbol asSymbol
		ifPresent: [ :cls | cls removeFromSystem ]
]
