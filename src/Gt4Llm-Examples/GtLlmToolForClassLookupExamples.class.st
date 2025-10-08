Class {
	#name : #GtLlmToolForClassLookupExamples,
	#superclass : #Object,
	#category : #'Gt4Llm-Examples'
}

{ #category : #'llm-generated' }
GtLlmToolForClassLookupExamples >> lookupClassForExistingClass [
	<gtExample>
	| tool call result |
	tool := GtLlmToolForClassLookup new.
	call := GtLlmFunctionToolCall new.
	call function: {
		'name' -> tool name.
		'arguments' -> {'className' -> 'GtLlmToolForClassLookup'} asDictionary
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result includesSubstring: '{"class":"GtLlmToolForClassLookup","package":"Gt4Llm-GToolkit"').
	^ tool
]

{ #category : #'llm-generated' }
GtLlmToolForClassLookupExamples >> lookupClassForUnknownClass [
	<gtExample>
	| tool call result |
	tool := GtLlmToolForClassLookup new.
	call := GtLlmFunctionToolCall new.
	call function: {
		'name' -> tool name.
		'arguments' -> {'className' -> 'NonExistingClassName42'} asDictionary
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: result equals: 'Class not found'.
	^ tool
]
