"
Examples for GtLMagritteToolForClassCreation.
"
Class {
	#name : #GtLMagritteToolForClassCreationExamples,
	#superclass : #Object,
	#category : 'Gt4LlmCore-Examples-Tools'
}

{ #category : #examples }
GtLMagritteToolForClassCreationExamples >> createClassThatAlreadyExists [
	<gtExample>
	| tool call result model |
	tool := GtLMagritteToolForClassCreation new.
	call := GtLFunctionToolCall new.
	call rawArguments: {
		'classCreationRequest' -> {
			'targetClassName' -> #Object.
			'superclassName' -> #Object.
			'package' -> 'Gt4LlmCoreNewPackage'
		} asDictionary
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GtLMagritteBasedModel).
	model := result model.
	self assert: (model isKindOf: GtLUnexpectedDomainObject).
	^ call
]

{ #category : #examples }
GtLMagritteToolForClassCreationExamples >> createClassWithComment [
	<gtExample>
	| tool call result model className createdClass comment |
	className := #GtLMagritteToolForClassCreationExamplesGeneratedWithComment.
	comment := 'Example class comment'.
	self removeClassNamedIfPresent: className.
	tool := GtLMagritteToolForClassCreation new.
	[
		call := GtLFunctionToolCall new.
		call rawArguments: {
			'classCreationRequest' -> {
				'targetClassName' -> className.
				'superclassName' -> #Object.
				'package' -> 'Gt4LlmCoreNewPackage'.
				'comment' -> comment
			} asDictionary
		} asDictionary.
		result := tool performToolCall: call.
		self assert: call tool == tool.
		self assert: (result isKindOf: GtLMagritteBasedModel).
		model := result model.
		self assert: (model isKindOf: GtLClassModificationResult).
		createdClass := Smalltalk globals at: className ifAbsent: [ nil ].
		self assert: createdClass notNil.
		self assert: createdClass comment equals: comment.
		self assert: model comment equals: comment
	] ensure: [
		self removeClassNamedIfPresent: className
	].
	^ call
]

{ #category : #examples }
GtLMagritteToolForClassCreationExamples >> createClassWithInstanceVariables [
	<gtExample>
	| tool call result model className createdClass |
	className := #GtLMagritteToolForClassCreationExamplesGenerated1.
	self removeClassNamedIfPresent: className.
	tool := GtLMagritteToolForClassCreation new.
	[
		call := GtLFunctionToolCall new.
		call rawArguments: {
			'classCreationRequest' -> {
				'targetClassName' -> className.
				'superclassName' -> #Object.
				'instanceVariables' -> 'firstSlot secondSlot'.
				'package' -> 'Gt4LlmCoreNewPackage'
			} asDictionary
		} asDictionary.
		result := tool performToolCall: call.
		self assert: call tool == tool.
		self assert: (result isKindOf: GtLMagritteBasedModel).
		model := result model.
		self assert: (model isKindOf: GtLClassModificationResult).
		createdClass := Smalltalk globals at: className ifAbsent: [ nil ].
		self assert: createdClass notNil.
		self assert: (createdClass instanceVariables collect: #name) equals: #('firstSlot' 'secondSlot').
		self assert: model currentClassName equals: className asString.
		self assert: model superclassName equals: 'Object'.
		self assert: model packageName equals: 'Gt4LlmCoreNewPackage'.
		self assert: model instanceSlotNames asArray equals: #('firstSlot' 'secondSlot')
	] ensure: [
		self removeClassNamedIfPresent: className
	].
	^ call
]

{ #category : #examples }
GtLMagritteToolForClassCreationExamples >> createClassWithMissingArguments [
	<gtExample>
	| tool call result model |
	tool := GtLMagritteToolForClassCreation new.
	call := GtLFunctionToolCall new.
	call rawArguments: Dictionary new.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GtLMagritteBasedModel).
	model := result model.
	self assert: (model isKindOf: GtLMissingRequiredPropertiesDomainObject).
	^ call
]

{ #category : #examples }
GtLMagritteToolForClassCreationExamples >> createClassWithUnknownSuperclass [
	<gtExample>
	| tool call result model |
	tool := GtLMagritteToolForClassCreation new.
	call := GtLFunctionToolCall new.
	call rawArguments: {
		'classCreationRequest' -> {
			'targetClassName' -> #GtLMagritteToolForClassCreationExamplesUnknownSuperclass.
			'superclassName' -> 'ClassThatDoesNotExistForClassCreation'.
			'package' -> 'Gt4LlmCoreNewPackage'
		} asDictionary
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GtLMagritteBasedModel).
	model := result model.
	self assert: (model isKindOf: GtLMissingDomainObject).
	^ call
]

{ #category : #private }
GtLMagritteToolForClassCreationExamples >> removeClassNamedIfPresent: aSymbol [
	Smalltalk globals
		at: aSymbol asSymbol
		ifPresent: [ :cls | cls removeFromSystem ]
]
