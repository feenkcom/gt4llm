"
I provide examples for GtLImageFile.
"
Class {
	#name : #GtLImageFileExamples,
	#superclass : #GtLFileReferenceExamples,
	#category : 'Gt4LlmCore-Examples-Domain Objects'
}

{ #category : #examples }
GtLImageFileExamples >> imageFile [
	<gtExample>
	<after: #cleanupTempDirectory>
	| imageFile |
	imageFile := GtLImageFile fileReference: self samplePngFileReference.
	
	self assert: imageFile fileReference exists.
	self assertFileReference: imageFile hasContentType: 'image/png'.
	
	^ imageFile
]

{ #category : #examples }
GtLImageFileExamples >> imageFileMainDataView [
	<gtExample>
	<after: #cleanupTempDirectory>
	| imageFile mainDataView |
	imageFile := self imageFile.
	mainDataView := imageFile llmDataViewsFor: GtLDataView new.
	
	self assertCompositeDataView: mainDataView hasTitle: 'Object views' viewsCount: 1.
	
	^ mainDataView
]

{ #category : #examples }
GtLImageFileExamples >> imageFileSerialization [
	<gtExample>
	<after: #cleanupTempDirectory>
	| mainDataView dataBlock |
	mainDataView := self imageFileMainDataView.
	dataBlock := mainDataView serializeToLlmPrimiteData.
	
	self assert: dataBlock isNotNil.
	self assert: dataBlock dataBlocks size equals: 1.
	self assert: dataBlock imageDataBlocks size equals: 1.
	self assert: dataBlock imageDataBlocks first imageType equals: 'png'.
	
	^ dataBlock
]

{ #category : #examples }
GtLImageFileExamples >> imageFileSerialization_contentLabel [
	<gtExample>
	<after: #cleanupTempDirectory>
	| mainDataView dataBlock imageDataBlock |
	mainDataView := self imageFileMainDataView.
	dataBlock := mainDataView serializeToLlmPrimiteData.
	
	self assert: dataBlock isNotNil.
	self assert: dataBlock dataBlocks size equals: 1.
	self assert: dataBlock imageDataBlocks size equals: 1.
	self assert: dataBlock imageDataBlocks first imageType equals: 'png'.
	
	imageDataBlock := dataBlock imageDataBlocks first.
	self assert: imageDataBlock contentLabel equals: 'sample.png'.
	
	^ dataBlock
]

{ #category : #'examples - support' }
GtLImageFileExamples >> samplePngFileReference [
	<gtExample>
	<after: #cleanupTempDirectory>
	| fileRef element form stream imageBytes |
	fileRef := self tempDirectory / 'sample.png'.
	
	element := BlElement new
		size: 50@50;
		background: Color red.
	form := BlExporter form element: element; export.
	stream := ByteArray new writeStream.
	PNGReadWriter putForm: form onStream: stream.
	imageBytes := stream contents.
	
	fileRef binaryWriteStreamDo: [ :out | out nextPutAll: imageBytes ].
	
	self assert: fileRef exists.
	
	^ fileRef
]
