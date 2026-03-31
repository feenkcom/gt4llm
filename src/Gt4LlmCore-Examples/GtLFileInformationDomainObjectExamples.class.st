"
Examples for file information domain object.
"
Class {
	#name : #GtLFileInformationDomainObjectExamples,
	#superclass : #GtLMagritteDomainObjectExamples,
	#category : 'Gt4LlmCore-Examples-Domain Objects'
}

{ #category : #examples }
GtLFileInformationDomainObjectExamples >> fileInformationDataViewSerialization [
	<gtExample>
	<return: #GtLPrimitiveMessageDataBlock>
	| domainObject compositeView dataBlock jsonData expectedJson |
	domainObject := self fileInformationForExistingFile.
	
	compositeView := domainObject llmDataViewsFor: GtLDataView new.
	self assert: compositeView dataViews size equals: 1.
	
	dataBlock := compositeView serializeToLlmPrimiteData.
	self assert: dataBlock dataBlocks size equals: 1.
	self assert: dataBlock imageDataBlocks isEmpty.
	
	jsonData := dataBlock compositeJsonData.
	expectedJson := {
		#path -> domainObject path.
		#size -> domainObject size.
		#creationTime -> domainObject creationTime asIso8601.
		#modificationTime -> domainObject modificationTime asIso8601.
		#accessTime -> domainObject accessTime asIso8601.
		#type -> domainObject type.
		#permissions -> domainObject permissions
	} asDictionary.
	self assert: jsonData equals: expectedJson.
	
	^ dataBlock
]

{ #category : #examples }
GtLFileInformationDomainObjectExamples >> fileInformationForExistingFile [
	<gtExample>
	| fileReference domainObject |
	fileReference := FileReference newTempFilePrefix: 'GtLFileInformation' suffix: '.txt'.
	[ fileReference writeStreamDo: [ :stream | stream nextPutAll: 'Example' ].
		domainObject := GtLFileInformation new
			initializeFromFileReference: fileReference;
			yourself.
		self assert: domainObject path equals: fileReference pathString.
		self assert: domainObject size equals: fileReference size.
		self assert: domainObject creationTime equals: fileReference creationTime.
		self assert: domainObject modificationTime equals: fileReference modificationTime.
		self assert: domainObject accessTime equals: fileReference accessTime.
		self assert: domainObject type equals: 'file'.
		self assert: domainObject permissions equals: fileReference permissions printString.
		^ domainObject ]
		ensure: [ fileReference exists ifTrue: [ fileReference delete ] ]
]

{ #category : #examples }
GtLFileInformationDomainObjectExamples >> fileInformationSerialization [
	<gtExample>
	| domainObject jsonObject expected |
	domainObject := self fileInformationForExistingFile.
	jsonObject := GtMagritteJSONDataExporter exportObject: domainObject.
	expected := NeoJSONObject new
		at: 'path' put: domainObject path;
		at: 'size' put: domainObject size;
		at: 'creationTime' put: domainObject creationTime asIso8601;
		at: 'modificationTime' put: domainObject modificationTime asIso8601;
		at: 'accessTime' put: domainObject accessTime asIso8601;
		at: 'type' put: domainObject type;
		at: 'permissions' put: domainObject permissions;
		yourself.
	self assert: jsonObject equals: expected.
	^ jsonObject
]
