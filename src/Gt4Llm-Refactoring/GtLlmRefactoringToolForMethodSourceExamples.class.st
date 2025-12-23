Class {
	#name : #GtLlmRefactoringToolForMethodSourceExamples,
	#superclass : #Object,
	#category : #'Gt4Llm-Refactoring-Ex'
}

{ #category : #'llm-generated' }
GtLlmRefactoringToolForMethodSourceExamples >> methodSourceForInstanceMethod [
	<gtExample>
	| tool call result |
	tool := self toolWithExampleMethods.
	call := GtLlmFunctionToolCall new.
	call function: {
		'name' -> tool name.
		'arguments' -> { 'className' -> 'GtLlmRefactoringMethodSourceExample'.
			'methodName' -> 'example'.
			'classSide' -> 'false' } asDictionary
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: result equals: 'example
	^ 42'.
	^ tool
]

{ #category : #'llm-generated' }
GtLlmRefactoringToolForMethodSourceExamples >> methodSourceForUnknownMethod [
	<gtExample>
	| tool call result |
	tool := self toolWithExampleMethods.
	call := GtLlmFunctionToolCall new.
	call function: {
		'name' -> tool name.
		'arguments' -> { 'className' -> 'GtLlmRefactoringMethodSourceExample'.
			'methodName' -> 'missing'.
			'classSide' -> false } asDictionary
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: result equals: 'Method not found'.
	^ tool
]

{ #category : #'llm-generated' }
GtLlmRefactoringToolForMethodSourceExamples >> toolWithExampleMethods [
	| namespace tool exampleClass |
	namespace := GtRBNamespace new.
	namespace defineClass: 'Object subclass: #GtLlmRefactoringMethodSourceExample
		instanceVariableNames: ''''''
		classVariableNames: ''''''
		package: ''Gt4Llm-Refactoring-Examples''' .
	exampleClass := namespace classNamed: 'GtLlmRefactoringMethodSourceExample'.
	exampleClass compile: 'example
	^ 42' classified: 'examples'.
	exampleClass classSide compile: 'classExample
	^ 21' classified: 'examples'.
	tool := GtLlmRefactoringToolForMethodSource new.
	tool model: namespace.
	^ tool
]
