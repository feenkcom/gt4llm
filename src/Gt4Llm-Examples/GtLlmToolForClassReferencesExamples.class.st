Class {
	#name : #GtLlmToolForClassReferencesExamples,
	#superclass : #Object,
	#category : #'Gt4Llm-Examples'
}

{ #category : #'llm-generated' }
GtLlmToolForClassReferencesExamples >> classReferencesForExistingClass [
	<gtExample>
	| tool call result |
	tool := GtLlmToolForClassReferences new.
	call := GtLlmFunctionToolCall new.
	call function: {
		'name' -> tool name.
		'arguments' -> {'className' -> 'GtLlmToolForClassReferences'} asDictionary
	} asDictionary.
	result := tool performToolCall: call.
	self assert: result isEmpty not.
	self assert: (result includesSubstring: 'GtLlmToolForClassReferencesExamples').
	^ tool
]

{ #category : #'llm-generated' }
GtLlmToolForClassReferencesExamples >> classReferencesForUnknownClass [
	<gtExample>
	| tool call result |
	tool := GtLlmToolForClassReferences new.
	call := GtLlmFunctionToolCall new.
	call function: {
		'name' -> tool name.
		'arguments' -> {'className' -> 'NonExistingClassName'} asDictionary
	} asDictionary.
	result := tool performToolCall: call.
	self assert: result equals: 'Class not found'.
	^ tool
]
