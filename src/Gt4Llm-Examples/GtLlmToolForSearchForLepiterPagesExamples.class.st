Class {
	#name : #GtLlmToolForSearchForLepiterPagesExamples,
	#superclass : #Object,
	#category : #'Gt4Llm-Examples'
}

{ #category : #'llm-generated' }
GtLlmToolForSearchForLepiterPagesExamples >> documentationLookupForExistingPage [
	<gtExample>
	| tool call result |
	tool := GtLlmToolForSearchForLepiterPages new.
	call := GtLlmFunctionToolCall new.
	call function: {
		'name' -> tool name.
		'arguments' -> {'query' -> 'Warmup: understanding the Money classes'} asDictionary
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (STONJSON fromString: result) size equals: 1.
	self assert: (result includesSubstring: 'Warmup: understanding the Money classes').
	^ call
]

{ #category : #'llm-generated' }
GtLlmToolForSearchForLepiterPagesExamples >> documentationLookupForMissingPage [
	<gtExample>
	| tool call result |
	tool := GtLlmToolForSearchForLepiterPages new.
	call := GtLlmFunctionToolCall new.
	call function: {
		'name' -> tool name.
		'arguments' -> {'query' -> 'NonExistingDocumentationPage42'} asDictionary
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: result equals: 'No page found'.
	^ tool
]
