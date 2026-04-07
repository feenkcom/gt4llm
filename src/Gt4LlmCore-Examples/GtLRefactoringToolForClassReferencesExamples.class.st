Class {
	#name : #GtLRefactoringToolForClassReferencesExamples,
	#superclass : #GtLAbstractPlainSchemaFunctionToolExamples,
	#category : #'Gt4LlmCore-Examples-Tools'
}

{ #category : #examples }
GtLRefactoringToolForClassReferencesExamples >> classReferencesForExistingClass [
	<gtExample>
	| tool call result |
	tool := self toolWithExampleReferences.
	call := GtLFunctionToolCall new.
	call rawArguments: {'className' -> 'GtLRefactoringClassReferencesTarget'} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: result isErrorDomainObject not.
	self assert: result targetObject references isNotEmpty.
	^ call
]

{ #category : #examples }
GtLRefactoringToolForClassReferencesExamples >> classReferencesForUnknownClass [
	<gtExample>
	| tool call result |
	tool := self toolWithExampleReferences.
	call := GtLFunctionToolCall new.
	call rawArguments: {'className' -> 'UnknownClassName'} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: result isErrorDomainObject.
	^ call
]

{ #category : #'llm-generated' }
GtLRefactoringToolForClassReferencesExamples >> toolWithExampleReferences [
	| namespace tool targetClass holderClass |
	namespace := GtRBNamespace new.
	namespace defineClass: 'Object subclass: #GtLRefactoringClassReferencesTarget
		instanceVariableNames: ''''''
		classVariableNames: ''''''
		package: ''Gt4Llm-Refactoring-Examples''' .
	namespace defineClass: 'Object subclass: #GtLRefactoringClassReferencesHolder
		instanceVariableNames: ''''''
		classVariableNames: ''''''
		package: ''Gt4Llm-Refactoring-Examples''' .
	targetClass := namespace classNamed: 'GtLRefactoringClassReferencesTarget'.
	holderClass := namespace classNamed: 'GtLRefactoringClassReferencesHolder'.
	holderClass compile: 'reference
	^ GtLRefactoringClassReferencesTarget new' classified: 'accessing'.
	tool := GtLRefactoringToolForClassReferences new.
	tool model: namespace.
	^ tool
]
