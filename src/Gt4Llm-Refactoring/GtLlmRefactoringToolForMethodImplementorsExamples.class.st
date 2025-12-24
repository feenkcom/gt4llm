Class {
	#name : #GtLlmRefactoringToolForMethodImplementorsExamples,
	#superclass : #Object,
	#category : #'Gt4Llm-Refactoring-Ex'
}

{ #category : #'llm-generated' }
GtLlmRefactoringToolForMethodImplementorsExamples >> methodImplementorsForExistingSelector [
	<gtExample>
	| tool call result |
	tool := self toolWithExampleHierarchy.
	call := GtLlmFunctionToolCall new.
	call function: {
		'name' -> tool name.
		'arguments' -> {'methodName' -> 'example'} asDictionary
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result includesSubstring: 'GtLlmRefactoringMethodImplementorsBase').
	self assert: (result includesSubstring: 'GtLlmRefactoringMethodImplementorsChild').
	^ tool
]

{ #category : #'llm-generated' }
GtLlmRefactoringToolForMethodImplementorsExamples >> methodImplementorsForUnknownSelector [
	<gtExample>
	| tool call result |
	tool := self toolWithExampleHierarchy.
	call := GtLlmFunctionToolCall new.
	call function: {
		'name' -> tool name.
		'arguments' -> {'methodName' -> 'missingSelector'} asDictionary
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: result equals: 'No implementors found'.
	^ tool
]

{ #category : #'llm-generated' }
GtLlmRefactoringToolForMethodImplementorsExamples >> toolWithExampleHierarchy [
	| namespace tool baseClass childClass |
	namespace := GtRBNamespace new.
	namespace defineClass: 'Object subclass: #GtLlmRefactoringMethodImplementorsBase
		instanceVariableNames: ''''''
		classVariableNames: ''''''
		package: ''Gt4Llm-Refactoring-Examples''' .
	namespace defineClass: 'GtLlmRefactoringMethodImplementorsBase subclass: #GtLlmRefactoringMethodImplementorsChild
		instanceVariableNames: ''''''
		classVariableNames: ''''''
		package: ''Gt4Llm-Refactoring-Examples''' .
	baseClass := namespace classNamed: 'GtLlmRefactoringMethodImplementorsBase'.
	childClass := namespace classNamed: 'GtLlmRefactoringMethodImplementorsChild'.
	baseClass compile: 'example
	^ 1' classified: 'examples'.
	childClass compile: 'example
	^ super example + 1' classified: 'examples'.
	tool := GtLlmRefactoringToolForMethodImplementors new.
	tool model: namespace.
	^ tool
]
