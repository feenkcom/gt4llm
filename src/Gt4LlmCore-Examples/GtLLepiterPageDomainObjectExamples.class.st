"
Examples for GtLLepiterPageCreateDomainObject and GtLLepiterPageRemoveDomainObject.
"
Class {
	#name : #GtLLepiterPageDomainObjectExamples,
	#superclass : #GtLDomainObjectExamples,
	#category : #'Gt4LlmCore-Examples-Domain Objects'
}

{ #category : #examples }
GtLLepiterPageDomainObjectExamples >> basicPageCreateDomainObject [
	<gtExample>
	| domainObject |
	domainObject := GtLLepiterPageCreateDomainObject new
		status: 'created';
		databaseId: 'test-db-uuid';
		pageUid: 'test-page-uid';
		title: 'Test Page'.
	
	self assert: domainObject status equals: 'created'.
	self assert: domainObject databaseId equals: 'test-db-uuid'.
	self assert: domainObject pageUid equals: 'test-page-uid'.
	self assert: domainObject title equals: 'Test Page'.
	
	^ domainObject
]

{ #category : #examples }
GtLLepiterPageDomainObjectExamples >> basicPageRemoveDomainObject [
	<gtExample>
	| domainObject |
	domainObject := GtLLepiterPageRemoveDomainObject new
		status: 'removed';
		databaseId: 'test-db-uuid';
		pageUid: 'test-page-uid';
		title: 'Test Page'.
	
	self assert: domainObject status equals: 'removed'.
	self assert: domainObject databaseId equals: 'test-db-uuid'.
	self assert: domainObject pageUid equals: 'test-page-uid'.
	self assert: domainObject title equals: 'Test Page'.
	
	^ domainObject
]

{ #category : #'examples - serialization' }
GtLLepiterPageDomainObjectExamples >> pageCreateDataViewSerialization [
	<gtExample>
	| domainObject compositeView dataBlock jsonData expected |
	domainObject := self basicPageCreateDomainObject.
	compositeView := domainObject llmDataViewsFor: GtLDataView new.
	self assert: compositeView dataViews size equals: 1.
	
	dataBlock := compositeView serializeToLlmPrimiteData.
	self assert: dataBlock isNotNil.
	self assert: dataBlock dataBlocks size equals: 1.
	self assert: dataBlock imageDataBlocks isEmpty.
	
	jsonData := dataBlock compositeJsonData.
	expected := Dictionary new
		at: #status put: 'created';
		at: #pageUid put: 'test-page-uid';
		at: #title put: 'Test Page';
		at: #databaseId put: 'test-db-uuid';
		yourself.
	self assert: jsonData equals: expected.
	
	^ dataBlock
]

{ #category : #'examples - serialization' }
GtLLepiterPageDomainObjectExamples >> pageRemoveDataViewSerialization [
	<gtExample>
	| domainObject compositeView dataBlock jsonData expected |
	domainObject := self basicPageRemoveDomainObject.
	compositeView := domainObject llmDataViewsFor: GtLDataView new.
	self assert: compositeView dataViews size equals: 1.
	
	dataBlock := compositeView serializeToLlmPrimiteData.
	self assert: dataBlock isNotNil.
	self assert: dataBlock dataBlocks size equals: 1.
	self assert: dataBlock imageDataBlocks isEmpty.
	
	jsonData := dataBlock compositeJsonData.
	expected := Dictionary new
		at: #status put: 'removed';
		at: #pageUid put: 'test-page-uid';
		at: #title put: 'Test Page';
		at: #databaseId put: 'test-db-uuid';
		yourself.
	self assert: jsonData equals: expected.
	
	^ dataBlock
]
