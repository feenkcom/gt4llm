Class {
	#name : #GtLlmToolForClassSearchExamples,
	#superclass : #Object,
	#category : #'Gt4Llm-Examples'
}

{ #category : #'llm-generated' }
GtLlmToolForClassSearchExamples >> searchClassesWithMatches [
	<gtExample>
	| tool call result |
	tool := GtLlmToolForClassSearch new.
	call := GtLlmFunctionToolCall new.
	call function: {
		'name' -> tool name.
		'arguments' -> {'query' -> 'GtLlmToolForClass'} asDictionary
	} asDictionary.
	result := tool performToolCall: call.
	self assert: (result includesSubstring: 'GtLlmToolForClassReferences').
	self assert: (result includesSubstring: 'GtLlmToolForClassSearch').
	^ tool
]

{ #category : #'llm-generated' }
GtLlmToolForClassSearchExamples >> searchClassesWithNoMatches [
	<gtExample>
	| tool call result |
	tool := GtLlmToolForClassSearch new.
	call := GtLlmFunctionToolCall new.
	call function: {
		'name' -> tool name.
		'arguments' -> {'query' -> 'ClassNameThatDoesNotExist42'} asDictionary
	} asDictionary.
	result := tool performToolCall: call.
	self assert: result equals: '[]'.
	^ tool
]
