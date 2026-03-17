Class {
	#name : #GtLPrimitiveImageDataBlockExamples,
	#superclass : #GtLPrimitiveDataBlockExamples,
	#category : 'Gt4LlmCore-Examples-Data Views'
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
	self assert: skiaImage width equals: 100.
	self assert: skiaImage height equals: 100.
	
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
	| element form stream imageBytes |
	element := BlElement new
		size: 100@100;
		background: Color blue.
	
	form := BlExporter form element: element; export.
	stream := ByteArray new writeStream.
	PNGReadWriter putForm: form onStream: stream.
	imageBytes := stream contents.
	
	self assert: imageBytes isNotEmpty.
	
	^ imageBytes
]
