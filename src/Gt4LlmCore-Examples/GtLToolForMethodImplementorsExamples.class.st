Class {
	#name : #GtLToolForMethodImplementorsExamples,
	#superclass : #Object,
	#category : 'Gt4LlmCore-Examples-Tools'
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
	self assert: result isErrorDomainObject not.
	self assert: (result serializeToOpenAIResponseJsonString includesSubstring: 'GtLAbstractFunctionTool>>#performToolCall:').
	^ call
]

{ #category : #'llm-generated' }
GtLToolForMethodImplementorsExamples >> implementorsForUnknownMethodName [
	<gtExample>
	| tool call result |
	tool := GtLToolForMethodImplementors new.
	call := GtLFunctionToolCall new.
	call
		function: {'name' -> tool name.
				'arguments' -> {'methodName' -> 'unknownMethodName42'} asDictionary}
				asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: result isErrorDomainObject not.
	self assert: result methods equals: #().
	^ call
]
