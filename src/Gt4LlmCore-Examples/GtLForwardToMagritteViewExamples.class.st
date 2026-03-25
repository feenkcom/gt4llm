"
I provide examples for GtLForwardDataView forwarding to Magritte views.
"
Class {
	#name : #GtLForwardToMagritteViewExamples,
	#superclass : #GtLForwardObjectDataViewExamples,
	#category : #'Gt4LlmCore-Examples-Data Views'
}

{ #category : #examples }
GtLForwardToMagritteViewExamples >> forwardToMagritteViewWithBothDataKeys [
	<gtExample>
	"Test forwarding where both the inner Magritte view and the forward view have data keys."
	| object dataView |
	object := self objectWithMagritteViewWithDataKey.
	
	dataView := GtLForwardObjectDataView new
		object: [ object ];
		view: #gtLlmMagritteViewFor:;
		dataKey: #outerKey.
	
	self assert: dataView targetObject equals: object.
	self assert: dataView dataKey equals: #outerKey.
	self 
		assertCompositeView: dataView targetDataView 
		hasSingleMagritteDataViewWithDataKey: #itemData.
	
	^ dataView
]

{ #category : #examples }
GtLForwardToMagritteViewExamples >> forwardToMagritteViewWithBothDataKeys_serialization [
	<gtExample>
	"Test serialization when both inner view and forward view have data keys.
	Note: Only the forward view's dataKey wraps the data since the Magritte view's dataKey is set on the inner JSON view."
	| dataView dataBlock actualData expectedData |
	dataView := self forwardToMagritteViewWithBothDataKeys.
	dataBlock := dataView serializeToLlmPrimiteData.
	
	self assert: dataBlock dataBlocks size equals: 1.
	self assert: dataBlock compositeJsonDataBlock containedJsonDataBlocksCount equals: 1.
	
	actualData := dataBlock compositeJsonDataBlock llmJsonData.
	expectedData := Dictionary new
		at: #outerKey put: (Dictionary new
			at: 'itemData' put: (NeoJSONObject new
				at: #name put: 'Example Item';
				at: #amount put: 42;
				yourself);
			yourself);
		yourself.
	self assert: actualData equals: expectedData.
	
	^ dataBlock
]

{ #category : #examples }
GtLForwardToMagritteViewExamples >> forwardToMagritteViewWithDataKey [
	<gtExample>
	"Test forwarding to a Magritte view that has its own data key."
	| object dataView |
	object := self objectWithMagritteViewWithDataKey.
	
	dataView := GtLForwardObjectDataView new
		object: [ object ];
		view: #gtLlmMagritteViewFor:.
	
	self assert: dataView targetObject equals: object.
	self 
		assertCompositeView: dataView targetDataView 
		hasSingleMagritteDataViewWithDataKey: #itemData.
	
	^ dataView
]

{ #category : #examples }
GtLForwardToMagritteViewExamples >> forwardToMagritteViewWithDataKey_serialization [
	<gtExample>
	"Test serialization when the inner Magritte view has a data key.
	Note: The Magritte view's dataKey does NOT wrap the data - the inner JSON view gets the dataKey."
	| dataView dataBlock actualData expectedData |
	dataView := self forwardToMagritteViewWithDataKey.
	dataBlock := dataView serializeToLlmPrimiteData.
	
	self assert: dataBlock dataBlocks size equals: 1.
	self assert: dataBlock compositeJsonDataBlock containedJsonDataBlocksCount equals: 1.
	
	actualData := dataBlock compositeJsonDataBlock llmJsonData.
	expectedData := Dictionary new 
		at: 'itemData' put: (NeoJSONObject new
			at: #name put: 'Example Item';
			at: #amount put: 42;
			yourself);
		yourself.
	self assert: actualData equals: expectedData.
	
	^ dataBlock
]

{ #category : #examples }
GtLForwardToMagritteViewExamples >> forwardToMagritteViewWithForwardDataKey [
	<gtExample>
	"Test forwarding to a Magritte view where the forward view itself has a data key."
	| object dataView |
	object := self objectWithMagritteView.
	
	dataView := GtLForwardObjectDataView new
		object: [ object ];
		view: #gtLlmMagritteViewFor:;
		dataKey: #forwardedMagritte.
	
	self assert: dataView targetObject equals: object.
	self assert: dataView dataKey equals: #forwardedMagritte.
	self 
		assertCompositeView: dataView targetDataView 
		hasSingleMagritteDataViewWithDataKey: nil.
	
	^ dataView
]

{ #category : #examples }
GtLForwardToMagritteViewExamples >> forwardToMagritteViewWithForwardDataKey_serialization [
	<gtExample>
	"Test serialization when the forward view has its own data key."
	| dataView dataBlock actualData expectedData |
	dataView := self forwardToMagritteViewWithForwardDataKey.
	dataBlock := dataView serializeToLlmPrimiteData.
	
	self assert: dataBlock dataBlocks size equals: 1.
	self assert: dataBlock compositeJsonDataBlock containedJsonDataBlocksCount equals: 1.
	
	actualData := dataBlock compositeJsonDataBlock llmJsonData.
	expectedData := Dictionary new
		at: #forwardedMagritte put: (Dictionary new
			at: #name put: 'Example Item';
			at: #amount put: 42;
			yourself);
		yourself.
	self assert: actualData equals: expectedData.
	
	^ dataBlock
]

{ #category : #examples }
GtLForwardToMagritteViewExamples >> forwardToMagritteViewWithoutDataKey [
	<gtExample>
	| object dataView |
	object := self objectWithMagritteView.
	
	dataView := GtLForwardObjectDataView new
		object: [ object ];
		view: #gtLlmMagritteViewFor:.
	
	self assert: dataView targetObject equals: object.
	self 
		assertCompositeView: dataView targetDataView 
		hasSingleMagritteDataViewWithDataKey: nil.
	
	^ dataView
]

{ #category : #examples }
GtLForwardToMagritteViewExamples >> forwardToMagritteViewWithoutDataKey_serialization [
	<gtExample>
	| dataView dataBlock actualData expectedData |
	dataView := self forwardToMagritteViewWithoutDataKey.
	dataBlock := dataView serializeToLlmPrimiteData.
	
	self assert: dataBlock dataBlocks size equals: 1.
	self assert: dataBlock compositeJsonDataBlock containedJsonDataBlocksCount equals: 1.
	
	actualData := dataBlock compositeJsonDataBlock llmJsonData.
	expectedData := Dictionary new
		at: #name put: 'Example Item';
		at: #amount put: 42;
		yourself.
	self assert: actualData equals: expectedData.
	
	^ dataBlock
]

{ #category : #'examples - support' }
GtLForwardToMagritteViewExamples >> objectWithMagritteView [
	<gtExample>
	| object |
	object := GtLObjectWithMagritteViewForExamples new.
	
	self assert: object name equals: 'Example Item'.
	self assert: object amount equals: 42.
	self assert: object magritteViewDataKey isNil.
	
	^ object
]

{ #category : #'examples - support' }
GtLForwardToMagritteViewExamples >> objectWithMagritteViewWithDataKey [
	<gtExample>
	| object |
	object := self objectWithMagritteView.
	object magritteViewDataKey: #itemData.
	
	self assert: object magritteViewDataKey equals: #itemData.
	
	^ object
]
