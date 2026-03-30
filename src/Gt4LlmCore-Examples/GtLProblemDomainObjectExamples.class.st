Class {
	#name : #GtLProblemDomainObjectExamples,
	#superclass : #GtLErroneousConditionDomainObjectExamples,
	#category : 'Gt4LlmCore-Examples-Domain Objects'
}

{ #category : #examples }
GtLProblemDomainObjectExamples >> basicProblemDomainObject [
	<gtExample>
	<return: #GtLProblemDomainObject>
	| domainObject |
	domainObject := GtLProblemDomainObject new
		errorMessage: 'Something went wrong during operation';
		yourself.
	self assert: domainObject errorMessage equals: 'Something went wrong during operation'.
	^ domainObject
]

{ #category : #examples }
GtLProblemDomainObjectExamples >> emptyProblemDomainObject [
	<gtExample>
	<return: #GtLProblemDomainObject>
	| domainObject compositeView dataBlock jsonData expectedJson |
	
	domainObject := GtLProblemDomainObject new.
	self assert: domainObject errorMessage isNil.
	
	compositeView := domainObject llmDataViewsFor: GtLDataView new.
	self assert: compositeView dataViews size equals: 1.
	
	dataBlock := compositeView serializeToLlmPrimiteData.
	self assert: dataBlock dataBlocks size equals: 1.
	self assert: dataBlock imageDataBlocks isEmpty.
	
	jsonData := dataBlock compositeJsonData.
	expectedJson := {
		#errorMessage -> nil
	} asDictionary.
	self assert: jsonData equals: expectedJson.
	
	^ domainObject
]

{ #category : #examples }
GtLProblemDomainObjectExamples >> problemDataViewSerialization [
	<gtExample>
	<return: #Dictionary>
	| domainObject compositeView dataBlock jsonData expectedJson |
	
	domainObject := self basicProblemDomainObject.
	compositeView := domainObject llmDataViewsFor: GtLDataView new.
	self assert: compositeView dataViews size equals: 1.
	
	dataBlock := compositeView serializeToLlmPrimiteData.
	self assert: dataBlock isNotNil.
	self assert: dataBlock dataBlocks size equals: 1.
	self assert: dataBlock imageDataBlocks isEmpty.
	
	jsonData := dataBlock compositeJsonData.
	expectedJson := {
		#errorMessage -> 'Something went wrong during operation'
	} asDictionary.
	self assert: jsonData equals: expectedJson.
	
	^ dataBlock
]

{ #category : #examples }
GtLProblemDomainObjectExamples >> problemWithEmptyErrorMessage [
	<gtExample>
	<return: #GtLProblemDomainObject>
	| domainObject compositeView dataBlock jsonData expectedJson |
	
	domainObject := GtLProblemDomainObject new
		errorMessage: ''.
	self assert: domainObject errorMessage equals: ''.
	
	compositeView := domainObject llmDataViewsFor: GtLDataView new.
	self assert: compositeView dataViews size equals: 1.
	
	dataBlock := compositeView serializeToLlmPrimiteData.
	self assert: dataBlock dataBlocks size equals: 1.
	self assert: dataBlock imageDataBlocks isEmpty.
	
	jsonData := dataBlock compositeJsonData.
	expectedJson := {
		#errorMessage -> ''
	} asDictionary.
	self assert: jsonData equals: expectedJson.
	
	^ domainObject
]
