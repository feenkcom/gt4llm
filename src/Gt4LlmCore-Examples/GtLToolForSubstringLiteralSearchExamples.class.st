Class {
	#name : #GtLToolForSubstringLiteralSearchExamples,
	#superclass : #Object,
	#category : 'Gt4LlmCore-Examples-Tools'
}

{ #category : #examples }
GtLToolForSubstringLiteralSearchExamples >> searchWithMatches [
	<gtExample>
	| tool call result query |
	query := 'substringLiteralSearchExampleUnique'.
	tool := GtLToolForSubstringLiteralSearch new.
	call := GtLFunctionToolCall new.
	call
		function: {'name' -> tool name.
				'arguments' -> {'query' -> query} asDictionary} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: result isErrorDomainObject not.
	self
		assert: (result methods
				includes: GtLToolForSubstringLiteralSearchExamples >> #searchWithMatches).
	^ call
]

{ #category : #examples }
GtLToolForSubstringLiteralSearchExamples >> searchWithNoMatches [
	<gtExample>
	| tool call result query |
	query := 'noLiteralMatchString' , 'ForSearch'.
	tool := GtLToolForSubstringLiteralSearch new.
	call := GtLFunctionToolCall new.
	call function: {
		'name' -> tool name.
		'arguments' -> {'query' -> query} asDictionary
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: result isErrorDomainObject not.
	self assert: result methods isEmpty.
	^ call
]
