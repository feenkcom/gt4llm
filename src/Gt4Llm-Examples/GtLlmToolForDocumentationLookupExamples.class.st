Class {
	#name : #GtLlmToolForDocumentationLookupExamples,
	#superclass : #GtLlmToolExamples,
	#category : #'Gt4Llm-Examples'
}

{ #category : #'llm-generated' }
GtLlmToolForDocumentationLookupExamples >> documentationLookupForExistingPage [
	<gtExample>
	| tool call result |
	tool := GtLlmToolForDocumentationLookup new.
	call := GtLlmFunctionToolCall new.
	call function: {
		'name' -> tool name.
		'arguments' -> {'pageName' -> 'Warmup: understanding the Money classes'} asDictionary
	} asDictionary.
	result := tool performToolCall: call.
	self assert: (result includesSubstring: 'Warmup: understanding the Money classes').
	^ tool
]

{ #category : #'llm-generated' }
GtLlmToolForDocumentationLookupExamples >> documentationLookupForMissingPage [
	<gtExample>
	| tool call result |
	tool := GtLlmToolForDocumentationLookup new.
	call := GtLlmFunctionToolCall new.
	call function: {
		'name' -> tool name.
		'arguments' -> {'pageName' -> 'NonExistingDocumentationPage42'} asDictionary
	} asDictionary.
	result := tool performToolCall: call.
	self assert: result equals: 'No page found'.
	^ tool
]
