"
Examples for GtLWorldScreenshotDataDomainObject, including data view serialization tests.
"
Class {
	#name : #GtLWorldScreenshotDataDomainObjectExamples,
	#superclass : #GtLDomainObjectExamples,
	#category : 'Gt4LlmCore-Examples-Domain Objects'
}

{ #category : #examples }
GtLWorldScreenshotDataDomainObjectExamples >> basicScreenshotDomainObject [
	<gtExample>
	"A minimal PNG image (1x1 red pixel) for testing"
	| domainObject pngBytes |
	pngBytes := #[137 80 78 71 13 10 26 10 0 0 0 13 73 72 68 82 0 0 0 1 0 0 0 1 8 2 0 0 0 144 119 83 222 0 0 0 12 73 68 65 84 8 215 99 248 207 192 0 0 0 4 0 1 255 127 51 136 0 0 0 0 73 69 78 68 174 66 96 130].
	domainObject := GtLWorldScreenshotDataDomainObject new
		bytes: pngBytes.
	
	self assert: domainObject encodedBytes isNotEmpty.
	
	^ domainObject
]

{ #category : #examples }
GtLWorldScreenshotDataDomainObjectExamples >> screenshotDataViewSerialization [
	<gtExample>
	| domainObject compositeView dataBlock imageBlock |
	domainObject := self basicScreenshotDomainObject.
	compositeView := domainObject llmDataViewsFor: GtLDataView new.
	self assert: compositeView dataViews size equals: 1.
	
	dataBlock := compositeView serializeToLlmPrimiteData.
	self assert: dataBlock isNotNil.
	self assert: dataBlock dataBlocks size equals: 1.
	self assert: dataBlock imageDataBlocks size equals: 1.
	
	imageBlock := dataBlock imageDataBlocks first.
	self assert: (imageBlock isKindOf: GtLPrimitiveImageDataBlock).
	self assert: imageBlock imageType equals: 'png'.
	self assert: imageBlock imageBytes size equals: 69.
	self assert: imageBlock encodedBytes isNotEmpty.
	
	^ dataBlock
]
