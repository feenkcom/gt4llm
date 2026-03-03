Class {
	#name : #GtLToolForSmalltalkCodeEvaluationExamples,
	#superclass : #Object,
	#category : #'Gt4LlmCore-Examples-Tools'
}

{ #category : #examples }
GtLToolForSmalltalkCodeEvaluationExamples >> executeSimpleDoIt [
	<gtExample>
	| objectStorage tool call result expected |
	
	objectStorage := GtLObjectStorage new.
	
	tool := GtLToolForSmalltalkCodeEvaluation new.
	call := GtLFunctionToolCall new.
	call function: {
		'name' -> tool name.
		'arguments' -> {
			'code' -> '1 + 2'
		} asDictionary
	} asDictionary.
	result := tool 
		performToolCall: call
		inContext: (GtLToolExecutionContext new
			objectStorage: objectStorage).
	
	self assert: call tool == tool.
	self assert: result isErrorDomainObject not.
	self assert: result object equals: 3.
	self assert: result code equals: '1 + 2'.
	
	self assert: objectStorage objectCount equals: 1.
	self 
		assert: (objectStorage objectAt: objectStorage objectIds first)
		equals: 3.
	
	expected := NeoJSONObject new
		at: 'code' put: '1 + 2';
		at: 'objectValue' put: (GtLValueSerializer new 
			serializeValue: 3);
		at: 'objectId' put: (objectStorage objectIds first);
		yourself.
	self 
		assert: result serializeToLlmJsonObject
		equals: expected.

	^ call
]

{ #category : #examples }
GtLToolForSmalltalkCodeEvaluationExamples >> executeSimpleDoItWithoutObjectStorage [
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
	result := tool 
		performToolCall: call.
	
	self assert: call tool == tool.
	self assert: result isErrorDomainObject not.
	self assert: result object equals: 3.
	self assert: result code equals: '1 + 2'.
	expected := NeoJSONObject new
		at: 'code' put: '1 + 2';
		at: 'objectValue' put: (GtLValueSerializer new 
			serializeValue: 3);
		at: 'objectId' put: nil;
		yourself.
	self 
		assert: result serializeToLlmJsonObject
		equals: expected.

	^ call
]

{ #category : #examples }
GtLToolForSmalltalkCodeEvaluationExamples >> executeWithBindings [
	<gtExample>
	| objectStorage tool call result bindingObjectId resultObjectId |
	objectStorage := GtLObjectStorage new.
	bindingObjectId := objectStorage addNewObject: 40.
	tool := GtLToolForSmalltalkCodeEvaluation new.
	call := GtLFunctionToolCall new.
	call function: {
		'name' -> tool name.
		'arguments' -> {
			'code' -> 'value + 2'.
			'bindings' -> {
				{
					'name' -> 'value'.
					'objectId' -> bindingObjectId
				} asDictionary
			} asArray
		} asDictionary
	} asDictionary.
	result := tool
		performToolCall: call
		inContext: (GtLToolExecutionContext new objectStorage: objectStorage).
	self assert: call tool == tool.
	self assert: result isErrorDomainObject not.
	self assert: result object equals: 42.
	resultObjectId := result objectId.
	self assert: resultObjectId isString.
	self assert: resultObjectId ~= bindingObjectId.
	self assert: (objectStorage objectAt: bindingObjectId) equals: 40.
	self assert: (objectStorage objectAt: resultObjectId) equals: 42.
	^ call
]

{ #category : #examples }
GtLToolForSmalltalkCodeEvaluationExamples >> executeWithBindingsMissingObjectStorage [
	<gtExample>
	| tool call result |
	tool := GtLToolForSmalltalkCodeEvaluation new.
	call := GtLFunctionToolCall new.
	call function: {
		'name' -> tool name.
		'arguments' -> {
			'code' -> 'value + 2'.
			'bindings' -> {
				{
					'name' -> 'value'.
					'objectId' -> 'missing'
				} asDictionary
			} asArray
		} asDictionary
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: result isErrorDomainObject.
	self assert: result missingModelName equals: 'objectStorage'.
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
