Class {
	#name : #GtLRefactoringToolForClassLookupExamples,
	#superclass : #GtLAbstractRefactoringMagritteToolExamples,
	#category : 'Gt4LlmCore-Examples-Tools'
}

{ #category : #examples }
GtLRefactoringToolForClassLookupExamples >> classLookupForExistingClass [
	<gtExample>
	| tool call targetObject |
	tool := self toolWithExampleClass.
	call := self
		executeTool: tool
		withArguments: {'targetClassName' -> 'GtLRefactoringToolForClassLookupExampleClass'} asDictionary.
	targetObject := call result targetObject.
	self assert: targetObject isErrorDomainObject not.
	self assert: targetObject targetClass name equals: 'GtLRefactoringToolForClassLookupExampleClass'.
	^ call
]

{ #category : #examples }
GtLRefactoringToolForClassLookupExamples >> classLookupForUnknownClass [
	<gtExample>
	| tool call |
	tool := self toolWithExampleClass.
	call := self
		executeTool: tool
		withArguments: {'targetClassName' -> 'NonExistentClass'} asDictionary.
	self assert: call result targetObject isErrorDomainObject.
	^ call
]

{ #category : #'examples - tools' }
GtLRefactoringToolForClassLookupExamples >> toolWithExampleClass [
	| namespace tool |
	namespace := GtRBNamespace new.
	namespace defineClass: 'Object subclass: #GtLRefactoringToolForClassLookupExampleClass
		instanceVariableNames: ''slot1''
		classVariableNames: ''''
		package: ''DemoTest'''.
	(namespace classNamed: 'GtLRefactoringToolForClassLookupExampleClass')
		compile: 'example ^ 42' classified: 'accessing'.
	tool := GtLRefactoringToolForClassLookup new.
	tool model: namespace.
	^ tool
]
