"
Examples for GtLMagritteToolForClassRemoval.
"
Class {
	#name : #GtLMagritteToolForClassRemovalExamples,
	#superclass : #Object,
	#category : #'Gt4LlmCore-Examples-Tools'
}

{ #category : #private }
GtLMagritteToolForClassRemovalExamples >> ensureClassNamed: aSymbol [
	self removeClassNamedIfPresent: aSymbol.
	^ Object
		subclass: aSymbol
		instanceVariableNames: ''
		classVariableNames: ''
		package: 'Gt4LlmCore-Examples'
]

{ #category : #examples }
GtLMagritteToolForClassRemovalExamples >> removeClassEmptyClassName [
	<gtExample>
	| tool call result model |
	tool := GtLMagritteToolForClassRemoval new.
	call := GtLFunctionToolCall new.
	call rawArguments: { 'className' -> '' } asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GtLMagritteBasedModel).
	model := result model.
	self assert: (model isKindOf: GtLMissingDomainObject).
	self assert: model objectName equals: ''.
	^ call
]

{ #category : #examples }
GtLMagritteToolForClassRemovalExamples >> removeClassMissingArgument [
	<gtExample>
	| tool call result model |
	tool := GtLMagritteToolForClassRemoval new.
	call := GtLFunctionToolCall new.
	call rawArguments: Dictionary new.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GtLMagritteBasedModel).
	model := result model.
	self assert: model class equals: GtLMissingRequiredPropertiesDomainObject.
	self assert: model missingPropertyNames equals: #('className').
	^ call
]

{ #category : #private }
GtLMagritteToolForClassRemovalExamples >> removeClassNamedIfPresent: aSymbol [
	Smalltalk globals
		at: aSymbol asSymbol
		ifPresent: [ :cls | cls removeFromSystem ]
]

{ #category : #examples }
GtLMagritteToolForClassRemovalExamples >> removeClassNilClassName [
	<gtExample>
	| tool call result model |
	tool := GtLMagritteToolForClassRemoval new.
	call := GtLFunctionToolCall new.
	call rawArguments: { 'className' -> nil } asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GtLMagritteBasedModel).
	model := result model.
	self assert: model class equals: GtLJSONSchemaValidationErrorDomainObject.
	self assert: model path asArray equals: #('className').
	self assert: model errorMessage equals: '@[className] string expected'.
	^ call
]

{ #category : #examples }
GtLMagritteToolForClassRemovalExamples >> removeExistingClass [
	<gtExample>
	| tool call result model className |
	className := #GtLMagritteToolForClassRemovalExamplesTemporary.
	[
		self ensureClassNamed: className.
		tool := GtLMagritteToolForClassRemoval new.
		call := GtLFunctionToolCall new.
		call rawArguments: { 'className' -> className asString } asDictionary.
		result := tool performToolCall: call.
		self assert: call tool == tool.
		self assert: (result isKindOf: GtLMagritteBasedModel).
		model := result model.
		self assert: (model isKindOf: GtLClassRemovalResult).
		self assert: model removedClassName equals: className asString.
		self assert: model status equals: 'removed'.
		self assert: (Smalltalk globals includesKey: className) not
	] ensure: [ self removeClassNamedIfPresent: className ].
	^ call
]

{ #category : #examples }
GtLMagritteToolForClassRemovalExamples >> removeUnknownClass [
	<gtExample>
	| tool call result model className |
	className := 'GtLMagritteToolForClassRemovalExamplesDoesNotExist'.
	tool := GtLMagritteToolForClassRemoval new.
	call := GtLFunctionToolCall new.
	call rawArguments: { 'className' -> className } asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GtLMagritteBasedModel).
	model := result model.
	self assert: (model isKindOf: GtLMissingDomainObject).
	self assert: model objectName equals: className.
	^ call
]
