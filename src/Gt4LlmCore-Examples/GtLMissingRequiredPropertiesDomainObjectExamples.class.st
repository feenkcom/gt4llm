"
Examples for GtLMissingRequiredPropertiesDomainObject testing state and serialization using data views.
"
Class {
	#name : #GtLMissingRequiredPropertiesDomainObjectExamples,
	#superclass : #GtLErroneousConditionDomainObjectExamples,
	#category : 'Gt4LlmCore-Examples-Domain Objects'
}

{ #category : #examples }
GtLMissingRequiredPropertiesDomainObjectExamples >> basicMissingRequiredProperties [
	<gtExample>
	<return: #GtLMissingRequiredPropertiesDomainObject>
	| domainObject |
	domainObject := GtLMissingRequiredPropertiesDomainObject new
		errorMessage: 'Missing required properties';
		path: #('root' 'config');
		missingPropertyNames: #('name' 'version' 'author');
		yourself.
	
	self assert: domainObject errorMessage equals: 'Missing required properties'.
	self assert: domainObject path equals: #('root' 'config').
	self assert: domainObject missingPropertyNames equals: #('name' 'version' 'author').
	
	^ domainObject
]

{ #category : #examples }
GtLMissingRequiredPropertiesDomainObjectExamples >> emptyMissingRequiredProperties [
	<gtExample>
	<return: #GtLMissingRequiredPropertiesDomainObject>
	| domainObject |
	domainObject := GtLMissingRequiredPropertiesDomainObject new.
	
	self assert: domainObject errorMessage isNil.
	self assert: domainObject path isNil.
	self assert: domainObject missingPropertyNames isNil.
	
	^ domainObject
]

{ #category : #examples }
GtLMissingRequiredPropertiesDomainObjectExamples >> missingRequiredPropertiesDataViewSerialization [
	<gtExample>
	<return: #Dictionary>
	| domainObject compositeView dataBlock expectedJson |
	domainObject := self basicMissingRequiredProperties.
	
	compositeView := domainObject llmDataViewsFor: GtLDataView new.
	self assert: compositeView dataViews size equals: 1.
	
	dataBlock := compositeView serializeToLlmPrimiteData.
	self assert: dataBlock isNotNil.
	self assert: dataBlock dataBlocks size equals: 1.
	self assert: dataBlock imageDataBlocks isEmpty.
	
	expectedJson := {
		#errorMessage -> 'Missing required properties'.
		#missingPropertyNames -> (NeoJSONArray withAll: #('name' 'version' 'author')).
		#path -> (NeoJSONArray withAll: #('root' 'config'))
	} asDictionary.
	self assertDataBlock: dataBlock hasLlmJsonData: expectedJson.
	
	^ dataBlock llmJsonData
]

{ #category : #examples }
GtLMissingRequiredPropertiesDomainObjectExamples >> missingRequiredPropertiesSingleProperty [
	<gtExample>
	<return: #GtLMissingRequiredPropertiesDomainObject>
	| domainObject |
	domainObject := GtLMissingRequiredPropertiesDomainObject new
		errorMessage: 'Missing required property: id';
		path: #('data');
		missingPropertyNames: #('id');
		yourself.
	
	self assert: domainObject errorMessage equals: 'Missing required property: id'.
	self assert: domainObject path equals: #('data').
	self assert: domainObject missingPropertyNames equals: #('id').
	
	^ domainObject
]

{ #category : #examples }
GtLMissingRequiredPropertiesDomainObjectExamples >> missingRequiredPropertiesWithEmptyArrays [
	<gtExample>
	<return: #GtLMissingRequiredPropertiesDomainObject>
	| domainObject |
	domainObject := GtLMissingRequiredPropertiesDomainObject new
		errorMessage: 'No properties missing';
		path: #();
		missingPropertyNames: #();
		yourself.
	
	self assert: domainObject errorMessage equals: 'No properties missing'.
	self assert: domainObject path equals: #().
	self assert: domainObject missingPropertyNames equals: #().
	
	^ domainObject
]

{ #category : #examples }
GtLMissingRequiredPropertiesDomainObjectExamples >> missingRequiredPropertiesWithEmptyArraysSerialization [
	<gtExample>
	<return: #Dictionary>
	| domainObject compositeView dataBlock expectedJson |
	domainObject := self missingRequiredPropertiesWithEmptyArrays.
	
	compositeView := domainObject llmDataViewsFor: GtLDataView new.
	self assert: compositeView dataViews size equals: 1.
	
	dataBlock := compositeView serializeToLlmPrimiteData.
	self assert: dataBlock dataBlocks size equals: 1.
	self assert: dataBlock imageDataBlocks isEmpty.
	
	expectedJson := {
		#errorMessage -> 'No properties missing'.
		#missingPropertyNames -> NeoJSONArray new.
		#path -> NeoJSONArray new
	} asDictionary.
	self assertDataBlock: dataBlock hasLlmJsonData: expectedJson.
	
	^ dataBlock llmJsonData
]
