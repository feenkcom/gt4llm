Class {
	#name : #GtLToolForClassReferencesExamples,
	#superclass : #Object,
	#category : #'Gt4LlmCore-Examples-Tools'
}

{ #category : #'llm-generated' }
GtLToolForClassReferencesExamples >> classReferencesForExistingClass [
	<gtExample>
	| tool call result |
	tool := GtLlmToolForClassReferences new.
	call := GtLlmFunctionToolCall new.
	call function: {
		'name' -> tool name.
		'arguments' -> {'className' -> 'GtLlmToolForClassReferences'} asDictionary
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: result isEmpty not.
	self assert: (result includesSubstring: 'GtLlmToolForClassReferencesExamples').
	^ tool
]

{ #category : #'llm-generated' }
GtLToolForClassReferencesExamples >> classReferencesForUnknownClass [
	<gtExample>
	| tool call result |
	tool := GtLlmToolForClassReferences new.
	call := GtLlmFunctionToolCall new.
	call function: {
		'name' -> tool name.
		'arguments' -> {'className' -> 'NonExistingClassName'} asDictionary
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: result equals: 'Class not found'.
	^ tool
]
