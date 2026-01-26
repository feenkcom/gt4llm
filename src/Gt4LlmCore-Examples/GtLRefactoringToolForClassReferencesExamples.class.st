Class {
	#name : #GtLRefactoringToolForClassReferencesExamples,
	#superclass : #Object,
	#category : 'Gt4LlmCore-Examples-Tools'
}

{ #category : #'llm-generated' }
GtLRefactoringToolForClassReferencesExamples >> classReferencesForExistingClass [
	<gtExample>
	| tool call result |
	tool := self toolWithExampleReferences.
	call := GtLFunctionToolCall new.
	call function: {
		'name' -> tool name.
		'arguments' -> {'className' -> 'GtLRefactoringClassReferencesTarget'} asDictionary
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result serializeToOpenAIResponseJsonString includesSubstring: 'GtLRefactoringClassReferencesHolder').
	^ tool
]

{ #category : #'llm-generated' }
GtLRefactoringToolForClassReferencesExamples >> classReferencesForUnknownClass [
	<gtExample>
	| tool call result |
	tool := self toolWithExampleReferences.
	call := GtLFunctionToolCall new.
	call
		function: {'name' -> tool name.
				'arguments' -> {'className' -> 'UnknownClassName'} asDictionary}
				asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: result isErrorDomainObject.
	self assert: result objectName equals: 'UnknownClassName'.
	self
		assert: result serializeToOpenAIResponseJsonString
		equals: '{"error":"UnknownClassName is not found","missingObject":"UnknownClassName"}'.
	^ tool
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
