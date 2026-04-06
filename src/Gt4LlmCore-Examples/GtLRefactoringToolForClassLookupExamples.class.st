Class {
	#name : #GtLRefactoringToolForClassLookupExamples,
	#superclass : #Object,
	#category : 'Gt4LlmCore-Examples-Tools'
}

{ #category : #examples }
GtLRefactoringToolForClassLookupExamples >> classLookupForExistingClass [
	<gtExample>
	| tool call result |
	tool := self toolWithExampleClass.
	call := GtLFunctionToolCall new.
	call rawArguments: {'className' -> 'GtLRefactoringToolForClassLookupExampleClass'} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: result isErrorDomainObject not.
	self assert: result targetObject targetClass name equals: 'GtLRefactoringToolForClassLookupExampleClass'.
	^ call
]

{ #category : #examples }
GtLRefactoringToolForClassLookupExamples >> classLookupForUnknownClass [
	<gtExample>
	| tool call result |
	tool := self toolWithExampleClass.
	call := GtLFunctionToolCall new.
	call rawArguments: {'className' -> 'NonExistentClass'} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: result isErrorDomainObject.
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
