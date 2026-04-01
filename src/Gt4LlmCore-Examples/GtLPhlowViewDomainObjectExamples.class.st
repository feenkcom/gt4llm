"
Examples for GtLPhlowViewDomainObject demonstrating data view serialization.
"
Class {
	#name : #GtLPhlowViewDomainObjectExamples,
	#superclass : #Object,
	#category : 'Gt4LlmCore-Examples-Domain Objects'
}

{ #category : #examples }
GtLPhlowViewDomainObjectExamples >> basicPhlowViewDomainObject [
	<gtExample>
	<return: #GtLPhlowViewDomainObject>
	| view domainObject |
	view := GtPhlowView empty on: 'Hello' perform: #gtStringFor:.
	domainObject := GtLPhlowViewDomainObject 
		phlowView: view 
		viewMethodClassName: String name 
		viewMethodSourceCode: (String >> #gtStringFor:) sourceCode.
	
	self assert: domainObject phlowView equals: view.
	self assert: domainObject viewMethodClassName equals: #String.
	self assert: domainObject viewMethodSourceCode equals: (String >> #gtStringFor:) sourceCode.
	self assert: domainObject phlowView title equals: 'String'.
	
	^ domainObject
]

{ #category : #examples }
GtLPhlowViewDomainObjectExamples >> phlowViewDataViewSerialization [
	<gtExample>
	<return: #GtLPrimitiveMessageDataBlock>
	| domainObject compositeView dataBlock jsonData imageBlock |
	domainObject := self basicPhlowViewDomainObject.
	compositeView := domainObject llmDataViewsFor: GtLDataView new.
	self assert: compositeView dataViews size equals: 2.
	
	dataBlock := compositeView serializeToLlmPrimiteData.
	self assert: dataBlock isNotNil.
	self assert: dataBlock dataBlocks size equals: 2.
	self assert: dataBlock imageDataBlocks size equals: 1.
	
	jsonData := dataBlock compositeJsonData.
	self assert: jsonData equals: (Dictionary new
		at: #viewTitle put: 'String';
		at: #priority put: 9;
		at: #viewMethodClass put: #String;
		at: #viewMethodSourceCode put: (String >> #gtStringFor:) sourceCode;
		yourself).
	
	imageBlock := dataBlock imageDataBlocks first.
	self assert: (imageBlock isKindOf: GtLPrimitiveImageDataBlock).
	self assert: imageBlock imageType equals: 'png'.
	self assert: imageBlock imageBytes isNotEmpty.
	
	^ dataBlock
]
