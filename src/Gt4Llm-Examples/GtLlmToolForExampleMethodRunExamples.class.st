Class {
	#name : #GtLlmToolForExampleMethodRunExamples,
	#superclass : #Object,
	#category : #'Gt4Llm-Examples'
}

{ #category : #'llm-generated' }
GtLlmToolForExampleMethodRunExamples >> exampleRunError [
	<gtExample>
	| tool call result |
	tool := GtLlmToolForExampleMethodRun new.
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
GtLlmToolForExampleMethodRunExamples >> exampleRunFailure [
	<gtExample>
	| tool call result |
	tool := GtLlmToolForExampleMethodRun new.
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
GtLlmToolForExampleMethodRunExamples >> exampleRunForNonExampleMethod [
	<gtExample>
	| tool call result |
	tool := GtLlmToolForExampleMethodRun new.
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
GtLlmToolForExampleMethodRunExamples >> exampleRunSuccess [
	<gtExample>
	| tool call result |
	tool := GtLlmToolForExampleMethodRun new.
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
