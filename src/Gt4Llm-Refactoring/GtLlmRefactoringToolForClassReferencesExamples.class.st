Class {
	#name : #GtLlmRefactoringToolForClassReferencesExamples,
	#superclass : #Object,
	#category : #'Gt4Llm-Refactoring-Ex'
}

{ #category : #'llm-generated' }
GtLlmRefactoringToolForClassReferencesExamples >> classReferencesForExistingClass [
	<gtExample>
	| tool call result |
	tool := self toolWithExampleReferences.
	call := GtLlmFunctionToolCall new.
	call function: {
		'name' -> tool name.
		'arguments' -> {'className' -> 'GtLlmRefactoringClassReferencesTarget'} asDictionary
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result includesSubstring: 'GtLlmRefactoringClassReferencesHolder').
	^ tool
]

{ #category : #'llm-generated' }
GtLlmRefactoringToolForClassReferencesExamples >> classReferencesForUnknownClass [
	<gtExample>
	| tool call result |
	tool := self toolWithExampleReferences.
	call := GtLlmFunctionToolCall new.
	call function: {
		'name' -> tool name.
		'arguments' -> {'className' -> 'UnknownClassName'} asDictionary
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: result equals: 'Class not found'.
	^ tool
]

{ #category : #'llm-generated' }
GtLlmRefactoringToolForClassReferencesExamples >> toolWithExampleReferences [
	| namespace tool targetClass holderClass |
	namespace := GtRBNamespace new.
	namespace defineClass: 'Object subclass: #GtLlmRefactoringClassReferencesTarget
		instanceVariableNames: ''''''
		classVariableNames: ''''''
		package: ''Gt4Llm-Refactoring-Examples''' .
	namespace defineClass: 'Object subclass: #GtLlmRefactoringClassReferencesHolder
		instanceVariableNames: ''''''
		classVariableNames: ''''''
		package: ''Gt4Llm-Refactoring-Examples''' .
	targetClass := namespace classNamed: 'GtLlmRefactoringClassReferencesTarget'.
	holderClass := namespace classNamed: 'GtLlmRefactoringClassReferencesHolder'.
	holderClass compile: 'reference
	^ GtLlmRefactoringClassReferencesTarget new' classified: 'accessing'.
	tool := GtLlmRefactoringToolForClassReferences new.
	tool model: namespace.
	^ tool
]
