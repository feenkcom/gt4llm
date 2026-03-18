"
Examples for GtLMagritteToolForMethodRemoval.
"
Class {
	#name : #GtLMagritteToolForMethodRemovalExamples,
	#superclass : #Object,
	#category : #'Gt4LlmCore-Examples-Tools'
}

{ #category : #private }
GtLMagritteToolForMethodRemovalExamples >> createSubjectClass [
	self removeClassNamedIfPresent: self subjectClassName.
	^ Object
		subclass: self subjectClassName
		instanceVariableNames: ''
		classVariableNames: ''
		package: 'Gt4LlmCore-Examples'
]

{ #category : #private }
GtLMagritteToolForMethodRemovalExamples >> removeClassNamedIfPresent: aSymbol [
	Smalltalk globals
		at: aSymbol asSymbol
		ifPresent: [ :cls | cls removeFromSystem ]
]

{ #category : #examples }
GtLMagritteToolForMethodRemovalExamples >> removeClassSideMethod [
	<gtExample>
	| tool call result model class methodSelector |
	[
		class := self createSubjectClass.
		methodSelector := #temporaryClassMethod.
		class class compile: 'temporaryClassMethod ^ 21'.
		tool := GtLMagritteToolForMethodRemoval new.
		call := GtLFunctionToolCall new.
		call rawArguments: {
			'methodDescriptor' -> {
				'methodClassName' -> class name asString.
				'methodName' -> methodSelector asString.
				'classSide' -> true
			} asDictionary
		} asDictionary.
		result := tool performToolCall: call.
		self assert: call tool == tool.
		self assert: (result isKindOf: GtLMagritteBasedModel).
		model := result model.
		self assert: (model isKindOf: GtLMethodRemovalResult).
		self assert: model status equals: 'removed'.
		self assert: model removedMethod methodName equals: methodSelector asString.
		self assert: model removedMethod isClassSide.
		self assert: (class class includesSelector: methodSelector) not
	] ensure: [ self removeClassNamedIfPresent: self subjectClassName ].
	^ call
]

{ #category : #examples }
GtLMagritteToolForMethodRemovalExamples >> removeInstanceMethod [
	<gtExample>
	| tool call result model class methodSelector |
	[
		class := self createSubjectClass.
		methodSelector := #temporaryInstanceMethod.
		class compile: 'temporaryInstanceMethod ^ 42'.
		tool := GtLMagritteToolForMethodRemoval new.
		call := GtLFunctionToolCall new.
		call rawArguments: {
			'methodDescriptor' -> {
				'methodClassName' -> class name asString.
				'methodName' -> methodSelector asString.
				'classSide' -> false
			} asDictionary
		} asDictionary.
		result := tool performToolCall: call.
		self assert: call tool == tool.
		self assert: (result isKindOf: GtLMagritteBasedModel).
		model := result model.
		self assert: (model isKindOf: GtLMethodRemovalResult).
		self assert: model status equals: 'removed'.
		self assert: model removedMethod methodName equals: methodSelector asString.
		self assert: model removedMethod methodClassName equals: class name asString.
		self assert: (class includesSelector: methodSelector) not
	] ensure: [ self removeClassNamedIfPresent: self subjectClassName ].
	^ call
]

{ #category : #examples }
GtLMagritteToolForMethodRemovalExamples >> removeMethodFromUnknownClass [
	<gtExample>
	| tool call result model |
	tool := GtLMagritteToolForMethodRemoval new.
	call := GtLFunctionToolCall new.
	call rawArguments: {
		'methodDescriptor' -> {
			'methodClassName' -> 'NonExistingClassName42'.
			'methodName' -> 'someMethod'.
			'classSide' -> false
		} asDictionary
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GtLMagritteBasedModel).
	model := result model.
	self assert: (model isKindOf: GtLMissingDomainObject).
	self assert: model objectName equals: 'NonExistingClassName42'.
	^ call
]

{ #category : #examples }
GtLMagritteToolForMethodRemovalExamples >> removeMethodMissingArgument [
	<gtExample>
	| tool call result model |
	tool := GtLMagritteToolForMethodRemoval new.
	call := GtLFunctionToolCall new.
	call rawArguments: Dictionary new.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GtLMagritteBasedModel).
	model := result model.
	self assert: model class equals: GtLMissingRequiredPropertiesDomainObject.
	self assert: model missingPropertyNames equals: #('methodDescriptor').
	^ call
]

{ #category : #examples }
GtLMagritteToolForMethodRemovalExamples >> removeUnknownMethod [
	<gtExample>
	| tool call result model class methodSelector expectedSignature |
	[
		class := self createSubjectClass.
		methodSelector := #methodThatDoesNotExist.
		tool := GtLMagritteToolForMethodRemoval new.
		call := GtLFunctionToolCall new.
		call rawArguments: {
			'methodDescriptor' -> {
				'methodClassName' -> class name asString.
				'methodName' -> methodSelector asString.
				'classSide' -> false
			} asDictionary
		} asDictionary.
		result := tool performToolCall: call.
		self assert: call tool == tool.
		self assert: (result isKindOf: GtLMagritteBasedModel).
		model := result model.
		self assert: (model isKindOf: GtLMissingDomainObject).
		expectedSignature := class name asString , '>>#' , methodSelector asString.
		self assert: model objectName equals: expectedSignature
	] ensure: [ self removeClassNamedIfPresent: self subjectClassName ].
	^ call
]

{ #category : #private }
GtLMagritteToolForMethodRemovalExamples >> subjectClassName [
	^ #GtLMagritteToolForMethodRemovalExamplesSubject
]
