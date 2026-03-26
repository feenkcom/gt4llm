"
Examples for GtLMagritteToolForMethodCompilation.
"
Class {
	#name : #GtLMagritteToolForMethodCompilationExamples,
	#superclass : #Object,
	#category : 'Gt4LlmCore-Examples-Tools'
}

{ #category : #examples }
GtLMagritteToolForMethodCompilationExamples >> compileClassSideMethod [
	<gtExample>
	| tool call result model selector targetClass metaClass source |
	selector := #gtMagritteCompiledExampleClassSideMethod.
	targetClass := GtLMagritteToolForMethodCompilationExamples.
	metaClass := targetClass class.
	source := 'gtMagritteCompiledExampleClassSideMethod ^ ''class'''.
	tool := GtLMagritteToolForMethodCompilation new.
	(metaClass includesSelector: selector)
		ifTrue: [ metaClass removeSelector: selector ].
	[
		call := GtLFunctionToolCall new.
		call rawArguments: {
			'methodRequest' -> {
				'methodClassName' -> targetClass name asString.
				'sourceCode' -> source.
				'protocol' -> 'examples'.
				'classSide' -> true
			} asDictionary
		} asDictionary.
		result := tool performToolCall: call.
		self assert: call tool == tool.
		self assert: (result isKindOf: GtLMagritteBasedModel).
		model := result model.
		self assert: (model isKindOf: GtLMethodCompilationResult).
		self assert: model status equals: 'compiled'.
		self assert: (metaClass includesSelector: selector).
		self assert: model newMethod isClassSide.
		self assert: model oldMethod isNil
	] ensure: [
		(metaClass includesSelector: selector)
			ifTrue: [ metaClass removeSelector: selector ] ].
	^ call
]

{ #category : #examples }
GtLMagritteToolForMethodCompilationExamples >> compileInstanceSideMethod [
	<gtExample>
	| tool call result model selector targetClass source |
	selector := #gtMagritteCompiledExampleInstanceMethod.
	targetClass := GtLMagritteToolForMethodCompilationExamples.
	source := 'gtMagritteCompiledExampleInstanceMethod ^ 42'.
	tool := GtLMagritteToolForMethodCompilation new.
	(targetClass includesSelector: selector)
		ifTrue: [ targetClass removeSelector: selector ].
	[
		call := GtLFunctionToolCall new.
		call rawArguments: {
			'methodRequest' -> {
				'methodClassName' -> targetClass name asString.
				'sourceCode' -> source.
				'protocol' -> 'examples'.
				'classSide' -> false
			} asDictionary
		} asDictionary.
		result := tool performToolCall: call.
		self assert: call tool == tool.
		self assert: (result isKindOf: GtLMagritteBasedModel).
		model := result model.
		self assert: (model isKindOf: GtLMethodCompilationResult).
		self assert: model status equals: 'compiled'.
		self assert: (targetClass includesSelector: selector).
		self assert: model newMethod methodName equals: selector asString.
		self assert: model oldMethod isNil
	] ensure: [
		(targetClass includesSelector: selector)
			ifTrue: [ targetClass removeSelector: selector ] ].
	^ call
]

{ #category : #examples }
GtLMagritteToolForMethodCompilationExamples >> compileMethodForUnknownClass [
	<gtExample>
	| tool call result model |
	tool := GtLMagritteToolForMethodCompilation new.
	call := GtLFunctionToolCall new.
	call rawArguments: {
		'methodRequest' -> {
			'methodClassName' -> 'ClassThatDoesNotExist'.
			'sourceCode' -> 'someMethod ^ 1'.
			'protocol' -> 'examples'.
			'classSide' -> false
		} asDictionary
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GtLMagritteBasedModel).
	model := result model.
	self assert: (model isKindOf: GtLMissingDomainObject).
	self assert: model objectName equals: 'ClassThatDoesNotExist'.
	^ call
]

{ #category : #examples }
GtLMagritteToolForMethodCompilationExamples >> compileMethodMissingArgument [
	<gtExample>
	| tool call result model |
	tool := GtLMagritteToolForMethodCompilation new.
	call := GtLFunctionToolCall new.
	call rawArguments: Dictionary new.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GtLMagritteBasedModel).
	model := result model.
	self assert: model class equals: GtLMissingRequiredPropertiesDomainObject.
	self assert: model missingPropertyNames equals: #('methodRequest').
	^ call
]

{ #category : #examples }
GtLMagritteToolForMethodCompilationExamples >> compileMethodWithExistingSource [
	<gtExample>
	| tool call result model selector targetClass sourceBefore sourceAfter |
	selector := #gtMagritteCompiledExampleExisting.
	targetClass := GtLMagritteToolForMethodCompilationExamples.
	sourceBefore := 'gtMagritteCompiledExampleExisting ^ 1'.
	sourceAfter := 'gtMagritteCompiledExampleExisting ^ 2'.
	targetClass compile: sourceBefore classified: 'examples'.
	tool := GtLMagritteToolForMethodCompilation new.
	[
		call := GtLFunctionToolCall new.
		call rawArguments: {
			'methodRequest' -> {
				'methodClassName' -> targetClass name asString.
				'sourceCode' -> sourceAfter.
				'protocol' -> 'examples'.
				'classSide' -> false
			} asDictionary
		} asDictionary.
		result := tool performToolCall: call.
		self assert: call tool == tool.
		self assert: (result isKindOf: GtLMagritteBasedModel).
		model := result model.
		self assert: (model isKindOf: GtLMethodCompilationResult).
		self assert: model status equals: 'compiled'.
		self assert: model oldMethod sourceCode equals: sourceBefore.
		self assert: model newMethod sourceCode equals: sourceAfter
	] ensure: [
		(targetClass includesSelector: selector)
			ifTrue: [ targetClass removeSelector: selector ] ].
	^ call
]

{ #category : #examples }
GtLMagritteToolForMethodCompilationExamples >> compileMethodWithSyntaxError [
	<gtExample>
	| tool call result model selector targetClass |
	targetClass := GtLMagritteToolForMethodCompilationExamples.
	selector := #gtMagritteCompiledExampleWithSyntaxError.
	tool := GtLMagritteToolForMethodCompilation new.
	(targetClass includesSelector: selector)
		ifTrue: [ targetClass removeSelector: selector ].
	[
		call := GtLFunctionToolCall new.
		call rawArguments: {
			'methodRequest' -> {
				'methodClassName' -> targetClass name asString.
				'sourceCode' -> 'gtMagritteCompiledExampleWithSyntaxError ^'.
				'protocol' -> 'examples'.
				'classSide' -> false
			} asDictionary
		} asDictionary.
		result := tool performToolCall: call.
		self assert: call tool == tool.
		self assert: (result isKindOf: GtLMethodCompilationExceptionDomainObject).
		model := result.
		self assert: model isErrorDomainObject.
		self assert: (model description beginsWith: 'Syntax error').
		self assert: (targetClass includesSelector: selector) not
	] ensure: [
		(targetClass includesSelector: selector)
			ifTrue: [ targetClass removeSelector: selector ] ].
	^ call
]
