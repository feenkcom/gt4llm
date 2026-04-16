Class {
	#name : #GtLObjectStorageValueResultExamples,
	#superclass : #GtLDomainObjectExamples,
	#category : #'Gt4LlmCore-Examples-Domain Objects'
}

{ #category : #assertions }
GtLObjectStorageValueResultExamples >> assertObjectDetailsJson: objectDetailsJson hasErrorMessage: expectedErrorMessage errorClass: expectedErrorClass stackTraceIncludes: expectedStackTraceStrings [
	"Assert that the objectDetails JSON contains the expected exception data."
	
	self assert: (objectDetailsJson at: 'errorMessage') equals: expectedErrorMessage.
	self assert: (objectDetailsJson at: 'errorClass') equals: expectedErrorClass.
	
	expectedStackTraceStrings do: [ :expectedString |
		self assert: ((objectDetailsJson at: 'stackTrace') includesSubstring: expectedString) ]
]

{ #category : #assertions }
GtLObjectStorageValueResultExamples >> assertObjectStorageValueResultJsonDataKeys: jsonData [
	| expectedKeys expectedObjectValueKeys objectValueJson |
	expectedKeys := #('objectDetails' #objectId #objectValue).
	self assertJsonData: jsonData hasExpectedKeys: expectedKeys.
	
	objectValueJson := jsonData at: #objectValue.
	expectedObjectValueKeys := #(#allInstanceSlots #objectClassName #objectPrintString #packageName #phlowViews #superclassName).
	self assertJsonData: objectValueJson hasExpectedKeys: expectedObjectValueKeys
]

{ #category : #assertions }
GtLObjectStorageValueResultExamples >> assertObjectValueJson: objectValueJson includesPhlowViews: expectedMethodNames [
	| phlowViews phlowViewMethodNames |
	phlowViews := objectValueJson at: 'phlowViews'.
	self assert: phlowViews isNotEmpty.
	phlowViewMethodNames := phlowViews collect: [ :each | each at: 'methodName' ].
	expectedMethodNames do: [ :methodName |
		self assert: (phlowViewMethodNames includes: methodName) ]
]

{ #category : #examples }
GtLObjectStorageValueResultExamples >> objectStorageValueResultForBlElement [
	<gtExample>
	<return: #GtLObjectStorageValueResult>
	| domainObject compositeView dataBlock jsonData objectValueJson imageBlock |
	
	domainObject := GtLObjectStorageValueResult forObject: BlElement new withId: 'element-id-001'.
	self assert: domainObject object class equals: BlElement.
	self assert: domainObject objectId equals: 'element-id-001'.
	
	compositeView := domainObject llmDataViewsFor: GtLDataView new.
	self assert: compositeView dataViews size equals: 2.
	
	dataBlock := compositeView serializeToLlmPrimiteData.
	self assert: dataBlock dataBlocks size equals: 2.
	self assert: dataBlock imageDataBlocks size equals: 1.
	
	imageBlock := dataBlock imageDataBlocks first.
	self assert: imageBlock imageBytes isNotEmpty.
	self assert: imageBlock imageType equals: 'png'.
	
	jsonData := dataBlock compositeJsonData.
	self assertObjectStorageValueResultJsonDataKeys: jsonData.
	self assert: (jsonData at: #objectId) equals: 'element-id-001'.
	self assert: (jsonData at: 'objectDetails') isEmpty.
	
	objectValueJson := jsonData at: #objectValue.
	self assert: (objectValueJson at: 'objectClassName') equals: 'BlElement'.
	self assert: (objectValueJson at: 'superclassName') equals: 'Object'.
	self assert: (objectValueJson at: 'packageName') equals: 'Bloc'.
	self assert: (objectValueJson at: 'allInstanceSlots') isNotEmpty.
	self assertObjectValueJson: objectValueJson includesPhlowViews: #('gtPrintFor:' 'gtRawFor:' 'gtLiveFor:' 'gtPreviewFor:').
	
	^ domainObject
]

{ #category : #examples }
GtLObjectStorageValueResultExamples >> objectStorageValueResultForCollection [
	<gtExample>
	<return: #GtLObjectStorageValueResult>
	| domainObject compositeView dataBlock jsonData objectValueJson |
	
	domainObject := GtLObjectStorageValueResult forObject: #(1 2 3) withId: 'array-id-789'.
	self assert: domainObject object equals: #(1 2 3).
	self assert: domainObject objectId equals: 'array-id-789'.
	
	compositeView := domainObject llmDataViewsFor: GtLDataView new.
	self assert: compositeView dataViews size equals: 2.
	
	dataBlock := compositeView serializeToLlmPrimiteData.
	self assertDataBlockHasOnlyJsonData: dataBlock.
	
	jsonData := dataBlock compositeJsonData.
	self assertObjectStorageValueResultJsonDataKeys: jsonData.
	self assert: (jsonData at: #objectId) equals: 'array-id-789'.
	self assert: (jsonData at: 'objectDetails') isEmpty.
	
	objectValueJson := jsonData at: #objectValue.
	self assert: (objectValueJson at: 'objectClassName') equals: 'Array'.
	self assert: (objectValueJson at: 'superclassName') equals: 'ArrayedCollection'.
	self assert: (objectValueJson at: 'packageName') equals: 'Collections-Sequenceable'.
	self assert: (objectValueJson at: 'allInstanceSlots') isEmpty.
	self assertObjectValueJson: objectValueJson includesPhlowViews: #('gtPrintFor:' 'gtRawFor:' 'gtItemsFor:').
	
	^ domainObject
]

{ #category : #examples }
GtLObjectStorageValueResultExamples >> objectStorageValueResultForDataComparisonException [
	<gtExample>
	<return: #GtLObjectStorageValueResult>
	| exception domainObject compositeView dataBlock jsonData objectValueJson objectDetailsJson imageBlock |
	
	"Create the exception by catching it from signal and freezing it"
	exception := [ 
		(GtLExampleDataComparisonException new
			expectedData: (GtLExampleComparisonWrappedString new
				targetString: GtExampleComparisonExceptionWithDebuggingViews new expectedStringForTest);
			actualData: (GtLExampleComparisonWrappedString new
				targetString: GtExampleComparisonExceptionWithDebuggingViews new computedStringForTest)) signal
	] on: GtLExampleDataComparisonException do: [ :ex | GtSystemUtility freeze: ex ].
	
	self assert: exception class equals: GtLExampleDataComparisonException.
	
	domainObject := GtLObjectStorageValueResult forObject: exception withId: 'comparison-exception-id'.
	self assert: domainObject object equals: exception.
	self assert: domainObject objectId equals: 'comparison-exception-id'.
	self assert: domainObject objectValue class equals: GtLSerializedObjectValue.
	
	compositeView := domainObject llmDataViewsFor: GtLDataView new.
	self assert: compositeView dataViews size equals: 2.
	
	dataBlock := compositeView serializeToLlmPrimiteData.
	"This exception produces image data for the diff view"
	self assert: dataBlock dataBlocks size equals: 2.
	self assert: dataBlock imageDataBlocks size equals: 1.
	
	"Assert the image block has correct type and content"
	imageBlock := dataBlock imageDataBlocks first.
	self assert: imageBlock imageBytes isNotEmpty.
	self assert: imageBlock imageType equals: 'png'.
	
	jsonData := dataBlock compositeJsonData.
	self assertObjectStorageValueResultJsonDataKeys: jsonData.
	self assert: (jsonData at: #objectId) equals: 'comparison-exception-id'.
	
	"Assert exception details"
	objectDetailsJson := jsonData at: 'objectDetails'.
	self 
		assertObjectDetailsJson: objectDetailsJson 
		hasErrorMessage: 'GtLExampleDataComparisonException' 
		errorClass: 'GtLExampleDataComparisonException' 
		stackTraceIncludes: #('GtLExampleDataComparisonException(Exception)>>signal').
	
	objectValueJson := jsonData at: #objectValue.
	self assert: (objectValueJson at: 'objectClassName') equals: 'GtLExampleDataComparisonException'.
	self assert: (objectValueJson at: 'superclassName') equals: 'Error'.
	self assert: (objectValueJson at: 'packageName') equals: 'Gt4LlmCore-Examples'.
	
	"Check that instance slots include expectedData and actualData"
	self assert: ((objectValueJson at: 'allInstanceSlots') collect: [ :each | each at: 'name' ]) asSet
		equals: #('messageText' 'tag' 'signaler' 'signalContext' 'handlerContext' 'outerContext' 'expectedData' 'actualData') asSet.
	
	"Check expected phlow views"
	self 
		assertObjectValueJson: objectValueJson 
		includesPhlowViews: #('gtViewDiffFor:' 'gtRawFor:' 'gtPrintFor:' 'gtMetaFor:').
	
	^ domainObject
]

{ #category : #examples }
GtLObjectStorageValueResultExamples >> objectStorageValueResultForException [
	<gtExample>
	<return: #GtLObjectStorageValueResult>
	| exception domainObject compositeView dataBlock jsonData objectValueJson objectDetailsJson |
	
	exception := [ 1 / 0 ] on: ZeroDivide do: [ :ex | GtSystemUtility freeze: ex ].
	self assert: exception class equals: ZeroDivide.
	
	domainObject := GtLObjectStorageValueResult forObject: exception withId: 'exception-id-123'.
	self assert: domainObject object equals: exception.
	self assert: domainObject objectId equals: 'exception-id-123'.
	self assert: domainObject objectValue class equals: GtLSerializedObjectValue.
	
	compositeView := domainObject llmDataViewsFor: GtLDataView new.
	self assert: compositeView dataViews size equals: 2.
	
	dataBlock := compositeView serializeToLlmPrimiteData.
	self assertDataBlockHasOnlyJsonData: dataBlock.
	
	jsonData := dataBlock compositeJsonData.
	self assertObjectStorageValueResultJsonDataKeys: jsonData.
	self assert: (jsonData at: #objectId) equals: 'exception-id-123'.
	
	"Assert exception details"
	objectDetailsJson := jsonData at: 'objectDetails'.
	self 
		assertObjectDetailsJson: objectDetailsJson 
		hasErrorMessage: 'ZeroDivide' 
		errorClass: 'ZeroDivide' 
		stackTraceIncludes: #('ZeroDivide' 'SmallInteger>>/') .
	
	objectValueJson := jsonData at: #objectValue.
	self assert: (objectValueJson at: 'objectClassName') equals: 'ZeroDivide'.
	self assert: (objectValueJson at: 'superclassName') equals: 'ArithmeticError'.
	self assert: (objectValueJson at: 'packageName') equals: 'Kernel'.
	
	self 
		assertObjectValueJson: objectValueJson 
		includesPhlowViews: #('gtPrintFor:' 'gtRawFor:' 'gtMetaFor:').
	
	^ domainObject
]

{ #category : #examples }
GtLObjectStorageValueResultExamples >> objectStorageValueResultForInteger [
	<gtExample>
	<return: #GtLObjectStorageValueResult>
	| domainObject compositeView dataBlock jsonData objectValueJson expectedPhlowViews actualPhlowViews |
	
	domainObject := GtLObjectStorageValueResult forObject: 42 withId: 'test-id-123'.
	self assert: domainObject object equals: 42.
	self assert: domainObject objectId equals: 'test-id-123'.
	self assert: domainObject objectValue class equals: GtLSerializedObjectValue.
	
	compositeView := domainObject llmDataViewsFor: GtLDataView new.
	self assert: compositeView dataViews size equals: 2.
	
	dataBlock := compositeView serializeToLlmPrimiteData.
	self assertDataBlockHasOnlyJsonData: dataBlock.
	
	jsonData := dataBlock compositeJsonData.
	self assert: (jsonData at: #objectId) equals: 'test-id-123'.
	self assert: (jsonData at: 'objectDetails') equals: Dictionary new.
	
	objectValueJson := jsonData at: #objectValue.
	self assert: (objectValueJson at: 'objectClassName') equals: 'SmallInteger'.
	self assert: (objectValueJson at: 'objectPrintString') equals: '42'.
	self assert: (objectValueJson at: 'superclassName') equals: 'Integer'.
	self assert: (objectValueJson at: 'packageName') equals: 'Kernel'.
	self assert: (objectValueJson at: 'allInstanceSlots') asArray equals: #().
	
	expectedPhlowViews := {
		{ 'title' -> 'Preview'. 'methodName' -> 'gtPreviewFor:' } asDictionary.
		{ 'title' -> 'Integer'. 'methodName' -> 'gtIntegerFor:' } asDictionary.
		{ 'title' -> 'Raw'. 'methodName' -> 'gtRawFor:' } asDictionary.
		{ 'title' -> 'Print'. 'methodName' -> 'gtPrintFor:' } asDictionary.
		{ 'title' -> 'Meta'. 'methodName' -> 'gtMetaFor:' } asDictionary
	}.
	actualPhlowViews := (objectValueJson at: 'phlowViews') collect: [ :each |
		{ 'title' -> (each at: 'title'). 'methodName' -> (each at: 'methodName') } asDictionary ].
	self assert: actualPhlowViews asArray equals: expectedPhlowViews.
	
	^ domainObject
]

{ #category : #examples }
GtLObjectStorageValueResultExamples >> objectStorageValueResultForIntegerFullSerialization [
	<gtExample>
	<return: #Dictionary>
	| objectValue domainObject compositeView dataBlock jsonData expectedPhlowViews expectedObjectValue expectedJson |
	
	objectValue := GtLSerializedObjectValue new
		objectClassName: 'SmallInteger';
		superclassName: 'Integer';
		packageName: 'Kernel';
		objectPrintString: '42';
		phlowViews: {
			GtLSerializedViewInfo new title: 'Raw'; methodName: 'gtRawFor:'.
			GtLSerializedViewInfo new title: 'Print'; methodName: 'gtPrintFor:'
		};
		allInstanceSlots: #();
		yourself.
	
	domainObject := GtLObjectStorageValueResult new
		object: 42;
		objectValue: objectValue;
		objectId: 'test-id-123';
		yourself.
	
	compositeView := domainObject llmDataViewsFor: GtLDataView new.
	self assert: compositeView dataViews size equals: 2.
	
	dataBlock := compositeView serializeToLlmPrimiteData.
	self assertDataBlockHasOnlyJsonData: dataBlock.
	
	jsonData := dataBlock compositeJsonData.
	
	expectedPhlowViews := NeoJSONArray withAll: {
		(NeoJSONObject new at: 'title' put: 'Raw'; at: 'methodName' put: 'gtRawFor:'; yourself).
		(NeoJSONObject new at: 'title' put: 'Print'; at: 'methodName' put: 'gtPrintFor:'; yourself)
	}.
	
	expectedObjectValue := NeoJSONObject new
		at: 'objectClassName' put: 'SmallInteger';
		at: 'superclassName' put: 'Integer';
		at: 'packageName' put: 'Kernel';
		at: 'objectPrintString' put: '42';
		at: 'phlowViews' put: expectedPhlowViews;
		at: 'allInstanceSlots' put: NeoJSONArray new;
		yourself.
	
	expectedJson := Dictionary new
		at: #objectId put: 'test-id-123';
		at: 'objectDetails' put: Dictionary new;
		at: #objectValue put: expectedObjectValue;
		yourself.
	
	self assert: jsonData equals: expectedJson.
	
	^ jsonData
]

{ #category : #examples }
GtLObjectStorageValueResultExamples >> objectStorageValueResultForObjectStorageValueResult [
	<gtExample>
	<return: #GtLObjectStorageValueResult>
	| innerResult domainObject compositeView dataBlock jsonData objectValueJson |
	
	"Create an inner GtLObjectStorageValueResult wrapping an integer"
	innerResult := GtLObjectStorageValueResult forObject: 42 withId: 'inner-id-123'.
	
	"Create a meta GtLObjectStorageValueResult wrapping the inner result"
	domainObject := GtLObjectStorageValueResult forObject: innerResult withId: 'outer-id-456'.
	self assert: domainObject object equals: innerResult.
	self assert: domainObject objectId equals: 'outer-id-456'.
	self assert: domainObject objectValue class equals: GtLSerializedObjectValue.
	
	compositeView := domainObject llmDataViewsFor: GtLDataView new.
	self assert: compositeView dataViews size equals: 2.
	
	dataBlock := compositeView serializeToLlmPrimiteData.
	self assertDataBlockHasOnlyJsonData: dataBlock.
	
	jsonData := dataBlock compositeJsonData.
	self assertObjectStorageValueResultJsonDataKeys: jsonData.
	self assert: (jsonData at: #objectId) equals: 'outer-id-456'.
	
	objectValueJson := jsonData at: #objectValue.
	self assert: (objectValueJson at: 'objectClassName') equals: 'GtLObjectStorageValueResult'.
	self assert: ((objectValueJson at: 'objectPrintString') includesSubstring: 'inner-id-123').
	self assert: (objectValueJson at: 'superclassName') equals: 'GtLObjectValueResult'.
	self assert: (objectValueJson at: 'packageName') equals: 'Gt4LlmCore'.
	
	"Check that the instance slots include objectValue, objectId, object"
	self assert: ((objectValueJson at: 'allInstanceSlots') collect: [ :each | each at: 'name' ]) asSet 
		equals: #('objectValue' 'objectId' 'object') asSet.
	
	self 
		assertObjectValueJson: objectValueJson 
		includesPhlowViews: #('gtMagritteFor:' 'gtRawFor:' 'gtPrintFor:' 'gtMetaFor:').
	
	^ domainObject
]

{ #category : #examples }
GtLObjectStorageValueResultExamples >> objectStorageValueResultForString [
	<gtExample>
	<return: #GtLObjectStorageValueResult>
	| domainObject compositeView dataBlock jsonData objectValueJson |
	
	domainObject := GtLObjectStorageValueResult forObject: 'hello world' withId: 'string-id-456'.
	self assert: domainObject object equals: 'hello world'.
	self assert: domainObject objectId equals: 'string-id-456'.
	
	compositeView := domainObject llmDataViewsFor: GtLDataView new.
	self assert: compositeView dataViews size equals: 2.
	
	dataBlock := compositeView serializeToLlmPrimiteData.
	self assertDataBlockHasOnlyJsonData: dataBlock.
	
	jsonData := dataBlock compositeJsonData.
	self assertObjectStorageValueResultJsonDataKeys: jsonData.
	self assert: (jsonData at: #objectId) equals: 'string-id-456'.
	self assert: (jsonData at: 'objectDetails') isEmpty.
	
	objectValueJson := jsonData at: #objectValue.
	self assert: (objectValueJson at: 'objectClassName') equals: 'ByteString'.
	self assert: (objectValueJson at: 'superclassName') equals: 'String'.
	self assert: (objectValueJson at: 'packageName') equals: 'Collections-Strings'.
	self assert: (objectValueJson at: 'allInstanceSlots') isEmpty.
	self assertObjectValueJson: objectValueJson includesPhlowViews: #('gtPrintFor:' 'gtRawFor:' 'gtStringFor:').
	
	^ domainObject
]

{ #category : #examples }
GtLObjectStorageValueResultExamples >> objectStorageValueResultForTestObject [
	<gtExample>
	<return: #GtLObjectStorageValueResult>
	| testObject domainObject compositeView dataBlock jsonData expectedPhlowViews expectedSlots expectedObjectValue expectedJsonOne expectedJsonTwo|
	
	testObject := GtLSerializedObjectValueTestObject exampleInstance.
	self assert: testObject name equals: 'TestObject'.
	self assert: testObject count equals: 42.
	self assert: testObject items equals: #('apple' 'banana' 'cherry').
	
	domainObject := GtLObjectStorageValueResult forObject: testObject withId: 'test-object-id-789'.
	self assert: domainObject object equals: testObject.
	self assert: domainObject objectId equals: 'test-object-id-789'.
	
	compositeView := domainObject llmDataViewsFor: GtLDataView new.
	self assert: compositeView dataViews size equals: 2.
	
	dataBlock := compositeView serializeToLlmPrimiteData.
	self assertDataBlockHasOnlyJsonData: dataBlock.
	
	jsonData := dataBlock compositeJsonData.
	
	"Build expected JSON - top level is Dictionary with symbol keys, nested is NeoJSONObject"
	expectedPhlowViews := NeoJSONArray withAll: {
		(NeoJSONObject new at: 'methodName' put: 'gtDetailsFor:'; at: 'title' put: 'Details'; yourself).
		(NeoJSONObject new at: 'methodName' put: 'gtItemsFor:'; at: 'title' put: 'Items'; yourself).
		(NeoJSONObject new at: 'methodName' put: 'gtRawFor:'; at: 'title' put: 'Raw'; yourself).
		(NeoJSONObject new at: 'methodName' put: 'gtPrintFor:'; at: 'title' put: 'Print'; yourself).
		(NeoJSONObject new at: 'methodName' put: 'gtMetaFor:'; at: 'title' put: 'Meta'; yourself)
	}.
	
	"The items slot print string has doubled single quotes in the serialization"
	expectedSlots := NeoJSONArray withAll: {
		(NeoJSONObject new at: 'name' put: 'name'; at: 'valueClassName' put: 'ByteString'; at: 'valuePrintString' put: 'TestObject'; yourself).
		(NeoJSONObject new at: 'name' put: 'count'; at: 'valueClassName' put: 'SmallInteger'; at: 'valuePrintString' put: '42'; yourself).
		(NeoJSONObject new at: 'name' put: 'items'; at: 'valueClassName' put: 'Array'; at: 'valuePrintString' put: '#(''''apple'''' ''''banana'''' ''''cherry'''')'; yourself)
	}.
	
	expectedObjectValue := NeoJSONObject new
		at: 'allInstanceSlots' put: expectedSlots;
		at: 'objectClassName' put: 'GtLSerializedObjectValueTestObject';
		at: 'objectPrintString' put: 'a GtLSerializedObjectValueTestObject(TestObject)';
		at: 'packageName' put: 'Gt4LlmCore-Examples';
		at: 'phlowViews' put: expectedPhlowViews;
		at: 'superclassName' put: 'Object';
		yourself.
	
	expectedJsonOne := Dictionary new
		at: #objectDetails put: Dictionary new;
		at: #objectId put: 'test-object-id-789';
		at: #objectValue put: expectedObjectValue;
		yourself.
	expectedJsonTwo := Dictionary new
		at: 'objectDetails' put: Dictionary new;
		at: 'objectId' put: 'test-object-id-789';
		at: 'objectValue' put: (expectedObjectValue copy
			at: 'objectPrintString' put: 'aGtLSerializedObjectValueTestObject(TestObject)';
			yourself);
		yourself.
	
	self assert: ((jsonData = expectedJsonOne) or: [jsonData = expectedJsonOne]).
	
	^ domainObject
]
