Class {
	#name : #GtLToolForClassLookupExamples,
	#superclass : #Object,
	#category : #'Gt4LlmCore-Examples-Tools'
}

{ #category : #'llm-generated' }
GtLToolForClassLookupExamples >> lookupClassForExistingClass [
	<gtExample>
	| tool call result |
	tool := GtLToolForClassLookup new.
	call := GtLFunctionToolCall new.
	call function: {
		'name' -> tool name.
		'arguments' -> {'className' -> 'GtLToolForClassLookup'} asDictionary
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result includesSubstring: '"class":"GtLToolForClassLookup"').
	self assert: (result includesSubstring: '"package":"Gt4LlmCore"').
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
	tool := GtLToolForClassLookup new.
	call := GtLFunctionToolCall new.
	call function: {
		'name' -> tool name.
		'arguments' -> {'className' -> 'NonExistingClassName42'} asDictionary
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: result equals: 'Class not found'.
	^ tool
]
