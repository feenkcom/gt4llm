Class {
	#name : #GtLFilesContentsDomainObjectExamples,
	#superclass : #GtLDomainObjectExamples,
	#category : 'Gt4LlmCore-Examples-Domain Objects'
}

{ #category : #examples }
GtLFilesContentsDomainObjectExamples >> emptyFilesContents [
	<gtExample>
	<return: #GtLFilesContents>
	| domainObject compositeView dataBlock jsonData expectedJson |
	
	domainObject := GtLFilesContents new files: #().
	self assert: domainObject files isEmpty.
	
	compositeView := domainObject llmDataViewsFor: GtLDataView new.
	self assert: compositeView dataViews size equals: 1.
	
	dataBlock := compositeView serializeToLlmPrimiteData.
	self assertDataBlockHasOnlyJsonData: dataBlock.
	
	jsonData := dataBlock compositeJsonData.
	expectedJson := {
		#files -> NeoJSONArray new
	} asDictionary.
	self assert: jsonData equals: expectedJson.
	
	^ domainObject
]

{ #category : #examples }
GtLFilesContentsDomainObjectExamples >> filesContentsWithMultipleFiles [
	<gtExample>
	<return: #GtLFilesContents>
	| domainObject compositeView dataBlock jsonData file1 file2 encoded1 encoded2 |
	
	encoded1 := 'First file content' asByteArray base64Encoded.
	encoded2 := 'Second file content' asByteArray base64Encoded.
	file1 := GtLFileContentsDomainObject new path: '/tmp/file1.txt'; contents: encoded1.
	file2 := GtLFileContentsDomainObject new path: '/tmp/file2.txt'; contents: encoded2.
	
	domainObject := GtLFilesContents new files: { file1. file2 }.
	self assert: domainObject files size equals: 2.
	
	compositeView := domainObject llmDataViewsFor: GtLDataView new.
	self assert: compositeView dataViews size equals: 1.
	
	dataBlock := compositeView serializeToLlmPrimiteData.
	self assertDataBlockHasOnlyJsonData: dataBlock.
	
	jsonData := dataBlock compositeJsonData.
	self assert: (jsonData at: #files) size equals: 2.
	self assert: ((jsonData at: #files) first at: #path) equals: '/tmp/file1.txt'.
	self assert: ((jsonData at: #files) first at: #contents) equals: encoded1.
	self assert: ((jsonData at: #files) second at: #path) equals: '/tmp/file2.txt'.
	self assert: ((jsonData at: #files) second at: #contents) equals: encoded2.
	
	^ domainObject
]
