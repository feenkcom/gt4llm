"
Examples for GtLTestCaseWithResultDomainObject data views.
"
Class {
	#name : #GtLTestCaseWithResultDomainObjectExamples,
	#superclass : #Object,
	#traits : 'TGtLExceptionResultAssertions',
	#classTraits : 'TGtLExceptionResultAssertions classTrait',
	#category : #'Gt4LlmCore-Examples-Domain Objects'
}

{ #category : #assertions }
GtLTestCaseWithResultDomainObjectExamples >> assertJsonData: jsonData hasExpectedKeys: expectedKeys [
	self assert: jsonData keys sorted equals: expectedKeys sorted
]

{ #category : #private }
GtLTestCaseWithResultDomainObjectExamples >> runTestMethod: aCompiledMethod [
	"Run the given test method and return the test case with result."
	| testCase |
	testCase := aCompiledMethod methodClass selector: aCompiledMethod selector.
	^ testCase gtRunWithExplicitResult
]

{ #category : #'examples - comparison failure' }
GtLTestCaseWithResultDomainObjectExamples >> testCaseWithResultForComparisonFailure [
	<gtExample>
	<return: #GtLTestCaseWithResultDomainObject>
	| method domainObject compositeView dataBlock jsonData exceptionData |
	
	method := GtLExampleDummyMixedTest >> #testComparisonFailure.
	domainObject := GtLTestCaseWithResultDomainObject new
		testCaseWithResult: (self runTestMethod: method).
	
	self assert: domainObject isErrorResult.
	self assert: domainObject statusText equals: 'error'.
	self assert: domainObject messageText equals: 'Error'.
	
	compositeView := domainObject llmDataViewsFor: GtLDataView new.
	self assert: compositeView dataViews size equals: 2.
	
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
	
	^ domainObject
]

{ #category : #'examples - error' }
GtLTestCaseWithResultDomainObjectExamples >> testCaseWithResultForErrorTest [
	<gtExample>
	<return: #GtLTestCaseWithResultDomainObject>
	| method domainObject compositeView dataBlock jsonData exceptionData |
	
	method := GtLExampleDummyMixedTest >> #testError.
	domainObject := GtLTestCaseWithResultDomainObject new
		testCaseWithResult: (self runTestMethod: method).
	
	self assert: domainObject isErrorResult.
	self assert: domainObject isSuccessResult not.
	self assert: domainObject statusText equals: 'error'.
	self assert: domainObject messageText equals: 'Error'.
	
	compositeView := domainObject llmDataViewsFor: GtLDataView new.
	self assert: compositeView dataViews size equals: 2.
	
	dataBlock := compositeView serializeToLlmPrimiteData.
	jsonData := dataBlock llmJsonData.
	self assert: (jsonData at: #className) equals: 'GtLExampleDummyMixedTest'.
	self assert: (jsonData at: #selector) equals: 'testError'.
	self assert: (jsonData at: #status) equals: 'error'.
	self assert: (jsonData at: #result) equals: 'Error'.
	
	exceptionData := jsonData at: #exception.
	self 
		assertExceptionResult: exceptionData 
		errorClass: 'Error' 
		errorMessage: 'Boom' 
		stackTraceIncludes: #('GtLExampleDummyMixedTest>>testError').
	
	^ domainObject
]

{ #category : #'examples - expected failure' }
GtLTestCaseWithResultDomainObjectExamples >> testCaseWithResultForExpectedFailureTest [
	<gtExample>
	<return: #GtLTestCaseWithResultDomainObject>
	| method domainObject jsonData dataBlock |
	
	method := GtLExampleDummyMixedTest >> #testExpectedFailure.
	domainObject := GtLTestCaseWithResultDomainObject new
		testCaseWithResult: (self runTestMethod: method).
	
	self assert: domainObject isExpectedDefectResult.
	self assert: domainObject isFailureResult.
	
	dataBlock := (domainObject llmDataViewsFor: GtLDataView new) serializeToLlmPrimiteData.
	jsonData := dataBlock llmJsonData.
	self assert: (jsonData at: #className) equals: 'GtLExampleDummyMixedTest'.
	self assert: (jsonData at: #selector) equals: 'testExpectedFailure'.
	self assert: (jsonData at: #status) equals: 'failure'.
	self assert: (jsonData at: #shouldPass) equals: false.
	self assert: (jsonData at: #expectedFailure) equals: true.
	
	^ domainObject
]

{ #category : #'examples - failure' }
GtLTestCaseWithResultDomainObjectExamples >> testCaseWithResultForFailingTest [
	<gtExample>
	<return: #GtLTestCaseWithResultDomainObject>
	| method domainObject compositeView dataBlock jsonData exceptionData |
	
	method := GtLExampleDummyMixedTest >> #testFailure.
	domainObject := GtLTestCaseWithResultDomainObject new
		testCaseWithResult: (self runTestMethod: method).
	
	self assert: domainObject isFailureResult.
	self assert: domainObject isSuccessResult not.
	self assert: domainObject statusText equals: 'failure'.
	self assert: domainObject messageText equals: 'Failure'.
	
	compositeView := domainObject llmDataViewsFor: GtLDataView new.
	self assert: compositeView dataViews size equals: 2.
	
	dataBlock := compositeView serializeToLlmPrimiteData.
	self assert: dataBlock dataBlocks size equals: 1.
	
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
	
	^ domainObject
]

{ #category : #'examples - success' }
GtLTestCaseWithResultDomainObjectExamples >> testCaseWithResultForPassingTest [
	<gtExample>
	<return: #GtLTestCaseWithResultDomainObject>
	| method domainObject compositeView dataBlock jsonData expectedJson |
	
	method := GtLExampleDummyMixedTest >> #testPass.
	domainObject := GtLTestCaseWithResultDomainObject new
		testCaseWithResult: (self runTestMethod: method).
	
	self assert: domainObject isSuccessResult.
	self assert: domainObject isPassedResult.
	self assert: domainObject statusText equals: 'success'.
	self assert: domainObject messageText equals: 'Passed'.
	self assert: domainObject isErrorDomainObject not.
	
	compositeView := domainObject llmDataViewsFor: GtLDataView new.
	self assert: compositeView dataViews size equals: 2.
	
	dataBlock := compositeView serializeToLlmPrimiteData.
	self assert: dataBlock dataBlocks size equals: 1.
	self assert: dataBlock imageDataBlocks isEmpty.
	
	jsonData := dataBlock llmJsonData.
	expectedJson := {
		#className -> 'GtLExampleDummyMixedTest'.
		#selector -> 'testPass'.
		#status -> 'success'.
		#result -> 'Passed'.
		#shouldPass -> true.
		#expectedFailure -> false
	} asDictionary.
	self assert: jsonData equals: expectedJson.
	
	^ domainObject
]

{ #category : #'examples - skipped' }
GtLTestCaseWithResultDomainObjectExamples >> testCaseWithResultForSkippedTest [
	<gtExample>
	<return: #GtLTestCaseWithResultDomainObject>
	| method domainObject compositeView dataBlock jsonData expectedJson |
	
	method := GtLExampleDummyMixedTest >> #testSkip.
	domainObject := GtLTestCaseWithResultDomainObject new
		testCaseWithResult: (self runTestMethod: method).
	
	self assert: domainObject isSkippedResult.
	self assert: domainObject isSuccessResult not.
	self assert: domainObject statusText equals: 'skipped'.
	self assert: domainObject messageText equals: 'Skipped'.
	
	compositeView := domainObject llmDataViewsFor: GtLDataView new.
	dataBlock := compositeView serializeToLlmPrimiteData.
	jsonData := dataBlock llmJsonData.
	
	expectedJson := {
		#className -> 'GtLExampleDummyMixedTest'.
		#selector -> 'testSkip'.
		#status -> 'skipped'.
		#result -> 'Skipped'.
		#shouldPass -> true.
		#expectedFailure -> false
	} asDictionary.
	self assert: jsonData equals: expectedJson.
	
	^ domainObject
]
