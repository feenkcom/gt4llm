Class {
	#name : #GtLRefactoringToolForClassSubclassesExamples,
	#superclass : #GtLAbstractRefactoringMagritteToolExamples,
	#category : 'Gt4LlmCore-Examples-Tools'
}

{ #category : #examples }
GtLRefactoringToolForClassSubclassesExamples >> classSubclassesForClassWithNoSubclasses [
	<gtExample>
	| tool call targetObject |
	tool := self toolWithExampleHierarchy.
	call := self
		executeTool: tool
		withArguments: {'targetClassName' -> 'GtLRefactoringToolForClassSubclassesExampleChild'} asDictionary.
	targetObject := call result targetObject.
	self assert: targetObject isErrorDomainObject not.
	self assert: targetObject targetClass name equals: 'GtLRefactoringToolForClassSubclassesExampleChild'.
	self assert: targetObject subclasses equals: #().
	^ call
]

{ #category : #examples }
GtLRefactoringToolForClassSubclassesExamples >> classSubclassesForExistingClass [
	<gtExample>
	| tool call targetObject |
	tool := self toolWithExampleHierarchy.
	call := self
		executeTool: tool
		withArguments: {'targetClassName' -> 'GtLRefactoringToolForClassSubclassesExampleBase'} asDictionary.
	targetObject := call result targetObject.
	self assert: targetObject isErrorDomainObject not.
	self
		assert: targetObject targetClass name
		equals: 'GtLRefactoringToolForClassSubclassesExampleBase'.
	self
		assert: (targetObject subclasses collect: #name as: Array)
		equals: #('GtLRefactoringToolForClassSubclassesExampleChild').
	^ call
]

{ #category : #examples }
GtLRefactoringToolForClassSubclassesExamples >> classSubclassesForUnknownClass [
	<gtExample>
	| tool call |
	tool := self toolWithExampleHierarchy.
	call := self
		executeTool: tool
		withArguments: {'targetClassName' -> 'NonExistingClassName'} asDictionary.
	self assert: call result targetObject isErrorDomainObject.
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
