Class {
	#name : #GtLRefactoringToolForMethodReferencesExamples,
	#superclass : #Object,
	#category : #'Gt4LlmCore-Examples-Tools'
}

{ #category : #'llm-generated' }
GtLRefactoringToolForMethodReferencesExamples >> methodReferencesForExistingSelector [
	<gtExample>
	| tool call result |
	tool := self toolWithExampleSenders.
	call := GtLlmFunctionToolCall new.
	call function: {
		'name' -> tool name.
		'arguments' -> {'selector' -> 'bar'} asDictionary
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result includesSubstring: 'GtLlmRefactoringMethodReferencesSender>>#call').
	self assert: (result includesSubstring: 'GtLlmRefactoringMethodReferencesForwarder>>#call').
	^ tool
]

{ #category : #'llm-generated' }
GtLRefactoringToolForMethodReferencesExamples >> methodReferencesForUnknownSelector [
	<gtExample>
	| tool call result |
	tool := self toolWithExampleSenders.
	call := GtLlmFunctionToolCall new.
	call function: {
		'name' -> tool name.
		'arguments' -> {'selector' -> 'missingSelector'} asDictionary
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: result equals: 'No references found'.
	^ tool
]

{ #category : #'llm-generated' }
GtLRefactoringToolForMethodReferencesExamples >> toolWithExampleSenders [
	| namespace tool senderClass forwarderClass |
	namespace := GtRBNamespace new.
	namespace defineClass: 'Object subclass: #GtLlmRefactoringMethodReferencesSender
		instanceVariableNames: ''''''
		classVariableNames: ''''''
		package: ''Gt4Llm-Refactoring-Examples''' .
	namespace defineClass: 'Object subclass: #GtLlmRefactoringMethodReferencesForwarder
		instanceVariableNames: ''''''
		classVariableNames: ''''''
		package: ''Gt4Llm-Refactoring-Examples''' .
	senderClass := namespace classNamed: 'GtLlmRefactoringMethodReferencesSender'.
	forwarderClass := namespace classNamed: 'GtLlmRefactoringMethodReferencesForwarder'.
	senderClass compile: 'bar
	^ 1' classified: 'examples'.
	senderClass compile: 'call
	^ self bar' classified: 'examples'.
	forwarderClass compile: 'call
	^ GtLlmRefactoringMethodReferencesSender new bar' classified: 'examples'.
	tool := GtLlmRefactoringToolForMethodReferences new.
	tool model: namespace.
	^ tool
]
