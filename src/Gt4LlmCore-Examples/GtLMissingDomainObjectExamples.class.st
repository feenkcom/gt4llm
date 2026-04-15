Class {
	#name : #GtLMissingDomainObjectExamples,
	#superclass : #GtLErroneousConditionDomainObjectExamples,
	#category : 'Gt4LlmCore-Examples-Domain Objects'
}

{ #category : #examples }
GtLMissingDomainObjectExamples >> emptyMissingDomainObject [
	<gtExample>
	<return: #GtLMissingDomainObject>
	| domainObject compositeView dataBlock jsonData expectedJson |
	
	domainObject := GtLMissingDomainObject new.
	self assert: domainObject missingObjectName isNil.
	self assert: domainObject errorMessage equals: ''.
	
	compositeView := domainObject llmDataViewsFor: GtLDataView new.
	self assert: compositeView dataViews size equals: 1.
	
	dataBlock := compositeView serializeToLlmPrimiteData.
	self assertDataBlockHasOnlyJsonData: dataBlock.
	
	jsonData := dataBlock compositeJsonData.
	expectedJson := {
		#missingObjectName -> nil.
		#errorMessage -> ''
	} asDictionary.
	self assert: jsonData equals: expectedJson.
	
	^ domainObject
]

{ #category : #examples }
GtLMissingDomainObjectExamples >> missingDomainObjectWithCustomErrorMessage [
	<gtExample>
	<return: #GtLMissingDomainObject>
	| domainObject compositeView dataBlock jsonData expectedJson |
	
	domainObject := GtLMissingDomainObject new
		missingObjectName: 'Database connection';
		errorMessage: 'Custom error: database connection unavailable'.
	self assert: domainObject missingObjectName equals: 'Database connection'.
	self assert: domainObject errorMessage equals: 'Custom error: database connection unavailable'.
	
	compositeView := domainObject llmDataViewsFor: GtLDataView new.
	self assert: compositeView dataViews size equals: 1.
	
	dataBlock := compositeView serializeToLlmPrimiteData.
	self assertDataBlockHasOnlyJsonData: dataBlock.
	
	jsonData := dataBlock compositeJsonData.
	expectedJson := {
		#missingObjectName -> 'Database connection'.
		#errorMessage -> 'Custom error: database connection unavailable'
	} asDictionary.
	self assert: jsonData equals: expectedJson.
	
	^ domainObject
]

{ #category : #examples }
GtLMissingDomainObjectExamples >> missingDomainObjectWithObjectName [
	<gtExample>
	<return: #GtLMissingDomainObject>
	| domainObject compositeView dataBlock jsonData expectedJson |
	
	domainObject := GtLMissingDomainObject new
		missingObjectName: 'User'.
	self assert: domainObject missingObjectName equals: 'User'.
	self assert: domainObject errorMessage equals: 'User is not found'.
	
	compositeView := domainObject llmDataViewsFor: GtLDataView new.
	self assert: compositeView dataViews size equals: 1.
	
	dataBlock := compositeView serializeToLlmPrimiteData.
	self assertDataBlockHasOnlyJsonData: dataBlock.
	
	jsonData := dataBlock compositeJsonData.
	expectedJson := {
		#missingObjectName -> 'User'.
		#errorMessage -> 'User is not found'
	} asDictionary.
	self assert: jsonData equals: expectedJson.
	
	^ domainObject
]
