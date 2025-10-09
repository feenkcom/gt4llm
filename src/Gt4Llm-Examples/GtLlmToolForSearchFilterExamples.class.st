Class {
	#name : #GtLlmToolForSearchFilterExamples,
	#superclass : #Object,
	#category : #'Gt4Llm-Examples'
}

{ #category : #'llm-generated' }
GtLlmToolForSearchFilterExamples >> searchFilterForExampleMethods [
	<gtExample>
	| tool call result |
	tool := GtLlmToolForSearchFilter new.
	call := GtLlmFunctionToolCall new.
	call function: {
		'name' -> tool name.
		'arguments' -> {'query' -> 'GtLlmToolForSearchFilterExamples gtMethodsInClass & #gtExample gtPragmas'} asDictionary
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result includesSubstring: 'GtLlmToolForSearchFilterExamples>>#searchFilterForExampleMethods').
	^ tool
]

{ #category : #'llm-generated' }
GtLlmToolForSearchFilterExamples >> searchFilterWithError [
	<gtExample>
	| tool call result |
	tool := GtLlmToolForSearchFilter new.
	call := GtLlmFunctionToolCall new.
	call function: {
		'name' -> tool name.
		'arguments' -> {'query' -> 'self error: ''boom'''} asDictionary
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result beginsWith: 'There was an error when evaluating the query: ').
	self assert: (result includesSubstring: 'boom').
	^ tool
]
