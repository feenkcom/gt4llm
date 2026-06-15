"
Examples for GtLExceptionDomainObject testing state and serialization using data views.
"
Class {
	#name : #GtLExceptionDomainObjectExamples,
	#superclass : #GtLExceptionBasedDomainObjectExamples,
	#traits : 'TGtLExceptionResultSerializationAssertions',
	#classTraits : 'TGtLExceptionResultSerializationAssertions classTrait',
	#category : #'Gt4LlmCore-Examples-Domain Objects'
}

{ #category : #examples }
GtLExceptionDomainObjectExamples >> basicZeroDivideException [
	<gtExample>
	<return: #GtLExceptionDomainObject>
	| domainObject |
	domainObject := [ 1 / 0 ] on: ZeroDivide do: [ :ex |
		GtLExceptionDomainObject freeze: ex ].
	
	self assert: domainObject exception class equals: ZeroDivide.
	
	^ domainObject
]

{ #category : #examples }
GtLExceptionDomainObjectExamples >> dataComparisonException [
	<gtExample>
	<return: #GtLExceptionDomainObject>
	| domainObject |
	domainObject := [ 
		(GtLExampleDataComparisonException new
			expectedData: (GtLExampleComparisonWrappedString new
				targetString: GtExampleComparisonExceptionWithDebuggingViews new
					expectedStringForTest);
			actualData: (GtLExampleComparisonWrappedString new
				targetString: GtExampleComparisonExceptionWithDebuggingViews new
					computedStringForTest)) signal
	] on: GtLExampleDataComparisonException do: [ :ex |
		GtLExceptionDomainObject freeze: ex ].
	
	self assert: domainObject exception class equals: GtLExampleDataComparisonException.
	
	^ domainObject
]

{ #category : #examples }
GtLExceptionDomainObjectExamples >> dataComparisonExceptionDataViewSerialization [
	<gtExample>
	<return: #Dictionary>
	| domainObject compositeView dataBlock jsonData errorDetails imageBlock |
	domainObject := self dataComparisonException.
	
	compositeView := domainObject llmDataViewsFor: GtLDataView new.
	self assert: compositeView dataViews size equals: 2.
	
	dataBlock := compositeView serializeToLlmPrimiteData.
	self assert: dataBlock isNotNil.
	self assert: dataBlock dataBlocks size equals: 2.
	self assert: dataBlock imageDataBlocks size equals: 1.
	
	jsonData := dataBlock compositeJsonData.
	self assertJsonData: jsonData hasExpectedKeys: #(#errorDetails #errorReason #objectId #objectValue #playgroundPageReference).
	self assert: (jsonData at: #errorReason) isNil.
	self assert: (jsonData at: #objectId) isNil.
	self assert: (jsonData at: #objectValue) isDictionary.
	self assert: (jsonData at: #playgroundPageReference) isNil.
	
	errorDetails := jsonData at: 'errorDetails'.
	self assert: (errorDetails at: #errorClass) equals: 'GtLExampleDataComparisonException'.
	self assert: ((errorDetails at: #stackTrace) includesSubstring: 'GtLExampleDataComparisonException').
	
	"Assert that the diff image is generated"
	imageBlock := dataBlock imageDataBlocks first.
	self assert: imageBlock imageType equals: 'png'.
	self assert: imageBlock imageBytes isNotEmpty.
	
	^ jsonData
]

{ #category : #examples }
GtLExceptionDomainObjectExamples >> emptyExceptionDataViewSerialization [
	<gtExample>
	<return: #Dictionary>
	| domainObject compositeView dataBlock jsonData |
	domainObject := self emptyExceptionDomainObject.
	
	compositeView := domainObject llmDataViewsFor: GtLDataView new.
	self assert: compositeView dataViews size equals: 2.
	
	dataBlock := compositeView serializeToLlmPrimiteData.
	self assertDataBlockHasOnlyJsonData: dataBlock.
	
	jsonData := dataBlock compositeJsonData.
	self assertJsonData: jsonData hasExpectedKeys: #(#errorDetails #errorReason #objectId #objectValue #playgroundPageReference).
	self assert: (jsonData at: 'errorDetails') equals: Dictionary new.
	self assert: (jsonData at: 'errorReason') isNil.
	self assert: (jsonData at: #objectId) isNil.
	self assert: (jsonData at: #objectValue) isNil.
	self assert: (jsonData at: #playgroundPageReference) isNil.
	
	^ jsonData
]

{ #category : #examples }
GtLExceptionDomainObjectExamples >> emptyExceptionDomainObject [
	<gtExample>
	<return: #GtLExceptionDomainObject>
	| domainObject |
	domainObject := GtLExceptionDomainObject new.
	
	self assert: domainObject exception isNil.
	self assert: domainObject errorReason isNil.
	
	^ domainObject
]

{ #category : #examples }
GtLExceptionDomainObjectExamples >> exceptionWithDescription [
	<gtExample>
	<return: #GtLExceptionDomainObject>
	| domainObject |
	domainObject := [ 1 / 0 ] on: ZeroDivide do: [ :ex |
		GtLExceptionDomainObject freeze: ex ].
	domainObject description: 'Error while evaluating code'.
	
	self assert: domainObject exception class equals: ZeroDivide.
	self assert: domainObject description equals: 'Error while evaluating code'.
	self assert: domainObject errorReason equals: 'Error while evaluating code'.
	
	^ domainObject
]

{ #category : #examples }
GtLExceptionDomainObjectExamples >> exceptionWithDescriptionDataViewSerialization [
	<gtExample>
	<return: #Dictionary>
	| domainObject compositeView dataBlock jsonData errorDetails |
	domainObject := self exceptionWithDescription.
	
	compositeView := domainObject llmDataViewsFor: GtLDataView new.
	self assert: compositeView dataViews size equals: 2.
	
	dataBlock := compositeView serializeToLlmPrimiteData.
	self assertDataBlockHasOnlyJsonData: dataBlock.
	
	jsonData := dataBlock compositeJsonData.
	self assert: (jsonData at: 'errorReason') equals: 'Error while evaluating code'.
	
	errorDetails := jsonData at: 'errorDetails'.
	self 
		assertExceptionResult: errorDetails 
		errorClass: 'ZeroDivide' 
		errorMessage: 'ZeroDivide' 
		stackTraceIncludes: #('ZeroDivide').
	
	^ jsonData
]

{ #category : #examples }
GtLExceptionDomainObjectExamples >> messageNotUnderstoodDataViewSerialization [
	<gtExample>
	<return: #Dictionary>
	| domainObject compositeView dataBlock jsonData errorDetails |
	domainObject := self messageNotUnderstoodException.
	
	compositeView := domainObject llmDataViewsFor: GtLDataView new.
	dataBlock := compositeView serializeToLlmPrimiteData.
	jsonData := dataBlock compositeJsonData.
	
	errorDetails := jsonData at: 'errorDetails'.
	self assert: (errorDetails at: #errorClass) equals: 'MessageNotUnderstood'.
	self assert: ((errorDetails at: #errorMessage) includesSubstring: 'foo').
	self assert: ((errorDetails at: #stackTrace) includesSubstring: 'Object').
	
	^ jsonData
]

{ #category : #examples }
GtLExceptionDomainObjectExamples >> messageNotUnderstoodException [
	<gtExample>
	<return: #GtLExceptionDomainObject>
	| domainObject |
	domainObject := [ Object new foo ] on: MessageNotUnderstood do: [ :ex |
		GtLExceptionDomainObject freeze: ex ].
	
	self assert: domainObject exception class equals: MessageNotUnderstood.
	
	^ domainObject
]

{ #category : #examples }
GtLExceptionDomainObjectExamples >> zeroDivideExceptionDataViewSerialization [
	<gtExample>
	<return: #Dictionary>
	| domainObject compositeView dataBlock jsonData errorDetails |
	domainObject := self basicZeroDivideException.
	
	compositeView := domainObject llmDataViewsFor: GtLDataView new.
	self assert: compositeView dataViews size equals: 2.
	
	dataBlock := compositeView serializeToLlmPrimiteData.
	self assertDataBlockHasOnlyJsonData: dataBlock.
	
	jsonData := dataBlock compositeJsonData.
	self assertJsonData: jsonData hasExpectedKeys: #(#errorDetails #errorReason #objectId #objectValue #playgroundPageReference).
	self assert: (jsonData at: #errorReason) isNil.
	self assert: (jsonData at: #objectId) isNil.
	self assert: (jsonData at: #objectValue) isDictionary.
	self assert: (jsonData at: #playgroundPageReference) isNil.
	
	errorDetails := jsonData at: 'errorDetails'.
	self 
		assertExceptionResult: errorDetails 
		errorClass: 'ZeroDivide' 
		errorMessage: 'ZeroDivide' 
		stackTraceIncludes: #('ZeroDivide' 'SmallInteger>>/').
	
	^ jsonData
]
