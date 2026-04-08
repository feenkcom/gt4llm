Class {
	#name : #GtLPrimitiveMessageDataBlockExamples,
	#superclass : #GtLPrimitiveDataBlockExamples,
	#category : #'Gt4LlmCore-Examples-Data Views'
}

{ #category : #examples }
GtLPrimitiveMessageDataBlockExamples >> basicMessageDataBlock [
	<gtExample>
	| block |
	block := GtLPrimitiveMessageDataBlock new.
	
	self assert: block compositeJsonDataBlock isNotNil.
	self assert: block compositeJsonDataBlock jsonDataBlocks isEmpty.
	self assert: block imageDataBlocks isEmpty.
	self assert: block dataBlocks size equals: 0.
	self assert: block containedJsonDataBlocksCount equals: 0.
	
	^ block
]

{ #category : #'examples - support' }
GtLPrimitiveMessageDataBlockExamples >> compositeJsonDataBlockExamples [
	^ GtLPrimitiveCompositeJsonDataBlockExamples new
]

{ #category : #'examples - support' }
GtLPrimitiveMessageDataBlockExamples >> imageDataBlockExamples [
	^ GtLPrimitiveImageDataBlockExamples new
]

{ #category : #'examples - support' }
GtLPrimitiveMessageDataBlockExamples >> jsonDataBlockExamples [
	^ GtLPrimitiveJsonDataBlockExamples new
]

{ #category : #examples }
GtLPrimitiveMessageDataBlockExamples >> messageDataBlockWithCompositeJsonBlock [
	<gtExample>
	| block compositeBlock |
	block := self basicMessageDataBlock.
	compositeBlock := self compositeJsonDataBlockExamples compositeWithTwoBlocksWithDataKeys.
	
	block addJsonDataBlock: compositeBlock.
	
	self assert: block compositeJsonDataBlock jsonDataBlocks size equals: 1.
	self assert: block imageDataBlocks isEmpty.
	self assert: block containedJsonDataBlocksCount equals: 2.
	self assertSerializationForDataBlockWithOneDataPart: block.
	
	^ block
]

{ #category : #examples }
GtLPrimitiveMessageDataBlockExamples >> messageDataBlockWithCompositeJsonBlockAndImageBlock [
	<gtExample>
	| block compositeBlock imageBlock |
	block := self basicMessageDataBlock.
	
	compositeBlock := self compositeJsonDataBlockExamples compositeWithMixedBlocks.
	imageBlock := self imageDataBlockExamples imageDataBlockWithBytesAndType.
	
	block addJsonDataBlock: compositeBlock.
	block addImageDataBlock: imageBlock.
	
	self assert: block compositeJsonDataBlock jsonDataBlocks size equals: 1.
	self assert: block imageDataBlocks size equals: 1.
	self assert: block dataBlocks size equals: 2.
	self assertSerializationForDataBlockWithTwoDataParts: block.
	
	^ block
]

{ #category : #examples }
GtLPrimitiveMessageDataBlockExamples >> messageDataBlockWithJsonAndImageBlocks [
	<gtExample>
	| block jsonBlock imageBlock |
	block := self basicMessageDataBlock.
	
	jsonBlock := self jsonDataBlockExamples jsonDataBlockWithData.
	imageBlock := self imageDataBlockExamples imageDataBlockWithBytesAndType.
	
	block addJsonDataBlock: jsonBlock.
	block addImageDataBlock: imageBlock.
	
	self assert: block compositeJsonDataBlock jsonDataBlocks size equals: 1.
	self assert: block imageDataBlocks size equals: 1.
	self assert: block dataBlocks size equals: 2.
	self assertSerializationForDataBlockWithTwoDataParts: block.
	
	^ block
]

{ #category : #examples }
GtLPrimitiveMessageDataBlockExamples >> messageDataBlockWithJsonBlockAndCompositeJsonBlock [
	<gtExample>
	| block jsonBlock compositeBlock |
	block := self basicMessageDataBlock.
	
	jsonBlock := GtLPrimitiveJsonDataBlock new
		jsonData: (Dictionary new
			at: 'name' put: 'John';
			yourself).
	
	compositeBlock := self compositeJsonDataBlockExamples compositeWithDataKeyAndBlocksWithoutDataKeys.
	
	block addJsonDataBlock: jsonBlock.
	block addJsonDataBlock: compositeBlock.
	
	self assert: block compositeJsonDataBlock jsonDataBlocks size equals: 2.
	self assert: block imageDataBlocks isEmpty.
	self assert: block containedJsonDataBlocksCount equals: 3.
	self assertSerializationForDataBlockWithOneDataPart: block.
	
	^ block
]

{ #category : #examples }
GtLPrimitiveMessageDataBlockExamples >> messageDataBlockWithMultipleJsonAndImageBlocks [
	<gtExample>
	| block jsonBlock1 jsonBlock2 imageBlock1 imageBlock2 |
	block := self basicMessageDataBlock.
	
	jsonBlock1 := GtLPrimitiveJsonDataBlock new
		jsonData: (Dictionary new
			at: 'name' put: 'John';
			yourself).
	
	jsonBlock2 := GtLPrimitiveJsonDataBlock new
		dataKey: 'address';
		jsonData: (Dictionary new
			at: 'city' put: 'New York';
			yourself).
	
	imageBlock1 := self imageDataBlockExamples imageDataBlockWithBytesAndType.
	imageBlock2 := self imageDataBlockExamples imageDataBlockWithDataKey.
	
	block addJsonDataBlock: jsonBlock1.
	block addJsonDataBlock: jsonBlock2.
	block addImageDataBlock: imageBlock1.
	block addImageDataBlock: imageBlock2.
	
	self assert: block compositeJsonDataBlock jsonDataBlocks size equals: 2.
	self assert: block imageDataBlocks size equals: 2.
	self assert: block dataBlocks size equals: 3.
	self assertSerializationForDataBlock: block dataPartsCount: 3.
	
	^ block
]

{ #category : #examples }
GtLPrimitiveMessageDataBlockExamples >> messageDataBlockWithMultipleJsonBlocks [
	<gtExample>
	| block jsonBlock1 jsonBlock2 |
	block := self basicMessageDataBlock.
	
	jsonBlock1 := GtLPrimitiveJsonDataBlock new
		jsonData: (Dictionary new
			at: 'name' put: 'John';
			yourself).
	
	jsonBlock2 := GtLPrimitiveJsonDataBlock new
		dataKey: 'details';
		jsonData: (Dictionary new
			at: 'age' put: 30;
			yourself).
	
	block addJsonDataBlock: jsonBlock1.
	block addJsonDataBlock: jsonBlock2.
	
	self assert: block compositeJsonDataBlock jsonDataBlocks size equals: 2.
	self assert: block imageDataBlocks isEmpty.
	self assert: block containedJsonDataBlocksCount equals: 2.
	self assertSerializationForDataBlockWithOneDataPart: block.
	
	^ block
]

{ #category : #examples }
GtLPrimitiveMessageDataBlockExamples >> messageDataBlockWithNestedCompositeJsonBlock [
	<gtExample>
	| block nestedCompositeBlock |
	block := self basicMessageDataBlock.
	nestedCompositeBlock := self compositeJsonDataBlockExamples nestedCompositeWithInnerDataKey.
	
	block addJsonDataBlock: nestedCompositeBlock.
	
	self assert: block compositeJsonDataBlock jsonDataBlocks size equals: 1.
	self assert: block imageDataBlocks isEmpty.
	self assert: block containedJsonDataBlocksCount equals: 3.
	self assertSerializationForDataBlockWithOneDataPart: block.
	
	^ block
]

{ #category : #examples }
GtLPrimitiveMessageDataBlockExamples >> messageDataBlockWithOneImageBlock [
	<gtExample>
	| block imageBlock |
	block := self basicMessageDataBlock.
	imageBlock := self imageDataBlockExamples imageDataBlockWithBytesAndType.
	
	block addImageDataBlock: imageBlock.
	
	self assert: block compositeJsonDataBlock jsonDataBlocks isEmpty.
	self assert: block imageDataBlocks size equals: 1.
	self assert: block dataBlocks size equals: 1.
	self assertSerializationForDataBlockWithOneDataPart: block.
	
	^ block
]

{ #category : #examples }
GtLPrimitiveMessageDataBlockExamples >> messageDataBlockWithOneJsonBlock [
	<gtExample>
	| block jsonBlock |
	block := self basicMessageDataBlock.
	jsonBlock := self jsonDataBlockExamples jsonDataBlockWithData.
	
	block addJsonDataBlock: jsonBlock.
	
	self assert: block compositeJsonDataBlock jsonDataBlocks size equals: 1.
	self assert: block imageDataBlocks isEmpty.
	self assert: block dataBlocks size equals: 1.
	self assert: block containedJsonDataBlocksCount equals: 1.
	self assertSerializationForDataBlockWithOneDataPart: block.
	
	^ block
]
