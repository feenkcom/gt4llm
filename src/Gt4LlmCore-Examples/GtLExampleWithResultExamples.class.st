"
Examples for GtLExampleWithResultDomainObject data views.
"
Class {
	#name : #GtLExampleWithResultExamples,
	#superclass : #GtLDomainObjectExamples,
	#traits : 'TGtLExceptionResultAssertions',
	#classTraits : 'TGtLExceptionResultAssertions classTrait',
	#category : 'Gt4LlmCore-Examples-Domain Objects'
}

{ #category : #private }
GtLExampleWithResultExamples >> assertDomainObject: domainObject isSuccess: isSuccess statusText: statusText className: className selector: selector objectId: objectId [
	self assert: domainObject isSuccessResult equals: isSuccess.
	self assert: domainObject statusText equals: statusText.
	self assert: domainObject exampleWithResult methodClass name equals: className.
	self assert: domainObject exampleWithResult selector equals: selector.
	self assert: domainObject objectId equals: objectId.
]

{ #category : #private }
GtLExampleWithResultExamples >> assertExampleData: jsonData forMethod: aCompiledMethod status: statusString [
	| exampleRefJson |
	self assertJsonData: jsonData hasExpectedKeys: #('exampleReference' 'exampleStatus' #result).
	exampleRefJson := jsonData at: 'exampleReference'.
	self assert: (exampleRefJson at: 'exampleClassName') equals: aCompiledMethod methodClass instanceSide name asString.
	self assert: (exampleRefJson at: 'methodName') equals: aCompiledMethod selector asString.
	self assert: (exampleRefJson at: 'classSide') equals: aCompiledMethod methodClass isClassSide.
	self assert: (jsonData at: 'exampleStatus') equals: statusString.
]

{ #category : #private }
GtLExampleWithResultExamples >> assertObjectValue: objectValueJson className: className printString: printString superclassName: superclassName packageName: packageName instanceSlots: instanceSlots [
	self assert: (objectValueJson at: 'objectClassName') equals: className.
	self 
		assert: ((objectValueJson at: 'objectPrintString') copyWithoutAll: ' ') 
		equals: (printString copyWithoutAll: ' ').
	self assert: (objectValueJson at: 'superclassName') equals: superclassName.
	self assert: (objectValueJson at: 'packageName') equals: packageName.
	self assert: (objectValueJson at: 'allInstanceSlots') asArray equals: instanceSlots.
]

{ #category : #private }
GtLExampleWithResultExamples >> assertObjectValue: objectValueJson hasPhlowViews: expectedPhlowViews [
	| actualPhlowViews |
	actualPhlowViews := (objectValueJson at: 'phlowViews') collect: [ :each |
		{ 'title' -> (each at: 'title'). 'methodName' -> (each at: 'methodName') } asDictionary ].
	self assert: actualPhlowViews asArray equals: expectedPhlowViews.
]

{ #category : #private }
GtLExampleWithResultExamples >> assertSuccessResult: resultJson objectId: objectId objectDetails: expectedObjectDetails [
	self assertJsonData: resultJson hasExpectedKeys: #('objectDetails' #objectId #objectValue).
	self assert: (resultJson at: #objectId) equals: objectId.
	self assert: (resultJson at: 'objectDetails') equals: expectedObjectDetails.
]

{ #category : #examples }
GtLExampleWithResultExamples >> exampleWithResultForComparisonFailure [
	<gtExample>
	<return: #GtLExampleWithResult>
	| method domainObject compositeView dataBlock jsonData resultJson |
	
	method := GtLExampleRunDummyExamples >> #failingExampleWithComparisonFailures.
	domainObject := GtLExampleWithResult new
		exampleWithResult: (self runExampleMethod: method);
		objectId: nil.
	
	self 
		assertDomainObject: domainObject 
		isSuccess: false 
		statusText: 'error' 
		className: #GtLExampleRunDummyExamples 
		selector: #failingExampleWithComparisonFailures 
		objectId: nil.
	self assert: domainObject isErrorResult.
	
	compositeView := domainObject llmDataViewsFor: GtLDataView new.
	self assert: compositeView dataViews size equals: 3.
	
	dataBlock := compositeView serializeToLlmPrimiteData.
	self assert: dataBlock dataBlocks size equals: 2.
	self assert: dataBlock imageDataBlocks size equals: 1.
	
	jsonData := dataBlock compositeJsonData.
	self assertExampleData: jsonData forMethod: method status: 'error'.
	
	resultJson := jsonData at: #result.
	self 
		assertExceptionResult: resultJson 
		errorClass: 'GtLExampleDataComparisonException' 
		errorMessage: 'GtLExampleDataComparisonException' 
		stackTraceIncludes: #('GtLExampleRunDummyExamples>>failingExampleWithComparisonFailures').
	
	^ domainObject
]

{ #category : #examples }
GtLExampleWithResultExamples >> exampleWithResultForFailingExample [
	<gtExample>
	<return: #GtLExampleWithResult>
	| method domainObject compositeView dataBlock jsonData resultJson |
	
	method := GtLExampleRunDummyExamples >> #failingExample.
	domainObject := GtLExampleWithResult new
		exampleWithResult: (self runExampleMethod: method);
		objectId: nil.
	
	self 
		assertDomainObject: domainObject 
		isSuccess: false 
		statusText: 'failure' 
		className: #GtLExampleRunDummyExamples 
		selector: #failingExample 
		objectId: nil.
	
	compositeView := domainObject llmDataViewsFor: GtLDataView new.
	self assert: compositeView dataViews size equals: 3.
	
	dataBlock := compositeView serializeToLlmPrimiteData.
	self assertDataBlockHasOnlyJsonData: dataBlock.
	
	jsonData := dataBlock compositeJsonData.
	self assertExampleData: jsonData forMethod: method status: 'failure'.
	
	resultJson := jsonData at: #result.
	self 
		assertExceptionResult: resultJson 
		errorClass: 'AssertionFailure' 
		errorMessage: 'Assertion failed' 
		stackTraceIncludes: #('GtLExampleRunDummyExamples>>failingExample' 'AssertionFailure').
	
	^ domainObject
]

{ #category : #examples }
GtLExampleWithResultExamples >> exampleWithResultForSuccessfulExample [
	<gtExample>
	<return: #GtLExampleWithResult>
	| method domainObject compositeView dataBlock jsonData resultJson objectValueJson expectedPhlowViews |
	
	method := GtLExampleRunDummyExamples >> #successfulExample.
	domainObject := GtLExampleWithResult new
		exampleWithResult: (self runExampleMethod: method);
		objectId: 'test-object-id'.
	
	self 
		assertDomainObject: domainObject 
		isSuccess: true 
		statusText: 'success' 
		className: #GtLExampleRunDummyExamples 
		selector: #successfulExample 
		objectId: 'test-object-id'.
	
	compositeView := domainObject llmDataViewsFor: GtLDataView new.
	self assert: compositeView dataViews size equals: 3.
	
	dataBlock := compositeView serializeToLlmPrimiteData.
	self assertDataBlockHasOnlyJsonData: dataBlock.
	
	jsonData := dataBlock compositeJsonData.
	self assertExampleData: jsonData forMethod: method status: 'success'.
	
	resultJson := jsonData at: #result.
	self assertSuccessResult: resultJson objectId: 'test-object-id' objectDetails: Dictionary new.
	
	objectValueJson := resultJson at: #objectValue.
	self 
		assertObjectValue: objectValueJson 
		className: 'SmallInteger' 
		printString: '42' 
		superclassName: 'Integer' 
		packageName: 'Kernel' 
		instanceSlots: #().
	
	expectedPhlowViews := {
		{ 'title' -> 'Preview'. 'methodName' -> 'gtPreviewFor:' } asDictionary.
		{ 'title' -> 'Integer'. 'methodName' -> 'gtIntegerFor:' } asDictionary.
		{ 'title' -> 'Raw'. 'methodName' -> 'gtRawFor:' } asDictionary.
		{ 'title' -> 'Print'. 'methodName' -> 'gtPrintFor:' } asDictionary.
		{ 'title' -> 'Meta'. 'methodName' -> 'gtMetaFor:' } asDictionary
	}.
	self assertObjectValue: objectValueJson hasPhlowViews: expectedPhlowViews.
	
	^ domainObject
]

{ #category : #examples }
GtLExampleWithResultExamples >> exampleWithResultForSuccessfulExampleWithDataJsonView [
	<gtExample>
	<return: #GtLExampleWithResult>
	| method domainObject compositeView dataBlock jsonData resultJson objectValueJson expectedObjectDetails expectedInstanceSlots expectedPhlowViews |
	
	method := GtLExampleRunDummyExamples >> #successfulExampleWithObjectWithADataJsonView.
	domainObject := GtLExampleWithResult new
		exampleWithResult: (self runExampleMethod: method);
		objectId: 'test-object-id'.
	
	self 
		assertDomainObject: domainObject 
		isSuccess: true 
		statusText: 'success' 
		className: #GtLExampleRunDummyExamples 
		selector: #successfulExampleWithObjectWithADataJsonView 
		objectId: 'test-object-id'.
	
	compositeView := domainObject llmDataViewsFor: GtLDataView new.
	self assert: compositeView dataViews size equals: 3.
	
	dataBlock := compositeView serializeToLlmPrimiteData.
	self assertDataBlockHasOnlyJsonData: dataBlock.
	
	jsonData := dataBlock compositeJsonData.
	self assertExampleData: jsonData forMethod: method status: 'success'.
	
	resultJson := jsonData at: #result.
	expectedObjectDetails := Dictionary new
		at: 'valueOne' put: 1;
		at: 'valueTwo' put: 2;
		yourself.
	self assertSuccessResult: resultJson objectId: 'test-object-id' objectDetails: expectedObjectDetails.
	
	objectValueJson := resultJson at: #objectValue.
	expectedInstanceSlots := {
		(NeoJSONObject new at: 'name' put: 'slotOne'; at: 'valueClassName' put: 'ByteString'; at: 'valuePrintString' put: 'AValue'; yourself).
		(NeoJSONObject new at: 'name' put: 'slotTwo'; at: 'valueClassName' put: 'SmallInteger'; at: 'valuePrintString' put: '42'; yourself)
	}.
	self 
		assertObjectValue: objectValueJson 
		className: 'GtLObjectWithADataJsonViewForTest' 
		printString: 'a GtLObjectWithADataJsonViewForTest' 
		superclassName: 'Object' 
		packageName: 'Gt4LlmCore-Examples' 
		instanceSlots: expectedInstanceSlots.
	
	expectedPhlowViews := {
		{ 'title' -> 'Raw'. 'methodName' -> 'gtRawFor:' } asDictionary.
		{ 'title' -> 'Print'. 'methodName' -> 'gtPrintFor:' } asDictionary.
		{ 'title' -> 'Meta'. 'methodName' -> 'gtMetaFor:' } asDictionary
	}.
	self assertObjectValue: objectValueJson hasPhlowViews: expectedPhlowViews.
	
	^ domainObject
]

{ #category : #private }
GtLExampleWithResultExamples >> runExampleMethod: aCompiledMethod [
	"Run the given example method and return the example with result."
	| example |
	example := aCompiledMethod gtExample asExampleWithResult.
	example run.
	^ example
]
