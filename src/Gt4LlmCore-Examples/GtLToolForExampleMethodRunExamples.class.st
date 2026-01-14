Class {
	#name : #GtLToolForExampleMethodRunExamples,
	#superclass : #Object,
	#category : #'Gt4LlmCore-Examples-Tools'
}

{ #category : #'llm-generated' }
GtLToolForExampleMethodRunExamples >> exampleRunError [
	<gtExample>
	| tool call result |
	tool := GtLToolForExampleMethodRun new.
	call := GtLFunctionToolCall new.
	call function: {
		'name' -> tool name.
		'arguments' -> {
			'className' -> 'GtLExampleRunDummyExamples'.
			'methodName' -> 'errorExample'
		} asDictionary
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: result equals: 'error'.
	^ tool
]

{ #category : #'llm-generated' }
GtLToolForExampleMethodRunExamples >> exampleRunFailure [
	<gtExample>
	| tool call result |
	tool := GtLToolForExampleMethodRun new.
	call := GtLFunctionToolCall new.
	call function: {
		'name' -> tool name.
		'arguments' -> {
			'className' -> 'GtLExampleRunDummyExamples'.
			'methodName' -> 'failingExample'
		} asDictionary
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: result equals: 'failure'.
	^ tool
]

{ #category : #'llm-generated' }
GtLToolForExampleMethodRunExamples >> exampleRunForNonExampleMethod [
	<gtExample>
	| tool call result |
	tool := GtLToolForExampleMethodRun new.
	call := GtLFunctionToolCall new.
	call function: {
		'name' -> tool name.
		'arguments' -> {
			'className' -> 'GtLExampleRunDummyExamples'.
			'methodName' -> 'regularMethod'
		} asDictionary
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: result equals: 'Method is not an example'.
	^ tool
]

{ #category : #'llm-generated' }
GtLToolForExampleMethodRunExamples >> exampleRunSuccess [
	<gtExample>
	| tool call result |
	tool := GtLToolForExampleMethodRun new.
	call := GtLFunctionToolCall new.
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
