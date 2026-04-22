Class {
	#name : #GtLRefactoringToolForMethodSourceExamples,
	#superclass : #GtLAbstractRefactoringMagritteToolExamples,
	#category : #'Gt4LlmCore-Examples-Tools'
}

{ #category : #examples }
GtLRefactoringToolForMethodSourceExamples >> methodSourceForInstanceMethod [
	<gtExample>
	| tool call targetObject |
	tool := self toolWithExampleMethods.
	call := self
		executeTool: tool
		withArguments: {
			'methodReference' -> {
				'methodClassName' -> 'GtLRefactoringMethodSourceExample'.
				'methodName' -> 'example'.
				'classSide' -> false
			} asDictionary
		} asDictionary.
	targetObject := call result targetObject.
	self assert: targetObject isErrorDomainObject not.
	self assert: targetObject methodName equals: 'example'.
	self assert: targetObject methodClassName equals: 'GtLRefactoringMethodSourceExample'.
	self
		assert: targetObject methodSourceCode
		equals: ('example{1}{2}^ 42'
				format: {Character cr.
						Character tab}).
	^ call
]

{ #category : #examples }
GtLRefactoringToolForMethodSourceExamples >> methodSourceForUnknownMethod [
	<gtExample>
	| tool call |
	tool := self toolWithExampleMethods.
	call := self
		executeTool: tool
		withArguments: {
			'methodReference' -> {
				'methodClassName' -> 'GtLRefactoringMethodSourceExample'.
				'methodName' -> 'missing'.
				'classSide' -> false
			} asDictionary
		} asDictionary.
	self assert: call result targetObject isErrorDomainObject.
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
