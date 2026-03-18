"
I am the common superclass for all example classes for primitive data blocks.
"
Class {
	#name : #GtLPrimitiveDataBlockExamples,
	#superclass : #Object,
	#category : #'Gt4LlmCore-Examples-Data Views'
}

{ #category : #assertions }
GtLPrimitiveDataBlockExamples >> assertSerializationForDataBlock: aDataBlock dataPartsCount: expectedSize [
	"Assert that all LLM serialization methods return arrays of the expected size.
	This ensures consistency across different LLM providers (Anthropic, OpenAI, Bedrock, etc.)."
	
	| pragmas |
	pragmas := Pragma
		allNamed: #llmSerialization:
		from: aDataBlock class
		to: Object.
	
	self assert: pragmas isNotEmpty description: 'Data block should have LLM serialization methods'.
	
	pragmas do: [ :eachPragma |
		| result llmName |
		llmName := eachPragma arguments first.
		result := aDataBlock perform: eachPragma methodSelector.
		self 
			assert: result size = expectedSize
			description: ('Serialization for {1} should return array of size {2}, but got {3}' 
				format: { llmName. expectedSize. result size }) ]
]

{ #category : #assertions }
GtLPrimitiveDataBlockExamples >> assertSerializationForDataBlockWithOneDataPart: aDataBlock [
	self assertSerializationForDataBlock: aDataBlock dataPartsCount: 1
]

{ #category : #assertions }
GtLPrimitiveDataBlockExamples >> assertSerializationForDataBlockWithTwoDataParts: aDataBlock [
	self assertSerializationForDataBlock: aDataBlock dataPartsCount: 2
]
