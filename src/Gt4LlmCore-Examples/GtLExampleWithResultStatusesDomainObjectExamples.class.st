"
Examples for GtLExampleWithResultStatusesDomainObject domain object and data views.
"
Class {
	#name : #GtLExampleWithResultStatusesDomainObjectExamples,
	#superclass : #Object,
	#category : 'Gt4LlmCore-Examples-Domain Objects'
}

{ #category : #assertions }
GtLExampleWithResultStatusesDomainObjectExamples >> assertDetailJson: detailJson hasClassName: className selector: selector status: status objectId: objectId [
	"Assert the JSON detail structure from llmJsonObject details."
	
	self assert: (detailJson at: #className) equals: className.
	self assert: (detailJson at: #selector) equals: selector.
	self assert: (detailJson at: #status) equals: status.
	self assert: (detailJson at: #objectId) equals: objectId.
]

{ #category : #assertions }
GtLExampleWithResultStatusesDomainObjectExamples >> assertExampleStatus: anExampleStatus hasClassName: aClassName selector: aSelector status: aStatusText objectId: expectedObjectId [
	"Assert the properties from llmJsonObject."
	
	self assert: anExampleStatus exampleWithResult methodClass name asString equals: aClassName.
	self assert: anExampleStatus exampleWithResult selector asString equals: aSelector.
	self assert: anExampleStatus statusText equals: aStatusText.
	self assert: anExampleStatus objectId equals: expectedObjectId.
]

{ #category : #assertions }
GtLExampleWithResultStatusesDomainObjectExamples >> assertExampleStatus: anExampleStatus isSuccess: isSuccess isFailure: isFailure isError: isError isSkipped: isSkipped [
	"Assert the boolean state flags of an example status."
	
	self assert: anExampleStatus isSuccessResult equals: isSuccess.
	self assert: anExampleStatus isFailureResult equals: isFailure.
	self assert: anExampleStatus isErrorResult equals: isError.
	self assert: anExampleStatus isSkippedResult equals: isSkipped.
]

{ #category : #assertions }
GtLExampleWithResultStatusesDomainObjectExamples >> assertLlmJsonObject: jsonData hasTotal: totalCount successes: successCount failures: failureCount errors: errorCount skips: skippedCount notFound: notFoundClassNames detailsCount: detailsCount [
	"Assert the JSON object representation."
	
	self assert: (jsonData at: #total) equals: totalCount.
	self assert: (jsonData at: #successes) equals: successCount.
	self assert: (jsonData at: #failures) equals: failureCount.
	self assert: (jsonData at: #errors) equals: errorCount.
	self assert: (jsonData at: #skips) equals: skippedCount.
	self assert: (jsonData at: #notFound) equals: notFoundClassNames.
	self assert: (jsonData at: #details) size equals: detailsCount.
]

{ #category : #assertions }
GtLExampleWithResultStatusesDomainObjectExamples >> assertStatusesDomainObject: aDomainObject total: totalCount skipped: skippedCount success: successCount failure: failureCount error: errorCount notFound: notFoundClassNames [
	"Assert all counts and properties on a GtLExampleWithResultStatusesDomainObject."
	
	self assert: (aDomainObject isKindOf: GtLExampleWithResultStatusesDomainObject).
	self assert: aDomainObject totalCount equals: totalCount.
	self assert: aDomainObject skippedCount equals: skippedCount.
	self assert: aDomainObject successResultCount equals: successCount.
	self assert: aDomainObject failureResultCount equals: failureCount.
	self assert: aDomainObject errorResultCount equals: errorCount.
	self assert: aDomainObject exampleWithStatuses size equals: totalCount.
	self assert: aDomainObject notFoundClassNames equals: notFoundClassNames.
]

{ #category : #private }
GtLExampleWithResultStatusesDomainObjectExamples >> createExampleStatusFor: aCompiledMethod withObjectId: anObjectIdOrNil [
	"Create an example status domain object for the given method."
	^ GtLExampleWithResultStatusDomainObject new
		exampleWithResult: (self runExampleMethod: aCompiledMethod);
		objectId: anObjectIdOrNil
]

{ #category : #private }
GtLExampleWithResultStatusesDomainObjectExamples >> createSkippedExampleStatusFor: aCompiledMethod withObjectId: anObjectIdOrNil [
	"Create an example status domain object for a skipped example (not run)."
	| example |
	example := aCompiledMethod gtExample asExampleWithResult.
	"Don't run the example - it will be in skipped state"
	^ GtLExampleWithResultStatusDomainObject new
		exampleWithResult: example;
		objectId: anObjectIdOrNil
]

{ #category : #'examples - data views' }
GtLExampleWithResultStatusesDomainObjectExamples >> domainObjectDataViews [
	<gtExample>
	<return: #GtLExampleWithResultStatusesDomainObject>
	| domainObject compositeView dataBlock jsonData |
	
	domainObject := self domainObjectWithMixedStatuses.
	
	compositeView := domainObject llmDataViewsFor: GtLDataView new.
	self assert: compositeView dataViews size equals: 1.
	
	dataBlock := compositeView serializeToLlmPrimiteData.
	self assert: dataBlock dataBlocks size equals: 1.
	self assert: dataBlock imageDataBlocks isEmpty.
	
	jsonData := dataBlock compositeJsonData.
	self assert: (jsonData at: #total) equals: 4.
	self assert: (jsonData at: #details) size equals: 4.
	
	^ domainObject
]

{ #category : #examples }
GtLExampleWithResultStatusesDomainObjectExamples >> domainObjectWithEmptyStatuses [
	<gtExample>
	<return: #GtLExampleWithResultStatusesDomainObject>
	| domainObject |
	
	domainObject := GtLExampleWithResultStatusesDomainObject new
		exampleWithStatuses: #();
		notFoundClassNames: #().
	
	self 
		assertStatusesDomainObject: domainObject 
		total: 0 
		skipped: 0 
		success: 0 
		failure: 0 
		error: 0 
		notFound: #().
	
	^ domainObject
]

{ #category : #examples }
GtLExampleWithResultStatusesDomainObjectExamples >> domainObjectWithErrorExample [
	<gtExample>
	<return: #GtLExampleWithResultStatusesDomainObject>
	| domainObject errorStatus jsonData |
	
	errorStatus := self createExampleStatusFor: (GtLExampleRunDummyExamples >> #errorExample) withObjectId: nil.
	
	domainObject := GtLExampleWithResultStatusesDomainObject new
		exampleWithStatuses: { errorStatus };
		notFoundClassNames: #().
	
	self 
		assertStatusesDomainObject: domainObject 
		total: 1 
		skipped: 0 
		success: 0 
		failure: 0 
		error: 1 
		notFound: #().
	
	self 
		assertExampleStatus: errorStatus 
		isSuccess: false 
		isFailure: false 
		isError: true 
		isSkipped: false.
	
	self 
		assertExampleStatus: errorStatus 
		hasClassName: 'GtLExampleRunDummyExamples' 
		selector: 'errorExample' 
		status: 'error' 
		objectId: nil.
	
	jsonData := domainObject llmJsonObject.
	self 
		assertLlmJsonObject: jsonData 
		hasTotal: 1 
		successes: 0 
		failures: 0 
		errors: 1 
		skips: 0 
		notFound: #() 
		detailsCount: 1.
	
	^ domainObject
]

{ #category : #examples }
GtLExampleWithResultStatusesDomainObjectExamples >> domainObjectWithFailingExample [
	<gtExample>
	<return: #GtLExampleWithResultStatusesDomainObject>
	| domainObject failureStatus jsonData |
	
	failureStatus := self createExampleStatusFor: (GtLExampleRunDummyExamples >> #failingExample) withObjectId: nil.
	
	domainObject := GtLExampleWithResultStatusesDomainObject new
		exampleWithStatuses: { failureStatus };
		notFoundClassNames: #().
	
	self 
		assertStatusesDomainObject: domainObject 
		total: 1 
		skipped: 0 
		success: 0 
		failure: 1 
		error: 0 
		notFound: #().
	
	self 
		assertExampleStatus: failureStatus 
		isSuccess: false 
		isFailure: true 
		isError: false 
		isSkipped: false.
	
	self 
		assertExampleStatus: failureStatus 
		hasClassName: 'GtLExampleRunDummyExamples' 
		selector: 'failingExample' 
		status: 'failure' 
		objectId: nil.
	
	jsonData := domainObject llmJsonObject.
	self 
		assertLlmJsonObject: jsonData 
		hasTotal: 1 
		successes: 0 
		failures: 1 
		errors: 0 
		skips: 0 
		notFound: #() 
		detailsCount: 1.
	
	^ domainObject
]

{ #category : #examples }
GtLExampleWithResultStatusesDomainObjectExamples >> domainObjectWithMixedStatuses [
	<gtExample>
	<return: #GtLExampleWithResultStatusesDomainObject>
	| domainObject successStatus failureStatus errorStatus skippedStatus jsonData |
	
	successStatus := self createExampleStatusFor: (GtLExampleRunDummyExamples >> #successfulExample) withObjectId: 'success-id'.
	failureStatus := self createExampleStatusFor: (GtLExampleRunDummyExamples >> #failingExample) withObjectId: nil.
	errorStatus := self createExampleStatusFor: (GtLExampleRunDummyExamples >> #errorExample) withObjectId: nil.
	skippedStatus := self createSkippedExampleStatusFor: (GtLExampleRunDummyExamples >> #successfulExampleWithObjectWithADataJsonView) withObjectId: nil.
	
	domainObject := GtLExampleWithResultStatusesDomainObject new
		exampleWithStatuses: { successStatus. failureStatus. errorStatus. skippedStatus };
		notFoundClassNames: #().
	
	self 
		assertStatusesDomainObject: domainObject 
		total: 4 
		skipped: 1 
		success: 1 
		failure: 1 
		error: 1 
		notFound: #().
	
	"Verify individual statuses"
	self assertExampleStatus: successStatus isSuccess: true isFailure: false isError: false isSkipped: false.
	self assertExampleStatus: failureStatus isSuccess: false isFailure: true isError: false isSkipped: false.
	self assertExampleStatus: errorStatus isSuccess: false isFailure: false isError: true isSkipped: false.
	self assertExampleStatus: skippedStatus isSuccess: false isFailure: false isError: false isSkipped: true.
	
	jsonData := domainObject llmJsonObject.
	self 
		assertLlmJsonObject: jsonData 
		hasTotal: 4 
		successes: 1 
		failures: 1 
		errors: 1 
		skips: 1 
		notFound: #() 
		detailsCount: 4.
	
	^ domainObject
]

{ #category : #examples }
GtLExampleWithResultStatusesDomainObjectExamples >> domainObjectWithNotFoundClasses [
	<gtExample>
	<return: #GtLExampleWithResultStatusesDomainObject>
	| domainObject successStatus jsonData notFoundClasses |
	
	successStatus := self createExampleStatusFor: (GtLExampleRunDummyExamples >> #successfulExample) withObjectId: 'test-id'.
	notFoundClasses := #('NonExistentClass1' 'NonExistentClass2').
	
	domainObject := GtLExampleWithResultStatusesDomainObject new
		exampleWithStatuses: { successStatus };
		notFoundClassNames: notFoundClasses.
	
	self 
		assertStatusesDomainObject: domainObject 
		total: 1 
		skipped: 0 
		success: 1 
		failure: 0 
		error: 0 
		notFound: notFoundClasses.
	
	jsonData := domainObject llmJsonObject.
	self 
		assertLlmJsonObject: jsonData 
		hasTotal: 1 
		successes: 1 
		failures: 0 
		errors: 0 
		skips: 0 
		notFound: notFoundClasses 
		detailsCount: 1.
	
	^ domainObject
]

{ #category : #examples }
GtLExampleWithResultStatusesDomainObjectExamples >> domainObjectWithSkippedExample [
	<gtExample>
	<return: #GtLExampleWithResultStatusesDomainObject>
	| domainObject skippedStatus jsonData |
	
	skippedStatus := self createSkippedExampleStatusFor: (GtLExampleRunDummyExamples >> #successfulExample) withObjectId: nil.
	
	domainObject := GtLExampleWithResultStatusesDomainObject new
		exampleWithStatuses: { skippedStatus };
		notFoundClassNames: #().
	
	self 
		assertStatusesDomainObject: domainObject 
		total: 1 
		skipped: 1 
		success: 0 
		failure: 0 
		error: 0 
		notFound: #().
	
	self 
		assertExampleStatus: skippedStatus 
		isSuccess: false 
		isFailure: false 
		isError: false 
		isSkipped: true.
	
	self 
		assertExampleStatus: skippedStatus 
		hasClassName: 'GtLExampleRunDummyExamples' 
		selector: 'successfulExample' 
		status: 'skipped' 
		objectId: nil.
	
	jsonData := domainObject llmJsonObject.
	self 
		assertLlmJsonObject: jsonData 
		hasTotal: 1 
		successes: 0 
		failures: 0 
		errors: 0 
		skips: 1 
		notFound: #() 
		detailsCount: 1.
	
	^ domainObject
]

{ #category : #examples }
GtLExampleWithResultStatusesDomainObjectExamples >> domainObjectWithSuccessfulExample [
	<gtExample>
	<return: #GtLExampleWithResultStatusesDomainObject>
	| domainObject successStatus jsonData |
	
	successStatus := self createExampleStatusFor: (GtLExampleRunDummyExamples >> #successfulExample) withObjectId: 'test-obj-id'.
	
	domainObject := GtLExampleWithResultStatusesDomainObject new
		exampleWithStatuses: { successStatus };
		notFoundClassNames: #().
	
	"GtLExampleRunDummyExamples has <noTest> pragma, so it's skipped but still has a result"
	self 
		assertStatusesDomainObject: domainObject 
		total: 1 
		skipped: 0 
		success: 1 
		failure: 0 
		error: 0 
		notFound: #().
	
	self 
		assertExampleStatus: successStatus 
		isSuccess: true 
		isFailure: false 
		isError: false 
		isSkipped: false.
	
	self 
		assertExampleStatus: successStatus 
		hasClassName: 'GtLExampleRunDummyExamples' 
		selector: 'successfulExample' 
		status: 'success' 
		objectId: 'test-obj-id'.
	
	jsonData := domainObject llmJsonObject.
	self 
		assertLlmJsonObject: jsonData 
		hasTotal: 1 
		successes: 1 
		failures: 0 
		errors: 0 
		skips: 0 
		notFound: #() 
		detailsCount: 1.
	
	^ domainObject
]

{ #category : #private }
GtLExampleWithResultStatusesDomainObjectExamples >> findExampleStatusFor: aSelector in: aDomainObject [
	"Find an example status by selector in the domain object."
	^ aDomainObject exampleWithStatuses 
		detect: [ :es | es exampleWithResult example method selector = aSelector ]
]

{ #category : #'examples - json' }
GtLExampleWithResultStatusesDomainObjectExamples >> jsonSerializationForEmptyStatuses [
	<gtExample>
	<return: #NeoJSONObject>
	| domainObject jsonData expectedJson |
	
	domainObject := self domainObjectWithEmptyStatuses.
	jsonData := domainObject llmJsonObject.
	
	expectedJson := NeoJSONObject new
		at: #total put: 0;
		at: #successes put: 0;
		at: #failures put: 0;
		at: #errors put: 0;
		at: #skips put: 0;
		at: #notFound put: #();
		at: #details put: #();
		yourself.
	
	self assert: jsonData equals: expectedJson.
	
	^ jsonData
]

{ #category : #'examples - json serialization' }
GtLExampleWithResultStatusesDomainObjectExamples >> jsonSerializationForErrorExample [
	<gtExample>
	<return: #NeoJSONObject>
	| domainObject jsonData expectedJson expectedDetail errorDetails |
	
	domainObject := self domainObjectWithErrorExample.
	jsonData := domainObject llmJsonObject.
	
	errorDetails := NeoJSONObject new
		at: #errorMessage put: 'Intentional example error';
		at: #errorClass put: 'Error';
		yourself.
	
	expectedDetail := NeoJSONObject new
		at: #className put: 'GtLExampleRunDummyExamples';
		at: #selector put: 'errorExample';
		at: #status put: 'error';
		at: #objectId put: nil;
		at: #errorDetails put: errorDetails;
		yourself.
	
	expectedJson := NeoJSONObject new
		at: #total put: 1;
		at: #successes put: 0;
		at: #failures put: 0;
		at: #errors put: 1;
		at: #skips put: 0;
		at: #notFound put: #();
		at: #details put: { expectedDetail };
		yourself.
	
	self assert: jsonData equals: expectedJson.
	
	^ jsonData
]

{ #category : #'examples - json serialization' }
GtLExampleWithResultStatusesDomainObjectExamples >> jsonSerializationForFailingExample [
	<gtExample>
	<return: #NeoJSONObject>
	| domainObject jsonData expectedJson expectedDetail errorDetails |
	
	domainObject := self domainObjectWithFailingExample.
	jsonData := domainObject llmJsonObject.
	
	errorDetails := NeoJSONObject new
		at: #errorMessage put: 'Assertion failed';
		at: #errorClass put: 'AssertionFailure';
		yourself.
	
	expectedDetail := NeoJSONObject new
		at: #className put: 'GtLExampleRunDummyExamples';
		at: #selector put: 'failingExample';
		at: #status put: 'failure';
		at: #objectId put: nil;
		at: #errorDetails put: errorDetails;
		yourself.
	
	expectedJson := NeoJSONObject new
		at: #total put: 1;
		at: #successes put: 0;
		at: #failures put: 1;
		at: #errors put: 0;
		at: #skips put: 0;
		at: #notFound put: #();
		at: #details put: { expectedDetail };
		yourself.
	
	self assert: jsonData equals: expectedJson.
	
	^ jsonData
]

{ #category : #'examples - json serialization' }
GtLExampleWithResultStatusesDomainObjectExamples >> jsonSerializationForMixedStatuses [
	<gtExample>
	<return: #NeoJSONObject>
	| domainObject jsonData expectedJson successDetail failureDetail errorDetail skippedDetail failureErrorDetails errorErrorDetails |
	
	domainObject := self domainObjectWithMixedStatuses.
	jsonData := domainObject llmJsonObject.
	
	successDetail := NeoJSONObject new
		at: #className put: 'GtLExampleRunDummyExamples';
		at: #selector put: 'successfulExample';
		at: #status put: 'success';
		at: #objectId put: 'success-id';
		yourself.
	
	failureErrorDetails := NeoJSONObject new
		at: #errorMessage put: 'Assertion failed';
		at: #errorClass put: 'AssertionFailure';
		yourself.
	
	failureDetail := NeoJSONObject new
		at: #className put: 'GtLExampleRunDummyExamples';
		at: #selector put: 'failingExample';
		at: #status put: 'failure';
		at: #objectId put: nil;
		at: #errorDetails put: failureErrorDetails;
		yourself.
	
	errorErrorDetails := NeoJSONObject new
		at: #errorMessage put: 'Intentional example error';
		at: #errorClass put: 'Error';
		yourself.
	
	errorDetail := NeoJSONObject new
		at: #className put: 'GtLExampleRunDummyExamples';
		at: #selector put: 'errorExample';
		at: #status put: 'error';
		at: #objectId put: nil;
		at: #errorDetails put: errorErrorDetails;
		yourself.
	
	skippedDetail := NeoJSONObject new
		at: #className put: 'GtLExampleRunDummyExamples';
		at: #selector put: 'successfulExampleWithObjectWithADataJsonView';
		at: #status put: 'skipped';
		at: #objectId put: nil;
		yourself.
	
	expectedJson := NeoJSONObject new
		at: #total put: 4;
		at: #successes put: 1;
		at: #failures put: 1;
		at: #errors put: 1;
		at: #skips put: 1;
		at: #notFound put: #();
		at: #details put: { successDetail. failureDetail. errorDetail. skippedDetail };
		yourself.
	
	self assert: jsonData equals: expectedJson.
	
	^ jsonData
]

{ #category : #'examples - json serialization' }
GtLExampleWithResultStatusesDomainObjectExamples >> jsonSerializationForNotFoundClasses [
	<gtExample>
	<return: #NeoJSONObject>
	| domainObject jsonData expectedJson expectedDetail |
	
	domainObject := self domainObjectWithNotFoundClasses.
	jsonData := domainObject llmJsonObject.
	
	expectedDetail := NeoJSONObject new
		at: #className put: 'GtLExampleRunDummyExamples';
		at: #selector put: 'successfulExample';
		at: #status put: 'success';
		at: #objectId put: 'test-id';
		yourself.
	
	expectedJson := NeoJSONObject new
		at: #total put: 1;
		at: #successes put: 1;
		at: #failures put: 0;
		at: #errors put: 0;
		at: #skips put: 0;
		at: #notFound put: #('NonExistentClass1' 'NonExistentClass2');
		at: #details put: { expectedDetail };
		yourself.
	
	self assert: jsonData equals: expectedJson.
	
	^ jsonData
]

{ #category : #'examples - json serialization' }
GtLExampleWithResultStatusesDomainObjectExamples >> jsonSerializationForSkippedExample [
	<gtExample>
	<return: #NeoJSONObject>
	| domainObject jsonData expectedJson expectedDetail |
	
	domainObject := self domainObjectWithSkippedExample.
	jsonData := domainObject llmJsonObject.
	
	expectedDetail := NeoJSONObject new
		at: #className put: 'GtLExampleRunDummyExamples';
		at: #selector put: 'successfulExample';
		at: #status put: 'skipped';
		at: #objectId put: nil;
		yourself.
	
	expectedJson := NeoJSONObject new
		at: #total put: 1;
		at: #successes put: 0;
		at: #failures put: 0;
		at: #errors put: 0;
		at: #skips put: 1;
		at: #notFound put: #();
		at: #details put: { expectedDetail };
		yourself.
	
	self assert: jsonData equals: expectedJson.
	
	^ jsonData
]

{ #category : #'examples - json serialization' }
GtLExampleWithResultStatusesDomainObjectExamples >> jsonSerializationForSuccessfulExample [
	<gtExample>
	<return: #NeoJSONObject>
	| domainObject jsonData expectedJson expectedDetail |
	
	domainObject := self domainObjectWithSuccessfulExample.
	jsonData := domainObject llmJsonObject.
	
	expectedDetail := NeoJSONObject new
		at: #className put: 'GtLExampleRunDummyExamples';
		at: #selector put: 'successfulExample';
		at: #status put: 'success';
		at: #objectId put: 'test-obj-id';
		yourself.
	
	expectedJson := NeoJSONObject new
		at: #total put: 1;
		at: #successes put: 1;
		at: #failures put: 0;
		at: #errors put: 0;
		at: #skips put: 0;
		at: #notFound put: #();
		at: #details put: { expectedDetail };
		yourself.
	
	self assert: jsonData equals: expectedJson.
	
	^ jsonData
]

{ #category : #private }
GtLExampleWithResultStatusesDomainObjectExamples >> runExampleMethod: aCompiledMethod [
	"Run the given example method and return the example with result."
	| example |
	example := aCompiledMethod gtExample asExampleWithResult.
	example run.
	^ example
]
