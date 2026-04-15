"
I provide examples for GtLTextFile.
"
Class {
	#name : #GtLTextFileExamples,
	#superclass : #GtLFileReferenceExamples,
	#category : #'Gt4LlmCore-Examples-Domain Objects'
}

{ #category : #'examples - support' }
GtLTextFileExamples >> sampleTextFileReference [
	<gtExample>
	<after: #cleanupTempDirectory>
	| fileRef |
	fileRef := self tempDirectory / 'sample.txt'.
	fileRef writeStreamDo: [ :stream | stream nextPutAll: 'Hello, World!' ].
	
	self assert: fileRef exists.
	
	^ fileRef
]

{ #category : #examples }
GtLTextFileExamples >> textFile [
	<gtExample>
	<after: #cleanupTempDirectory>
	| textFile |
	textFile := GtLTextFile fileReference: self sampleTextFileReference.
	
	self assert: textFile fileReference exists.
	self assertFileReference: textFile hasContentType: 'text/plain'.
	
	^ textFile
]

{ #category : #examples }
GtLTextFileExamples >> textFileMainDataView [
	<gtExample>
	<after: #cleanupTempDirectory>
	| textFile mainDataView |
	textFile := self textFile.
	mainDataView := textFile llmDataViewsFor: GtLDataView new.
	
	self assertCompositeDataView: mainDataView hasTitle: 'Object views' viewsCount: 1.
	
	^ mainDataView
]

{ #category : #examples }
GtLTextFileExamples >> textFileSerialization [
	<gtExample>
	<after: #cleanupTempDirectory>
	| mainDataView dataBlock |
	mainDataView := self textFileMainDataView.
	dataBlock := mainDataView serializeToLlmPrimiteData.
	
	self assert: dataBlock isNotNil.
	self assert: dataBlock dataBlocks size equals: 1.
	self assertDataBlock: dataBlock hasDocumentWithContentType: 'text/plain'.
	
	^ dataBlock
]
