"
Abstract superclass for examples testing LLM domain objects, their serialization and data views.
"
Class {
	#name : #GtLObjectExamples,
	#superclass : #Object,
	#traits : 'TGtLDataViewAssertions',
	#classTraits : 'TGtLDataViewAssertions classTrait',
	#category : 'Gt4LlmCore-Examples-Domain Objects'
}

{ #category : #assertions }
GtLObjectExamples >> assertDataBlockHasOnlyJsonData: dataBlock [
	"Assert that the data block is valid and contains only JSON data (no images or secondary blocks)"
	self assert: dataBlock isNotNil.
	self assert: dataBlock class equals: GtLPrimitiveMessageDataBlock.
	self assert: dataBlock imageDataBlocks isEmpty.
	self assert: dataBlock secondaryDataBlocks isEmpty.
	self assert: dataBlock dataBlocks size equals: 1.
	self assert: dataBlock dataBlocks first == dataBlock compositeJsonDataBlock
]
