Class {
	#name : #GtLToolForMethodsCompilationExamples,
	#superclass : #Object,
	#category : #'Gt4LlmCore-Examples-Tools'
}

{ #category : #examples }
GtLToolForMethodsCompilationExamples >> compileInstanceSideMethods [
	<gtExample>
	| tool call result targetClass selectorOne selectorTwo sources |
	tool := GtLToolForMethodsCompilation new.
	targetClass := GtLToolForMethodsCompilationExamples.
	selectorOne := #gtCompiledExampleInstanceOne.
	selectorTwo := #gtCompiledExampleInstanceTwo.
	(targetClass includesSelector: selectorOne)
		ifTrue: [ targetClass removeSelector: selectorOne ].
	(targetClass includesSelector: selectorTwo)
		ifTrue: [ targetClass removeSelector: selectorTwo ].
	sources := {
		{'className' -> #GtLToolForMethodsCompilationExamples.
			'sourceCode' -> 'gtCompiledExampleInstanceOne ^ 1'.
			'protocol' -> 'examples'.
			'classSide' -> 'false'} asDictionary.
		{'className' -> #GtLToolForMethodsCompilationExamples.
			'sourceCode' -> 'gtCompiledExampleInstanceTwo ^ 2'.
			'protocol' -> 'examples'.
			'classSide' -> 'false'} asDictionary
	} asArray.
	[ call := GtLFunctionToolCall new.
	call function: {
		'name' -> tool name.
		'arguments' -> {'methods' -> sources} asDictionary
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: result isErrorDomainObject not.
	self assert: result methods size equals: 2.
	self assert: (targetClass includesSelector: selectorOne).
	self assert: (targetClass includesSelector: selectorTwo).
	self assert: result methods first isErrorDomainObject not.
	self assert: result methods second isErrorDomainObject not ]
		ensure: [
			(targetClass includesSelector: selectorOne)
				ifTrue: [ targetClass removeSelector: selectorOne ].
			(targetClass includesSelector: selectorTwo)
				ifTrue: [ targetClass removeSelector: selectorTwo ] ].
	^ call
]

{ #category : #examples }
GtLToolForMethodsCompilationExamples >> compileMethodsForUnknownClass [
	<gtExample>
	| tool call result sources |
	tool := GtLToolForMethodsCompilation new.
	sources := {
		{'className' -> #ClassThatDoesNotExist.
			'sourceCode' -> 'gtCompiledExampleUnknown ^ 1'.
			'protocol' -> 'examples'.
			'classSide' -> 'false'} asDictionary.
		{'className' -> #GtLToolForMethodsCompilationExamples.
			'sourceCode' -> 'gtCompiledExampleKnown ^ 2'.
			'protocol' -> 'examples'.
			'classSide' -> 'false'} asDictionary
	} asArray.
	[ call := GtLFunctionToolCall new.
	call function: {
		'name' -> tool name.
		'arguments' -> {'methods' -> sources} asDictionary
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: result isErrorDomainObject not.
	self assert: result methods size equals: 2.
	self assert: result methods first isErrorDomainObject.
	self assert: result methods first objectName equals: 'ClassThatDoesNotExist'.
	self assert: result methods second isErrorDomainObject not ]
		ensure: [
			(GtLToolForMethodsCompilationExamples includesSelector: #gtCompiledExampleKnown)
				ifTrue: [ GtLToolForMethodsCompilationExamples removeSelector: #gtCompiledExampleKnown ] ].
	^ call
]

{ #category : #examples }
GtLToolForMethodsCompilationExamples >> compileMethodsWithSyntaxError [
	<gtExample>
	| tool call result sources selector targetClass |
	tool := GtLToolForMethodsCompilation new.
	selector := #gtCompiledExampleSyntaxError.
	targetClass := GtLToolForMethodsCompilationExamples.
	(targetClass includesSelector: selector)
		ifTrue: [ targetClass removeSelector: selector ].
	sources := {
		{'className' -> #GtLToolForMethodsCompilationExamples.
			'sourceCode' -> 'gtCompiledExampleSyntaxError ^'.
			'protocol' -> 'examples'.
			'classSide' -> 'false'} asDictionary.
		{'className' -> #GtLToolForMethodsCompilationExamples.
			'sourceCode' -> 'gtCompiledExampleSyntaxOkay ^ 3'.
			'protocol' -> 'examples'.
			'classSide' -> 'false'} asDictionary
	} asArray.
	[ call := GtLFunctionToolCall new.
	call function: {
		'name' -> tool name.
		'arguments' -> {'methods' -> sources} asDictionary
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: result isErrorDomainObject not.
	self assert: result methods size equals: 2.
	self assert: result methods first isErrorDomainObject.
	self assert: (result methods first description beginsWith: 'Syntax error').
	self assert: result methods second isErrorDomainObject not.
	self assert: (targetClass includesSelector: #gtCompiledExampleSyntaxOkay) ]
		ensure: [
			(targetClass includesSelector: selector)
				ifTrue: [ targetClass removeSelector: selector ].
			(targetClass includesSelector: #gtCompiledExampleSyntaxOkay)
				ifTrue: [ targetClass removeSelector: #gtCompiledExampleSyntaxOkay ] ].
	^ call
]
