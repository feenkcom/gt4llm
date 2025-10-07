Class {
	#name : #GtLlmToolForImplementorsExamples,
	#superclass : #GtLlmToolExamples,
	#category : #'Gt4Llm-Examples'
}

{ #category : #'llm-generated' }
GtLlmToolForImplementorsExamples >> implementorsForExistingMethodName [
	<gtExample>
	| tool call result |
	tool := GtLlmToolForImplementors new.
	call := GtLlmFunctionToolCall new.
	call function: {
		'name' -> tool name.
		'arguments' -> {'methodName' -> 'performToolCall:'} asDictionary
	} asDictionary.
	result := tool performToolCall: call.
	self assert: result isEmpty not.
	self assert: (result includesSubstring: 'GtLlmToolForImplementors>>#performToolCall:').
	^ tool
]

{ #category : #'llm-generated' }
GtLlmToolForImplementorsExamples >> implementorsForUnknownMethodName [
	<gtExample>
	| tool call result |
	tool := GtLlmToolForImplementors new.
	call := GtLlmFunctionToolCall new.
	call function: {
		'name' -> tool name.
		'arguments' -> {'methodName' -> 'unknownMethodName42'} asDictionary
	} asDictionary.
	result := tool performToolCall: call.
	self assert: result equals: 'No implementors found'.
	^ tool
]
