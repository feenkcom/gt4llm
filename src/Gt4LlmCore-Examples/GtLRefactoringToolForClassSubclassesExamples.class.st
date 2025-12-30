Class {
	#name : #GtLRefactoringToolForClassSubclassesExamples,
	#superclass : #Object,
	#category : #'Gt4LlmCore-Examples-Tools'
}

{ #category : #'llm-generated' }
GtLRefactoringToolForClassSubclassesExamples >> classSubclassesForClassWithNoSubclasses [
	<gtExample>
	| tool call result |
	tool := self toolWithExampleHierarchy.
	call := GtLlmFunctionToolCall new.
	call function: {
		'name' -> tool name.
		'arguments' -> {'className' -> 'GtLlmRefactoringToolForClassSubclassesExampleChild'} asDictionary
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: result equals: 'No subclasses found'.
	^ tool
]

{ #category : #'llm-generated' }
GtLRefactoringToolForClassSubclassesExamples >> classSubclassesForExistingClass [
	<gtExample>
	| tool call result |
	tool := self toolWithExampleHierarchy.
	call := GtLlmFunctionToolCall new.
	call function: {
		'name' -> tool name.
		'arguments' -> {'className' -> 'GtLlmRefactoringToolForClassSubclassesExampleBase'} asDictionary
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: result equals: 'GtLlmRefactoringToolForClassSubclassesExampleChild'.
	^ tool
]

{ #category : #'llm-generated' }
GtLRefactoringToolForClassSubclassesExamples >> classSubclassesForUnknownClass [
	<gtExample>
	| tool call result |
	tool := self toolWithExampleHierarchy.
	call := GtLlmFunctionToolCall new.
	call function: {
		'name' -> tool name.
		'arguments' -> {'className' -> 'NonExistingClassName'} asDictionary
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: result equals: 'Class not found'.
	^ tool
]

{ #category : #'llm-generated' }
GtLRefactoringToolForClassSubclassesExamples >> toolWithExampleHierarchy [
	| namespace tool |
	namespace := GtRBNamespace new.
	namespace defineClass: 'Object subclass: #GtLlmRefactoringToolForClassSubclassesExampleBase
		instanceVariableNames: ''''
		classVariableNames: ''''
		package: ''Gt4Llm-Refactoring-Examples''' .
	namespace defineClass: 'GtLlmRefactoringToolForClassSubclassesExampleBase subclass: #GtLlmRefactoringToolForClassSubclassesExampleChild
		instanceVariableNames: ''''
		classVariableNames: ''''
		package: ''Gt4Llm-Refactoring-Examples''' .
	tool := GtLlmRefactoringToolForClassSubclasses new.
	tool model: namespace.
	^ tool
]
