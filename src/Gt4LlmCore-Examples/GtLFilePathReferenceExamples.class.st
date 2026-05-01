Class {
	#name : #GtLFilePathReferenceExamples,
	#superclass : #GtLDomainObjectExamples,
	#category : #'Gt4LlmCore-Examples-Domain Objects'
}

{ #category : #examples }
GtLFilePathReferenceExamples >> emptyFilePathReference [
	<gtExample>
	<return: #GtLFilePathReference>
	| domainObject compositeView dataBlock jsonData expectedJson |
	
	domainObject := GtLFilePathReference new.
	self assert: domainObject pathString isNil.
	
	compositeView := domainObject llmDataViewsFor: GtLDataView new.
	self assert: compositeView dataViews size equals: 1.
	
	dataBlock := compositeView serializeToLlmPrimiteData.
	self assertDataBlockHasOnlyJsonData: dataBlock.
	
	jsonData := dataBlock compositeJsonData.
	expectedJson := {
		#pathString -> nil
	} asDictionary.
	self assert: jsonData equals: expectedJson.
	
	^ domainObject
]

{ #category : #examples }
GtLFilePathReferenceExamples >> filePathReferenceForDirectory [
	<gtExample>
	<return: #GtLFilePathReference>
	| domainObject compositeView dataBlock jsonData expectedJson pathString |
	
	pathString := '/tmp/example-dir'.
	domainObject := GtLFilePathReference new pathString: pathString.
	self assert: domainObject pathString equals: pathString.
	
	compositeView := domainObject llmDataViewsFor: GtLDataView new.
	self assert: compositeView dataViews size equals: 1.
	
	dataBlock := compositeView serializeToLlmPrimiteData.
	self assertDataBlockHasOnlyJsonData: dataBlock.
	
	jsonData := dataBlock compositeJsonData.
	expectedJson := {
		#pathString -> pathString
	} asDictionary.
	self assert: jsonData equals: expectedJson.
	
	^ domainObject
]

{ #category : #examples }
GtLFilePathReferenceExamples >> filePathReferenceForFile [
	<gtExample>
	<return: #GtLFilePathReference>
	| domainObject compositeView dataBlock expectedJson pathString |
	
	pathString := '/tmp/example.txt'.
	domainObject := GtLFilePathReference new pathString: pathString.
	self assert: domainObject pathString equals: pathString.
	
	compositeView := domainObject llmDataViewsFor: GtLDataView new.
	self assert: compositeView dataViews size equals: 1.
	
	dataBlock := compositeView serializeToLlmPrimiteData.
	self assertDataBlockHasOnlyJsonData: dataBlock.
	
	expectedJson := {
		#pathString -> pathString
	} asDictionary.
	self assertDataBlock: dataBlock hasLlmJsonData: expectedJson.
	
	^ domainObject
]
