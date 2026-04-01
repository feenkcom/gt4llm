"
Examples for GtLMagritteToolForMethodsCompilation.
"
Class {
	#name : #GtLMagritteToolForMethodsCompilationExamples,
	#superclass : #Object,
	#traits : 'TGtLInvalidInputDataAssertions',
	#classTraits : 'TGtLInvalidInputDataAssertions classTrait',
	#category : 'Gt4LlmCore-Examples-Tools'
}

{ #category : #examples }
GtLMagritteToolForMethodsCompilationExamples >> compileInstanceSideMethods [
	<gtExample>
	| tool call result domainObject targetClass selectorOne selectorTwo |
	tool := GtLMagritteToolForMethodsCompilation new.
	targetClass := GtLMagritteToolForMethodsCompilationExamples.
	selectorOne := #gtMagritteCompiledExampleInstanceOne.
	selectorTwo := #gtMagritteCompiledExampleInstanceTwo.
	(targetClass includesSelector: selectorOne)
		ifTrue: [ targetClass removeSelector: selectorOne ].
	(targetClass includesSelector: selectorTwo)
		ifTrue: [ targetClass removeSelector: selectorTwo ].
	[
		call := GtLFunctionToolCall new.
		call rawArguments: {
			'methods' -> {
				{
					'methodClassName' -> 'GtLMagritteToolForMethodsCompilationExamples'.
					'sourceCode' -> 'gtMagritteCompiledExampleInstanceOne ^ 1'.
					'protocol' -> 'examples'.
					'classSide' -> false
				} asDictionary.
				{
					'methodClassName' -> 'GtLMagritteToolForMethodsCompilationExamples'.
					'sourceCode' -> 'gtMagritteCompiledExampleInstanceTwo ^ 2'.
					'protocol' -> 'examples'.
					'classSide' -> false
				} asDictionary
			}
		} asDictionary.
		result := tool performToolCall: call.
		self assert: call tool == tool.
		self assert: (result isKindOf: GTLDataViewWrapperModel).
		domainObject := result targetObject.
		self assert: (domainObject isKindOf: GtLMethodsCompilationResult).
		self assert: domainObject methods size equals: 2.
		self assert: (targetClass includesSelector: selectorOne).
		self assert: (targetClass includesSelector: selectorTwo).
		self assert: domainObject methods first status equals: 'compiled'.
		self assert: domainObject methods second status equals: 'compiled'.
		self assert: domainObject methods first oldMethod isNil.
		self assert: domainObject methods second oldMethod isNil.
		self assert: domainObject methods first newMethod sourceCode equals: 'gtMagritteCompiledExampleInstanceOne ^ 1'.
		self assert: domainObject methods second newMethod sourceCode equals: 'gtMagritteCompiledExampleInstanceTwo ^ 2'
	] ensure: [
		(targetClass includesSelector: selectorOne)
			ifTrue: [ targetClass removeSelector: selectorOne ].
		(targetClass includesSelector: selectorTwo)
			ifTrue: [ targetClass removeSelector: selectorTwo ] ].
	^ domainObject
]

{ #category : #examples }
GtLMagritteToolForMethodsCompilationExamples >> compileInstanceSideMethodsWithExistingSources [
	<gtExample>
	| tool call result domainObject targetClass selectorOne selectorTwo sourceBeforeOne sourceBeforeTwo |
	tool := GtLMagritteToolForMethodsCompilation new.
	targetClass := GtLMagritteToolForMethodsCompilationExamples.
	selectorOne := #gtMagritteCompiledExampleExistingOne.
	selectorTwo := #gtMagritteCompiledExampleExistingTwo.
	sourceBeforeOne := 'gtMagritteCompiledExampleExistingOne ^ 10'.
	sourceBeforeTwo := 'gtMagritteCompiledExampleExistingTwo ^ 20'.
	targetClass compile: sourceBeforeOne classified: 'examples'.
	targetClass compile: sourceBeforeTwo classified: 'examples'.
	[
		call := GtLFunctionToolCall new.
		call rawArguments: {
			'methods' -> {
				{
					'methodClassName' -> 'GtLMagritteToolForMethodsCompilationExamples'.
					'sourceCode' -> 'gtMagritteCompiledExampleExistingOne ^ 11'.
					'protocol' -> 'examples'.
					'classSide' -> false
				} asDictionary.
				{
					'methodClassName' -> 'GtLMagritteToolForMethodsCompilationExamples'.
					'sourceCode' -> 'gtMagritteCompiledExampleExistingTwo ^ 21'.
					'protocol' -> 'examples'.
					'classSide' -> false
				} asDictionary
			}
		} asDictionary.
		result := tool performToolCall: call.
		self assert: call tool == tool.
		self assert: (result isKindOf: GTLDataViewWrapperModel).
		domainObject := result targetObject.
		self assert: (domainObject isKindOf: GtLMethodsCompilationResult).
		self assert: domainObject methods size equals: 2.
		self assert: domainObject methods first oldMethod sourceCode equals: sourceBeforeOne.
		self assert: domainObject methods second oldMethod sourceCode equals: sourceBeforeTwo.
		self assert: domainObject methods first newMethod sourceCode equals: 'gtMagritteCompiledExampleExistingOne ^ 11'.
		self assert: domainObject methods second newMethod sourceCode equals: 'gtMagritteCompiledExampleExistingTwo ^ 21'
	] ensure: [
		(targetClass includesSelector: selectorOne)
			ifTrue: [ targetClass removeSelector: selectorOne ].
		(targetClass includesSelector: selectorTwo)
			ifTrue: [ targetClass removeSelector: selectorTwo ] ].
	^ domainObject
]

{ #category : #'examples - error conditions' }
GtLMagritteToolForMethodsCompilationExamples >> compileMethodsForUnknownClass [
	<gtExample>
	| tool call result domainObject targetClass selector |
	tool := GtLMagritteToolForMethodsCompilation new.
	targetClass := GtLMagritteToolForMethodsCompilationExamples.
	selector := #gtMagritteCompiledExampleKnown.
	[
		call := GtLFunctionToolCall new.
		call rawArguments: {
			'methods' -> {
				{
					'methodClassName' -> 'ClassThatDoesNotExist'.
					'sourceCode' -> 'gtMagritteCompiledExampleUnknown ^ 1'.
					'protocol' -> 'examples'.
					'classSide' -> false
				} asDictionary.
				{
					'methodClassName' -> 'GtLMagritteToolForMethodsCompilationExamples'.
					'sourceCode' -> 'gtMagritteCompiledExampleKnown ^ 2'.
					'protocol' -> 'examples'.
					'classSide' -> false
				} asDictionary
			}
		} asDictionary.
		result := tool performToolCall: call.
		self assert: call tool == tool.
		self assert: (result isKindOf: GTLDataViewWrapperModel).
		domainObject := result targetObject.
		self assert: (domainObject isKindOf: GtLMethodsCompilationResult).
		self assert: domainObject methods size equals: 2.
		self assert: (domainObject methods first isKindOf: GtLMissingDomainObject).
		self assert: domainObject methods first objectName equals: 'ClassThatDoesNotExist'.
		self assert: (domainObject methods second isKindOf: GtLMethodCompilationResult).
		self assert: domainObject methods second oldMethod isNil.
		self assert: domainObject methods second newMethod sourceCode equals: 'gtMagritteCompiledExampleKnown ^ 2'
	] ensure: [
		(targetClass includesSelector: selector)
			ifTrue: [ targetClass removeSelector: selector ] ].
	^ domainObject
]

{ #category : #'examples - error conditions' }
GtLMagritteToolForMethodsCompilationExamples >> compileMethodsMissingArgument [
	<gtExample>
	| tool call result domainObject |
	tool := GtLMagritteToolForMethodsCompilation new.
	call := GtLFunctionToolCall new.
	call rawArguments: Dictionary new.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	domainObject := result targetObject.
	self 
		assertMissingRequiredProperties: domainObject 
		withPropertyNames: #('methods') 
		path: #(nil) 
		errorMessage: 'required properties missing [methods]'.
	^ domainObject
]

{ #category : #'examples - error conditions' }
GtLMagritteToolForMethodsCompilationExamples >> compileMethodsWithSyntaxError [
	<gtExample>
	| tool call result domainObject targetClass selector |
	tool := GtLMagritteToolForMethodsCompilation new.
	targetClass := GtLMagritteToolForMethodsCompilationExamples.
	selector := #gtMagritteCompiledExampleSyntaxOkay.
	(targetClass includesSelector: selector)
		ifTrue: [ targetClass removeSelector: selector ].
	[
		call := GtLFunctionToolCall new.
		call rawArguments: {
			'methods' -> {
				{
					'methodClassName' -> 'GtLMagritteToolForMethodsCompilationExamples'.
					'sourceCode' -> 'gtMagritteCompiledExampleSyntaxError ^'.
					'protocol' -> 'examples'.
					'classSide' -> false
				} asDictionary.
				{
					'methodClassName' -> 'GtLMagritteToolForMethodsCompilationExamples'.
					'sourceCode' -> 'gtMagritteCompiledExampleSyntaxOkay ^ 3'.
					'protocol' -> 'examples'.
					'classSide' -> false
				} asDictionary
			}
		} asDictionary.
		result := tool performToolCall: call.
		self assert: call tool == tool.
		self assert: (result isKindOf: GTLDataViewWrapperModel).
		domainObject := result targetObject.
		self assert: (domainObject isKindOf: GtLMethodsCompilationResult).
		self assert: domainObject methods size equals: 2.
		self assert: (domainObject methods first isKindOf: GtLMethodCompilationExceptionDomainObject).
		self assert: (domainObject methods first description beginsWith: 'Syntax error').
		self assert: (domainObject methods second isKindOf: GtLMethodCompilationResult).
		self assert: (targetClass includesSelector: selector).
		self assert: domainObject methods second oldMethod isNil.
		self assert: domainObject methods second newMethod sourceCode equals: 'gtMagritteCompiledExampleSyntaxOkay ^ 3'
	] ensure: [
		(targetClass includesSelector: #gtMagritteCompiledExampleSyntaxError)
			ifTrue: [ targetClass removeSelector: #gtMagritteCompiledExampleSyntaxError ].
		(targetClass includesSelector: selector)
			ifTrue: [ targetClass removeSelector: selector ] ].
	^ domainObject
]
