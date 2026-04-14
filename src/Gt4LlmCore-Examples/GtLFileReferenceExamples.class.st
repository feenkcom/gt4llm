"
I provide common example infrastructure for GtLFileReference subclass examples.
"
Class {
	#name : #GtLFileReferenceExamples,
	#superclass : #GtLDomainObjectExamples,
	#traits : 'TGtLDataViewAssertions',
	#classTraits : 'TGtLDataViewAssertions classTrait',
	#instVars : [
		'tempDirectory'
	],
	#category : 'Gt4LlmCore-Examples-Domain Objects'
}

{ #category : #assertions }
GtLFileReferenceExamples >> assertDataBlock: aDataBlock hasDocumentWithContentType: aContentType [
	"Assert that the data block contains a document with the expected content type"
	self assert: aDataBlock documentDataBlocks size equals: 1.
	self assert: aDataBlock documentDataBlocks first contentType equals: aContentType
]

{ #category : #assertions }
GtLFileReferenceExamples >> assertFileReference: aFileRef hasContentType: aContentType [
	"Assert that the file reference has the expected content type"
	self assert: aFileRef contentType equals: aContentType
]

{ #category : #'examples - support' }
GtLFileReferenceExamples >> cleanupTempDirectory [
	"Remove the temporary directory and its contents"
	tempDirectory ifNotNil: [ 
		tempDirectory exists ifTrue: [ tempDirectory ensureDeleteAll ].
		tempDirectory := nil ]
]

{ #category : #examples }
GtLFileReferenceExamples >> ensureTempDirectory [
	<gtExample>
	<after: #cleanupTempDirectory>
	| dir |
	dir := self tempDirectory.
	self assert: dir exists.
	^ dir
]

{ #category : #examples }
GtLFileReferenceExamples >> fromFileReferenceForPdf [
	<gtExample>
	<after: #cleanupTempDirectory>
	| fileRef result |
	fileRef := self tempDirectory / 'test.pdf'.
	fileRef writeStreamDo: [ :stream | stream nextPutAll: '%PDF' ].
	
	result := GtLFileReference fromFileReference: fileRef.
	
	self assert: result class equals: GtLPdfFile.
	self assert: result fileReference equals: fileRef.
	
	^ result
]

{ #category : #examples }
GtLFileReferenceExamples >> fromFileReferenceForPng [
	<gtExample>
	<after: #cleanupTempDirectory>
	| fileRef result |
	fileRef := self tempDirectory / 'test.png'.
	fileRef binaryWriteStreamDo: [ :stream | stream nextPutAll: #[137 80 78 71] ].
	
	result := GtLFileReference fromFileReference: fileRef.
	
	self assert: result class equals: GtLImageFile.
	self assert: result fileReference equals: fileRef.
	
	^ result
]

{ #category : #examples }
GtLFileReferenceExamples >> fromFileReferenceForTxt [
	<gtExample>
	<after: #cleanupTempDirectory>
	| fileRef result |
	fileRef := self tempDirectory / 'test.txt'.
	fileRef writeStreamDo: [ :stream | stream nextPutAll: 'Hello' ].
	
	result := GtLFileReference fromFileReference: fileRef.
	
	self assert: result class equals: GtLTextFile.
	self assert: result fileReference equals: fileRef.
	
	^ result
]

{ #category : #'examples - support' }
GtLFileReferenceExamples >> tempDirectory [
	"Return the temporary directory for test files, creating it if needed"
	^ tempDirectory ifNil: [
		tempDirectory := FileLocator temp / ('gtl-file-reference-examples-', UUID new asString).
		tempDirectory ensureCreateDirectory.
		tempDirectory ]
]
