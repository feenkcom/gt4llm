Class {
	#name : #GtLRefactoringToolForClassSearchExamples,
	#superclass : #GtLAbstractRefactoringMagritteToolExamples,
	#category : 'Gt4LlmCore-Examples-Tools'
}

{ #category : #examples }
GtLRefactoringToolForClassSearchExamples >> classSearchForEmptyQuery [
	<gtExample>
	| tool call targetObject |
	tool := self toolWithExampleClasses.
	call := self
		executeTool: tool
		withArguments: {'query' -> 'NonExistentClassPattern123456'} asDictionary.
	targetObject := call result targetObject.
	self assert: targetObject isErrorDomainObject not.
	self assert: targetObject foundClassNames isEmpty.
	^ call
]

{ #category : #examples }
GtLRefactoringToolForClassSearchExamples >> classSearchForQuery [
	<gtExample>
	| tool call targetObject |
	tool := self toolWithExampleClasses.
	call := self
		executeTool: tool
		withArguments: {'query' -> 'SearchExample'} asDictionary.
	targetObject := call result targetObject.
	self assert: targetObject isErrorDomainObject not.
	self assert: targetObject foundClassNames size >= 2.
	^ call
]

{ #category : #'examples - tools' }
GtLRefactoringToolForClassSearchExamples >> toolWithExampleClasses [
	| namespace tool |
	namespace := GtRBNamespace new.
	namespace defineClass: 'Object subclass: #GtLSearchExampleBase
		instanceVariableNames: ''''
		classVariableNames: ''''
		package: ''DemoTest'''.
	namespace defineClass: 'GtLSearchExampleBase subclass: #GtLSearchExampleChild
		instanceVariableNames: ''''
		classVariableNames: ''''
		package: ''DemoTest'''.
	tool := GtLRefactoringToolForClassSearch new.
	tool model: namespace.
	^ tool
]
