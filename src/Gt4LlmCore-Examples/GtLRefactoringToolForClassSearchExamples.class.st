Class {
	#name : #GtLRefactoringToolForClassSearchExamples,
	#superclass : #Object,
	#category : #'Gt4LlmCore-Examples-Tools'
}

{ #category : #examples }
GtLRefactoringToolForClassSearchExamples >> classSearchForEmptyQuery [
	<gtExample>
	| tool call result |
	tool := self toolWithExampleClasses.
	call := GtLFunctionToolCall new.
	call rawArguments: {'query' -> 'NonExistentClassPattern123456'} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: result isErrorDomainObject not.
	self assert: result targetObject foundClassNames isEmpty.
	^ call
]

{ #category : #examples }
GtLRefactoringToolForClassSearchExamples >> classSearchForQuery [
	<gtExample>
	| tool call result |
	tool := self toolWithExampleClasses.
	call := GtLFunctionToolCall new.
	call rawArguments: {'query' -> 'SearchExample'} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: result isErrorDomainObject not.
	self assert: result targetObject foundClassNames size >= 2.
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
