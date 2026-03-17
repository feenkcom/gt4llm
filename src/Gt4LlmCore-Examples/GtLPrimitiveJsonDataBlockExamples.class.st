Class {
	#name : #GtLPrimitiveJsonDataBlockExamples,
	#superclass : #GtLPrimitiveDataBlockExamples,
	#category : 'Gt4LlmCore-Examples-Data Views'
}

{ #category : #examples }
GtLPrimitiveJsonDataBlockExamples >> addJsonBlockOneWithDataKeyWithBlockTwoWithDataKey [
	<gtExample>
	| block1 block2 expectedJsonData expectedLlmJsonData |
	block1 := GtLPrimitiveJsonDataBlock new
		dataKey: 'person';
		jsonData: (Dictionary new
			at: 'name' put: 'John';
			yourself).
	
	block2 := GtLPrimitiveJsonDataBlock new
		dataKey: 'address';
		jsonData: (Dictionary new
			at: 'city' put: 'New York';
			yourself).
	
	self assert: block1 keysForMerge equals: #('person').
	self assert: block2 keysForMerge equals: #('address').
	
	block1 addJsonBlock: block2.
	
	expectedJsonData := Dictionary new
		at: 'name' put: 'John';
		at: 'address' put: (Dictionary new
			at: 'city' put: 'New York';
			yourself);
		yourself.
	
	expectedLlmJsonData := Dictionary new
		at: 'person' put: expectedJsonData;
		yourself.
	
	self assert: block1 jsonData equals: expectedJsonData.
	self assert: block1 llmJsonData equals: expectedLlmJsonData.
	self assert: block1 keysForMerge equals: #('person').
	self assertSerializationForDataBlockWithOneDataPart: block1.
	
	^ block1
]

{ #category : #examples }
GtLPrimitiveJsonDataBlockExamples >> addJsonBlockOneWithDataKeyWithBlockTwoWithoutDataKey [
	<gtExample>
	| block1 block2 expectedJsonData expectedLlmJsonData |
	block1 := GtLPrimitiveJsonDataBlock new
		dataKey: 'person';
		jsonData: (Dictionary new
			at: 'name' put: 'John';
			yourself).
	
	block2 := GtLPrimitiveJsonDataBlock new
		jsonData: (Dictionary new
			at: 'age' put: 30;
			yourself).
	
	self assert: block1 keysForMerge equals: #('person').
	self assert: block2 keysForMerge asSet equals: #('age') asSet.
	
	block1 addJsonBlock: block2.
	
	expectedJsonData := Dictionary new
		at: 'name' put: 'John';
		at: 'age' put: 30;
		yourself.
	
	expectedLlmJsonData := Dictionary new
		at: 'person' put: expectedJsonData;
		yourself.
	
	self assert: block1 jsonData equals: expectedJsonData.
	self assert: block1 llmJsonData equals: expectedLlmJsonData.
	self assert: block1 keysForMerge equals: #('person').
	self assertSerializationForDataBlockWithOneDataPart: block1.
	
	^ block1
]

{ #category : #examples }
GtLPrimitiveJsonDataBlockExamples >> addJsonBlockOneWithoutDataKeyWithBlockTwoWithDataKey [
	<gtExample>
	| block1 block2 expectedJsonData |
	block1 := GtLPrimitiveJsonDataBlock new
		jsonData: (Dictionary new
			at: 'name' put: 'John';
			yourself).
	
	block2 := GtLPrimitiveJsonDataBlock new
		dataKey: 'address';
		jsonData: (Dictionary new
			at: 'city' put: 'New York';
			yourself).
	
	self assert: block1 keysForMerge asSet equals: #('name') asSet.
	self assert: block2 keysForMerge equals: #('address').
	
	block1 addJsonBlock: block2.
	
	expectedJsonData := Dictionary new
		at: 'name' put: 'John';
		at: 'address' put: (Dictionary new
			at: 'city' put: 'New York';
			yourself);
		yourself.
	
	self assert: block1 jsonData equals: expectedJsonData.
	self assert: block1 llmJsonData equals: expectedJsonData.
	self assert: block1 keysForMerge asSet equals: #('name' 'address') asSet.
	self assertSerializationForDataBlockWithOneDataPart: block1.
	
	^ block1
]

{ #category : #examples }
GtLPrimitiveJsonDataBlockExamples >> addJsonBlockOneWithoutDataKeyWithBlockTwoWithoutDataKey [
	<gtExample>
	| block1 block2 expectedJsonData |
	block1 := GtLPrimitiveJsonDataBlock new
		jsonData: (Dictionary new
			at: 'name' put: 'John';
			yourself).
	
	block2 := GtLPrimitiveJsonDataBlock new
		jsonData: (Dictionary new
			at: 'age' put: 30;
			yourself).
	
	self assert: block1 keysForMerge asSet equals: #('name') asSet.
	self assert: block2 keysForMerge asSet equals: #('age') asSet.
	
	block1 addJsonBlock: block2.
	
	expectedJsonData := Dictionary new
		at: 'name' put: 'John';
		at: 'age' put: 30;
		yourself.
	
	self assert: block1 jsonData equals: expectedJsonData.
	self assert: block1 llmJsonData equals: expectedJsonData.
	self assert: block1 keysForMerge asSet equals: #('name' 'age') asSet.
	self assertSerializationForDataBlockWithOneDataPart: block1.
	
	^ block1
]

{ #category : #examples }
GtLPrimitiveJsonDataBlockExamples >> basicJsonDataBlock [
	<gtExample>
	| block |
	block := GtLPrimitiveJsonDataBlock new.
	
	self assert: block jsonData isNil.
	self assert: block dataKey isNil.
	self assert: block sourceDataView isNil.
	
	^ block
]

{ #category : #'examples - primitive types' }
GtLPrimitiveJsonDataBlockExamples >> jsonDataBlockWithArrayAndDataKey [
	<gtExample>
	| block arrayData expectedLlmJsonData |
	arrayData := #('red' 'green' 'blue').
	
	block := self basicJsonDataBlock.
	block dataKey: 'colors'.
	block jsonData: arrayData.
	
	expectedLlmJsonData := Dictionary new
		at: 'colors' put: arrayData;
		yourself.
	
	self assert: block jsonData equals: arrayData.
	self assert: block dataKey equals: 'colors'.
	self assert: block llmJsonData equals: expectedLlmJsonData.
	self assert: block keysForMerge equals: #('colors').
	self assertSerializationForDataBlockWithOneDataPart: block.
	
	^ block
]

{ #category : #'examples - primitive types' }
GtLPrimitiveJsonDataBlockExamples >> jsonDataBlockWithArrayOfNumbers [
	<gtExample>
	| block arrayData |
	arrayData := #(1 2 3 4 5).
	
	block := self basicJsonDataBlock.
	block jsonData: arrayData.
	
	self assert: block jsonData equals: arrayData.
	self assert: block dataKey isNil.
	self assert: block llmJsonData equals: arrayData.
	self assert: block keysForMerge isEmpty.
	self assertSerializationForDataBlockWithOneDataPart: block.
	
	^ block
]

{ #category : #'examples - primitive types' }
GtLPrimitiveJsonDataBlockExamples >> jsonDataBlockWithArrayOfStrings [
	<gtExample>
	| block arrayData |
	arrayData := #('apple' 'banana' 'cherry').
	
	block := self basicJsonDataBlock.
	block jsonData: arrayData.
	
	self assert: block jsonData equals: arrayData.
	self assert: block dataKey isNil.
	self assert: block llmJsonData equals: arrayData.
	self assert: block keysForMerge isEmpty.
	self assertSerializationForDataBlockWithOneDataPart: block.
	
	^ block
]

{ #category : #'examples - primitive types' }
GtLPrimitiveJsonDataBlockExamples >> jsonDataBlockWithBooleanAndDataKey [
	<gtExample>
	| block expectedLlmJsonData |
	block := self basicJsonDataBlock.
	block dataKey: 'isActive'.
	block jsonData: true.
	
	expectedLlmJsonData := Dictionary new
		at: 'isActive' put: true;
		yourself.
	
	self assert: block jsonData equals: true.
	self assert: block dataKey equals: 'isActive'.
	self assert: block llmJsonData equals: expectedLlmJsonData.
	self assert: block keysForMerge equals: #('isActive').
	self assertSerializationForDataBlockWithOneDataPart: block.
	
	^ block
]

{ #category : #'examples - primitive types' }
GtLPrimitiveJsonDataBlockExamples >> jsonDataBlockWithBooleanFalse [
	<gtExample>
	| block |
	block := self basicJsonDataBlock.
	block jsonData: false.
	
	self assert: block jsonData equals: false.
	self assert: block dataKey isNil.
	self assert: block llmJsonData equals: false.
	self assert: block keysForMerge isEmpty.
	self assertSerializationForDataBlockWithOneDataPart: block.
	
	^ block
]

{ #category : #'examples - primitive types' }
GtLPrimitiveJsonDataBlockExamples >> jsonDataBlockWithBooleanTrue [
	<gtExample>
	| block |
	block := self basicJsonDataBlock.
	block jsonData: true.
	
	self assert: block jsonData equals: true.
	self assert: block dataKey isNil.
	self assert: block llmJsonData equals: true.
	self assert: block keysForMerge isEmpty.
	self assertSerializationForDataBlockWithOneDataPart: block.
	
	^ block
]

{ #category : #examples }
GtLPrimitiveJsonDataBlockExamples >> jsonDataBlockWithData [
	<gtExample>
	| block jsonData |
	jsonData := Dictionary new
		at: 'name' put: 'John';
		at: 'age' put: 30;
		yourself.
	
	block := self basicJsonDataBlock.
	block jsonData: jsonData.
	
	self assert: block jsonData equals: jsonData.
	self assert: block dataKey isNil.
	self assert: block llmJsonData equals: jsonData.
	self assert: block keysForMerge asSet equals: #('name' 'age') asSet.
	self assertSerializationForDataBlockWithOneDataPart: block.
	
	^ block
]

{ #category : #examples }
GtLPrimitiveJsonDataBlockExamples >> jsonDataBlockWithDataKey [
	<gtExample>
	| block jsonData expectedLlmJsonData |
	jsonData := Dictionary new
		at: 'name' put: 'John';
		at: 'age' put: 30;
		yourself.
	
	expectedLlmJsonData := Dictionary new
		at: 'person' put: jsonData;
		yourself.
	
	block := self basicJsonDataBlock.
	block dataKey: 'person'.
	block jsonData: jsonData.
	
	self assert: block jsonData equals: jsonData.
	self assert: block dataKey equals: 'person'.
	self assert: block llmJsonData equals: expectedLlmJsonData.
	self assert: block keysForMerge equals: #('person').
	self assertSerializationForDataBlockWithOneDataPart: block.
	
	^ block
]

{ #category : #'examples - primitive types' }
GtLPrimitiveJsonDataBlockExamples >> jsonDataBlockWithFloat [
	<gtExample>
	| block |
	block := self basicJsonDataBlock.
	block jsonData: 3.14159.
	
	self assert: block jsonData equals: 3.14159.
	self assert: block dataKey isNil.
	self assert: block llmJsonData equals: 3.14159.
	self assert: block keysForMerge isEmpty.
	self assertSerializationForDataBlockWithOneDataPart: block.
	
	^ block
]

{ #category : #'examples - primitive types' }
GtLPrimitiveJsonDataBlockExamples >> jsonDataBlockWithMixedArray [
	<gtExample>
	| block arrayData |
	arrayData := {'hello'. 42. true. 3.14}.
	
	block := self basicJsonDataBlock.
	block jsonData: arrayData.
	
	self assert: block jsonData equals: arrayData.
	self assert: block dataKey isNil.
	self assert: block llmJsonData equals: arrayData.
	self assert: block keysForMerge isEmpty.
	self assertSerializationForDataBlockWithOneDataPart: block.
	
	^ block
]

{ #category : #'examples - primitive types' }
GtLPrimitiveJsonDataBlockExamples >> jsonDataBlockWithNumber [
	<gtExample>
	| block |
	block := self basicJsonDataBlock.
	block jsonData: 42.
	
	self assert: block jsonData equals: 42.
	self assert: block dataKey isNil.
	self assert: block llmJsonData equals: 42.
	self assert: block keysForMerge isEmpty.
	self assertSerializationForDataBlockWithOneDataPart: block.
	
	^ block
]

{ #category : #'examples - primitive types' }
GtLPrimitiveJsonDataBlockExamples >> jsonDataBlockWithNumberAndDataKey [
	<gtExample>
	| block expectedLlmJsonData |
	block := self basicJsonDataBlock.
	block dataKey: 'count'.
	block jsonData: 42.
	
	expectedLlmJsonData := Dictionary new
		at: 'count' put: 42;
		yourself.
	
	self assert: block jsonData equals: 42.
	self assert: block dataKey equals: 'count'.
	self assert: block llmJsonData equals: expectedLlmJsonData.
	self assert: block keysForMerge equals: #('count').
	self assertSerializationForDataBlockWithOneDataPart: block.
	
	^ block
]

{ #category : #'examples - primitive types' }
GtLPrimitiveJsonDataBlockExamples >> jsonDataBlockWithString [
	<gtExample>
	| block |
	block := self basicJsonDataBlock.
	block jsonData: 'Hello, World!'.
	
	self assert: block jsonData equals: 'Hello, World!'.
	self assert: block dataKey isNil.
	self assert: block llmJsonData equals: 'Hello, World!'.
	self assert: block keysForMerge isEmpty.
	self assertSerializationForDataBlockWithOneDataPart: block.
	
	^ block
]

{ #category : #'examples - primitive types' }
GtLPrimitiveJsonDataBlockExamples >> jsonDataBlockWithStringAndDataKey [
	<gtExample>
	| block expectedLlmJsonData |
	block := self basicJsonDataBlock.
	block dataKey: 'message'.
	block jsonData: 'Hello, World!'.
	
	expectedLlmJsonData := Dictionary new
		at: 'message' put: 'Hello, World!';
		yourself.
	
	self assert: block jsonData equals: 'Hello, World!'.
	self assert: block dataKey equals: 'message'.
	self assert: block llmJsonData equals: expectedLlmJsonData.
	self assert: block keysForMerge equals: #('message').
	self assertSerializationForDataBlockWithOneDataPart: block.
	
	^ block
]

{ #category : #examples }
GtLPrimitiveJsonDataBlockExamples >> jsonString [
	<gtExample>
	| block jsonString |
	block := self jsonDataBlockWithData.
	
	jsonString := block serializedJsonString.
	
	self assert: (jsonString includesSubstring: 'John').
	self assert: (jsonString includesSubstring: '30').
	
	^ jsonString
]
