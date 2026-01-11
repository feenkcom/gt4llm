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
	expected := STONJSON toStringPretty: (GtLlmValueSerializer new serializeValue: 3).
	self assert: result equals: expected.
	^ tool
]

{ #category : #examples }
GtLToolForSmalltalkCodeEvaluationExamples >> executeWithError [
	<gtExample>
	| tool call result |
	tool := GtLToolForSmalltalkCodeEvaluation new.
	call := GtLFunctionToolCall new.
	call function: {
		'name' -> tool name.
		'arguments' -> {
			'code' -> '1 / 0'
		} asDictionary
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result beginsWith: 'Error:').
	self assert: ((result findString: 'ZeroDivide' startingAt: 1) > 0).
	^ tool
]

{ #category : #examples }
GtLToolForSmalltalkCodeEvaluationExamples >> missingCodeArgument [
	<gtExample>
	| tool call result |
	tool := GtLToolForSmalltalkCodeEvaluation new.
	call := GtLFunctionToolCall new.
	call function: {
		'name' -> tool name.
		'arguments' -> Dictionary new
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: result equals: 'Code not provided'.
	^ tool
]
