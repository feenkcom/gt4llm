Class {
	#name : #GtLUnexpectedDomainObjectExamples,
	#superclass : #GtLErroneousConditionDomainObjectExamples,
	#category : 'Gt4LlmCore-Examples-Domain Objects'
}

{ #category : #examples }
GtLUnexpectedDomainObjectExamples >> basicUnexpectedDomainObject [
	<gtExample>
	<return: #GtLUnexpectedDomainObject>
	| domainObject |
	domainObject := GtLUnexpectedDomainObject new
		objectName: 'ExistingClass';
		yourself.
	self assert: domainObject objectName equals: 'ExistingClass'.
	self assert: domainObject messageText equals: 'ExistingClass already exists'.
	self assert: domainObject isErrorDomainObject.
	^ domainObject
]

{ #category : #examples }
GtLUnexpectedDomainObjectExamples >> emptyUnexpectedDomainObject [
	<gtExample>
	<return: #GtLUnexpectedDomainObject>
	| domainObject compositeView dataBlock jsonData expectedJson |
	
	domainObject := GtLUnexpectedDomainObject new.
	self assert: domainObject objectName isNil.
	self assert: domainObject messageText equals: 'nil already exists'.
	
	compositeView := domainObject llmDataViewsFor: GtLDataView new.
	self assert: compositeView dataViews size equals: 1.
	
	dataBlock := compositeView serializeToLlmPrimiteData.
	self assert: dataBlock dataBlocks size equals: 1.
	self assert: dataBlock imageDataBlocks isEmpty.
	
	jsonData := dataBlock compositeJsonData.
	expectedJson := {
		#objectName -> nil.
		#messageText -> 'nil already exists'
	} asDictionary.
	self assert: jsonData equals: expectedJson.
	
	^ domainObject
]

{ #category : #examples }
GtLUnexpectedDomainObjectExamples >> unexpectedDomainObjectDataViewSerialization [
	<gtExample>
	<return: #GtLCompositeDataBlock>
	| domainObject compositeView dataBlock jsonData expectedJson |
	
	domainObject := self basicUnexpectedDomainObject.
	compositeView := domainObject llmDataViewsFor: GtLDataView new.
	self assert: compositeView dataViews size equals: 1.
	
	dataBlock := compositeView serializeToLlmPrimiteData.
	self assert: dataBlock isNotNil.
	self assert: dataBlock dataBlocks size equals: 1.
	self assert: dataBlock imageDataBlocks isEmpty.
	
	jsonData := dataBlock compositeJsonData.
	expectedJson := {
		#objectName -> 'ExistingClass'.
		#messageText -> 'ExistingClass already exists'
	} asDictionary.
	self assert: jsonData equals: expectedJson.
	
	^ dataBlock
]
