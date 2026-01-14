Class {
	#name : #GtLRefactoringToolForMethodSourceExamples,
	#superclass : #Object,
	#category : #'Gt4LlmCore-Examples-Tools'
}

{ #category : #'llm-generated' }
GtLRefactoringToolForMethodSourceExamples >> methodSourceForInstanceMethod [
	<gtExample>
	| tool call result |
	tool := self toolWithExampleMethods.
	call := GtLFunctionToolCall new.
	call function: {
		'name' -> tool name.
		'arguments' -> { 'className' -> 'GtLRefactoringMethodSourceExample'.
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
GtLRefactoringToolForMethodSourceExamples >> methodSourceForUnknownMethod [
	<gtExample>
	| tool call result |
	tool := self toolWithExampleMethods.
	call := GtLFunctionToolCall new.
	call function: {
		'name' -> tool name.
		'arguments' -> { 'className' -> 'GtLRefactoringMethodSourceExample'.
			'methodName' -> 'missing'.
			'classSide' -> false } asDictionary
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: result equals: 'Method not found'.
	^ tool
]

{ #category : #'llm-generated' }
GtLRefactoringToolForMethodSourceExamples >> toolWithExampleMethods [
	| namespace tool exampleClass |
	namespace := GtRBNamespace new.
	namespace defineClass: 'Object subclass: #GtLRefactoringMethodSourceExample
		instanceVariableNames: ''''''
		classVariableNames: ''''''
		package: ''DemoTest''' .
	exampleClass := namespace classNamed: 'GtLRefactoringMethodSourceExample'.
	exampleClass compile: 'example
	^ 42' classified: 'examples'.
	exampleClass classSide compile: 'classExample
	^ 21' classified: 'examples'.
	tool := GtLRefactoringToolForMethodSource new.
	tool model: namespace.
	^ tool
]
