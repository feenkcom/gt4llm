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
	call := GtLFunctionToolCall new.
	call function: {
		'name' -> tool name.
		'arguments' -> {'className' -> 'GtLRefactoringToolForClassSubclassesExampleChild'} asDictionary
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
	call := GtLFunctionToolCall new.
	call function: {
		'name' -> tool name.
		'arguments' -> {'className' -> 'GtLRefactoringToolForClassSubclassesExampleBase'} asDictionary
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: result equals: 'GtLRefactoringToolForClassSubclassesExampleChild'.
	^ tool
]

{ #category : #'llm-generated' }
GtLRefactoringToolForClassSubclassesExamples >> classSubclassesForUnknownClass [
	<gtExample>
	| tool call result |
	tool := self toolWithExampleHierarchy.
	call := GtLFunctionToolCall new.
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
	namespace defineClass: 'Object subclass: #GtLRefactoringToolForClassSubclassesExampleBase
		instanceVariableNames: ''''
		classVariableNames: ''''
		package: ''Demo''' .
	namespace defineClass: 'GtLRefactoringToolForClassSubclassesExampleBase subclass: #GtLRefactoringToolForClassSubclassesExampleChild
		instanceVariableNames: ''''
		classVariableNames: ''''
		package: ''Demo''' .
	tool := GtLRefactoringToolForClassSubclasses new.
	tool model: namespace.
	^ tool
]
