Class {
	#name : #GtLRefactoringToolForClassSubclassesExamples,
	#superclass : #Object,
	#category : 'Gt4LlmCore-Examples-Tools'
}

{ #category : #examples }
GtLRefactoringToolForClassSubclassesExamples >> classSubclassesForClassWithNoSubclasses [
	<gtExample>
	| tool call result |
	tool := self toolWithExampleHierarchy.
	call := GtLFunctionToolCall new.
	call rawArguments: {'className' -> 'GtLRefactoringToolForClassSubclassesExampleChild'} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: result isErrorDomainObject not.
	self assert: result targetObject targetClass name equals: 'GtLRefactoringToolForClassSubclassesExampleChild'.
	self assert: result targetObject subclasses equals: #().
	^ call
]

{ #category : #examples }
GtLRefactoringToolForClassSubclassesExamples >> classSubclassesForExistingClass [
	<gtExample>
	| tool call result |
	tool := self toolWithExampleHierarchy.
	call := GtLFunctionToolCall new.
	call rawArguments: {'className' -> 'GtLRefactoringToolForClassSubclassesExampleBase'} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.

	self assert: result isErrorDomainObject not.
	self
		assert: result targetObject targetClass name
		equals: 'GtLRefactoringToolForClassSubclassesExampleBase'.
	self
		assert: (result targetObject subclasses collect: #name as: Array)
		equals: #('GtLRefactoringToolForClassSubclassesExampleChild').
	^ call
]

{ #category : #examples }
GtLRefactoringToolForClassSubclassesExamples >> classSubclassesForUnknownClass [
	<gtExample>
	| tool call result |
	tool := self toolWithExampleHierarchy.
	call := GtLFunctionToolCall new.
	call rawArguments: {'className' -> 'NonExistingClassName'} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	
	self assert: result isErrorDomainObject.
	^ call
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
