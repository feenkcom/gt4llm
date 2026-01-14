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
	call := GtLFunctionToolCall new.
	call function: {
		'name' -> tool name.
		'arguments' -> {'selector' -> 'bar'} asDictionary
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result includesSubstring: 'GtLRefactoringMethodReferencesSender>>#call').
	self assert: (result includesSubstring: 'GtLRefactoringMethodReferencesForwarder>>#call').
	^ tool
]

{ #category : #'llm-generated' }
GtLRefactoringToolForMethodReferencesExamples >> methodReferencesForUnknownSelector [
	<gtExample>
	| tool call result |
	tool := self toolWithExampleSenders.
	call := GtLFunctionToolCall new.
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
	namespace defineClass: 'Object subclass: #GtLRefactoringMethodReferencesSender
		instanceVariableNames: ''''''
		classVariableNames: ''''''
		package: ''DemoTest''' .
	namespace defineClass: 'Object subclass: #GtLRefactoringMethodReferencesForwarder
		instanceVariableNames: ''''''
		classVariableNames: ''''''
		package: ''DemoTest''' .
	senderClass := namespace classNamed: 'GtLRefactoringMethodReferencesSender'.
	forwarderClass := namespace classNamed: 'GtLRefactoringMethodReferencesForwarder'.
	senderClass compile: 'bar
	^ 1' classified: 'examples'.
	senderClass compile: 'call
	^ self bar' classified: 'examples'.
	forwarderClass compile: 'call
	^ GtLRefactoringMethodReferencesSender new bar' classified: 'examples'.
	tool := GtLRefactoringToolForMethodReferences new.
	tool model: namespace.
	^ tool
]
