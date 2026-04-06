"
Examples for GtLToolForTestMethodRun.
"
Class {
	#name : #GtLToolForTestMethodRunExamples,
	#superclass : #Object,
	#traits : 'TGtLExceptionResultAssertions',
	#classTraits : 'TGtLExceptionResultAssertions classTrait',
	#category : #'Gt4LlmCore-Examples'
}

{ #category : #assertions }
GtLToolForTestMethodRunExamples >> assertJsonData: jsonData hasExpectedKeys: expectedKeys [
	self assert: jsonData keys sorted equals: expectedKeys sorted
]

{ #category : #'examples - comparison failure' }
GtLToolForTestMethodRunExamples >> exampleRunComparisonFailure [
	<gtExample>
	<return: #GtLFunctionToolCall>
	| tool call result targetObject dataBlock jsonData exceptionData |
	tool := GtLToolForTestMethodRun new.
	call := GtLFunctionToolCall new.
	call rawArguments: {
		'testReference' -> {
			'testClassName' -> 'GtLExampleDummyMixedTest'.
			'methodName' -> 'testComparisonFailure'
		} asDictionary
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	self assert: result isErrorDomainObject not.
	
	targetObject := result targetObject.
	self assert: (targetObject isKindOf: GtLTestCaseWithResultDomainObject).
	self assert: targetObject isErrorResult.
	self assert: targetObject statusText equals: 'error'.
	
	dataBlock := result mainDataView serializeToLlmPrimiteData.
	self assert: dataBlock dataBlocks size equals: 2.
	self assert: dataBlock imageDataBlocks size equals: 1.
	
	jsonData := dataBlock llmJsonData.
	self assert: (jsonData at: #className) equals: 'GtLExampleDummyMixedTest'.
	self assert: (jsonData at: #selector) equals: 'testComparisonFailure'.
	self assert: (jsonData at: #status) equals: 'error'.
	self assert: (jsonData at: #result) equals: 'Error'.
	
	exceptionData := jsonData at: #exception.
	self 
		assertExceptionResult: exceptionData 
		errorClass: 'GtLExampleDataComparisonException' 
		errorMessage: 'GtLExampleDataComparisonException' 
		stackTraceIncludes: #('GtLExampleDummyMixedTest>>testComparisonFailure').
	
	^ call
]

{ #category : #examples }
GtLToolForTestMethodRunExamples >> exampleRunError [
	<gtExample>
	<return: #GtLFunctionToolCall>
	| tool call result targetObject |
	tool := GtLToolForTestMethodRun new.
	call := GtLFunctionToolCall new.
	call rawArguments: {
		'testReference' -> {
			'testClassName' -> 'GtLExampleDummyMixedTest'.
			'methodName' -> 'testError'
		} asDictionary
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	self assert: result isErrorDomainObject not.
	
	targetObject := result targetObject.
	self assert: (targetObject isKindOf: GtLTestCaseWithResultDomainObject).
	self assert: targetObject isErrorResult.
	self assert: targetObject statusText equals: 'error'.
	^ call
]

{ #category : #examples }
GtLToolForTestMethodRunExamples >> exampleRunFailure [
	<gtExample>
	<return: #GtLFunctionToolCall>
	| tool call result targetObject |
	tool := GtLToolForTestMethodRun new.
	call := GtLFunctionToolCall new.
	call rawArguments: {
		'testReference' -> {
			'testClassName' -> 'GtLExampleDummyMixedTest'.
			'methodName' -> 'testFailure'
		} asDictionary
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	self assert: result isErrorDomainObject not.
	
	targetObject := result targetObject.
	self assert: (targetObject isKindOf: GtLTestCaseWithResultDomainObject).
	self assert: targetObject isFailureResult.
	self assert: targetObject statusText equals: 'failure'.
	^ call
]

{ #category : #'examples - failure' }
GtLToolForTestMethodRunExamples >> exampleRunFailureWithJsonAssertions [
	<gtExample>
	<return: #GtLFunctionToolCall>
	| tool call result targetObject dataBlock jsonData exceptionData |
	tool := GtLToolForTestMethodRun new.
	call := GtLFunctionToolCall new.
	call rawArguments: {
		'testReference' -> {
			'testClassName' -> 'GtLExampleDummyMixedTest'.
			'methodName' -> 'testFailure'
		} asDictionary
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	self assert: result isErrorDomainObject not.
	
	targetObject := result targetObject.
	self assert: (targetObject isKindOf: GtLTestCaseWithResultDomainObject).
	self assert: targetObject isFailureResult.
	self assert: targetObject statusText equals: 'failure'.
	
	dataBlock := result mainDataView serializeToLlmPrimiteData.
	jsonData := dataBlock llmJsonData.
	
	self assert: (jsonData at: #className) equals: 'GtLExampleDummyMixedTest'.
	self assert: (jsonData at: #selector) equals: 'testFailure'.
	self assert: (jsonData at: #status) equals: 'failure'.
	self assert: (jsonData at: #result) equals: 'Failure'.
	
	exceptionData := jsonData at: #exception.
	self 
		assertExceptionResult: exceptionData 
		errorClass: 'TestFailure' 
		errorMessage: 'Assertion failed' 
		stackTraceIncludes: #('GtLExampleDummyMixedTest>>testFailure').
	
	^ call
]

{ #category : #'examples - errors' }
GtLToolForTestMethodRunExamples >> exampleRunForNonTestCaseClass [
	<gtExample>
	<return: #GtLFunctionToolCall>
	| tool call result targetObject |
	tool := GtLToolForTestMethodRun new.
	call := GtLFunctionToolCall new.
	call rawArguments: {
		'testReference' -> {
			'testClassName' -> 'Object'.
			'methodName' -> 'printString'
		} asDictionary
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	self assert: result isErrorDomainObject.
	
	targetObject := result targetObject.
	self assert: (targetObject isKindOf: GtLIncorrectArgumentTypeDomainObject).
	self assert: targetObject argumentName equals: 'testClassName'.
	self assert: targetObject expectedArgumentValueKind equals: 'a subclass of TestCase'.
	^ call
]

{ #category : #'examples - errors' }
GtLToolForTestMethodRunExamples >> exampleRunForUnknownClass [
	<gtExample>
	<return: #GtLFunctionToolCall>
	| tool call result targetObject |
	tool := GtLToolForTestMethodRun new.
	call := GtLFunctionToolCall new.
	call rawArguments: {
		'testReference' -> {
			'testClassName' -> 'UnknownClassXYZ'.
			'methodName' -> 'testSomething'
		} asDictionary
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: result isErrorDomainObject.
	
	targetObject := result targetObject.
	self assert: (targetObject isKindOf: GtLMissingDomainObject).
	self assert: targetObject objectName equals: 'UnknownClassXYZ'.
	^ call
]

{ #category : #'examples - errors' }
GtLToolForTestMethodRunExamples >> exampleRunForUnknownMethod [
	<gtExample>
	<return: #GtLFunctionToolCall>
	| tool call result targetObject |
	tool := GtLToolForTestMethodRun new.
	call := GtLFunctionToolCall new.
	call rawArguments: {
		'testReference' -> {
			'testClassName' -> 'GtLExampleDummyMixedTest'.
			'methodName' -> 'unknownMethod'
		} asDictionary
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: result isErrorDomainObject.
	
	targetObject := result targetObject.
	self assert: (targetObject isKindOf: GtLMissingDomainObject).
	self assert: targetObject objectName equals: 'GtLExampleDummyMixedTest>>#unknownMethod'.
	^ call
]

{ #category : #examples }
GtLToolForTestMethodRunExamples >> exampleRunSkipped [
	<gtExample>
	<return: #GtLFunctionToolCall>
	| tool call result targetObject |
	tool := GtLToolForTestMethodRun new.
	call := GtLFunctionToolCall new.
	call rawArguments: {
		'testReference' -> {
			'testClassName' -> 'GtLExampleDummyMixedTest'.
			'methodName' -> 'testSkip'
		} asDictionary
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	self assert: result isErrorDomainObject not.
	
	targetObject := result targetObject.
	self assert: (targetObject isKindOf: GtLTestCaseWithResultDomainObject).
	self assert: targetObject isSkippedResult.
	self assert: targetObject statusText equals: 'skipped'.
	^ call
]

{ #category : #examples }
GtLToolForTestMethodRunExamples >> exampleRunSuccess [
	<gtExample>
	<return: #GtLFunctionToolCall>
	| tool call result targetObject |
	tool := GtLToolForTestMethodRun new.
	call := GtLFunctionToolCall new.
	call rawArguments: {
		'testReference' -> {
			'testClassName' -> 'GtLExampleDummyMixedTest'.
			'methodName' -> 'testPass'
		} asDictionary
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (call arguments at: 'testReference') class equals: GtLTestReference.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	self assert: result isErrorDomainObject not.
	
	targetObject := result targetObject.
	self assert: (targetObject isKindOf: GtLTestCaseWithResultDomainObject).
	self assert: targetObject isSuccessResult.
	self assert: targetObject statusText equals: 'success'.
	^ call
]

{ #category : #examples }
GtLToolForTestMethodRunExamples >> exampleRunSuccessWithDataViewSerialization [
	<gtExample>
	<return: #GtLFunctionToolCall>
	| tool call result dataBlock jsonData |
	tool := GtLToolForTestMethodRun new.
	call := GtLFunctionToolCall new.
	call rawArguments: {
		'testReference' -> {
			'testClassName' -> 'GtLExampleDummyMixedTest'.
			'methodName' -> 'testPass'
		} asDictionary
	} asDictionary.
	result := tool performToolCall: call.
	
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	dataBlock := result mainDataView serializeToLlmPrimiteData.
	jsonData := dataBlock llmJsonData.
	
	self assert: (jsonData at: #className) equals: 'GtLExampleDummyMixedTest'.
	self assert: (jsonData at: #selector) equals: 'testPass'.
	self assert: (jsonData at: #status) equals: 'success'.
	self assert: (jsonData at: #result) equals: 'Passed'.
	self assert: (jsonData at: #shouldPass) equals: true.
	self assert: (jsonData at: #expectedFailure) equals: false.
	
	^ call
]
