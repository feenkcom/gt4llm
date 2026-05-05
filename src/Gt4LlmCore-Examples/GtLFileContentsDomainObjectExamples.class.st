Class {
	#name : #GtLFileContentsDomainObjectExamples,
	#superclass : #GtLDomainObjectExamples,
	#category : #'Gt4LlmCore-Examples-Domain Objects'
}

{ #category : #examples }
GtLFileContentsDomainObjectExamples >> emptyFileContents [
	<gtExample>
	<return: #GtLFileContentsDomainObject>
	| domainObject compositeView dataBlock jsonData expectedJson |
	
	domainObject := GtLFileContentsDomainObject new.
	self assert: domainObject path isNil.
	self assert: domainObject contents isNil.
	
	compositeView := domainObject llmDataViewsFor: GtLDataView new.
	self assert: compositeView dataViews size equals: 1.
	
	dataBlock := compositeView serializeToLlmPrimiteData.
	self assertDataBlockHasOnlyJsonData: dataBlock.
	
	jsonData := dataBlock compositeJsonData.
	expectedJson := {
		#path -> nil.
		#contents -> nil
	} asDictionary.
	self assert: jsonData equals: expectedJson.
	
	^ domainObject
]

{ #category : #examples }
GtLFileContentsDomainObjectExamples >> fileContentsWithData [
	<gtExample>
	<return: #GtLFileContentsDomainObject>
	| domainObject compositeView dataBlock expectedJson encodedContents |
	
	encodedContents := 'Hello World' asByteArray base64Encoded.
	domainObject := GtLFileContentsDomainObject new
		path: '/tmp/test.txt';
		contents: encodedContents.
	self assert: domainObject path equals: '/tmp/test.txt'.
	self assert: domainObject contents equals: encodedContents.
	
	compositeView := domainObject llmDataViewsFor: GtLDataView new.
	self assert: compositeView dataViews size equals: 1.
	
	dataBlock := compositeView serializeToLlmPrimiteData.
	self assertDataBlockHasOnlyJsonData: dataBlock.
	
	expectedJson := {
		#path -> '/tmp/test.txt'.
		#contents -> encodedContents
	} asDictionary.
	self assertDataBlock: dataBlock hasLlmJsonData: expectedJson.
	
	^ domainObject
]
