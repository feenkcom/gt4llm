Class {
	#name : #GtLLepiterPagesDomainObjectExamples,
	#superclass : #GtLDomainObjectExamples,
	#category : 'Gt4LlmCore-Examples-Domain Objects'
}

{ #category : #examples }
GtLLepiterPagesDomainObjectExamples >> lepiterPagesDomainObjectDataViewSerialization [
	<gtExample>
	<return: #GtLPrimitiveMessageDataBlock>
	| domainObject compositeView dataBlock jsonData pagesData firstPage expected |
	domainObject := self lepiterPagesDomainObjectWithPages.
	compositeView := domainObject llmDataViewsFor: GtLDataView new.
	self assert: compositeView dataViews size equals: 1.
	
	dataBlock := compositeView serializeToLlmPrimiteData.
	self assertDataBlockHasOnlyJsonData: dataBlock.
	
	jsonData := dataBlock compositeJsonData.
	self assert: (jsonData includesKey: #pages).
	pagesData := jsonData at: #pages.
	self assert: pagesData size equals: 1.
	
	firstPage := pagesData first.
	expected := {
		#pageTitle -> 'Warmup: understanding the Money classes'.
		#pageUid -> (LeDatabase gtBook pageNamed: 'Warmup: understanding the Money classes') uid asString36.
		#databaseId -> LeDatabase gtBook uuidString
	} asDictionary.
	self assert: firstPage equals: expected.
	
	^ dataBlock
]

{ #category : #examples }
GtLLepiterPagesDomainObjectExamples >> lepiterPagesDomainObjectEmpty [
	<gtExample>
	<return: #GtLLepiterPagesDomainObject>
	| domainObject |
	domainObject := GtLLepiterPagesDomainObject new
		pages: #().
	
	self assert: domainObject pages isEmpty.
	
	^ domainObject
]

{ #category : #examples }
GtLLepiterPagesDomainObjectExamples >> lepiterPagesDomainObjectWithPages [
	<gtExample>
	<return: #GtLLepiterPagesDomainObject>
	| domainObject page |
	page := LeDatabase gtBook pageNamed: 'Warmup: understanding the Money classes'.
	
	domainObject := GtLLepiterPagesDomainObject new
		pages: { page }.
	
	self assert: domainObject pages size equals: 1.
	
	^ domainObject
]

{ #category : #examples }
GtLLepiterPagesDomainObjectExamples >> lepiterPagesEmptyDataViewSerialization [
	<gtExample>
	<return: #GtLPrimitiveMessageDataBlock>
	| domainObject compositeView dataBlock expected |
	domainObject := self lepiterPagesDomainObjectEmpty.
	compositeView := domainObject llmDataViewsFor: GtLDataView new.
	self assert: compositeView dataViews size equals: 1.
	
	dataBlock := compositeView serializeToLlmPrimiteData.
	self assertDataBlockHasOnlyJsonData: dataBlock.
	
	expected := { #pages -> #() } asDictionary.
	self assertDataBlock: dataBlock hasLlmJsonData: expected.
	
	^ dataBlock
]
