Class {
	#name : #GtLPrimitiveImageDataBlockExamples,
	#superclass : #GtLPrimitiveDataBlockExamples,
	#category : #'Gt4LlmCore-Examples-Data Views'
}

{ #category : #examples }
GtLPrimitiveImageDataBlockExamples >> basicImageDataBlock [
	<gtExample>
	| block |
	block := GtLPrimitiveImageDataBlock new.
	
	self assert: block imageBytes isNil.
	self assert: block imageType isNil.
	self assert: block dataKey isNil.
	
	^ block
]

{ #category : #examples }
GtLPrimitiveImageDataBlockExamples >> imageDataBlockSkiaImage [
	<gtExample>
	| block skiaImage |
	block := self imageDataBlockWithBytesAndType.
	
	skiaImage := block skiaImage.
	
	self assert: skiaImage isNotNil.
	self assert: skiaImage width > 0.
	self assert: skiaImage height > 0.
	
	^ skiaImage
]

{ #category : #examples }
GtLPrimitiveImageDataBlockExamples >> imageDataBlockWithBytes [
	<gtExample>
	| block imageBytes |
	imageBytes := self sampleImageBytes.
	
	block := self basicImageDataBlock.
	block imageBytes: imageBytes.
	
	self assert: block imageBytes equals: imageBytes.
	self assert: block encodedBytes isNotNil.
	self assert: block encodedBytes equals: imageBytes base64Encoded.
	self assert: block imageType isNil.
	self assert: block dataKey isNil.
	
	^ block
]

{ #category : #examples }
GtLPrimitiveImageDataBlockExamples >> imageDataBlockWithBytesAndType [
	<gtExample>
	| block imageBytes |
	imageBytes := self sampleImageBytes.
	
	block := self basicImageDataBlock.
	block imageBytes: imageBytes.
	block imageType: 'png'.
	
	self assert: block imageBytes equals: imageBytes.
	self assert: block encodedBytes equals: imageBytes base64Encoded.
	self assert: block imageType equals: 'png'.
	self assert: block dataKey isNil.
	self assertSerializationForDataBlockWithOneDataPart: block.
	
	^ block
]

{ #category : #examples }
GtLPrimitiveImageDataBlockExamples >> imageDataBlockWithContentLabel [
	<gtExample>
	| block imageBytes |
	imageBytes := self sampleImageBytes.
	
	block := self basicImageDataBlock.
	block imageBytes: imageBytes.
	block imageType: 'png'.
	block contentLabel: 'sample-image.png'.
	
	self assert: block imageBytes equals: imageBytes.
	self assert: block encodedBytes equals: imageBytes base64Encoded.
	self assert: block imageType equals: 'png'.
	self assert: block contentLabel equals: 'sample-image.png'.
	self assert: block dataKey isNil.
	self assertSerializationForDataBlockWithOneDataPart: block.
	
	^ block
]

{ #category : #examples }
GtLPrimitiveImageDataBlockExamples >> imageDataBlockWithDataKey [
	<gtExample>
	| block imageBytes |
	imageBytes := self sampleImageBytes.
	
	block := self basicImageDataBlock.
	block dataKey: 'screenshot'.
	block imageBytes: imageBytes.
	block imageType: 'png'.
	
	self assert: block imageBytes equals: imageBytes.
	self assert: block encodedBytes equals: imageBytes base64Encoded.
	self assert: block imageType equals: 'png'.
	self assert: block dataKey equals: 'screenshot'.
	self assertSerializationForDataBlockWithOneDataPart: block.
	
	^ block
]

{ #category : #'examples - support' }
GtLPrimitiveImageDataBlockExamples >> sampleImageBytes [
	<gtExample>
	| element rootElement form imageBytes |
	element := BlElement new
		size: 100@100;
		background: Color blue.
		
	rootElement := BlScripter new
			element: element;
			extent: 1600@1200;
			elementWithoutParent.
	form := BlExporter png
			element: rootElement;
			doExport: [ :aCanvas | aCanvas asForm ].
	imageBytes :=(ByteArray
		streamContents: [ :out | PNGReadWriter putForm: form onStream: out ]).
	
	self assert: imageBytes isNotEmpty.
	
	^ imageBytes
]
