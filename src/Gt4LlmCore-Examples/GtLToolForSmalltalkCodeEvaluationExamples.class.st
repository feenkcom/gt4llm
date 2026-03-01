Class {
	#name : #GtLToolForSmalltalkCodeEvaluationExamples,
	#superclass : #Object,
	#category : #'Gt4LlmCore-Examples-Tools'
}

{ #category : #examples }
GtLToolForSmalltalkCodeEvaluationExamples >> executeSimpleDoIt [
	<gtExample>
	| tool call result expected |
	tool := GtLToolForSmalltalkCodeEvaluation new.
	call := GtLFunctionToolCall new.
	call function: {
		'name' -> tool name.
		'arguments' -> {
			'code' -> '1 + 2'
		} asDictionary
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: result isErrorDomainObject not.
	self assert: result value equals: 3.
	self assert: result code equals: '1 + 2'.
	expected := NeoJSONObject new
		at: 'code' put: '1 + 2';
		at: 'value' put: (GtLValueSerializer new serializeValue: 3);
		yourself.
	self assert: result serializeToOpenAIResponseJsonObject equals: expected.

	^ call
]

{ #category : #examples }
GtLToolForSmalltalkCodeEvaluationExamples >> executeWithError [
	<gtExample>
	| tool call result |
	tool := GtLToolForSmalltalkCodeEvaluation new.
	call := GtLFunctionToolCall new.
	call
		function: {'name' -> tool name.
				'arguments' -> {'code' -> '1 / 0'} asDictionary} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: result isErrorDomainObject.
	self assert: (result description beginsWith: 'Error while evaluating smalltalk code').
	self assert: (result messageText beginsWith: 'ZeroDivide').
	^ call
]

{ #category : #examples }
GtLToolForSmalltalkCodeEvaluationExamples >> missingCodeArgument [
	<gtExample>
	| tool call result |
	tool := GtLToolForSmalltalkCodeEvaluation new.
	call := GtLFunctionToolCall new.
	call
		function: {'name' -> tool name.
				'arguments' -> Dictionary new} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: result isErrorDomainObject.
	self assert: result missingArgument equals: 'code'.
	
	^ call
]
