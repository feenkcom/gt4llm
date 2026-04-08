"
Examples for GtLMagritteToolForMethodsCompilation.
"
Class {
	#name : #GtLMagritteToolForMethodsCompilationExamples,
	#superclass : #GtLAbstractMagritteFunctionToolExamples,
	#category : #'Gt4LlmCore-Examples-Tools'
}

{ #category : #examples }
GtLMagritteToolForMethodsCompilationExamples >> compileInstanceSideMethods [
	<gtExample>
	| call targetClass selectorOne selectorTwo |
	targetClass := GtLMagritteToolForMethodsCompilationExamples.
	selectorOne := #gtMagritteCompiledExampleInstanceOne.
	selectorTwo := #gtMagritteCompiledExampleInstanceTwo.
	(targetClass includesSelector: selectorOne)
		ifTrue: [ targetClass removeSelector: selectorOne ].
	(targetClass includesSelector: selectorTwo)
		ifTrue: [ targetClass removeSelector: selectorTwo ].
	[
		call := self
			executeTool: GtLMagritteToolForMethodsCompilation new
			withArguments: {
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
		self assert: (call result targetObject isKindOf: GtLMethodsCompilationResult).
		self assert: call result targetObject methods size equals: 2.
		self assert: (targetClass includesSelector: selectorOne).
		self assert: (targetClass includesSelector: selectorTwo).
		self assert: call result targetObject methods first status equals: 'compiled'.
		self assert: call result targetObject methods second status equals: 'compiled'.
		self assert: call result targetObject methods first oldMethod isNil.
		self assert: call result targetObject methods second oldMethod isNil.
		self assert: call result targetObject methods first newMethod sourceCode equals: 'gtMagritteCompiledExampleInstanceOne ^ 1'.
		self assert: call result targetObject methods second newMethod sourceCode equals: 'gtMagritteCompiledExampleInstanceTwo ^ 2'
	] ensure: [
		(targetClass includesSelector: selectorOne)
			ifTrue: [ targetClass removeSelector: selectorOne ].
		(targetClass includesSelector: selectorTwo)
			ifTrue: [ targetClass removeSelector: selectorTwo ] ].
	^ call
]

{ #category : #examples }
GtLMagritteToolForMethodsCompilationExamples >> compileInstanceSideMethodsWithExistingSources [
	<gtExample>
	| call targetClass selectorOne selectorTwo sourceBeforeOne sourceBeforeTwo |
	targetClass := GtLMagritteToolForMethodsCompilationExamples.
	selectorOne := #gtMagritteCompiledExampleExistingOne.
	selectorTwo := #gtMagritteCompiledExampleExistingTwo.
	sourceBeforeOne := 'gtMagritteCompiledExampleExistingOne ^ 10'.
	sourceBeforeTwo := 'gtMagritteCompiledExampleExistingTwo ^ 20'.
	targetClass compile: sourceBeforeOne classified: 'examples'.
	targetClass compile: sourceBeforeTwo classified: 'examples'.
	[
		call := self
			executeTool: GtLMagritteToolForMethodsCompilation new
			withArguments: {
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
		self assert: (call result targetObject isKindOf: GtLMethodsCompilationResult).
		self assert: call result targetObject methods size equals: 2.
		self assert: call result targetObject methods first oldMethod sourceCode equals: sourceBeforeOne.
		self assert: call result targetObject methods second oldMethod sourceCode equals: sourceBeforeTwo.
		self assert: call result targetObject methods first newMethod sourceCode equals: 'gtMagritteCompiledExampleExistingOne ^ 11'.
		self assert: call result targetObject methods second newMethod sourceCode equals: 'gtMagritteCompiledExampleExistingTwo ^ 21'
	] ensure: [
		(targetClass includesSelector: selectorOne)
			ifTrue: [ targetClass removeSelector: selectorOne ].
		(targetClass includesSelector: selectorTwo)
			ifTrue: [ targetClass removeSelector: selectorTwo ] ].
	^ call
]

{ #category : #examples }
GtLMagritteToolForMethodsCompilationExamples >> compileMethodsForUnknownClass [
	<gtExample>
	| call targetClass selector |
	targetClass := GtLMagritteToolForMethodsCompilationExamples.
	selector := #gtMagritteCompiledExampleKnown.
	[
		| targetObject |
		call := self
			executeTool: GtLMagritteToolForMethodsCompilation new
			withArguments: {
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
		targetObject := call result targetObject.
		self assert: (targetObject isKindOf: GtLMethodsCompilationResult).
		self assert: targetObject methods size equals: 2.
		self assert: (targetObject methods first isKindOf: GtLMissingDomainObject).
		self assert: targetObject methods first objectName equals: 'ClassThatDoesNotExist'.
		self assert: (targetObject methods second isKindOf: GtLMethodCompilationResult).
		self assert: targetObject methods second oldMethod isNil.
		self assert: targetObject methods second newMethod sourceCode equals: 'gtMagritteCompiledExampleKnown ^ 2'
	] ensure: [
		(targetClass includesSelector: selector)
			ifTrue: [ targetClass removeSelector: selector ] ].
	^ call
]

{ #category : #examples }
GtLMagritteToolForMethodsCompilationExamples >> compileMethodsMissingArgument [
	<gtExample>
	| call |
	call := self
		executeTool: GtLMagritteToolForMethodsCompilation new
		withArguments: Dictionary new.
	self 
		assertMissingRequiredProperties: call result targetObject 
		withPropertyNames: #('methods') 
		path: #(nil) 
		errorMessage: 'required properties missing [methods]'.
	^ call
]

{ #category : #examples }
GtLMagritteToolForMethodsCompilationExamples >> compileMethodsWithSyntaxError [
	<gtExample>
	| call targetClass selector |
	targetClass := GtLMagritteToolForMethodsCompilationExamples.
	selector := #gtMagritteCompiledExampleSyntaxOkay.
	(targetClass includesSelector: selector)
		ifTrue: [ targetClass removeSelector: selector ].
	[
		call := self
			executeTool: GtLMagritteToolForMethodsCompilation new
			withArguments: {
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
		self assert: (call result targetObject isKindOf: GtLMethodsCompilationResult).
		self assert: call result targetObject methods size equals: 2.
		self assert: (call result targetObject methods first isKindOf: GtLMethodCompilationExceptionDomainObject).
		self assert: (call result targetObject methods first description beginsWith: 'Syntax error').
		self assert: (call result targetObject methods second isKindOf: GtLMethodCompilationResult).
		self assert: (targetClass includesSelector: selector).
		self assert: call result targetObject methods second oldMethod isNil.
		self assert: call result targetObject methods second newMethod sourceCode equals: 'gtMagritteCompiledExampleSyntaxOkay ^ 3'
	] ensure: [
		(targetClass includesSelector: #gtMagritteCompiledExampleSyntaxError)
			ifTrue: [ targetClass removeSelector: #gtMagritteCompiledExampleSyntaxError ].
		(targetClass includesSelector: selector)
			ifTrue: [ targetClass removeSelector: selector ] ].
	^ call
]
