"
Examples for GtLToolForTestMethodRun.
"
Class {
	#name : #GtLToolForTestMethodRunExamples,
	#superclass : #GtLAbstractMagritteFunctionToolExamples,
	#traits : 'TGtLExceptionResultAssertions',
	#classTraits : 'TGtLExceptionResultAssertions classTrait',
	#category : #'Gt4LlmCore-Examples'
}

{ #category : #assertions }
GtLToolForTestMethodRunExamples >> assertJsonData: jsonData hasExpectedKeys: expectedKeys [
	self assert: jsonData keys sorted equals: expectedKeys sorted
]

{ #category : #examples }
GtLToolForTestMethodRunExamples >> exampleRunComparisonFailure [
	<gtExample>
	<return: #GtLTestCaseWithResultDomainObject>
	| targetObject dataBlock jsonData exceptionData compositeView |
	
	targetObject := self
		executeTool: GtLToolForTestMethodRun new
		withArguments: {
			'testReference' -> {
				'testClassName' -> 'GtLExampleDummyMixedTest'.
				'methodName' -> 'testComparisonFailure'
			} asDictionary
		} asDictionary.
	
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
	
	^ targetObject
]

{ #category : #examples }
GtLToolForTestMethodRunExamples >> exampleRunError [
	<gtExample>
	<return: #GtLTestCaseWithResultDomainObject>
	| targetObject |
	
	targetObject := self
		executeTool: GtLToolForTestMethodRun new
		withArguments: {
			'testReference' -> {
				'testClassName' -> 'GtLExampleDummyMixedTest'.
				'methodName' -> 'testError'
			} asDictionary
		} asDictionary.
	
	self assert: (targetObject isKindOf: GtLTestCaseWithResultDomainObject).
	self assert: targetObject isErrorResult.
	self assert: targetObject statusText equals: 'error'.
	
	^ targetObject
]

{ #category : #examples }
GtLToolForTestMethodRunExamples >> exampleRunFailure [
	<gtExample>
	<return: #GtLTestCaseWithResultDomainObject>
	| targetObject |
	
	targetObject := self
		executeTool: GtLToolForTestMethodRun new
		withArguments: {
			'testReference' -> {
				'testClassName' -> 'GtLExampleDummyMixedTest'.
				'methodName' -> 'testFailure'
			} asDictionary
		} asDictionary.
	
	self assert: (targetObject isKindOf: GtLTestCaseWithResultDomainObject).
	self assert: targetObject isFailureResult.
	self assert: targetObject statusText equals: 'failure'.
	
	^ targetObject
]

{ #category : #examples }
GtLToolForTestMethodRunExamples >> exampleRunFailureWithJsonAssertions [
	<gtExample>
	<return: #GtLTestCaseWithResultDomainObject>
	| targetObject dataBlock jsonData exceptionData compositeView |
	
	targetObject := self
		executeTool: GtLToolForTestMethodRun new
		withArguments: {
			'testReference' -> {
				'testClassName' -> 'GtLExampleDummyMixedTest'.
				'methodName' -> 'testFailure'
			} asDictionary
		} asDictionary.
	
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
	
	^ targetObject
]

{ #category : #examples }
GtLToolForTestMethodRunExamples >> exampleRunForNonTestCaseClass [
	<gtExample>
	<return: #GtLIncorrectArgumentTypeDomainObject>
	| targetObject |
	
	targetObject := self
		executeTool: GtLToolForTestMethodRun new
		withArguments: {
			'testReference' -> {
				'testClassName' -> 'Object'.
				'methodName' -> 'printString'
			} asDictionary
		} asDictionary.
	
	self
		assertIncorrectArgumentType: targetObject
		withArgumentName: 'testClassName'
		argumentValue: 'Object'
		expectedKind: 'a subclass of TestCase'.
	
	^ targetObject
]

{ #category : #examples }
GtLToolForTestMethodRunExamples >> exampleRunForUnknownClass [
	<gtExample>
	<return: #GtLMissingObjectDomainObject>
	| targetObject |
	
	targetObject := self
		executeTool: GtLToolForTestMethodRun new
		withArguments: {
			'testReference' -> {
				'testClassName' -> 'UnknownClassXYZ'.
				'methodName' -> 'testSomething'
			} asDictionary
		} asDictionary.
	
	self
		assertMissingObject: targetObject
		withObjectName: 'UnknownClassXYZ'
		errorMessage: 'UnknownClassXYZ is not found'.
	
	^ targetObject
]

{ #category : #examples }
GtLToolForTestMethodRunExamples >> exampleRunForUnknownMethod [
	<gtExample>
	<return: #GtLMissingObjectDomainObject>
	| targetObject |
	
	targetObject := self
		executeTool: GtLToolForTestMethodRun new
		withArguments: {
			'testReference' -> {
				'testClassName' -> 'GtLExampleDummyMixedTest'.
				'methodName' -> 'unknownMethod'
			} asDictionary
		} asDictionary.
	
	self
		assertMissingObject: targetObject
		withObjectName: 'GtLExampleDummyMixedTest>>#unknownMethod'
		errorMessage: 'GtLExampleDummyMixedTest>>#unknownMethod is not found'.
	
	^ targetObject
]

{ #category : #examples }
GtLToolForTestMethodRunExamples >> exampleRunSkipped [
	<gtExample>
	<return: #GtLTestCaseWithResultDomainObject>
	| targetObject |
	
	targetObject := self
		executeTool: GtLToolForTestMethodRun new
		withArguments: {
			'testReference' -> {
				'testClassName' -> 'GtLExampleDummyMixedTest'.
				'methodName' -> 'testSkip'
			} asDictionary
		} asDictionary.
	
	self assert: (targetObject isKindOf: GtLTestCaseWithResultDomainObject).
	self assert: targetObject isSkippedResult.
	self assert: targetObject statusText equals: 'skipped'.
	
	^ targetObject
]

{ #category : #examples }
GtLToolForTestMethodRunExamples >> exampleRunSuccess [
	<gtExample>
	<return: #GtLTestCaseWithResultDomainObject>
	| targetObject |
	
	targetObject := self
		executeTool: GtLToolForTestMethodRun new
		withArguments: {
			'testReference' -> {
				'testClassName' -> 'GtLExampleDummyMixedTest'.
				'methodName' -> 'testPass'
			} asDictionary
		} asDictionary.
	
	self assert: (targetObject isKindOf: GtLTestCaseWithResultDomainObject).
	self assert: targetObject isSuccessResult.
	self assert: targetObject statusText equals: 'success'.
	
	^ targetObject
]

{ #category : #examples }
GtLToolForTestMethodRunExamples >> exampleRunSuccessWithDataViewSerialization [
	<gtExample>
	<return: #GtLTestCaseWithResultDomainObject>
	| targetObject dataBlock jsonData compositeView |
	
	targetObject := self
		executeTool: GtLToolForTestMethodRun new
		withArguments: {
			'testReference' -> {
				'testClassName' -> 'GtLExampleDummyMixedTest'.
				'methodName' -> 'testPass'
			} asDictionary
		} asDictionary.
	
	compositeView := targetObject llmDataViewsFor: GtLDataView new.
	dataBlock := compositeView serializeToLlmPrimiteData.
	jsonData := dataBlock llmJsonData.
	
	self assert: (jsonData at: #className) equals: 'GtLExampleDummyMixedTest'.
	self assert: (jsonData at: #selector) equals: 'testPass'.
	self assert: (jsonData at: #status) equals: 'success'.
	self assert: (jsonData at: #result) equals: 'Passed'.
	self assert: (jsonData at: #shouldPass) equals: true.
	self assert: (jsonData at: #expectedFailure) equals: false.
	
	^ targetObject
]
