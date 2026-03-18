Class {
	#name : #GtLPrimitiveCompositeJsonDataBlockExamples,
	#superclass : #GtLPrimitiveDataBlockExamples,
	#category : 'Gt4LlmCore-Examples-Data Views'
}

{ #category : #examples }
GtLPrimitiveCompositeJsonDataBlockExamples >> basicCompositeJsonDataBlock [
	<gtExample>
	| block |
	block := GtLPrimitiveCompositeJsonDataBlock new.
	
	self assert: block jsonDataBlocks isEmpty.
	self assert: block dataKey isNil.
	self assert: block containedJsonDataBlocksCount equals: 0.
	
	^ block
]

{ #category : #examples }
GtLPrimitiveCompositeJsonDataBlockExamples >> compositeWithDataKeyAndBlocksWithDataKeys [
	<gtExample>
	| composite block1 block2 expectedJsonData |
	composite := self basicCompositeJsonDataBlock.
	composite dataKey: 'data'.
	
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
	
	composite addJsonDataBlock: block1.
	composite addJsonDataBlock: block2.
	
	expectedJsonData := Dictionary new
		at: 'data' put: (Dictionary new
			at: 'person' put: (Dictionary new
				at: 'name' put: 'John';
				yourself);
			at: 'address' put: (Dictionary new
				at: 'city' put: 'New York';
				yourself);
			yourself);
		yourself.
	
	self assert: composite jsonDataBlocks size equals: 2.
	self assert: composite dataKey equals: 'data'.
	self assert: composite llmJsonData equals: expectedJsonData.
	self assertSerializationForDataBlockWithOneDataPart: composite.
	
	^ composite
]

{ #category : #examples }
GtLPrimitiveCompositeJsonDataBlockExamples >> compositeWithDataKeyAndBlocksWithoutDataKeys [
	<gtExample>
	| composite block1 block2 expectedJsonData |
	composite := self basicCompositeJsonDataBlock.
	composite dataKey: 'data'.
	
	block1 := GtLPrimitiveJsonDataBlock new
		jsonData: (Dictionary new
			at: 'name' put: 'John';
			yourself).
	
	block2 := GtLPrimitiveJsonDataBlock new
		jsonData: (Dictionary new
			at: 'age' put: 30;
			yourself).
	
	composite addJsonDataBlock: block1.
	composite addJsonDataBlock: block2.
	
	expectedJsonData := Dictionary new
		at: 'data' put: (Dictionary new
			at: 'name' put: 'John';
			at: 'age' put: 30;
			yourself);
		yourself.
	
	self assert: composite jsonDataBlocks size equals: 2.
	self assert: composite dataKey equals: 'data'.
	self assert: composite llmJsonData equals: expectedJsonData.
	self assertSerializationForDataBlockWithOneDataPart: composite.
	
	^ composite
]

{ #category : #examples }
GtLPrimitiveCompositeJsonDataBlockExamples >> compositeWithDataKeyAndMixedBlocks [
	<gtExample>
	| composite block1 block2 block3 expectedJsonData |
	composite := self basicCompositeJsonDataBlock.
	composite dataKey: 'data'.
	
	block1 := GtLPrimitiveJsonDataBlock new
		jsonData: (Dictionary new
			at: 'name' put: 'John';
			yourself).
	
	block2 := GtLPrimitiveJsonDataBlock new
		dataKey: 'address';
		jsonData: (Dictionary new
			at: 'city' put: 'New York';
			yourself).
	
	block3 := GtLPrimitiveJsonDataBlock new
		jsonData: (Dictionary new
			at: 'age' put: 30;
			yourself).
	
	composite addJsonDataBlock: block1.
	composite addJsonDataBlock: block2.
	composite addJsonDataBlock: block3.
	
	expectedJsonData := Dictionary new
		at: 'data' put: (Dictionary new
			at: 'name' put: 'John';
			at: 'address' put: (Dictionary new
				at: 'city' put: 'New York';
				yourself);
			at: 'age' put: 30;
			yourself);
		yourself.
	
	self assert: composite jsonDataBlocks size equals: 3.
	self assert: composite dataKey equals: 'data'.
	self assert: composite llmJsonData equals: expectedJsonData.
	self assertSerializationForDataBlockWithOneDataPart: composite.
	
	^ composite
]

{ #category : #examples }
GtLPrimitiveCompositeJsonDataBlockExamples >> compositeWithMixedBlocks [
	<gtExample>
	| composite block1 block2 block3 expectedJsonData |
	composite := self basicCompositeJsonDataBlock.
	
	block1 := GtLPrimitiveJsonDataBlock new
		jsonData: (Dictionary new
			at: 'name' put: 'John';
			yourself).
	
	block2 := GtLPrimitiveJsonDataBlock new
		dataKey: 'address';
		jsonData: (Dictionary new
			at: 'city' put: 'New York';
			yourself).
	
	block3 := GtLPrimitiveJsonDataBlock new
		jsonData: (Dictionary new
			at: 'age' put: 30;
			yourself).
	
	composite addJsonDataBlock: block1.
	composite addJsonDataBlock: block2.
	composite addJsonDataBlock: block3.
	
	expectedJsonData := Dictionary new
		at: 'name' put: 'John';
		at: 'address' put: (Dictionary new
			at: 'city' put: 'New York';
			yourself);
		at: 'age' put: 30;
		yourself.
	
	self assert: composite jsonDataBlocks size equals: 3.
	self assert: composite containedJsonDataBlocksCount equals: 3.
	self assert: composite llmJsonData equals: expectedJsonData.
	self assertSerializationForDataBlockWithOneDataPart: composite.
	
	^ composite
]

{ #category : #examples }
GtLPrimitiveCompositeJsonDataBlockExamples >> compositeWithOneBlockWithDataKey [
	<gtExample>
	| composite jsonBlock expectedJsonData |
	composite := self basicCompositeJsonDataBlock.
	
	jsonBlock := GtLPrimitiveJsonDataBlock new
		dataKey: 'person';
		jsonData: (Dictionary new
			at: 'name' put: 'John';
			yourself).
	
	composite addJsonDataBlock: jsonBlock.
	
	expectedJsonData := Dictionary new
		at: 'person' put: (Dictionary new
			at: 'name' put: 'John';
			yourself);
		yourself.
	
	self assert: composite jsonDataBlocks size equals: 1.
	self assert: composite llmJsonData equals: expectedJsonData.
	self assertSerializationForDataBlockWithOneDataPart: composite.
	
	^ composite
]

{ #category : #examples }
GtLPrimitiveCompositeJsonDataBlockExamples >> compositeWithOneBlockWithoutDataKey [
	<gtExample>
	| composite jsonBlock expectedJsonData |
	composite := self basicCompositeJsonDataBlock.
	
	jsonBlock := GtLPrimitiveJsonDataBlock new
		jsonData: (Dictionary new
			at: 'name' put: 'John';
			yourself).
	
	composite addJsonDataBlock: jsonBlock.
	
	expectedJsonData := Dictionary new
		at: 'name' put: 'John';
		yourself.
	
	self assert: composite jsonDataBlocks size equals: 1.
	self assert: composite containedJsonDataBlocksCount equals: 1.
	self assert: composite llmJsonData equals: expectedJsonData.
	self assertSerializationForDataBlockWithOneDataPart: composite.
	
	^ composite
]

{ #category : #examples }
GtLPrimitiveCompositeJsonDataBlockExamples >> compositeWithTwoBlocksWithDataKeys [
	<gtExample>
	| composite block1 block2 expectedJsonData |
	composite := self basicCompositeJsonDataBlock.
	
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
	
	composite addJsonDataBlock: block1.
	composite addJsonDataBlock: block2.
	
	expectedJsonData := Dictionary new
		at: 'person' put: (Dictionary new
			at: 'name' put: 'John';
			yourself);
		at: 'address' put: (Dictionary new
			at: 'city' put: 'New York';
			yourself);
		yourself.
	
	self assert: composite jsonDataBlocks size equals: 2.
	self assert: composite llmJsonData equals: expectedJsonData.
	self assertSerializationForDataBlockWithOneDataPart: composite.
	
	^ composite
]

{ #category : #examples }
GtLPrimitiveCompositeJsonDataBlockExamples >> compositeWithTwoBlocksWithoutDataKeys [
	<gtExample>
	| composite block1 block2 expectedJsonData |
	composite := self basicCompositeJsonDataBlock.
	
	block1 := GtLPrimitiveJsonDataBlock new
		jsonData: (Dictionary new
			at: 'name' put: 'John';
			yourself).
	
	block2 := GtLPrimitiveJsonDataBlock new
		jsonData: (Dictionary new
			at: 'age' put: 30;
			yourself).
	
	composite addJsonDataBlock: block1.
	composite addJsonDataBlock: block2.
	
	expectedJsonData := Dictionary new
		at: 'name' put: 'John';
		at: 'age' put: 30;
		yourself.
	
	self assert: composite jsonDataBlocks size equals: 2.
	self assert: composite containedJsonDataBlocksCount equals: 2.
	self assert: composite llmJsonData equals: expectedJsonData.
	self assertSerializationForDataBlockWithOneDataPart: composite.
	
	^ composite
]

{ #category : #'examples - nested composites' }
GtLPrimitiveCompositeJsonDataBlockExamples >> compositeWithTwoEmptyComposites [
	"Tests a composite containing two empty sibling composite blocks:
	- Main composite: no data key
	- Composite A: no data key, empty
	- Composite B: no data key, empty
	The result should have no JSON data since both child composites are empty."
	<gtExample>
	| mainComposite compositeA compositeB |
	
	compositeA := GtLPrimitiveCompositeJsonDataBlock new.
	self assert: compositeA jsonDataBlocks isEmpty.
	self assert: compositeA containedJsonDataBlocksCount equals: 0.
	
	compositeB := GtLPrimitiveCompositeJsonDataBlock new.
	self assert: compositeB jsonDataBlocks isEmpty.
	self assert: compositeB containedJsonDataBlocksCount equals: 0.
	
	mainComposite := GtLPrimitiveCompositeJsonDataBlock new.
	mainComposite addJsonDataBlock: compositeA.
	mainComposite addJsonDataBlock: compositeB.
	
	self assert: mainComposite jsonDataBlocks size equals: 2.
	self assert: mainComposite containedJsonDataBlocksCount equals: 0.
	self assert: mainComposite llmJsonData equals: Dictionary new.
	
	^ mainComposite
]

{ #category : #examples }
GtLPrimitiveCompositeJsonDataBlockExamples >> compositeWithTwoSiblingComposites [
	"Tests a composite containing two sibling composite blocks:
	- Main composite: no data key, contains two composites
	- Composite A: data key 'person', contains name and age blocks
	- Composite B: data key 'company', contains name and industry blocks"
	<gtExample>
	| mainComposite compositeA compositeB expectedJsonData |
	
	compositeA := GtLPrimitiveCompositeJsonDataBlock new.
	compositeA dataKey: 'person'.
	compositeA addJsonDataBlock: (GtLPrimitiveJsonDataBlock new
		dataKey: 'name';
		jsonData: 'Alice').
	compositeA addJsonDataBlock: (GtLPrimitiveJsonDataBlock new
		dataKey: 'age';
		jsonData: 30).
	
	self assert: compositeA containedJsonDataBlocksCount equals: 2.
	
	compositeB := GtLPrimitiveCompositeJsonDataBlock new.
	compositeB dataKey: 'company'.
	compositeB addJsonDataBlock: (GtLPrimitiveJsonDataBlock new
		dataKey: 'name';
		jsonData: 'TechCorp').
	compositeB addJsonDataBlock: (GtLPrimitiveJsonDataBlock new
		dataKey: 'industry';
		jsonData: 'Software').
	
	self assert: compositeB containedJsonDataBlocksCount equals: 2.
	
	mainComposite := GtLPrimitiveCompositeJsonDataBlock new.
	mainComposite addJsonDataBlock: compositeA.
	mainComposite addJsonDataBlock: compositeB.
	
	expectedJsonData := Dictionary new
		at: 'person' put: (Dictionary new
			at: 'name' put: 'Alice';
			at: 'age' put: 30;
			yourself);
		at: 'company' put: (Dictionary new
			at: 'name' put: 'TechCorp';
			at: 'industry' put: 'Software';
			yourself);
		yourself.
	
	self assert: mainComposite jsonDataBlocks size equals: 2.
	self assert: mainComposite containedJsonDataBlocksCount equals: 4.
	self assert: mainComposite llmJsonData equals: expectedJsonData.
	self assertSerializationForDataBlockWithOneDataPart: mainComposite.
	
	^ mainComposite
]

{ #category : #examples }
GtLPrimitiveCompositeJsonDataBlockExamples >> compositeWithTwoSiblingCompositesMixed [
	"Tests a composite containing two sibling composite blocks with mixed data key usage:
	- Main composite: data key 'record'
	- Composite A: data key 'contact', nested under record
	- Composite B: no data key, blocks merge into record level"
	<gtExample>
	| mainComposite compositeA compositeB expectedJsonData |
	
	compositeA := GtLPrimitiveCompositeJsonDataBlock new.
	compositeA dataKey: 'contact'.
	compositeA addJsonDataBlock: (GtLPrimitiveJsonDataBlock new
		dataKey: 'email';
		jsonData: 'alice@example.com').
	compositeA addJsonDataBlock: (GtLPrimitiveJsonDataBlock new
		dataKey: 'phone';
		jsonData: '+1-555-0123').
	
	self assert: compositeA containedJsonDataBlocksCount equals: 2.
	
	compositeB := GtLPrimitiveCompositeJsonDataBlock new.
	compositeB addJsonDataBlock: (GtLPrimitiveJsonDataBlock new
		dataKey: 'createdAt';
		jsonData: '2024-01-15').
	compositeB addJsonDataBlock: (GtLPrimitiveJsonDataBlock new
		dataKey: 'updatedAt';
		jsonData: '2024-01-20').
	
	self assert: compositeB containedJsonDataBlocksCount equals: 2.
	
	mainComposite := GtLPrimitiveCompositeJsonDataBlock new.
	mainComposite dataKey: 'record'.
	mainComposite addJsonDataBlock: (GtLPrimitiveJsonDataBlock new
		dataKey: 'id';
		jsonData: 12345).
	mainComposite addJsonDataBlock: compositeA.
	mainComposite addJsonDataBlock: compositeB.
	
	expectedJsonData := Dictionary new
		at: 'record' put: (Dictionary new
			at: 'id' put: 12345;
			at: 'contact' put: (Dictionary new
				at: 'email' put: 'alice@example.com';
				at: 'phone' put: '+1-555-0123';
				yourself);
			at: 'createdAt' put: '2024-01-15';
			at: 'updatedAt' put: '2024-01-20';
			yourself);
		yourself.
	
	self assert: mainComposite jsonDataBlocks size equals: 3.
	self assert: mainComposite containedJsonDataBlocksCount equals: 5.
	self assert: mainComposite llmJsonData equals: expectedJsonData.
	self assertSerializationForDataBlockWithOneDataPart: mainComposite.
	
	^ mainComposite
]

{ #category : #examples }
GtLPrimitiveCompositeJsonDataBlockExamples >> compositeWithTwoSiblingCompositesWithoutDataKeys [
	"Tests a composite containing two sibling composite blocks without data keys:
	- Main composite: no data key
	- Composite A: no data key, blocks merge at top level
	- Composite B: no data key, blocks merge at top level"
	<gtExample>
	| mainComposite compositeA compositeB expectedJsonData |
	
	compositeA := GtLPrimitiveCompositeJsonDataBlock new.
	compositeA addJsonDataBlock: (GtLPrimitiveJsonDataBlock new
		dataKey: 'firstName';
		jsonData: 'John').
	compositeA addJsonDataBlock: (GtLPrimitiveJsonDataBlock new
		dataKey: 'lastName';
		jsonData: 'Doe').
	
	self assert: compositeA containedJsonDataBlocksCount equals: 2.
	
	compositeB := GtLPrimitiveCompositeJsonDataBlock new.
	compositeB addJsonDataBlock: (GtLPrimitiveJsonDataBlock new
		dataKey: 'city';
		jsonData: 'Boston').
	compositeB addJsonDataBlock: (GtLPrimitiveJsonDataBlock new
		dataKey: 'country';
		jsonData: 'USA').
	
	self assert: compositeB containedJsonDataBlocksCount equals: 2.
	
	mainComposite := GtLPrimitiveCompositeJsonDataBlock new.
	mainComposite addJsonDataBlock: compositeA.
	mainComposite addJsonDataBlock: compositeB.
	
	expectedJsonData := Dictionary new
		at: 'firstName' put: 'John';
		at: 'lastName' put: 'Doe';
		at: 'city' put: 'Boston';
		at: 'country' put: 'USA';
		yourself.
	
	self assert: mainComposite jsonDataBlocks size equals: 2.
	self assert: mainComposite containedJsonDataBlocksCount equals: 4.
	self assert: mainComposite llmJsonData equals: expectedJsonData.
	self assertSerializationForDataBlockWithOneDataPart: mainComposite.
	
	^ mainComposite
]

{ #category : #examples }
GtLPrimitiveCompositeJsonDataBlockExamples >> deeplyNestedComposites [
	<gtExample>
	| outerComposite middleComposite innerComposite expectedJsonData |
	innerComposite := GtLPrimitiveCompositeJsonDataBlock new.
	innerComposite dataKey: 'location'.
	innerComposite addJsonDataBlock: (GtLPrimitiveJsonDataBlock new
		jsonData: (Dictionary new
			at: 'lat' put: 40.7128;
			at: 'lng' put: -74.0060;
			yourself)).
	
	self assert: innerComposite containedJsonDataBlocksCount equals: 1.
	
	middleComposite := GtLPrimitiveCompositeJsonDataBlock new.
	middleComposite dataKey: 'address'.
	middleComposite addJsonDataBlock: (GtLPrimitiveJsonDataBlock new
		jsonData: (Dictionary new
			at: 'city' put: 'New York';
			yourself)).
	middleComposite addJsonDataBlock: innerComposite.
	
	self assert: middleComposite containedJsonDataBlocksCount equals: 2.
	
	outerComposite := GtLPrimitiveCompositeJsonDataBlock new.
	outerComposite addJsonDataBlock: (GtLPrimitiveJsonDataBlock new
		jsonData: (Dictionary new
			at: 'name' put: 'John';
			yourself)).
	outerComposite addJsonDataBlock: middleComposite.
	
	expectedJsonData := Dictionary new
		at: 'name' put: 'John';
		at: 'address' put: (Dictionary new
			at: 'city' put: 'New York';
			at: 'location' put: (Dictionary new
				at: 'lat' put: 40.7128;
				at: 'lng' put: -74.0060;
				yourself);
			yourself);
		yourself.
	
	self assert: outerComposite jsonDataBlocks size equals: 2.
	self assert: outerComposite containedJsonDataBlocksCount equals: 3.
	self assert: outerComposite llmJsonData equals: expectedJsonData.
	self assertSerializationForDataBlockWithOneDataPart: outerComposite.
	
	^ outerComposite
]

{ #category : #examples }
GtLPrimitiveCompositeJsonDataBlockExamples >> nestedCompositeWithBothDataKeys [
	<gtExample>
	| outerComposite innerComposite block1 block2 expectedJsonData |
	innerComposite := GtLPrimitiveCompositeJsonDataBlock new.
	innerComposite dataKey: 'address'.
	
	block1 := GtLPrimitiveJsonDataBlock new
		jsonData: (Dictionary new
			at: 'city' put: 'New York';
			yourself).
	
	block2 := GtLPrimitiveJsonDataBlock new
		jsonData: (Dictionary new
			at: 'zip' put: '10001';
			yourself).
	
	innerComposite addJsonDataBlock: block1.
	innerComposite addJsonDataBlock: block2.
	
	outerComposite := GtLPrimitiveCompositeJsonDataBlock new.
	outerComposite dataKey: 'data'.
	outerComposite addJsonDataBlock: (GtLPrimitiveJsonDataBlock new
		jsonData: (Dictionary new
			at: 'name' put: 'John';
			yourself)).
	outerComposite addJsonDataBlock: innerComposite.
	
	expectedJsonData := Dictionary new
		at: 'data' put: (Dictionary new
			at: 'name' put: 'John';
			at: 'address' put: (Dictionary new
				at: 'city' put: 'New York';
				at: 'zip' put: '10001';
				yourself);
			yourself);
		yourself.
	
	self assert: outerComposite llmJsonData equals: expectedJsonData.
	self assertSerializationForDataBlockWithOneDataPart: outerComposite.
	
	^ outerComposite
]

{ #category : #examples }
GtLPrimitiveCompositeJsonDataBlockExamples >> nestedCompositeWithInnerDataKey [
	<gtExample>
	| outerComposite innerComposite block1 block2 expectedJsonData |
	innerComposite := GtLPrimitiveCompositeJsonDataBlock new.
	innerComposite dataKey: 'address'.
	
	block1 := GtLPrimitiveJsonDataBlock new
		jsonData: (Dictionary new
			at: 'city' put: 'New York';
			yourself).
	
	block2 := GtLPrimitiveJsonDataBlock new
		jsonData: (Dictionary new
			at: 'zip' put: '10001';
			yourself).
	
	innerComposite addJsonDataBlock: block1.
	innerComposite addJsonDataBlock: block2.
	
	self assert: innerComposite containedJsonDataBlocksCount equals: 2.
	
	outerComposite := GtLPrimitiveCompositeJsonDataBlock new.
	outerComposite addJsonDataBlock: (GtLPrimitiveJsonDataBlock new
		jsonData: (Dictionary new
			at: 'name' put: 'John';
			yourself)).
	outerComposite addJsonDataBlock: innerComposite.
	
	expectedJsonData := Dictionary new
		at: 'name' put: 'John';
		at: 'address' put: (Dictionary new
			at: 'city' put: 'New York';
			at: 'zip' put: '10001';
			yourself);
		yourself.
	
	self assert: outerComposite jsonDataBlocks size equals: 2.
	self assert: outerComposite containedJsonDataBlocksCount equals: 3.
	self assert: outerComposite llmJsonData equals: expectedJsonData.
	self assertSerializationForDataBlockWithOneDataPart: outerComposite.
	
	^ outerComposite
]

{ #category : #examples }
GtLPrimitiveCompositeJsonDataBlockExamples >> nestedCompositeWithMultipleInnerComposites [
	<gtExample>
	| outerComposite innerComposite1 innerComposite2 expectedJsonData |
	innerComposite1 := GtLPrimitiveCompositeJsonDataBlock new.
	innerComposite1 dataKey: 'address'.
	innerComposite1 addJsonDataBlock: (GtLPrimitiveJsonDataBlock new
		jsonData: (Dictionary new
			at: 'city' put: 'New York';
			yourself)).
	
	self assert: innerComposite1 containedJsonDataBlocksCount equals: 1.
	
	innerComposite2 := GtLPrimitiveCompositeJsonDataBlock new.
	innerComposite2 dataKey: 'contact'.
	innerComposite2 addJsonDataBlock: (GtLPrimitiveJsonDataBlock new
		jsonData: (Dictionary new
			at: 'email' put: 'john@example.com';
			yourself)).
	
	self assert: innerComposite2 containedJsonDataBlocksCount equals: 1.
	
	outerComposite := GtLPrimitiveCompositeJsonDataBlock new.
	outerComposite addJsonDataBlock: (GtLPrimitiveJsonDataBlock new
		jsonData: (Dictionary new
			at: 'name' put: 'John';
			yourself)).
	outerComposite addJsonDataBlock: innerComposite1.
	outerComposite addJsonDataBlock: innerComposite2.
	
	expectedJsonData := Dictionary new
		at: 'name' put: 'John';
		at: 'address' put: (Dictionary new
			at: 'city' put: 'New York';
			yourself);
		at: 'contact' put: (Dictionary new
			at: 'email' put: 'john@example.com';
			yourself);
		yourself.
	
	self assert: outerComposite jsonDataBlocks size equals: 3.
	self assert: outerComposite containedJsonDataBlocksCount equals: 3.
	self assert: outerComposite llmJsonData equals: expectedJsonData.
	self assertSerializationForDataBlockWithOneDataPart: outerComposite.
	
	^ outerComposite
]

{ #category : #examples }
GtLPrimitiveCompositeJsonDataBlockExamples >> nestedCompositeWithoutDataKeys [
	<gtExample>
	| outerComposite innerComposite block1 block2 expectedJsonData |
	innerComposite := GtLPrimitiveCompositeJsonDataBlock new.
	
	block1 := GtLPrimitiveJsonDataBlock new
		jsonData: (Dictionary new
			at: 'city' put: 'New York';
			yourself).
	
	block2 := GtLPrimitiveJsonDataBlock new
		jsonData: (Dictionary new
			at: 'zip' put: '10001';
			yourself).
	
	innerComposite addJsonDataBlock: block1.
	innerComposite addJsonDataBlock: block2.
	
	outerComposite := GtLPrimitiveCompositeJsonDataBlock new.
	outerComposite addJsonDataBlock: (GtLPrimitiveJsonDataBlock new
		jsonData: (Dictionary new
			at: 'name' put: 'John';
			yourself)).
	outerComposite addJsonDataBlock: innerComposite.
	
	expectedJsonData := Dictionary new
		at: 'name' put: 'John';
		at: 'city' put: 'New York';
		at: 'zip' put: '10001';
		yourself.
	
	self assert: outerComposite llmJsonData equals: expectedJsonData.
	self assertSerializationForDataBlockWithOneDataPart: outerComposite.
	
	^ outerComposite
]

{ #category : #examples }
GtLPrimitiveCompositeJsonDataBlockExamples >> nestedCompositeWithOuterDataKey [
	<gtExample>
	| outerComposite innerComposite block1 block2 expectedJsonData |
	innerComposite := GtLPrimitiveCompositeJsonDataBlock new.
	
	block1 := GtLPrimitiveJsonDataBlock new
		jsonData: (Dictionary new
			at: 'city' put: 'New York';
			yourself).
	
	block2 := GtLPrimitiveJsonDataBlock new
		jsonData: (Dictionary new
			at: 'zip' put: '10001';
			yourself).
	
	innerComposite addJsonDataBlock: block1.
	innerComposite addJsonDataBlock: block2.
	
	outerComposite := GtLPrimitiveCompositeJsonDataBlock new.
	outerComposite dataKey: 'data'.
	outerComposite addJsonDataBlock: (GtLPrimitiveJsonDataBlock new
		jsonData: (Dictionary new
			at: 'name' put: 'John';
			yourself)).
	outerComposite addJsonDataBlock: innerComposite.
	
	expectedJsonData := Dictionary new
		at: 'data' put: (Dictionary new
			at: 'name' put: 'John';
			at: 'city' put: 'New York';
			at: 'zip' put: '10001';
			yourself);
		yourself.
	
	self assert: outerComposite llmJsonData equals: expectedJsonData.
	self assertSerializationForDataBlockWithOneDataPart: outerComposite.
	
	^ outerComposite
]

{ #category : #examples }
GtLPrimitiveCompositeJsonDataBlockExamples >> veryDeeplyNestedComposites [
	"Tests a 5-level deeply nested structure mixing composites with and without data keys:
	- Level 1 (outer): no data key, 3 blocks (with key, without key, composite)
	- Level 2: data key 'reading', mixed blocks including two sibling composites
	- Level 3a: no data key, block with key + composite (leads to level 4)
	- Level 3b: data key 'metadata', contains blocks with mixed keys
	- Level 4: data key 'measurement', block with key + composite
	- Level 5 (deepest): no data key, single block without key"
	<gtExample>
	| level1 level2 level3a level3b level4 level5 expectedJsonData |
	
	level5 := GtLPrimitiveCompositeJsonDataBlock new.
	level5 addJsonDataBlock: (GtLPrimitiveJsonDataBlock new
		jsonData: (Dictionary new
			at: 'value' put: 42;
			at: 'unit' put: 'meters';
			yourself)).
	
	self assert: level5 containedJsonDataBlocksCount equals: 1.
	
	level4 := GtLPrimitiveCompositeJsonDataBlock new.
	level4 dataKey: 'measurement'.
	level4 addJsonDataBlock: (GtLPrimitiveJsonDataBlock new
		dataKey: 'timestamp';
		jsonData: '2024-01-15T10:30:00Z').
	level4 addJsonDataBlock: level5.
	
	self assert: level4 containedJsonDataBlocksCount equals: 2.
	
	level3a := GtLPrimitiveCompositeJsonDataBlock new.
	level3a addJsonDataBlock: (GtLPrimitiveJsonDataBlock new
		dataKey: 'sensor';
		jsonData: 'temperature-01').
	level3a addJsonDataBlock: level4.
	
	self assert: level3a containedJsonDataBlocksCount equals: 3.
	
	level3b := GtLPrimitiveCompositeJsonDataBlock new.
	level3b dataKey: 'metadata'.
	level3b addJsonDataBlock: (GtLPrimitiveJsonDataBlock new
		dataKey: 'source';
		jsonData: 'field-station').
	level3b addJsonDataBlock: (GtLPrimitiveJsonDataBlock new
		jsonData: (Dictionary new
			at: 'confidence' put: 0.95;
			yourself)).
	
	self assert: level3b containedJsonDataBlocksCount equals: 2.
	
	level2 := GtLPrimitiveCompositeJsonDataBlock new.
	level2 dataKey: 'reading'.
	level2 addJsonDataBlock: (GtLPrimitiveJsonDataBlock new
		jsonData: (Dictionary new
			at: 'status' put: 'active';
			yourself)).
	level2 addJsonDataBlock: level3a.
	level2 addJsonDataBlock: level3b.
	
	self assert: level2 containedJsonDataBlocksCount equals: 6.
	
	level1 := GtLPrimitiveCompositeJsonDataBlock new.
	level1 addJsonDataBlock: (GtLPrimitiveJsonDataBlock new
		dataKey: 'deviceId';
		jsonData: 'device-abc-123').
	level1 addJsonDataBlock: (GtLPrimitiveJsonDataBlock new
		jsonData: (Dictionary new
			at: 'version' put: '2.0';
			yourself)).
	level1 addJsonDataBlock: level2.
	
	expectedJsonData := Dictionary new
		at: 'deviceId' put: 'device-abc-123';
		at: 'version' put: '2.0';
		at: 'reading' put: (Dictionary new
			at: 'status' put: 'active';
			at: 'sensor' put: 'temperature-01';
			at: 'measurement' put: (Dictionary new
				at: 'timestamp' put: '2024-01-15T10:30:00Z';
				at: 'value' put: 42;
				at: 'unit' put: 'meters';
				yourself);
			at: 'metadata' put: (Dictionary new
				at: 'source' put: 'field-station';
				at: 'confidence' put: 0.95;
				yourself);
			yourself);
		yourself.
	
	self assert: level1 jsonDataBlocks size equals: 3.
	self assert: level1 containedJsonDataBlocksCount equals: 8.
	self assert: level1 llmJsonData equals: expectedJsonData.
	self assertSerializationForDataBlockWithOneDataPart: level1.
	
	^ level1
]
