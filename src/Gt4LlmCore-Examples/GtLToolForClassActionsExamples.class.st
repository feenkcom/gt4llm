Class {
	#name : #GtLToolForClassActionsExamples,
	#superclass : #Object,
	#category : #'Gt4LlmCore-Examples-Tools'
}

{ #category : #'llm-generated' }
GtLToolForClassActionsExamples >> classActionsForClassWithNoActions [
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
GtLToolForClassActionsExamples >> classActionsForExistingClass [
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
GtLToolForClassActionsExamples >> classActionsForUnknownClass [
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
