Class {
	#name : #GtLlmToolForExampleRunExamples,
	#superclass : #Object,
	#category : #'Gt4Llm-Examples'
}

{ #category : #'llm-generated' }
GtLlmToolForExampleRunExamples >> exampleRunError [
	<gtExample>
	| tool call result |
	tool := GtLlmToolForExampleRun new.
	call := GtLlmFunctionToolCall new.
	call function: {
		'name' -> tool name.
		'arguments' -> {
			'className' -> 'GtLlmExampleRunDummyExamples'.
			'methodName' -> 'errorExample'
		} asDictionary
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: result equals: 'error'.
	^ tool
]

{ #category : #'llm-generated' }
GtLlmToolForExampleRunExamples >> exampleRunFailure [
	<gtExample>
	| tool call result |
	tool := GtLlmToolForExampleRun new.
	call := GtLlmFunctionToolCall new.
	call function: {
		'name' -> tool name.
		'arguments' -> {
			'className' -> 'GtLlmExampleRunDummyExamples'.
			'methodName' -> 'failingExample'
		} asDictionary
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: result equals: 'failure'.
	^ tool
]

{ #category : #'llm-generated' }
GtLlmToolForExampleRunExamples >> exampleRunForNonExampleMethod [
	<gtExample>
	| tool call result |
	tool := GtLlmToolForExampleRun new.
	call := GtLlmFunctionToolCall new.
	call function: {
		'name' -> tool name.
		'arguments' -> {
			'className' -> 'GtLlmExampleRunDummyExamples'.
			'methodName' -> 'regularMethod'
		} asDictionary
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: result equals: 'Method is not an example'.
	^ tool
]

{ #category : #'llm-generated' }
GtLlmToolForExampleRunExamples >> exampleRunSuccess [
	<gtExample>
	| tool call result |
	tool := GtLlmToolForExampleRun new.
	call := GtLlmFunctionToolCall new.
	call function: {
		'name' -> tool name.
		'arguments' -> {
			'className' -> 'GtTMoneyExamples'.
			'methodName' -> 'fortyTwoEuros'
		} asDictionary
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: result equals: 'success'.
	^ tool
]
