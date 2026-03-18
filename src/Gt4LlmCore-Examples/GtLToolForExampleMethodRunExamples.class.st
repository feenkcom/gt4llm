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
	self assert: result isErrorDomainObject not.
	self assert: result isErrorResult.
	^ call
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
	self assert: result isErrorDomainObject not.
	self assert: result isFailureResult.
	^ call
]

{ #category : #'llm-generated' }
GtLToolForExampleMethodRunExamples >> exampleRunForNonExampleMethod [
	<gtExample>
	| tool call result |
	tool := GtLToolForExampleMethodRun new.
	call := GtLFunctionToolCall new.
	call
		function: {'name' -> tool name.
				'arguments'
					-> {'className' -> 'GtLExampleRunDummyExamples'.
							'methodName' -> 'regularMethod'} asDictionary} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: result isErrorDomainObject.
	self
		assert: result method name
		equals: 'GtLExampleRunDummyExamples>>#regularMethod'.
	^ call
]

{ #category : #examples }
GtLToolForExampleMethodRunExamples >> exampleRunSuccess [
	<gtExample>
	| tool call result |
	tool := GtLToolForExampleMethodRun new.
	call := GtLFunctionToolCall new.
	call
		function: {'name' -> tool name.
				'arguments'
					-> {'className' -> 'GtTMoneyExamples'.
							'methodName' -> 'fortyTwoEuros'} asDictionary} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: result isErrorDomainObject not.
	self assert: result isSuccessResult.
	self assert: result objectId isNil.
	^ call
]

{ #category : #examples }
GtLToolForExampleMethodRunExamples >> exampleRunSuccessStoresObjectId [
	<gtExample>
	| objectStorage tool call result objectId expected storedObject |
	objectStorage := GtLObjectStorage new.
	tool := GtLToolForExampleMethodRun new.
	call := GtLFunctionToolCall new.
	call function: {
		'name' -> tool name.
		'arguments' -> {
			'className' -> 'GtLExampleRunDummyExamples'.
			'methodName' -> 'successfulExample'
		} asDictionary
	} asDictionary.
	result := tool
		performToolCall: call
		inContext: (GtLToolExecutionContext new objectStorage: objectStorage).
	self assert: call tool == tool.
	self assert: result isErrorDomainObject not.
	self assert: result isSuccessResult.
	objectId := result objectId.
	self assert: objectId isString.
	self assert: (objectStorage objectAt: objectId) equals: 42.
	storedObject := objectStorage storedObjectAt: objectId.
	self assert: storedObject reason class equals: GtLStoredObjectExampleMethodReason.
	self assert: storedObject reason asReasonString equals: 'GtLExampleRunDummyExamples>>#successfulExample'.
	expected := NeoJSONObject new
		at: #className put: 'GtLExampleRunDummyExamples';
		at: #selector put: 'successfulExample';
		at: #status put: 'success';
		at: #result put: (GtLValueSerializer new serializeValue: 42);
		at: #objectId put: objectId;
		yourself.
	self assert: result serializeToLlmJsonObject equals: expected.
	^ call
]
