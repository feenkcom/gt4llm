Class {
	#name : #GtLSearchFilterDomainObjectExamples,
	#superclass : #GtLDomainObjectExamples,
	#category : 'Gt4LlmCore-Examples-Domain Objects'
}

{ #category : #examples }
GtLSearchFilterDomainObjectExamples >> searchFilterDomainObjectDataViewSerialization [
	<gtExample>
	<return: #GtLPrimitiveMessageDataBlock>
	| domainObject compositeView dataBlock jsonData |
	domainObject := self searchFilterDomainObjectWithItems.
	compositeView := domainObject llmDataViewsFor: GtLDataView new.
	self assert: compositeView dataViews size equals: 1.
	
	dataBlock := compositeView serializeToLlmPrimiteData.
	self assert: dataBlock isNotNil.
	self assert: dataBlock dataBlocks size equals: 1.
	self assert: dataBlock imageDataBlocks isEmpty.
	
	jsonData := dataBlock compositeJsonData.
	self assert: (jsonData at: #query) equals: 'GtLSearchFilterDomainObjectExamples gtMethodsInClass'.
	self assert: (jsonData at: #mayHaveMore) equals: false.
	self assert: (jsonData at: #itemsAsPrintStrings) asArray equals: #(
		'GtLSearchFilterDomainObjectExamples>>#searchFilterDomainObjectWithItems'
		'GtLSearchFilterDomainObjectExamples>>#searchFilterDomainObjectDataViewSerialization'
	).
	
	^ dataBlock
]

{ #category : #examples }
GtLSearchFilterDomainObjectExamples >> searchFilterDomainObjectWithItems [
	<gtExample>
	<return: #GtLSearchFilterDomainObject>
	| domainObject items |
	items := { 
		GtLSearchFilterDomainObjectExamples >> #searchFilterDomainObjectWithItems.
		GtLSearchFilterDomainObjectExamples >> #searchFilterDomainObjectDataViewSerialization 
	}.
	
	domainObject := GtLSearchFilterDomainObject new
		query: 'GtLSearchFilterDomainObjectExamples gtMethodsInClass';
		items: items;
		mayHaveMore: false.
	
	self assert: domainObject query equals: 'GtLSearchFilterDomainObjectExamples gtMethodsInClass'.
	self assert: domainObject items size equals: 2.
	self assert: domainObject mayHaveMore not.
	
	^ domainObject
]

{ #category : #examples }
GtLSearchFilterDomainObjectExamples >> searchFilterDomainObjectWithMayHaveMore [
	<gtExample>
	<return: #GtLSearchFilterDomainObject>
	| domainObject items |
	items := { GtLSearchFilterDomainObjectExamples >> #searchFilterDomainObjectWithMayHaveMore }.
	
	domainObject := GtLSearchFilterDomainObject new
		query: 'Object gtMethodsInClass';
		items: items;
		mayHaveMore: true.
	
	self assert: domainObject query equals: 'Object gtMethodsInClass'.
	self assert: domainObject items size equals: 1.
	self assert: domainObject mayHaveMore.
	
	^ domainObject
]

{ #category : #examples }
GtLSearchFilterDomainObjectExamples >> searchFilterDomainObjectWithMayHaveMoreDataViewSerialization [
	<gtExample>
	<return: #GtLPrimitiveMessageDataBlock>
	| domainObject compositeView dataBlock jsonData |
	domainObject := self searchFilterDomainObjectWithMayHaveMore.
	compositeView := domainObject llmDataViewsFor: GtLDataView new.
	self assert: compositeView dataViews size equals: 1.
	
	dataBlock := compositeView serializeToLlmPrimiteData.
	self assert: dataBlock isNotNil.
	self assert: dataBlock dataBlocks size equals: 1.
	self assert: dataBlock imageDataBlocks isEmpty.
	
	jsonData := dataBlock compositeJsonData.
	self assert: (jsonData at: #query) equals: 'Object gtMethodsInClass'.
	self assert: (jsonData at: #mayHaveMore) equals: true.
	self assert: (jsonData at: #itemsAsPrintStrings) asArray equals: #(
		'GtLSearchFilterDomainObjectExamples>>#searchFilterDomainObjectWithMayHaveMore'
	).
	
	^ dataBlock
]
