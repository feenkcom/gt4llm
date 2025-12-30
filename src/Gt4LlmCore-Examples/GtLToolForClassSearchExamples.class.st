Class {
	#name : #GtLToolForClassSearchExamples,
	#superclass : #Object,
	#category : #'Gt4LlmCore-Examples-Tools'
}

{ #category : #'llm-generated' }
GtLToolForClassSearchExamples >> searchClassesWithMatches [
	<gtExample>
	| tool call result |
	tool := GtLlmToolForClassSearch new.
	call := GtLlmFunctionToolCall new.
	call function: {
		'name' -> tool name.
		'arguments' -> {'query' -> 'GtLlmToolForClass'} asDictionary
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result includesSubstring: 'GtLlmToolForClassReferences').
	self assert: (result includesSubstring: 'GtLlmToolForClassSearch').
	^ tool
]

{ #category : #'llm-generated' }
GtLToolForClassSearchExamples >> searchClassesWithNoMatches [
	<gtExample>
	| tool call result |
	tool := GtLlmToolForClassSearch new.
	call := GtLlmFunctionToolCall new.
	call function: {
		'name' -> tool name.
		'arguments' -> {'query' -> 'ClassNameThatDoesNotExist42'} asDictionary
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: result equals: '[]'.
	^ tool
]
