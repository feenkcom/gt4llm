"
Examples for GtLTestCasesWithResultStatuses domain object and data views.
"
Class {
	#name : #GtLTestCasesWithResultStatusesDomainObjectExamples,
	#superclass : #Object,
	#category : 'Gt4LlmCore-Examples-Domain Objects'
}

{ #category : #private }
GtLTestCasesWithResultStatusesDomainObjectExamples >> assertStatusesDomainObject: aDomainObject total: totalCount skipped: skippedCount success: successCount failure: failureCount error: errorCount notFound: notFoundClassNames notTestCase: notTestCaseClasses [
	"Assert all counts and properties on a GtLTestCasesWithResultStatuses."
	
	self assert: (aDomainObject isKindOf: GtLTestCasesWithResultStatuses).
	self assert: aDomainObject testCases size equals: totalCount.
	self assert: aDomainObject skippedCount equals: skippedCount.
	self assert: aDomainObject passedCount equals: successCount.
	self assert: aDomainObject failureCount equals: failureCount.
	self assert: aDomainObject errorCount equals: errorCount.
	self assert: aDomainObject runCount equals: (successCount + failureCount + errorCount).
	self assert: aDomainObject notFoundClassNames equals: notFoundClassNames.
	self assert: aDomainObject notTestCaseClasses equals: notTestCaseClasses.
]

{ #category : #private }
GtLTestCasesWithResultStatusesDomainObjectExamples >> assertTestStatus: aTestStatus hasClassName: aClassName selector: aSelector status: aStatusText [
	"Assert the properties from serializeToLlmJsonObject."
	| json |
	json := aTestStatus serializeToLlmJsonObject.
	self assert: (json at: #className) equals: aClassName.
	self assert: (json at: #selector) equals: aSelector.
	self assert: (json at: #status) equals: aStatusText.
]

{ #category : #private }
GtLTestCasesWithResultStatusesDomainObjectExamples >> assertTestStatus: aTestStatus isSuccess: isSuccess isFailure: isFailure isError: isError isSkipped: isSkipped [
	"Assert the boolean state flags of a test status."
	
	self assert: aTestStatus isPassedResult equals: isSuccess.
	self assert: aTestStatus isFailureResult equals: isFailure.
	self assert: aTestStatus isErrorResult equals: isError.
	self assert: aTestStatus isSkippedResult equals: isSkipped.
]

{ #category : #private }
GtLTestCasesWithResultStatusesDomainObjectExamples >> createTestStatusFor: aCompiledMethod [
	"Create a test status domain object for the given test method."
	| testCase testResult |
	testCase := aCompiledMethod methodClass selector: aCompiledMethod selector.
	testResult := testCase gtRunWithExplicitResult.
	^ GtLTestCaseWithResultStatus new
		testCaseWithResult: testResult
]

{ #category : #'examples - data views' }
GtLTestCasesWithResultStatusesDomainObjectExamples >> domainObjectDataViews [
	<gtExample>
	<return: #GtLTestCasesWithResultStatuses>
	| domainObject compositeView dataBlock jsonData |
	
	domainObject := self domainObjectWithMixedStatuses.
	
	compositeView := domainObject llmDataViewsFor: GtLDataView new.
	self assert: compositeView dataViews size equals: 1.
	
	dataBlock := compositeView serializeToLlmPrimiteData.
	self assert: dataBlock dataBlocks size equals: 1.
	self assert: dataBlock imageDataBlocks isEmpty.
	
	jsonData := dataBlock compositeJsonData.
	self assert: (jsonData at: #runCount) equals: 3.
	self assert: (jsonData at: #details) size equals: 4.
	
	^ domainObject
]

{ #category : #'examples - domain object' }
GtLTestCasesWithResultStatusesDomainObjectExamples >> domainObjectWithEmptyStatuses [
	<gtExample>
	<return: #GtLTestCasesWithResultStatuses>
	| domainObject |
	
	domainObject := GtLTestCasesWithResultStatuses new
		testCases: #();
		notFoundClassNames: #();
		notTestCaseClasses: #().
	
	self 
		assertStatusesDomainObject: domainObject 
		total: 0 
		skipped: 0 
		success: 0 
		failure: 0 
		error: 0 
		notFound: #()
		notTestCase: #().
	
	^ domainObject
]

{ #category : #'examples - domain object' }
GtLTestCasesWithResultStatusesDomainObjectExamples >> domainObjectWithErrorTest [
	<gtExample>
	<return: #GtLTestCasesWithResultStatuses>
	| domainObject errorStatus |
	
	errorStatus := self createTestStatusFor: (GtLExampleDummyMixedTest >> #testError).
	
	domainObject := GtLTestCasesWithResultStatuses new
		testCases: { errorStatus };
		notFoundClassNames: #();
		notTestCaseClasses: #().
	
	self 
		assertStatusesDomainObject: domainObject 
		total: 1 
		skipped: 0 
		success: 0 
		failure: 0 
		error: 1 
		notFound: #()
		notTestCase: #().
	
	self 
		assertTestStatus: errorStatus 
		isSuccess: false 
		isFailure: false 
		isError: true 
		isSkipped: false.
	
	^ domainObject
]

{ #category : #'examples - domain object' }
GtLTestCasesWithResultStatusesDomainObjectExamples >> domainObjectWithFailingTest [
	<gtExample>
	<return: #GtLTestCasesWithResultStatuses>
	| domainObject failureStatus |
	
	failureStatus := self createTestStatusFor: (GtLExampleDummyMixedTest >> #testFailure).
	
	domainObject := GtLTestCasesWithResultStatuses new
		testCases: { failureStatus };
		notFoundClassNames: #();
		notTestCaseClasses: #().
	
	self 
		assertStatusesDomainObject: domainObject 
		total: 1 
		skipped: 0 
		success: 0 
		failure: 1 
		error: 0 
		notFound: #()
		notTestCase: #().
	
	self 
		assertTestStatus: failureStatus 
		isSuccess: false 
		isFailure: true 
		isError: false 
		isSkipped: false.
	
	^ domainObject
]

{ #category : #'examples - domain object' }
GtLTestCasesWithResultStatusesDomainObjectExamples >> domainObjectWithMixedStatuses [
	<gtExample>
	<return: #GtLTestCasesWithResultStatuses>
	| domainObject successStatus failureStatus errorStatus skippedStatus |
	
	successStatus := self createTestStatusFor: (GtLExampleDummyPassingTest >> #testSuccess).
	failureStatus := self createTestStatusFor: (GtLExampleDummyMixedTest >> #testFailure).
	errorStatus := self createTestStatusFor: (GtLExampleDummyMixedTest >> #testError).
	skippedStatus := self createTestStatusFor: (GtLExampleDummyMixedTest >> #testSkip).
	
	domainObject := GtLTestCasesWithResultStatuses new
		testCases: { successStatus. failureStatus. errorStatus. skippedStatus };
		notFoundClassNames: #();
		notTestCaseClasses: #().
	
	self 
		assertStatusesDomainObject: domainObject 
		total: 4 
		skipped: 1 
		success: 1 
		failure: 1 
		error: 1 
		notFound: #()
		notTestCase: #().
	
	"Verify individual statuses"
	self assertTestStatus: successStatus isSuccess: true isFailure: false isError: false isSkipped: false.
	self assertTestStatus: failureStatus isSuccess: false isFailure: true isError: false isSkipped: false.
	self assertTestStatus: errorStatus isSuccess: false isFailure: false isError: true isSkipped: false.
	self assertTestStatus: skippedStatus isSuccess: false isFailure: false isError: false isSkipped: true.
	
	^ domainObject
]

{ #category : #'examples - domain object' }
GtLTestCasesWithResultStatusesDomainObjectExamples >> domainObjectWithNotFoundClasses [
	<gtExample>
	<return: #GtLTestCasesWithResultStatuses>
	| domainObject successStatus notFoundClasses |
	
	successStatus := self createTestStatusFor: (GtLExampleDummyPassingTest >> #testSuccess).
	notFoundClasses := #('NonExistentClass1' 'NonExistentClass2').
	
	domainObject := GtLTestCasesWithResultStatuses new
		testCases: { successStatus };
		notFoundClassNames: notFoundClasses;
		notTestCaseClasses: #().
	
	self 
		assertStatusesDomainObject: domainObject 
		total: 1 
		skipped: 0 
		success: 1 
		failure: 0 
		error: 0 
		notFound: notFoundClasses
		notTestCase: #().
	
	^ domainObject
]

{ #category : #'examples - domain object' }
GtLTestCasesWithResultStatusesDomainObjectExamples >> domainObjectWithNotTestCaseClasses [
	<gtExample>
	<return: #GtLTestCasesWithResultStatuses>
	| domainObject successStatus notTestCaseClasses |
	
	successStatus := self createTestStatusFor: (GtLExampleDummyPassingTest >> #testSuccess).
	notTestCaseClasses := { Object. String }.
	
	domainObject := GtLTestCasesWithResultStatuses new
		testCases: { successStatus };
		notFoundClassNames: #();
		notTestCaseClasses: notTestCaseClasses.
	
	self 
		assertStatusesDomainObject: domainObject 
		total: 1 
		skipped: 0 
		success: 1 
		failure: 0 
		error: 0 
		notFound: #()
		notTestCase: notTestCaseClasses.
	
	^ domainObject
]

{ #category : #'examples - domain object' }
GtLTestCasesWithResultStatusesDomainObjectExamples >> domainObjectWithSkippedTest [
	<gtExample>
	<return: #GtLTestCasesWithResultStatuses>
	| domainObject skippedStatus |
	
	skippedStatus := self createTestStatusFor: (GtLExampleDummyMixedTest >> #testSkip).
	
	domainObject := GtLTestCasesWithResultStatuses new
		testCases: { skippedStatus };
		notFoundClassNames: #();
		notTestCaseClasses: #().
	
	self 
		assertStatusesDomainObject: domainObject 
		total: 1 
		skipped: 1 
		success: 0 
		failure: 0 
		error: 0 
		notFound: #()
		notTestCase: #().
	
	self 
		assertTestStatus: skippedStatus 
		isSuccess: false 
		isFailure: false 
		isError: false 
		isSkipped: true.
	
	^ domainObject
]

{ #category : #'examples - domain object' }
GtLTestCasesWithResultStatusesDomainObjectExamples >> domainObjectWithSuccessfulTest [
	<gtExample>
	<return: #GtLTestCasesWithResultStatuses>
	| domainObject successStatus |
	
	successStatus := self createTestStatusFor: (GtLExampleDummyPassingTest >> #testSuccess).
	
	domainObject := GtLTestCasesWithResultStatuses new
		testCases: { successStatus };
		notFoundClassNames: #();
		notTestCaseClasses: #().
	
	self 
		assertStatusesDomainObject: domainObject 
		total: 1 
		skipped: 0 
		success: 1 
		failure: 0 
		error: 0 
		notFound: #()
		notTestCase: #().
	
	self 
		assertTestStatus: successStatus 
		isSuccess: true 
		isFailure: false 
		isError: false 
		isSkipped: false.
	
	^ domainObject
]

{ #category : #'examples - json serialization' }
GtLTestCasesWithResultStatusesDomainObjectExamples >> jsonSerializationForEmptyStatuses [
	<gtExample>
	<return: #NeoJSONObject>
	| domainObject jsonData expectedJson |
	
	domainObject := self domainObjectWithEmptyStatuses.
	jsonData := (domainObject llmDataViewsFor: GtLDataView new) serializeToLlmPrimiteData compositeJsonData.
	
	expectedJson := Dictionary new
		at: #runCount put: 0;
		at: #successes put: 0;
		at: #failures put: 0;
		at: #errors put: 0;
		at: #skips put: 0;
		at: #unexpectedPasses put: 0;
		at: #unexpectedFailures put: 0;
		at: #unexpectedErrors put: 0;
		at: #expectedPasses put: 0;
		at: #expectedDefects put: 0;
		at: #notFound put: #();
		at: #notTestCaseClasses put: #();
		at: #details put: #();
		yourself.
	
	self assert: jsonData equals: expectedJson.
	
	^ jsonData
]

{ #category : #'examples - json serialization' }
GtLTestCasesWithResultStatusesDomainObjectExamples >> jsonSerializationForErrorTest [
	<gtExample>
	<return: #NeoJSONObject>
	| domainObject jsonData expectedJsonOne expectedJsonTwo expectedDetail |
	
	domainObject := self domainObjectWithErrorTest.
	jsonData := (domainObject llmDataViewsFor: GtLDataView new) serializeToLlmPrimiteData compositeJsonData.
	
	expectedDetail := NeoJSONObject new
		at: #className put: 'GtLExampleDummyMixedTest';
		at: #selector put: 'testError';
		at: #status put: 'error';
		at: #result put: 'Error';
		at: #shouldPass put: true;
		at: #expectedFailure put: false;
		at: #errorDescription put: 'Boom';
		yourself.
	
	expectedJsonOne := Dictionary new
		at: #runCount put: 1;
		at: #successes put: 0;
		at: #failures put: 0;
		at: #errors put: 1;
		at: #skips put: 0;
		at: #unexpectedPasses put: 0;
		at: #unexpectedFailures put: 0;
		at: #unexpectedErrors put: 1;
		at: #expectedPasses put: 0;
		at: #expectedDefects put: 0;
		at: #notFound put: #();
		at: #notTestCaseClasses put: #();
		at: #details put: { expectedDetail };
		yourself.
	
	expectedJsonTwo := expectedJsonOne copy.
	expectedJsonTwo at: 'details' put: { expectedDetail copy }.
	(expectedJsonTwo at: 'details')  first at: 'errorDescription' put: 'Error: Boom'.
	
	self assert: ((jsonData = expectedJsonOne) or: [
		jsonData = expectedJsonTwo]).
	
	^ jsonData
]

{ #category : #'examples - json serialization' }
GtLTestCasesWithResultStatusesDomainObjectExamples >> jsonSerializationForExpectedFailure [
	<gtExample>
	<return: #NeoJSONObject>
	| domainObject jsonData expectedJsonOne expectedJsonTwo expectedDetail testStatus |
	
	testStatus := self createTestStatusFor: (GtLExampleDummyMixedTest >> #testExpectedFailure).
	
	domainObject := GtLTestCasesWithResultStatuses new
		testCases: { testStatus };
		notFoundClassNames: #();
		notTestCaseClasses: #().
	
	jsonData := (domainObject llmDataViewsFor: GtLDataView new) serializeToLlmPrimiteData compositeJsonData.
	
	expectedDetail := NeoJSONObject new
		at: #className put: 'GtLExampleDummyMixedTest';
		at: #selector put: 'testExpectedFailure';
		at: #status put: 'failure';
		at: #result put: 'Failure';
		at: #shouldPass put: false;
		at: #expectedFailure put: true;
		at: #errorDescription put: 'Assertion failed';
		yourself.
	
	expectedJsonOne := Dictionary new
		at: #runCount put: 1;
		at: #successes put: 0;
		at: #failures put: 1;
		at: #errors put: 0;
		at: #skips put: 0;
		at: #unexpectedPasses put: 0;
		at: #unexpectedFailures put: 0;
		at: #unexpectedErrors put: 0;
		at: #expectedPasses put: 0;
		at: #expectedDefects put: 1;
		at: #notFound put: #();
		at: #notTestCaseClasses put: #();
		at: #details put: { expectedDetail };
		yourself.
		
	expectedJsonTwo := expectedJsonOne copy.
	expectedJsonTwo at: 'details' put: { expectedDetail copy }.
	(expectedJsonTwo at: 'details')  first at: 'errorDescription' put: 'TestFailure: Assertion failed'.
	
	self assert: ((jsonData = expectedJsonOne) or: [jsonData = expectedJsonTwo]).
	
	^ jsonData
]

{ #category : #'examples - json serialization' }
GtLTestCasesWithResultStatusesDomainObjectExamples >> jsonSerializationForFailingTest [
	<gtExample>
	<return: #NeoJSONObject>
	| domainObject jsonData expectedJsonOne expectedJsonTwo expectedDetail |
	
	domainObject := self domainObjectWithFailingTest.
	jsonData := (domainObject llmDataViewsFor: GtLDataView new) serializeToLlmPrimiteData compositeJsonData.
	
	expectedDetail := NeoJSONObject new
		at: #className put: 'GtLExampleDummyMixedTest';
		at: #selector put: 'testFailure';
		at: #status put: 'failure';
		at: #result put: 'Failure';
		at: #shouldPass put: true;
		at: #expectedFailure put: false;
		at: #errorDescription put: 'Assertion failed';
		yourself.
	
	expectedJsonOne := Dictionary new
		at: #runCount put: 1;
		at: #successes put: 0;
		at: #failures put: 1;
		at: #errors put: 0;
		at: #skips put: 0;
		at: #unexpectedPasses put: 0;
		at: #unexpectedFailures put: 1;
		at: #unexpectedErrors put: 0;
		at: #expectedPasses put: 0;
		at: #expectedDefects put: 0;
		at: #notFound put: #();
		at: #notTestCaseClasses put: #();
		at: #details put: { expectedDetail };
		yourself.
	
	expectedJsonTwo := expectedJsonOne copy.
	expectedJsonTwo at: 'details' put: { expectedDetail copy }.
	(expectedJsonTwo at: 'details')  first at: 'errorDescription' put: 'TestFailure: Assertion failed'.
	
	self assert: ((jsonData = expectedJsonOne) or: [jsonData = expectedJsonTwo]).
	
	
	^ jsonData
]

{ #category : #'examples - json serialization' }
GtLTestCasesWithResultStatusesDomainObjectExamples >> jsonSerializationForMixedStatuses [
	<gtExample>
	<return: #NeoJSONObject>
	| domainObject jsonData expectedJsonOne expectedJsonTwo successDetail failureDetail errorDetail skippedDetail |
	
	domainObject := self domainObjectWithMixedStatuses.
	jsonData := (domainObject llmDataViewsFor: GtLDataView new) serializeToLlmPrimiteData compositeJsonData.
	
	successDetail := NeoJSONObject new
		at: #className put: 'GtLExampleDummyPassingTest';
		at: #selector put: 'testSuccess';
		at: #status put: 'success';
		at: #result put: 'Passed';
		at: #shouldPass put: true;
		at: #expectedFailure put: false;
		yourself.
	
	failureDetail := NeoJSONObject new
		at: #className put: 'GtLExampleDummyMixedTest';
		at: #selector put: 'testFailure';
		at: #status put: 'failure';
		at: #result put: 'Failure';
		at: #shouldPass put: true;
		at: #expectedFailure put: false;
		at: #errorDescription put: 'Assertion failed';
		yourself.
	
	errorDetail := NeoJSONObject new
		at: #className put: 'GtLExampleDummyMixedTest';
		at: #selector put: 'testError';
		at: #status put: 'error';
		at: #result put: 'Error';
		at: #shouldPass put: true;
		at: #expectedFailure put: false;
		at: #errorDescription put: 'Boom';
		yourself.
	
	skippedDetail := NeoJSONObject new
		at: #className put: 'GtLExampleDummyMixedTest';
		at: #selector put: 'testSkip';
		at: #status put: 'skipped';
		at: #result put: 'Skipped';
		at: #shouldPass put: true;
		at: #expectedFailure put: false;
		yourself.
	
	expectedJsonOne := Dictionary new
		at: #runCount put: 3;
		at: #successes put: 1;
		at: #failures put: 1;
		at: #errors put: 1;
		at: #skips put: 1;
		at: #unexpectedPasses put: 0;
		at: #unexpectedFailures put: 1;
		at: #unexpectedErrors put: 1;
		at: #expectedPasses put: 1;
		at: #expectedDefects put: 0;
		at: #notFound put: #();
		at: #notTestCaseClasses put: #();
		at: #details put: { successDetail. failureDetail. errorDetail. skippedDetail };
		yourself.
	
	expectedJsonTwo := expectedJsonOne copy.
	expectedJsonTwo at: 'details' put: ({  
		successDetail. failureDetail. errorDetail. skippedDetail  } collect: [ :each | each copy ]).
	(expectedJsonTwo at: 'details')  second 
		at: 'errorDescription' put: 'TestFailure: Assertion failed'.
	(expectedJsonTwo at: 'details')  third 
		at: 'errorDescription' put: 'Error: Boom'.
	
	self assert: ((jsonData = expectedJsonOne) or: [jsonData = expectedJsonTwo]).
	
	^ jsonData
]

{ #category : #'examples - json serialization' }
GtLTestCasesWithResultStatusesDomainObjectExamples >> jsonSerializationForNotFoundClasses [
	<gtExample>
	<return: #NeoJSONObject>
	| domainObject jsonData expectedJson expectedDetail |
	
	domainObject := self domainObjectWithNotFoundClasses.
	jsonData := (domainObject llmDataViewsFor: GtLDataView new) serializeToLlmPrimiteData compositeJsonData.
	
	expectedDetail := NeoJSONObject new
		at: #className put: 'GtLExampleDummyPassingTest';
		at: #selector put: 'testSuccess';
		at: #status put: 'success';
		at: #result put: 'Passed';
		at: #shouldPass put: true;
		at: #expectedFailure put: false;
		yourself.
	
	expectedJson := Dictionary new
		at: #runCount put: 1;
		at: #successes put: 1;
		at: #failures put: 0;
		at: #errors put: 0;
		at: #skips put: 0;
		at: #unexpectedPasses put: 0;
		at: #unexpectedFailures put: 0;
		at: #unexpectedErrors put: 0;
		at: #expectedPasses put: 1;
		at: #expectedDefects put: 0;
		at: #notFound put: #('NonExistentClass1' 'NonExistentClass2');
		at: #notTestCaseClasses put: #();
		at: #details put: { expectedDetail };
		yourself.
	
	self assert: jsonData equals: expectedJson.
	
	^ jsonData
]

{ #category : #'examples - json serialization' }
GtLTestCasesWithResultStatusesDomainObjectExamples >> jsonSerializationForNotTestCaseClasses [
	<gtExample>
	<return: #NeoJSONObject>
	| domainObject jsonData expectedJson expectedDetail |
	
	domainObject := self domainObjectWithNotTestCaseClasses.
	jsonData := (domainObject llmDataViewsFor: GtLDataView new) serializeToLlmPrimiteData compositeJsonData.
	
	expectedDetail := NeoJSONObject new
		at: #className put: 'GtLExampleDummyPassingTest';
		at: #selector put: 'testSuccess';
		at: #status put: 'success';
		at: #result put: 'Passed';
		at: #shouldPass put: true;
		at: #expectedFailure put: false;
		yourself.
	
	expectedJson := Dictionary new
		at: #runCount put: 1;
		at: #successes put: 1;
		at: #failures put: 0;
		at: #errors put: 0;
		at: #skips put: 0;
		at: #unexpectedPasses put: 0;
		at: #unexpectedFailures put: 0;
		at: #unexpectedErrors put: 0;
		at: #expectedPasses put: 1;
		at: #expectedDefects put: 0;
		at: #notFound put: #();
		at: #notTestCaseClasses put: { Object. String };
		at: #details put: { expectedDetail };
		yourself.
	
	self assert: jsonData equals: expectedJson.
	
	^ jsonData
]

{ #category : #'examples - json serialization' }
GtLTestCasesWithResultStatusesDomainObjectExamples >> jsonSerializationForSkippedTest [
	<gtExample>
	<return: #NeoJSONObject>
	| domainObject jsonData expectedJson expectedDetail |
	
	domainObject := self domainObjectWithSkippedTest.
	jsonData := (domainObject llmDataViewsFor: GtLDataView new) serializeToLlmPrimiteData compositeJsonData.
	
	expectedDetail := NeoJSONObject new
		at: #className put: 'GtLExampleDummyMixedTest';
		at: #selector put: 'testSkip';
		at: #status put: 'skipped';
		at: #result put: 'Skipped';
		at: #shouldPass put: true;
		at: #expectedFailure put: false;
		yourself.
	
	expectedJson := Dictionary new
		at: #runCount put: 0;
		at: #successes put: 0;
		at: #failures put: 0;
		at: #errors put: 0;
		at: #skips put: 1;
		at: #unexpectedPasses put: 0;
		at: #unexpectedFailures put: 0;
		at: #unexpectedErrors put: 0;
		at: #expectedPasses put: 0;
		at: #expectedDefects put: 0;
		at: #notFound put: #();
		at: #notTestCaseClasses put: #();
		at: #details put: { expectedDetail };
		yourself.
	
	self assert: jsonData equals: expectedJson.
	
	^ jsonData
]

{ #category : #'examples - json serialization' }
GtLTestCasesWithResultStatusesDomainObjectExamples >> jsonSerializationForSuccessfulTest [
	<gtExample>
	<return: #NeoJSONObject>
	| domainObject jsonData expectedJson expectedDetail |
	
	domainObject := self domainObjectWithSuccessfulTest.
	jsonData := (domainObject llmDataViewsFor: GtLDataView new) serializeToLlmPrimiteData compositeJsonData.
	
	expectedDetail := NeoJSONObject new
		at: #className put: 'GtLExampleDummyPassingTest';
		at: #selector put: 'testSuccess';
		at: #status put: 'success';
		at: #result put: 'Passed';
		at: #shouldPass put: true;
		at: #expectedFailure put: false;
		yourself.
	
	expectedJson := Dictionary new
		at: #runCount put: 1;
		at: #successes put: 1;
		at: #failures put: 0;
		at: #errors put: 0;
		at: #skips put: 0;
		at: #unexpectedPasses put: 0;
		at: #unexpectedFailures put: 0;
		at: #unexpectedErrors put: 0;
		at: #expectedPasses put: 1;
		at: #expectedDefects put: 0;
		at: #notFound put: #();
		at: #notTestCaseClasses put: #();
		at: #details put: { expectedDetail };
		yourself.
	
	self assert: jsonData equals: expectedJson.
	
	^ jsonData
]
