Class {
	#name : #GtLRefactoringToolForClassReferencesExamples,
	#superclass : #GtLAbstractRefactoringMagritteToolExamples,
	#category : #'Gt4LlmCore-Examples-Tools'
}

{ #category : #examples }
GtLRefactoringToolForClassReferencesExamples >> classReferencesForExistingClass [
	<gtExample>
	| tool call targetObject |
	tool := self toolWithExampleReferences.
	call := self
		executeTool: tool
		withArguments: {'targetClassName' -> 'GtLRefactoringClassReferencesTarget'} asDictionary.
	targetObject := call result targetObject.
	self assert: targetObject isErrorDomainObject not.
	self assert: targetObject references isNotEmpty.
	^ call
]

{ #category : #examples }
GtLRefactoringToolForClassReferencesExamples >> classReferencesForUnknownClass [
	<gtExample>
	| tool call |
	tool := self toolWithExampleReferences.
	call := self
		executeTool: tool
		withArguments: {'targetClassName' -> 'UnknownClassName'} asDictionary.
	self assert: call result targetObject isErrorDomainObject.
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
