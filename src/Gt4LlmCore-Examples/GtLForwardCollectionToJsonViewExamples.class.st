Class {
	#name : #GtLForwardCollectionToJsonViewExamples,
	#superclass : #GtLForwardCollectionDataViewExamples,
	#category : #'Gt4LlmCore-Examples-Data Views'
}

{ #category : #'examples - with inner data keys' }
GtLForwardCollectionToJsonViewExamples >> forwardToJsonViewWithInnerDataKeys [
	<gtExample>
	"Test forwarding a collection to JSON views that have their own data keys."
	| collection dataView |
	collection := self objectsWithJsonViewsAndDataKeys.
	
	dataView := GtLForwardCollectionDataView new
		dataKey: 'data';
		collection: [ collection ];
		view: #gtLlmFirstJsonViewFor:.
	
	self assert: dataView targetCollection equals: collection.
	self assert: dataView dataKey equals: 'data'.
	self 
		assertArrayCompositeView: dataView targetDataView 
		hasSingleJsonDataViewsWithDataKeys: {#jsonContent. #jsonContent. #jsonContent}.
	
	^ dataView
]

{ #category : #'examples - serialization' }
GtLForwardCollectionToJsonViewExamples >> forwardToJsonViewWithInnerDataKeys_serialization [
	<gtExample>
	"When forwarding to JSON views with their own data keys, those data keys are preserved."
	| dataView dataBlock expectedData |
	dataView := self forwardToJsonViewWithInnerDataKeys.
	
	dataBlock := dataView serializeToLlmPrimiteData.
	
	self assert: dataBlock dataBlocks size equals: 1.
	self assert: dataBlock compositeJsonDataBlock containedJsonDataBlocksCount equals: 3.
	
	expectedData := Dictionary new
		at: #data put: {
			Dictionary new
				at: #jsonContent put: (NeoJSONObject new
					at: #type put: 'first';
					at: #value put: 10;
					yourself);
				yourself.
			Dictionary new
				at: #jsonContent put: (NeoJSONObject new
					at: #type put: 'first';
					at: #value put: 20;
					yourself);
				yourself.
			Dictionary new
				at: #jsonContent put: (NeoJSONObject new
					at: #type put: 'first';
					at: #value put: 30;
					yourself);
				yourself};
		yourself.
	self assertDataBlock: dataBlock hasLlmJsonData: expectedData.
	
	^ dataBlock
]

{ #category : #'examples - with mixed data keys' }
GtLForwardCollectionToJsonViewExamples >> forwardToJsonViewWithMixedDataKeys [
	<gtExample>
	"Test forwarding a collection to JSON views where some have data keys and some don't."
	| collection dataView |
	collection := self objectsWithMixedDataKeys.
	
	dataView := GtLForwardCollectionDataView new
		dataKey: 'data';
		collection: [ collection ];
		view: #gtLlmFirstJsonViewFor:.
	
	self assert: dataView targetCollection equals: collection.
	self assert: dataView dataKey equals: 'data'.
	self 
		assertArrayCompositeView: dataView targetDataView 
		hasSingleJsonDataViewsWithDataKeys: {#jsonContent. nil. #jsonContent}.
	
	^ dataView
]

{ #category : #'examples - serialization' }
GtLForwardCollectionToJsonViewExamples >> forwardToJsonViewWithMixedDataKeys_serialization [
	<gtExample>
	"When forwarding to JSON views with mixed data keys, each item serializes according to its own data key.
	Items with data keys get wrapped, items without data keys are serialized directly."
	| dataView dataBlock expectedData |
	dataView := self forwardToJsonViewWithMixedDataKeys.
	
	dataBlock := dataView serializeToLlmPrimiteData.
	
	self assert: dataBlock dataBlocks size equals: 1.
	self assert: dataBlock compositeJsonDataBlock containedJsonDataBlocksCount equals: 3.
	
	expectedData := Dictionary new
		at: #data put: {
			"First item - has data key #jsonContent"
			Dictionary new
				at: #jsonContent put: (NeoJSONObject new
					at: #type put: 'first';
					at: #value put: 10;
					yourself);
				yourself.
			"Second item - no data key, serialized directly"
			NeoJSONObject new
				at: #type put: 'first';
				at: #value put: 20;
				yourself.
			"Third item - has data key #jsonContent"
			Dictionary new
				at: #jsonContent put: (NeoJSONObject new
					at: #type put: 'first';
					at: #value put: 30;
					yourself);
				yourself};
		yourself.
	self assertDataBlock: dataBlock hasLlmJsonData: expectedData.
	
	^ dataBlock
]

{ #category : #examples }
GtLForwardCollectionToJsonViewExamples >> forwardToJsonViewWithoutDataKeys [
	<gtExample>
	| collection dataView |
	collection := self objectsWithJsonViews.
	
	dataView := GtLForwardCollectionDataView new
		dataKey: 'data';
		collection: [ collection ];
		view: #gtLlmFirstJsonViewFor:.
	
	self assert: dataView targetCollection equals: collection.
	self assert: dataView dataKey equals: 'data'.
	self 
		assertArrayCompositeView: dataView targetDataView 
		hasSingleJsonDataViewsWithDataKeys: {nil. nil. nil}.
	
	^ dataView targetDataView
]

{ #category : #'examples - serialization' }
GtLForwardCollectionToJsonViewExamples >> forwardToJsonViewWithoutDataKeys_serialization [
	<gtExample>
	| forwardDataView dataBlock expectedData |
	forwardDataView := self forwardToJsonViewWithoutDataKeys.
	dataBlock := forwardDataView serializeToLlmPrimiteData.
	
	self assert: dataBlock dataBlocks size equals: 1.
	self assert: dataBlock compositeJsonDataBlock containedJsonDataBlocksCount equals: 3.
	
	expectedData := Dictionary new
		at: #data put: {
			NeoJSONObject new
				at: #type put: 'first';
				at: #value put: 10;
				yourself.
			NeoJSONObject new
				at: #type put: 'first';
				at: #value put: 20;
				yourself.
			NeoJSONObject new
				at: #type put: 'first';
				at: #value put: 30;
				yourself};
		yourself.
	self assertDataBlock: dataBlock hasLlmJsonData: expectedData.
	
	^ dataBlock
]

{ #category : #'examples - setup' }
GtLForwardCollectionToJsonViewExamples >> objectsWithJsonViews [
	<gtExample>
	| objects |
	
	objects := (1 to: 3) collect: [ :each |
		| object |
		object := GtLObjectWithJsonViewsForExamples new.
		object firstValue: 10 * each.
		object secondValue: 11 * each.
	
		self assert: object firstJsonViewEnabled.
		self assert: object secondJsonViewEnabled.
		self assert: object firstJsonViewDataKey isNil.
		self assert: object secondJsonViewDataKey isNil.
	
		object ].
		
	^objects
]

{ #category : #'examples - setup' }
GtLForwardCollectionToJsonViewExamples >> objectsWithJsonViewsAndDataKeys [
	<gtExample>
	"A collection of objects where each has a JSON view with a data key."
	| objects |
	
	objects := (1 to: 3) collect: [ :each |
		| object |
		object := GtLObjectWithJsonViewsForExamples new.
		object firstValue: 10 * each.
		object firstJsonViewDataKey: #jsonContent.
		object secondJsonViewEnabled: false.
	
		self assert: object firstJsonViewEnabled.
		self assert: object firstJsonViewDataKey equals: #jsonContent.
	
		object ].
		
	^ objects
]

{ #category : #'examples - setup' }
GtLForwardCollectionToJsonViewExamples >> objectsWithMixedDataKeys [
	<gtExample>
	"A collection of objects where some have data keys and some don't."
	| objects |
	objects := OrderedCollection new.
	
	"First object with data key"
	objects add: (GtLObjectWithJsonViewsForExamples new
		firstValue: 10;
		firstJsonViewDataKey: #jsonContent;
		secondJsonViewEnabled: false;
		yourself).
	
	"Second object without data key"
	objects add: (GtLObjectWithJsonViewsForExamples new
		firstValue: 20;
		secondJsonViewEnabled: false;
		yourself).
	
	"Third object with data key"
	objects add: (GtLObjectWithJsonViewsForExamples new
		firstValue: 30;
		firstJsonViewDataKey: #jsonContent;
		secondJsonViewEnabled: false;
		yourself).
	
	self assert: (objects first) firstJsonViewDataKey equals: #jsonContent.
	self assert: (objects second) firstJsonViewDataKey isNil.
	self assert: (objects third) firstJsonViewDataKey equals: #jsonContent.
	
	^ objects
]
