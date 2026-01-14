Class {
	#name : #GtLToolForMethodImplementorsExamples,
	#superclass : #Object,
	#category : #'Gt4LlmCore-Examples-Tools'
}

{ #category : #'llm-generated' }
GtLToolForMethodImplementorsExamples >> implementorsForExistingMethodName [
	<gtExample>
	| tool call result |
	tool := GtLToolForMethodImplementors new.
	call := GtLFunctionToolCall new.
	call function: {
		'name' -> tool name.
		'arguments' -> {'methodName' -> 'performToolCall:'} asDictionary
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: result isEmpty not.
	self assert: (result includesSubstring: 'GtLAbstractFunctionTool>>#performToolCall:').
	^ tool
]

{ #category : #'llm-generated' }
GtLToolForMethodImplementorsExamples >> implementorsForUnknownMethodName [
	<gtExample>
	| tool call result |
	tool := GtLToolForMethodImplementors new.
	call := GtLFunctionToolCall new.
	call function: {
		'name' -> tool name.
		'arguments' -> {'methodName' -> 'unknownMethodName42'} asDictionary
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: result equals: 'No implementors found'.
	^ tool
]
