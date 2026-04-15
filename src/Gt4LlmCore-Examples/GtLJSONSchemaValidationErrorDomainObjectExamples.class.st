"
Examples for GtLJSONSchemaValidationErrorDomainObject testing state and serialization using data views.
"
Class {
	#name : #GtLJSONSchemaValidationErrorDomainObjectExamples,
	#superclass : #GtLErroneousConditionDomainObjectExamples,
	#category : 'Gt4LlmCore-Examples-Domain Objects'
}

{ #category : #examples }
GtLJSONSchemaValidationErrorDomainObjectExamples >> basicValidationError [
	<gtExample>
	<return: #GtLJSONSchemaValidationErrorDomainObject>
	| domainObject |
	domainObject := GtLJSONSchemaValidationErrorDomainObject new
		errorMessage: 'Invalid type: expected string, got number';
		path: #('root' 'items' '0' 'name');
		yourself.
	
	self assert: domainObject errorMessage equals: 'Invalid type: expected string, got number'.
	self assert: domainObject path equals: #('root' 'items' '0' 'name').
	
	^ domainObject
]

{ #category : #examples }
GtLJSONSchemaValidationErrorDomainObjectExamples >> emptyValidationError [
	<gtExample>
	<return: #GtLJSONSchemaValidationErrorDomainObject>
	| domainObject |
	domainObject := GtLJSONSchemaValidationErrorDomainObject new.
	
	self assert: domainObject errorMessage isNil.
	self assert: domainObject path isNil.
	
	^ domainObject
]

{ #category : #examples }
GtLJSONSchemaValidationErrorDomainObjectExamples >> validationErrorDataViewSerialization [
	<gtExample>
	<return: #Dictionary>
	| domainObject compositeView dataBlock expectedJson |
	domainObject := self basicValidationError.
	
	compositeView := domainObject llmDataViewsFor: GtLDataView new.
	self assert: compositeView dataViews size equals: 1.
	
	dataBlock := compositeView serializeToLlmPrimiteData.
	self assert: dataBlock isNotNil.
	self assert: dataBlock dataBlocks size equals: 1.
	self assert: dataBlock imageDataBlocks isEmpty.
	
	expectedJson := {
		#errorMessage -> 'Invalid type: expected string, got number'.
		#path -> (NeoJSONArray withAll: #('root' 'items' '0' 'name'))
	} asDictionary.
	self assertDataBlock: dataBlock hasLlmJsonData: expectedJson.
	
	^ dataBlock llmJsonData
]

{ #category : #examples }
GtLJSONSchemaValidationErrorDomainObjectExamples >> validationErrorWithEmptyPath [
	<gtExample>
	<return: #GtLJSONSchemaValidationErrorDomainObject>
	| domainObject |
	domainObject := GtLJSONSchemaValidationErrorDomainObject new
		errorMessage: 'Root object is invalid';
		path: #();
		yourself.
	
	self assert: domainObject errorMessage equals: 'Root object is invalid'.
	self assert: domainObject path equals: #().
	
	^ domainObject
]

{ #category : #examples }
GtLJSONSchemaValidationErrorDomainObjectExamples >> validationErrorWithEmptyPathSerialization [
	<gtExample>
	<return: #Dictionary>
	| domainObject compositeView dataBlock expectedJson |
	domainObject := self validationErrorWithEmptyPath.
	
	compositeView := domainObject llmDataViewsFor: GtLDataView new.
	self assert: compositeView dataViews size equals: 1.
	
	dataBlock := compositeView serializeToLlmPrimiteData.
	self assert: dataBlock dataBlocks size equals: 1.
	self assert: dataBlock imageDataBlocks isEmpty.
	
	expectedJson := {
		#errorMessage -> 'Root object is invalid'.
		#path -> NeoJSONArray new
	} asDictionary.
	self assertDataBlock: dataBlock hasLlmJsonData: expectedJson.
	
	^ dataBlock llmJsonData
]
