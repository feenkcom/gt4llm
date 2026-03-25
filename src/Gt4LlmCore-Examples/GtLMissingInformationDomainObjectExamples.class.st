Class {
	#name : #GtLMissingInformationDomainObjectExamples,
	#superclass : #GtLErroneousConditionDomainObjectExamples,
	#category : 'Gt4LlmCore-Examples-Domain Objects'
}

{ #category : #examples }
GtLMissingInformationDomainObjectExamples >> emptyMissingInformationDomainObject [
	<gtExample>
	<return: #GtLMissingInformationDomainObject>
	| domainObject compositeView dataBlock jsonData expectedJson |
	
	domainObject := GtLMissingInformationDomainObject new.
	self assert: domainObject missingModelName isNil.
	self assert: domainObject errorMessage equals: ''.
	
	compositeView := domainObject llmDataViewsFor: GtLDataView new.
	self assert: compositeView dataViews size equals: 1.
	
	dataBlock := compositeView serializeToLlmPrimiteData.
	self assert: dataBlock dataBlocks size equals: 1.
	self assert: dataBlock imageDataBlocks isEmpty.
	
	jsonData := dataBlock compositeJsonData.
	expectedJson := {
		#missingModelName -> nil.
		#errorMessage -> ''
	} asDictionary.
	self assert: jsonData equals: expectedJson.
	
	^ domainObject
]

{ #category : #examples }
GtLMissingInformationDomainObjectExamples >> missingInformationWithCustomErrorMessage [
	<gtExample>
	<return: #GtLMissingInformationDomainObject>
	| domainObject compositeView dataBlock jsonData expectedJson |
	
	domainObject := GtLMissingInformationDomainObject new
		missingModelName: 'configuration';
		errorMessage: 'Custom error: configuration not found'.
	self assert: domainObject missingModelName equals: 'configuration'.
	self assert: domainObject errorMessage equals: 'Custom error: configuration not found'.
	
	compositeView := domainObject llmDataViewsFor: GtLDataView new.
	self assert: compositeView dataViews size equals: 1.
	
	dataBlock := compositeView serializeToLlmPrimiteData.
	self assert: dataBlock dataBlocks size equals: 1.
	self assert: dataBlock imageDataBlocks isEmpty.
	
	jsonData := dataBlock compositeJsonData.
	expectedJson := {
		#missingModelName -> 'configuration'.
		#errorMessage -> 'Custom error: configuration not found'
	} asDictionary.
	self assert: jsonData equals: expectedJson.
	
	^ domainObject
]

{ #category : #examples }
GtLMissingInformationDomainObjectExamples >> missingInformationWithModelName [
	<gtExample>
	<return: #GtLMissingInformationDomainObject>
	| domainObject compositeView dataBlock jsonData expectedJson |
	
	domainObject := GtLMissingInformationDomainObject new
		missingModelName: 'API key'.
	self assert: domainObject missingModelName equals: 'API key'.
	self assert: domainObject errorMessage equals: 'Missing API key'.
	
	compositeView := domainObject llmDataViewsFor: GtLDataView new.
	self assert: compositeView dataViews size equals: 1.
	
	dataBlock := compositeView serializeToLlmPrimiteData.
	self assert: dataBlock dataBlocks size equals: 1.
	self assert: dataBlock imageDataBlocks isEmpty.
	
	jsonData := dataBlock compositeJsonData.
	expectedJson := {
		#missingModelName -> 'API key'.
		#errorMessage -> 'Missing API key'
	} asDictionary.
	self assert: jsonData equals: expectedJson.
	
	^ domainObject
]
