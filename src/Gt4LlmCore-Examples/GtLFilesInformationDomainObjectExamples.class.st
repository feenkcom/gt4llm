"
Examples for files information domain object.
"
Class {
	#name : #GtLFilesInformationDomainObjectExamples,
	#superclass : #GtLMagritteDomainObjectExamples,
	#category : 'Gt4LlmCore-Examples-Domain Objects'
}

{ #category : #examples }
GtLFilesInformationDomainObjectExamples >> filesInformationForExistingFiles [
	<gtExample>
	| fileOne fileTwo domainObject |
	fileOne := FileReference newTempFilePrefix: 'GtLFilesInformation' suffix: '.txt'.
	fileTwo := FileReference newTempFilePrefix: 'GtLFilesInformation' suffix: '.txt'.
	[ fileOne writeStreamDo: [ :stream | stream nextPutAll: 'First file' ].
		fileTwo writeStreamDo: [ :stream | stream nextPutAll: 'Second file' ].
		domainObject := GtLFilesInformation new
			files: {
				(GtLFileInformation new initializeFromFileReference: fileOne; yourself).
				(GtLFileInformation new initializeFromFileReference: fileTwo; yourself)
			}.
		self assert: domainObject files size equals: 2.
		self assert: domainObject files first path equals: fileOne pathString.
		self assert: domainObject files second path equals: fileTwo pathString.
		^ domainObject ]
		ensure: [
			fileOne exists ifTrue: [ fileOne delete ].
			fileTwo exists ifTrue: [ fileTwo delete ] ]
]

{ #category : #examples }
GtLFilesInformationDomainObjectExamples >> filesInformationSerialization [
	<gtExample>
	| domainObject jsonObject expected |
	domainObject := self filesInformationForExistingFiles.
	jsonObject := GtMagritteJSONDataExporter exportObject: domainObject.
	expected := NeoJSONObject new
		at: 'files'
		put: (NeoJSONArray withAll: (domainObject files collect: [ :each |
			NeoJSONObject new
				at: 'path' put: each path;
				at: 'size' put: each size;
				at: 'creationTime' put: each creationTime asIso8601;
				at: 'modificationTime' put: each modificationTime asIso8601;
				at: 'accessTime' put: each accessTime asIso8601;
				at: 'type' put: each type;
				at: 'permissions' put: each permissions;
				yourself ]) asArray);
		yourself.
	self assert: jsonObject equals: expected.
	^ jsonObject
]
