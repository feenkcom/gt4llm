Class {
	#name : #GtLMissingArgumentDomainObjectExamples,
	#superclass : #GtLErroneousConditionDomainObjectExamples,
	#category : 'Gt4LlmCore-Examples-Domain Objects'
}

{ #category : #examples }
GtLMissingArgumentDomainObjectExamples >> basicMissingArgumentDomainObject [
	<gtExample>
	<return: #GtLMissingArgumentDomainObject>
	| domainObject |
	domainObject := GtLMissingArgumentDomainObject new
		missingArgument: 'requiredParam';
		arguments: {'existingArg' -> 'someValue'. 'anotherArg' -> 42} asDictionary;
		errorMessage: 'Missing required argument: requiredParam';
		yourself.
	self assert: domainObject missingArgument equals: 'requiredParam'.
	self assert: domainObject errorMessage equals: 'Missing required argument: requiredParam'.
	self assert: domainObject arguments size equals: 2.
	^ domainObject
]

{ #category : #examples }
GtLMissingArgumentDomainObjectExamples >> emptyMissingArgumentDomainObject [
	<gtExample>
	<return: #GtLMissingArgumentDomainObject>
	| domainObject compositeView dataBlock jsonData expectedJson |
	
	domainObject := GtLMissingArgumentDomainObject new.
	self assert: domainObject missingArgument isNil.
	self assert: domainObject errorMessage equals: ''.
	
	compositeView := domainObject llmDataViewsFor: GtLDataView new.
	self assert: compositeView dataViews size equals: 1.
	
	dataBlock := compositeView serializeToLlmPrimiteData.
	self assert: dataBlock dataBlocks size equals: 1.
	self assert: dataBlock imageDataBlocks isEmpty.
	
	jsonData := dataBlock compositeJsonData.
	expectedJson := {
		#missingArgument -> nil.
		#errorMessage -> ''
	} asDictionary.
	self assert: jsonData equals: expectedJson.
	
	^ domainObject
]

{ #category : #examples }
GtLMissingArgumentDomainObjectExamples >> missingArgumentDataViewSerialization [
	<gtExample>
	<return: #Dictionary>
	| domainObject compositeView dataBlock jsonData expectedJson |
	
	domainObject := self basicMissingArgumentDomainObject.
	compositeView := domainObject llmDataViewsFor: GtLDataView new.
	self assert: compositeView dataViews size equals: 1.
	
	dataBlock := compositeView serializeToLlmPrimiteData.
	self assert: dataBlock isNotNil.
	self assert: dataBlock dataBlocks size equals: 1.
	self assert: dataBlock imageDataBlocks isEmpty.
	
	jsonData := dataBlock compositeJsonData.
	expectedJson := {
		#missingArgument -> 'requiredParam'.
		#errorMessage -> 'Missing required argument: requiredParam'
	} asDictionary.
	self assert: jsonData equals: expectedJson.
	
	^ jsonData
]

{ #category : #examples }
GtLMissingArgumentDomainObjectExamples >> missingArgumentWithEmptyArguments [
	<gtExample>
	<return: #GtLMissingArgumentDomainObject>
	| domainObject compositeView dataBlock jsonData expectedJson |
	
	domainObject := GtLMissingArgumentDomainObject new
		missingArgument: 'requiredParam';
		arguments: #().
	self assert: domainObject missingArgument equals: 'requiredParam'.
	self assert: domainObject arguments isEmpty.
	
	compositeView := domainObject llmDataViewsFor: GtLDataView new.
	self assert: compositeView dataViews size equals: 1.
	
	dataBlock := compositeView serializeToLlmPrimiteData.
	self assert: dataBlock dataBlocks size equals: 1.
	self assert: dataBlock imageDataBlocks isEmpty.
	
	jsonData := dataBlock compositeJsonData.
	expectedJson := {
		#missingArgument -> 'requiredParam'.
		#errorMessage -> 'Missing argument called requiredParam'
	} asDictionary.
	self assert: jsonData equals: expectedJson.
	
	^ domainObject
]

{ #category : #examples }
GtLMissingArgumentDomainObjectExamples >> missingArgumentWithoutErrorMessage [
	<gtExample>
	<return: #GtLMissingArgumentDomainObject>
	| domainObject compositeView dataBlock jsonData expectedJson |
	
	domainObject := GtLMissingArgumentDomainObject new
		missingArgument: 'testParam'.
	self assert: domainObject missingArgument equals: 'testParam'.
	self assert: domainObject errorMessage equals: 'Missing argument called testParam'.
	
	compositeView := domainObject llmDataViewsFor: GtLDataView new.
	self assert: compositeView dataViews size equals: 1.
	
	dataBlock := compositeView serializeToLlmPrimiteData.
	self assert: dataBlock dataBlocks size equals: 1.
	self assert: dataBlock imageDataBlocks isEmpty.
	
	jsonData := dataBlock compositeJsonData.
	expectedJson := {
		#missingArgument -> 'testParam'.
		#errorMessage -> 'Missing argument called testParam'
	} asDictionary.
	self assert: jsonData equals: expectedJson.
	
	^ domainObject
]
