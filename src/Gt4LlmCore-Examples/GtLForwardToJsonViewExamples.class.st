"
I provide examples for GtLForwardDataView forwarding to JSON views.
"
Class {
	#name : #GtLForwardToJsonViewExamples,
	#superclass : #GtLForwardDataViewExamples,
	#category : 'Gt4LlmCore-Examples-Data Views'
}

{ #category : #examples }
GtLForwardToJsonViewExamples >> forwardToFirstJsonViewWithBothDataKeys [
	<gtExample>
	"Test forwarding where both the inner JSON view and the forward view have data keys."
	| object dataView |
	object := self objectWithJsonViewsWithDataKeys.
	object secondJsonViewEnabled: false.
	
	dataView := GtLForwardObjectDataView new
		object: [ object ];
		view: #gtLlmFirstJsonViewFor:;
		dataKey: #outerKey.
	
	self assert: dataView targetObject equals: object.
	self assert: dataView dataKey equals: #outerKey.
	self 
		assertCompositeView: dataView targetDataView 
		hasSingleJsonDataViewWithDataKey: #firstData.
	
	^ dataView
]

{ #category : #examples }
GtLForwardToJsonViewExamples >> forwardToFirstJsonViewWithBothDataKeys_serialization [
	<gtExample>
	"Test serialization when both inner view and forward view have data keys (nested keys)."
	| dataView dataBlock actualData expectedData |
	dataView := self forwardToFirstJsonViewWithBothDataKeys.
	dataBlock := dataView serializeToLlmPrimiteData.
	
	self assert: dataBlock dataBlocks size equals: 1.
	self assert: dataBlock compositeJsonDataBlock containedJsonDataBlocksCount equals: 1.
	
	actualData := dataBlock compositeJsonDataBlock llmJsonData.
	expectedData := Dictionary new
		at: #outerKey put: (Dictionary new
			at: #firstData put: (NeoJSONObject new
				at: #type put: 'first';
				at: #value put: 100;
				yourself);
			yourself);
		yourself.
	self assert: actualData equals: expectedData.
	
	^ dataBlock
]

{ #category : #examples }
GtLForwardToJsonViewExamples >> forwardToFirstJsonViewWithDataKey [
	<gtExample>
	| object dataView |
	object := self objectWithJsonViewsWithDataKeys.
	object secondJsonViewEnabled: false.
	
	dataView := GtLForwardObjectDataView new
		object: [ object ];
		view: #gtLlmFirstJsonViewFor:.
	
	self assert: dataView targetObject equals: object.
	self 
		assertCompositeView: dataView targetDataView 
		hasSingleJsonDataViewWithDataKey: #firstData.
	
	^ dataView
]

{ #category : #examples }
GtLForwardToJsonViewExamples >> forwardToFirstJsonViewWithDataKey_serialization [
	<gtExample>
	| dataView dataBlock actualData expectedData |
	dataView := self forwardToFirstJsonViewWithDataKey.
	dataBlock := dataView serializeToLlmPrimiteData.
	
	self assert: dataBlock dataBlocks size equals: 1.
	self assert: dataBlock compositeJsonDataBlock containedJsonDataBlocksCount equals: 1.
	
	actualData := dataBlock compositeJsonDataBlock llmJsonData.
	expectedData := Dictionary new
		at: #firstData put: (NeoJSONObject new
			at: #type put: 'first';
			at: #value put: 100;
			yourself);
		yourself.
	self assert: actualData equals: expectedData.
	
	^ dataBlock
]

{ #category : #examples }
GtLForwardToJsonViewExamples >> forwardToFirstJsonViewWithForwardDataKey [
	<gtExample>
	"Test forwarding to a JSON view where the forward view itself has a data key."
	| object dataView |
	object := self objectWithJsonViews.
	object secondJsonViewEnabled: false.
	
	dataView := GtLForwardObjectDataView new
		object: [ object ];
		view: #gtLlmFirstJsonViewFor:;
		dataKey: #forwardedFirst.
	
	self assert: dataView targetObject equals: object.
	self assert: dataView dataKey equals: #forwardedFirst.
	self 
		assertCompositeView: dataView targetDataView 
		hasSingleJsonDataViewWithDataKey: nil.
	
	^ dataView
]

{ #category : #examples }
GtLForwardToJsonViewExamples >> forwardToFirstJsonViewWithForwardDataKey_serialization [
	<gtExample>
	"Test serialization when the forward view has its own data key."
	| dataView dataBlock actualData expectedData |
	dataView := self forwardToFirstJsonViewWithForwardDataKey.
	dataBlock := dataView serializeToLlmPrimiteData.
	
	self assert: dataBlock dataBlocks size equals: 1.
	self assert: dataBlock compositeJsonDataBlock containedJsonDataBlocksCount equals: 1.
	
	actualData := dataBlock compositeJsonDataBlock llmJsonData.
	expectedData := Dictionary new
		at: #forwardedFirst put: (Dictionary new
			at: #type put: 'first';
			at: #value put: 100;
			yourself);
		yourself.
	self assert: actualData equals: expectedData.
	
	^ dataBlock
]

{ #category : #examples }
GtLForwardToJsonViewExamples >> forwardToFirstJsonViewWithoutDataKey [
	<gtExample>
	| object dataView |
	object := self objectWithJsonViews.
	object secondJsonViewEnabled: false.
	
	dataView := GtLForwardObjectDataView new
		object: [ object ];
		view: #gtLlmFirstJsonViewFor:.
	
	self assert: dataView targetObject equals: object.
	self 
		assertCompositeView: dataView targetDataView 
		hasSingleJsonDataViewWithDataKey: nil.
	
	^ dataView
]

{ #category : #examples }
GtLForwardToJsonViewExamples >> forwardToFirstJsonViewWithoutDataKey_serialization [
	<gtExample>
	| dataView dataBlock actualData expectedData |
	dataView := self forwardToFirstJsonViewWithoutDataKey.
	dataBlock := dataView serializeToLlmPrimiteData.
	
	self assert: dataBlock dataBlocks size equals: 1.
	self assert: dataBlock compositeJsonDataBlock containedJsonDataBlocksCount equals: 1.
	
	actualData := dataBlock compositeJsonDataBlock llmJsonData.
	expectedData := Dictionary new
		at: #type put: 'first';
		at: #value put: 100;
		yourself.
	self assert: actualData equals: expectedData.
	
	^ dataBlock
]

{ #category : #examples }
GtLForwardToJsonViewExamples >> forwardToSecondJsonViewWithoutDataKey [
	<gtExample>
	| object dataView |
	object := self objectWithJsonViews.
	object firstJsonViewEnabled: false.
	
	dataView := GtLForwardObjectDataView new
		object: [ object ];
		view: #gtLlmSecondJsonViewFor:.
	
	self assert: dataView targetObject equals: object.
	self 
		assertCompositeView: dataView targetDataView 
		hasSingleJsonDataViewWithDataKey: nil.
	
	^ dataView
]

{ #category : #examples }
GtLForwardToJsonViewExamples >> forwardToSecondJsonViewWithoutDataKey_serialization [
	<gtExample>
	| dataView dataBlock actualData expectedData |
	dataView := self forwardToSecondJsonViewWithoutDataKey.
	dataBlock := dataView serializeToLlmPrimiteData.
	
	self assert: dataBlock dataBlocks size equals: 1.
	self assert: dataBlock compositeJsonDataBlock containedJsonDataBlocksCount equals: 1.
	
	actualData := dataBlock compositeJsonDataBlock llmJsonData.
	expectedData := Dictionary new
		at: #type put: 'second';
		at: #value put: 200;
		yourself.
	self assert: actualData equals: expectedData.
	
	^ dataBlock
]

{ #category : #'examples - support' }
GtLForwardToJsonViewExamples >> objectWithJsonViews [
	<gtExample>
	| object |
	object := GtLObjectWithJsonViewsForExamples new.
	
	self assert: object firstJsonViewEnabled.
	self assert: object secondJsonViewEnabled.
	self assert: object firstJsonViewDataKey isNil.
	self assert: object secondJsonViewDataKey isNil.
	
	^ object
]

{ #category : #'examples - support' }
GtLForwardToJsonViewExamples >> objectWithJsonViewsWithDataKeys [
	<gtExample>
	| object |
	object := self objectWithJsonViews.
	object firstJsonViewDataKey: #firstData.
	object secondJsonViewDataKey: #secondData.
	
	self assert: object firstJsonViewDataKey equals: #firstData.
	self assert: object secondJsonViewDataKey equals: #secondData.
	
	^ object
]
