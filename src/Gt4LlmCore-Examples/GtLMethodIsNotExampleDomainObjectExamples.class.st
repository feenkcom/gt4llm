"
Examples for GtLMethodIsNotExampleDomainObject data views.
"
Class {
	#name : #GtLMethodIsNotExampleDomainObjectExamples,
	#superclass : #GtLErroneousConditionDomainObjectExamples,
	#category : #'Gt4LlmCore-Examples-Domain Objects'
}

{ #category : #examples }
GtLMethodIsNotExampleDomainObjectExamples >> methodIsNotExampleDomainObject [
	<gtExample>
	<return: #GtLMethodIsNotExampleDomainObject>
	| domainObject compositeView dataBlock jsonData expectedJson |
	
	domainObject := GtLMethodIsNotExampleDomainObject new
		method: (GtLExampleRunDummyExamples >> #regularMethod).
	self assert: domainObject methodName equals: 'GtLExampleRunDummyExamples>>#regularMethod'.
	self assert: domainObject errorMessage equals: 'Method is not an example: GtLExampleRunDummyExamples>>#regularMethod'.
	
	compositeView := domainObject llmDataViewsFor: GtLDataView new.
	self assert: compositeView dataViews size equals: 1.
	
	dataBlock := compositeView serializeToLlmPrimiteData.
	self assert: dataBlock dataBlocks size equals: 1.
	self assert: dataBlock imageDataBlocks isEmpty.
	
	jsonData := dataBlock compositeJsonData.
	expectedJson := {
		#methodName -> 'GtLExampleRunDummyExamples>>#regularMethod'.
		#errorMessage -> 'Method is not an example: GtLExampleRunDummyExamples>>#regularMethod'
	} asDictionary.
	self assert: jsonData equals: expectedJson.
	
	^ domainObject
]

{ #category : #examples }
GtLMethodIsNotExampleDomainObjectExamples >> methodIsNotExampleDomainObjectFromClassSideMethod [
	<gtExample>
	<return: #GtLMethodIsNotExampleDomainObject>
	| domainObject compositeView dataBlock jsonData expectedJson |
	
	domainObject := GtLMethodIsNotExampleDomainObject new
		method: (GtLExampleReference class >> #fromCompiledMethod:).
	self assert: domainObject methodName equals: 'GtLExampleReference class>>#fromCompiledMethod:'.
	self assert: domainObject errorMessage equals: 'Method is not an example: GtLExampleReference class>>#fromCompiledMethod:'.
	
	compositeView := domainObject llmDataViewsFor: GtLDataView new.
	self assert: compositeView dataViews size equals: 1.
	
	dataBlock := compositeView serializeToLlmPrimiteData.
	self assert: dataBlock dataBlocks size equals: 1.
	self assert: dataBlock imageDataBlocks isEmpty.
	
	jsonData := dataBlock compositeJsonData.
	expectedJson := {
		#methodName -> 'GtLExampleReference class>>#fromCompiledMethod:'.
		#errorMessage -> 'Method is not an example: GtLExampleReference class>>#fromCompiledMethod:'
	} asDictionary.
	self assert: jsonData equals: expectedJson.
	
	^ domainObject
]
