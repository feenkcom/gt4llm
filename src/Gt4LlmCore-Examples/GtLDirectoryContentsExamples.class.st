Class {
	#name : #GtLDirectoryContentsExamples,
	#superclass : #GtLDomainObjectExamples,
	#category : #'Gt4LlmCore-Examples-Domain Objects'
}

{ #category : #examples }
GtLDirectoryContentsExamples >> directoryContentsWithFilesAndDirectories [
	<gtExample>
	<return: #GtLDirectoryContents>
	| domainObject compositeView dataBlock jsonData expectedJson file1 file2 dir1 |
	
	file1 := GtLFilePathReference new pathString: '/tmp/test/file1.txt'.
	file2 := GtLFilePathReference new pathString: '/tmp/test/file2.txt'.
	dir1 := GtLFilePathReference new pathString: '/tmp/test/subdir'.
	
	domainObject := GtLDirectoryContents new
		directoryPath: '/tmp/test';
		files: { file1. file2 };
		directories: { dir1 }.
	self assert: domainObject directoryPath equals: '/tmp/test'.
	self assert: domainObject files size equals: 2.
	self assert: domainObject directories size equals: 1.
	
	compositeView := domainObject llmDataViewsFor: GtLDataView new.
	self assert: compositeView dataViews size equals: 1.
	
	dataBlock := compositeView serializeToLlmPrimiteData.
	self assert: dataBlock dataBlocks size equals: 1.
	self assert: dataBlock imageDataBlocks isEmpty.
	
	jsonData := dataBlock compositeJsonData.
	expectedJson := {
		#directoryPath -> '/tmp/test'.
		#files -> (NeoJSONArray withAll: {
			NeoJSONObject new at: #pathString put: '/tmp/test/file1.txt'; yourself.
			NeoJSONObject new at: #pathString put: '/tmp/test/file2.txt'; yourself
		}).
		#directories -> (NeoJSONArray withAll: {
			NeoJSONObject new at: #pathString put: '/tmp/test/subdir'; yourself
		})
	} asDictionary.
	self assert: jsonData equals: expectedJson.
	
	^ domainObject
]

{ #category : #examples }
GtLDirectoryContentsExamples >> emptyDirectoryContents [
	<gtExample>
	<return: #GtLDirectoryContents>
	| domainObject compositeView dataBlock jsonData expectedJson |
	
	domainObject := GtLDirectoryContents new
		directoryPath: '/tmp/test';
		files: #();
		directories: #().
	self assert: domainObject directoryPath equals: '/tmp/test'.
	self assert: domainObject files isEmpty.
	self assert: domainObject directories isEmpty.
	
	compositeView := domainObject llmDataViewsFor: GtLDataView new.
	self assert: compositeView dataViews size equals: 1.
	
	dataBlock := compositeView serializeToLlmPrimiteData.
	self assert: dataBlock dataBlocks size equals: 1.
	self assert: dataBlock imageDataBlocks isEmpty.
	
	jsonData := dataBlock compositeJsonData.
	expectedJson := {
		#directoryPath -> '/tmp/test'.
		#files -> NeoJSONArray new.
		#directories -> NeoJSONArray new
	} asDictionary.
	self assert: jsonData equals: expectedJson.
	
	^ domainObject
]
