Class {
	#name : #GtLlmToolForMethodImplementorsExamples,
	#superclass : #Object,
	#category : #'Gt4Llm-Examples'
}

{ #category : #'llm-generated' }
GtLlmToolForMethodImplementorsExamples >> implementorsForExistingMethodName [
	<gtExample>
	| tool call result |
	tool := GtLlmToolForMethodImplementors new.
	call := GtLlmFunctionToolCall new.
	call function: {
		'name' -> tool name.
		'arguments' -> {'methodName' -> 'performToolCall:'} asDictionary
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: result isEmpty not.
	self assert: (result includesSubstring: 'GtLlmAbstractFunctionTool>>#performToolCall:').
	^ tool
]

{ #category : #'llm-generated' }
GtLlmToolForMethodImplementorsExamples >> implementorsForUnknownMethodName [
	<gtExample>
	| tool call result |
	tool := GtLlmToolForMethodImplementors new.
	call := GtLlmFunctionToolCall new.
	call function: {
		'name' -> tool name.
		'arguments' -> {'methodName' -> 'unknownMethodName42'} asDictionary
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: result equals: 'No implementors found'.
	^ tool
]
