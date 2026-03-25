"
I provide examples for GtLMagritteDataView.
"
Class {
	#name : #GtLMagritteDataViewExamples,
	#superclass : #GtLDataViewExamples,
	#category : #'Gt4LlmCore-Examples-Data Views'
}

{ #category : #'examples - support' }
GtLMagritteDataViewExamples >> expectedMathReasoningJsonData [
	"Returns the expected JSON data structure for a math reasoning object"
	| expectedData step1Data step2Data |
	
	step1Data := NeoJSONObject new
		at: 'explanation' put: 'First, add 2 and 3';
		at: 'output' put: '2 + 3 = 5';
		yourself.
	
	step2Data := NeoJSONObject new
		at: 'explanation' put: 'Then, multiply by 4';
		at: 'output' put: '5 * 4 = 20';
		yourself.
	
	expectedData := NeoJSONObject new
		at: #steps put: (NeoJSONArray withAll: { step1Data. step2Data });
		at: #finalAnswer put: '20';
		yourself.
	
	^ expectedData
]

{ #category : #examples }
GtLMagritteDataViewExamples >> magritteDataViewWithDataKey [
	<gtExample>
	| dataView reasoning |
	
	reasoning := self sampleMathReasoning.
	
	dataView := GtLMagritteDataView new
		dataKey: #mathReasoning;
		object: [ reasoning ].
	
	self assert: dataView title isNil.
	self assert: dataView dataKey equals: #mathReasoning.
	self assert: dataView targetObject equals: reasoning.
	
	^ dataView
]

{ #category : #'examples - serialization' }
GtLMagritteDataViewExamples >> magritteDataViewWithDataKey_serialization [
	<gtExample>
	| aDataView aDataBlock actualData expectedData |
	aDataView := self magritteDataViewWithDataKey.
	aDataBlock := aDataView serializeToLlmPrimiteData.

	self assert: aDataBlock dataBlocks size equals: 1.
	self assert: aDataBlock compositeJsonDataBlock containedJsonDataBlocksCount equals: 1.

	actualData := aDataBlock compositeJsonDataBlock llmJsonData.
	expectedData := Dictionary new
		at: #mathReasoning put: self expectedMathReasoningJsonData;
		yourself.
	self assert: actualData equals: expectedData.

	^ aDataBlock
]

{ #category : #examples }
GtLMagritteDataViewExamples >> magritteDataViewWithoutDataKey [
	<gtExample>
	| dataView reasoning |
	
	reasoning := self sampleMathReasoning.
	
	dataView := GtLMagritteDataView new
		object: [ reasoning ].
	
	self assert: dataView title isNil.
	self assert: dataView dataKey isNil.
	self assert: dataView targetObject equals: reasoning.
	
	^ dataView
]

{ #category : #'examples - serialization' }
GtLMagritteDataViewExamples >> magritteDataViewWithoutDataKey_serialization [
	<gtExample>
	| aDataView aDataBlock actualData expectedData |
	aDataView := self magritteDataViewWithoutDataKey.
	aDataBlock := aDataView serializeToLlmPrimiteData.

	self assert: aDataBlock dataBlocks size equals: 1.
	self assert: aDataBlock compositeJsonDataBlock containedJsonDataBlocksCount equals: 1.

	actualData := aDataBlock compositeJsonDataBlock llmJsonData.
	expectedData := self expectedMathReasoningJsonData asDictionary.
	self assert: actualData equals: expectedData.

	^ aDataBlock
]

{ #category : #'examples - support' }
GtLMagritteDataViewExamples >> sampleMathReasoning [
	<gtExample>
	| reasoning step1 step2 |
	
	reasoning := GtLDemoMathReasoning new.
	
	step1 := GtLDemoMathReasoningStep new
		explanation: 'First, add 2 and 3';
		output: '2 + 3 = 5'.
	
	step2 := GtLDemoMathReasoningStep new
		explanation: 'Then, multiply by 4';
		output: '5 * 4 = 20'.
	
	reasoning
		steps: { step1. step2 };
		finalAnswer: '20'.
	
	self assert: reasoning steps size equals: 2.
	self assert: reasoning finalAnswer equals: '20'.
	
	^ reasoning
]
