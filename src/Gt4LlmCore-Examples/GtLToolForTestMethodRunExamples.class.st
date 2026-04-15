"
Examples for GtLToolForTestMethodRun.
"
Class {
	#name : #GtLToolForTestMethodRunExamples,
	#superclass : #GtLAbstractMagritteFunctionToolExamples,
	#traits : 'TGtLExceptionResultAssertions',
	#classTraits : 'TGtLExceptionResultAssertions classTrait',
	#category : #'Gt4LlmCore-Examples-Tools'
}

{ #category : #assertions }
GtLToolForTestMethodRunExamples >> assertJsonData: jsonData hasExpectedKeys: expectedKeys [
	self assert: jsonData keys sorted equals: expectedKeys sorted
]

{ #category : #examples }
GtLToolForTestMethodRunExamples >> exampleRunComparisonFailure [
	<gtExample>
	<return: #GtLTestCaseWithResultDomainObject>
	| call targetObject dataBlock jsonData exceptionData compositeView |
	
	call := self
		executeTool: GtLToolForTestMethodRun new
		withArguments: {
			'testReference' -> {
				'testClassName' -> 'GtLExampleDummyMixedTest'.
				'methodName' -> 'testComparisonFailure'
			} asDictionary
		} asDictionary.
	targetObject := call result targetObject.
	
	self assert: (targetObject isKindOf: GtLTestCaseWithResultDomainObject).
	self assert: targetObject isErrorResult.
	self assert: targetObject statusText equals: 'error'.
	
	compositeView := targetObject llmDataViewsFor: GtLDataView new.
	dataBlock := compositeView serializeToLlmPrimiteData.
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
	<return: #GtLTestCaseWithResultDomainObject>
	| call targetObject |
	
	call := self
		executeTool: GtLToolForTestMethodRun new
		withArguments: {
			'testReference' -> {
				'testClassName' -> 'GtLExampleDummyMixedTest'.
				'methodName' -> 'testError'
			} asDictionary
		} asDictionary.
	targetObject := call result targetObject.
	
	self assert: (targetObject isKindOf: GtLTestCaseWithResultDomainObject).
	self assert: targetObject isErrorResult.
	self assert: targetObject statusText equals: 'error'.
	
	^ call
]

{ #category : #examples }
GtLToolForTestMethodRunExamples >> exampleRunFailure [
	<gtExample>
	<return: #GtLTestCaseWithResultDomainObject>
	| call targetObject |
	
	call := self
		executeTool: GtLToolForTestMethodRun new
		withArguments: {
			'testReference' -> {
				'testClassName' -> 'GtLExampleDummyMixedTest'.
				'methodName' -> 'testFailure'
			} asDictionary
		} asDictionary.
	targetObject := call result targetObject.
	
	self assert: (targetObject isKindOf: GtLTestCaseWithResultDomainObject).
	self assert: targetObject isFailureResult.
	self assert: targetObject statusText equals: 'failure'.
	
	^ call
]

{ #category : #examples }
GtLToolForTestMethodRunExamples >> exampleRunFailureWithJsonAssertions [
	<gtExample>
	<return: #GtLTestCaseWithResultDomainObject>
	| call targetObject dataBlock jsonData exceptionData compositeView |
	
	call := self
		executeTool: GtLToolForTestMethodRun new
		withArguments: {
			'testReference' -> {
				'testClassName' -> 'GtLExampleDummyMixedTest'.
				'methodName' -> 'testFailure'
			} asDictionary
		} asDictionary.
	targetObject := call result targetObject.
	
	self assert: (targetObject isKindOf: GtLTestCaseWithResultDomainObject).
	self assert: targetObject isFailureResult.
	self assert: targetObject statusText equals: 'failure'.
	
	compositeView := targetObject llmDataViewsFor: GtLDataView new.
	dataBlock := compositeView serializeToLlmPrimiteData.
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

{ #category : #examples }
GtLToolForTestMethodRunExamples >> exampleRunForNonTestCaseClass [
	<gtExample>
	<return: #GtLIncorrectArgumentTypeDomainObject>
	| call |
	call := self
		executeTool: GtLToolForTestMethodRun new
		withArguments: {
			'testReference' -> {
				'testClassName' -> 'Object'.
				'methodName' -> 'printString'
			} asDictionary
		} asDictionary.
	self
		assertIncorrectArgumentType: call result targetObject
		withArgumentName: 'testClassName'
		argumentValue: 'Object'
		expectedKind: 'a subclass of TestCase'.
	^ call
]

{ #category : #examples }
GtLToolForTestMethodRunExamples >> exampleRunForUnknownClass [
	<gtExample>
	| call |
	call := self
		executeTool: GtLToolForTestMethodRun new
		withArguments: {
			'testReference' -> {
				'testClassName' -> 'UnknownClassXYZ'.
				'methodName' -> 'testSomething'
			} asDictionary
		} asDictionary.
	self
		assertMissingObject: call result targetObject
		withObjectName: 'UnknownClassXYZ'
		errorMessage: 'UnknownClassXYZ is not found'.
	^ call
]

{ #category : #examples }
GtLToolForTestMethodRunExamples >> exampleRunForUnknownMethod [
	<gtExample>
	| call |
	call := self
		executeTool: GtLToolForTestMethodRun new
		withArguments: {
			'testReference' -> {
				'testClassName' -> 'GtLExampleDummyMixedTest'.
				'methodName' -> 'unknownMethod'
			} asDictionary
		} asDictionary.
	self
		assertMissingObject: call result targetObject
		withObjectName: 'GtLExampleDummyMixedTest>>#unknownMethod'
		errorMessage: 'GtLExampleDummyMixedTest>>#unknownMethod is not found'.
	^ call
]

{ #category : #examples }
GtLToolForTestMethodRunExamples >> exampleRunSkipped [
	<gtExample>
	<return: #GtLTestCaseWithResultDomainObject>
	| call targetObject |
	
	call := self
		executeTool: GtLToolForTestMethodRun new
		withArguments: {
			'testReference' -> {
				'testClassName' -> 'GtLExampleDummyMixedTest'.
				'methodName' -> 'testSkip'
			} asDictionary
		} asDictionary.
	targetObject := call result targetObject.
	
	self assert: (targetObject isKindOf: GtLTestCaseWithResultDomainObject).
	self assert: targetObject isSkippedResult.
	self assert: targetObject statusText equals: 'skipped'.
	
	^ call
]

{ #category : #examples }
GtLToolForTestMethodRunExamples >> exampleRunSuccess [
	<gtExample>
	<return: #GtLTestCaseWithResultDomainObject>
	| call targetObject |
	
	call := self
		executeTool: GtLToolForTestMethodRun new
		withArguments: {
			'testReference' -> {
				'testClassName' -> 'GtLExampleDummyMixedTest'.
				'methodName' -> 'testPass'
			} asDictionary
		} asDictionary.
	targetObject := call result targetObject.
	
	self assert: (targetObject isKindOf: GtLTestCaseWithResultDomainObject).
	self assert: targetObject isSuccessResult.
	self assert: targetObject statusText equals: 'success'.
	
	^ call
]

{ #category : #examples }
GtLToolForTestMethodRunExamples >> exampleRunSuccessWithDataViewSerialization [
	<gtExample>
	<return: #GtLTestCaseWithResultDomainObject>
	| call targetObject dataBlock jsonData compositeView |
	call := self
		executeTool: GtLToolForTestMethodRun new
		withArguments: {
			'testReference' -> {
				'testClassName' -> 'GtLExampleDummyMixedTest'.
				'methodName' -> 'testPass'
			} asDictionary
		} asDictionary.
	targetObject := call result targetObject.
	compositeView := targetObject llmDataViewsFor: GtLDataView new.
	dataBlock := compositeView serializeToLlmPrimiteData.
	jsonData := dataBlock llmJsonData.
	self assert: (jsonData at: #className) equals: 'GtLExampleDummyMixedTest'.
	self assert: (jsonData at: #selector) equals: 'testPass'.
	self assert: (jsonData at: #status) equals: 'success'.
	self assert: (jsonData at: #result) equals: 'Passed'.
	self assert: (jsonData at: #shouldPass) equals: true.
	self assert: (jsonData at: #expectedFailure) equals: false.
	^ call
]
