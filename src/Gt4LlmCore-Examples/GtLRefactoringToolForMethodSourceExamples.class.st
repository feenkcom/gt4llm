Class {
	#name : #GtLRefactoringToolForMethodSourceExamples,
	#superclass : #Object,
	#category : 'Gt4LlmCore-Examples-Tools'
}

{ #category : #'llm-generated' }
GtLRefactoringToolForMethodSourceExamples >> methodSourceForInstanceMethod [
	<gtExample>
	| tool call result |
	tool := self toolWithExampleMethods.
	call := GtLFunctionToolCall new.
	call
		function: {'name' -> tool name.
				'arguments'
					-> {'className' -> 'GtLRefactoringMethodSourceExample'.
							'methodName' -> 'example'.
							'classSide' -> 'false'} asDictionary} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.

	self assert: result isErrorDomainObject not.
	self assert: result methodName equals: 'example'.
	self assert: result methodClassName equals: 'GtLRefactoringMethodSourceExample'.
	self
		assert: result methodSourceCode
		equals: ('example{1}{2}^ 42'
				format: {Character cr.
						Character tab}).

	^ call
]

{ #category : #'llm-generated' }
GtLRefactoringToolForMethodSourceExamples >> methodSourceForUnknownMethod [
	<gtExample>
	| tool call result |
	tool := self toolWithExampleMethods.
	call := GtLFunctionToolCall new.
	call
		function: {'name' -> tool name.
				'arguments'
					-> {'className' -> 'GtLRefactoringMethodSourceExample'.
							'methodName' -> 'missing'.
							'classSide' -> false} asDictionary} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.

	self assert: result isErrorDomainObject.
	self
		assert: result objectName
		equals: 'GtLRefactoringMethodSourceExample>>#missing'.
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
