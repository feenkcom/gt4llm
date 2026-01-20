Class {
	#name : #GtLToolForSearchForLepiterPagesExamples,
	#superclass : #Object,
	#category : #'Gt4LlmCore-Examples-Tools'
}

{ #category : #'llm-generated' }
GtLToolForSearchForLepiterPagesExamples >> documentationLookupForExistingPage [
	<gtExample>
	| tool call result |
	tool := GtLToolForSearchForLepiterPages new.
	call := GtLFunctionToolCall new.
	call function: {
		'name' -> tool name.
		'arguments' -> {'query' -> 'Warmup: understanding the Money classes'} asDictionary
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: result isErrorDomainObject not.
	self assert: result pages size equals: 1.
	self assert: (result serializeToOpenAIResponseJsonString includesSubstring: 'Warmup: understanding the Money classes').
self assert: (result serializeToOpenAIResponseJsonString includesSubstring: 'uuid').
	^ call
]

{ #category : #'llm-generated' }
GtLToolForSearchForLepiterPagesExamples >> documentationLookupForMissingPage [
	<gtExample>
	| tool call result |
	tool := GtLToolForSearchForLepiterPages new.
	call := GtLFunctionToolCall new.
	call
		function: {'name' -> tool name.
				'arguments' -> {'query' -> 'NonExistingDocumentationPage42'} asDictionary}
				asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: result isErrorDomainObject not.
	self assert: result pages equals: #().

	^ call
]
