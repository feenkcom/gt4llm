Class {
	#name : #GtLToolForClassLookupExamples,
	#superclass : #Object,
	#category : #'Gt4LlmCore-Examples-Tools'
}

{ #category : #'llm-generated' }
GtLToolForClassLookupExamples >> lookupClassForExistingClass [
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
	self assert: (result includesSubstring: '"class":"GtLlmToolForClassLookup"').
	self assert: (result includesSubstring: '"package":"Gt4Llm-GToolkit"').
	self assert: (result includesSubstring: '"classSlots":[]').
	self assert: (result includesSubstring: '"instanceSlots":[]').
	self assert: (result includesSubstring: '"allInstanceMethods"').
	self assert: (result includesSubstring: '"allClassMethods"').

	^ tool
]

{ #category : #'llm-generated' }
GtLToolForClassLookupExamples >> lookupClassForUnknownClass [
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
