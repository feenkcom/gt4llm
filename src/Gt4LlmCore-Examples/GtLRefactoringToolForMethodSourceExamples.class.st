Class {
	#name : #GtLRefactoringToolForMethodSourceExamples,
	#superclass : #GtLAbstractPlainSchemaFunctionToolExamples,
	#category : #'Gt4LlmCore-Examples-Tools'
}

{ #category : #examples }
GtLRefactoringToolForMethodSourceExamples >> methodSourceForInstanceMethod [
	<gtExample>
	| tool call result |
	tool := self toolWithExampleMethods.
	call := GtLFunctionToolCall new.
	call rawArguments: {
		'className' -> 'GtLRefactoringMethodSourceExample'.
		'methodName' -> 'example'.
		'classSide' -> 'false'
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.

	self assert: result isErrorDomainObject not.
	self assert: result targetObject methodName equals: 'example'.
	self assert: result targetObject methodClassName equals: 'GtLRefactoringMethodSourceExample'.
	self
		assert: result targetObject methodSourceCode
		equals: ('example{1}{2}^ 42'
				format: {Character cr.
						Character tab}).

	^ call
]

{ #category : #examples }
GtLRefactoringToolForMethodSourceExamples >> methodSourceForUnknownMethod [
	<gtExample>
	| tool call result |
	tool := self toolWithExampleMethods.
	call := GtLFunctionToolCall new.
	call rawArguments: {
		'className' -> 'GtLRefactoringMethodSourceExample'.
		'methodName' -> 'missing'.
		'classSide' -> false
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.

	self assert: result isErrorDomainObject.
	^ call
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
