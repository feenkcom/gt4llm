Class {
	#name : #GtLlmToolForClassActionsExamples,
	#superclass : #Object,
	#category : #'Gt4Llm-Examples'
}

{ #category : #'llm-generated' }
GtLlmToolForClassActionsExamples >> classActionsForClassWithNoActions [
	<gtExample>
	| tool call result |
	tool := GtLlmToolForClassActions new.
	call := GtLlmFunctionToolCall new.
	call function: {
		'name' -> tool name.
		'arguments' -> {'className' -> 'GtLlmToolForClassActionsExamples'} asDictionary
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: result equals: 'No actions found'.
	^ tool
]

{ #category : #'llm-generated' }
GtLlmToolForClassActionsExamples >> classActionsForExistingClass [
	<gtExample>
	| tool call result |
	tool := GtLlmToolForClassActions new.
	call := GtLlmFunctionToolCall new.
	call function: {
		'name' -> tool name.
		'arguments' -> {'className' -> 'GtLudoRecordingGame'} asDictionary
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: result isEmpty not.
	self assert: (result includesSubstring: 'gtAutoplayAction:').
	^ tool
]

{ #category : #'llm-generated' }
GtLlmToolForClassActionsExamples >> classActionsForUnknownClass [
	<gtExample>
	| tool call result |
	tool := GtLlmToolForClassActions new.
	call := GtLlmFunctionToolCall new.
	call function: {
		'name' -> tool name.
		'arguments' -> {'className' -> 'NonExistingClassName'} asDictionary
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: result equals: 'Class not found'.
	^ tool
]
