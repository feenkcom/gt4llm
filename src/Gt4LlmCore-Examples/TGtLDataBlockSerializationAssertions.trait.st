"
I provide assertion methods for verifying data block serialization in examples.
"
Trait {
	#name : #TGtLDataBlockSerializationAssertions,
	#category : 'Gt4LlmCore-Examples-Data Views'
}

{ #category : #assertions }
TGtLDataBlockSerializationAssertions >> assertDataBlock: aDataBlock hasLlmJsonData: expectedJsonData [
	"Assert that aDataBlock llmJsonData equals expectedJsonData."
	self assert: aDataBlock llmJsonData equals: expectedJsonData
]

{ #category : #assertions }
TGtLDataBlockSerializationAssertions >> assertDataBlockHasOnlyJsonData: dataBlock [
	"Assert that the data block is valid and contains only JSON data (no images or secondary blocks)"
	self assert: dataBlock isNotNil.
	self assert: dataBlock class equals: GtLPrimitiveMessageDataBlock.
	self assert: dataBlock imageDataBlocks isEmpty.
	self assert: dataBlock documentDataBlocks isEmpty.
	self assert: dataBlock secondaryDataBlocks isEmpty.
	self assert: dataBlock dataBlocks size equals: 1.
	self assert: dataBlock dataBlocks first == dataBlock compositeJsonDataBlock
]

{ #category : #assertions }
TGtLDataBlockSerializationAssertions >> assertJsonData: jsonData hasExpectedKeys: expectedKeys [
	self assert: jsonData keys sorted equals: expectedKeys sorted
]
