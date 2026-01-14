Class {
	#name : #GtLToolForSearchFilterExamples,
	#superclass : #Object,
	#category : #'Gt4LlmCore-Examples-Tools'
}

{ #category : #'llm-generated' }
GtLToolForSearchFilterExamples >> searchFilterForExampleMethods [
	<gtExample>
	| tool call result |
	tool := GtLToolForSearchFilter new.
	call := GtLFunctionToolCall new.
	call function: {
		'name' -> tool name.
		'arguments' -> {'query' -> 'GtLToolForSearchFilterExamples gtMethodsInClass & #gtExample gtPragmas'} asDictionary
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result includesSubstring: 'GtLToolForSearchFilterExamples>>#searchFilterForExampleMethods').
	^ tool
]

{ #category : #'llm-generated' }
GtLToolForSearchFilterExamples >> searchFilterWithError [
	<gtExample>
	| tool call result |
	tool := GtLToolForSearchFilter new.
	call := GtLFunctionToolCall new.
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
