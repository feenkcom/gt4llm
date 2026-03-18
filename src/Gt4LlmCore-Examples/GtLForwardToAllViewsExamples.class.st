"
I provide examples for GtLForwardDataView forwarding to all views of an object.
"
Class {
	#name : #GtLForwardToAllViewsExamples,
	#superclass : #GtLForwardDataViewExamples,
	#category : 'Gt4LlmCore-Examples-Data Views'
}

{ #category : #examples }
GtLForwardToAllViewsExamples >> forwardToBothJsonViews [
	<gtExample>
	| object forwardDataView innerComposite |
	object := self objectWithTwoJsonViews.
	
	forwardDataView := GtLForwardDataView new
		object: [ object ].
	
	self assertForwardDataView: forwardDataView hasTargetObject: object.
	
	innerComposite := self 
		assertCompositeView: forwardDataView targetDataView 
		hasInnerCompositeWithViewCount: 2.
	
	self 
		assertCompositeView: innerComposite 
		hasJsonDataViewWithDataKey: #second 
		atIndex: 1.
	self 
		assertCompositeView: innerComposite 
		hasJsonDataViewWithDataKey: #first
		atIndex: 2.
	
	^ forwardDataView
]

{ #category : #examples }
GtLForwardToAllViewsExamples >> forwardToBothJsonViewsWithDataKey [
	<gtExample>
	| object forwardDataView innerComposite |
	object := self objectWithTwoJsonViews.
	
	forwardDataView := GtLForwardDataView new
		object: [ object ];
		dataKey: #allJsonViews.
	
	self assertForwardDataView: forwardDataView hasTargetObject: object withDataKey: #allJsonViews.
	
	innerComposite := self 
		assertCompositeView: forwardDataView targetDataView 
		hasInnerCompositeWithViewCount: 2.
	
	self assertCompositeView: innerComposite hasJsonDataViewWithDataKey: #second atIndex: 1.
	self assertCompositeView: innerComposite hasJsonDataViewWithDataKey: #first atIndex: 2.
	
	^ forwardDataView
]

{ #category : #examples }
GtLForwardToAllViewsExamples >> forwardToBothJsonViewsWithDataKey_serialization [
	<gtExample>
	| forwardDataView dataBlock actualData expectedData |
	forwardDataView := self forwardToBothJsonViewsWithDataKey.
	dataBlock := forwardDataView serializeToLlmPrimiteData.
	
	self assert: dataBlock dataBlocks size equals: 1.
	self assert: dataBlock compositeJsonDataBlock containedJsonDataBlocksCount equals: 2.
	
	actualData := dataBlock compositeJsonDataBlock llmJsonData.
	expectedData := Dictionary new
		at: #allJsonViews put: (Dictionary new
			at: #first put: (NeoJSONObject new
				at: #type put: 'first';
				at: #value put: 100;
				yourself);
			at: #second put: (NeoJSONObject new
				at: #type put: 'second';
				at: #value put: 200;
				yourself);
			yourself);
		yourself.
	self assert: actualData equals: expectedData.
	
	^ dataBlock
]

{ #category : #examples }
GtLForwardToAllViewsExamples >> forwardToBothJsonViews_serialization [
	<gtExample>
	| forwardDataView dataBlock actualData expectedData |
	forwardDataView := self forwardToBothJsonViews.
	dataBlock := forwardDataView serializeToLlmPrimiteData.
	
	self assert: dataBlock dataBlocks size equals: 1.
	self assert: dataBlock compositeJsonDataBlock containedJsonDataBlocksCount equals: 2.
	
	actualData := dataBlock compositeJsonDataBlock llmJsonData.
	expectedData := Dictionary new
		at: #first put: (NeoJSONObject new
			at: #type put: 'first';
			at: #value put: 100;
			yourself);
		at: #second put: (NeoJSONObject new
			at: #type put: 'second';
			at: #value put: 200;
			yourself);
		yourself.
	self assert: actualData equals: expectedData.
	
	^ dataBlock
]

{ #category : #examples }
GtLForwardToAllViewsExamples >> forwardToMultipleViews [
	<gtExample>
	| object forwardDataView innerComposite |
	object := self objectWithMultipleViews.
	
	forwardDataView := GtLForwardDataView new
		object: [ object ].
	
	self assertForwardDataView: forwardDataView hasTargetObject: object.
	
	innerComposite := self 
		assertCompositeView: forwardDataView targetDataView 
		hasInnerCompositeWithViewCount: 2.
	
	self assertCompositeView: innerComposite hasMagritteDataViewWithDataKey: #magritteData atIndex: 1.
	self assertCompositeView: innerComposite hasJsonDataViewWithDataKey: #jsonData atIndex: 2.
	
	^ forwardDataView
]

{ #category : #examples }
GtLForwardToAllViewsExamples >> forwardToMultipleViewsWithDataKey [
	<gtExample>
	| object forwardDataView innerComposite |
	object := self objectWithMultipleViews.
	
	forwardDataView := GtLForwardDataView new
		object: [ object ];
		dataKey: #allViews.
	
	self 
		assertForwardDataView: forwardDataView 
		hasTargetObject: object 
		withDataKey: #allViews.
	
	innerComposite := self 
		assertCompositeView: forwardDataView targetDataView 
		hasInnerCompositeWithViewCount: 2.
		
	self 
		assertCompositeView: innerComposite 
		hasMagritteDataViewWithDataKey: #magritteData 
		atIndex: 1.
	self 
		assertCompositeView: innerComposite 
		hasJsonDataViewWithDataKey: #jsonData 
		atIndex: 2.
	
	^ forwardDataView
]

{ #category : #examples }
GtLForwardToAllViewsExamples >> forwardToMultipleViewsWithDataKey_serialization [
	<gtExample>
	"Test serialization when the forward view has a data key."
	| forwardDataView dataBlock actualData expectedData |
	forwardDataView := self forwardToMultipleViewsWithDataKey.
	dataBlock := forwardDataView serializeToLlmPrimiteData.
	
	self assert: dataBlock dataBlocks size equals: 1.
	self assert: dataBlock compositeJsonDataBlock containedJsonDataBlocksCount equals: 2.
	
	"Magritte view data is flat (not wrapped), JSON view data is wrapped under its dataKey"
	actualData := dataBlock compositeJsonDataBlock llmJsonData.
	expectedData := Dictionary new
		at: #allViews put: (Dictionary new
			at: #jsonData put: (NeoJSONObject new
				at: #itemName put: 'Multi-View Item';
				at: #itemAmount put: 99;
				yourself);
			at: #name put: 'Multi-View Item';
			at: #amount put: 99;
			yourself);
		yourself.
	self assert: actualData equals: expectedData.
	
	^ dataBlock
]

{ #category : #examples }
GtLForwardToAllViewsExamples >> forwardToMultipleViews_serialization [
	<gtExample>
	| forwardDataView dataBlock actualData expectedData |
	forwardDataView := self forwardToMultipleViews.
	dataBlock := forwardDataView serializeToLlmPrimiteData.
	
	self assert: dataBlock dataBlocks size equals: 1.
	self assert: dataBlock compositeJsonDataBlock containedJsonDataBlocksCount equals: 2.
	
	"Magritte view data is flat (not wrapped), JSON view data is wrapped under its dataKey"
	actualData := dataBlock compositeJsonDataBlock llmJsonData.
	expectedData := Dictionary new
		at: #jsonData put: (NeoJSONObject new
			at: #itemName put: 'Multi-View Item';
			at: #itemAmount put: 99;
			yourself);
		at: #name put: 'Multi-View Item';
		at: #amount put: 99;
		yourself.
	self assert: actualData equals: expectedData.
	
	^ dataBlock
]

{ #category : #'examples - fixtures' }
GtLForwardToAllViewsExamples >> objectWithMagritteView [
	<gtExample>
	| object |
	object := GtLObjectWithMagritteViewForExamples new.
	
	self assert: object name equals: 'Example Item'.
	self assert: object amount equals: 42.
	self assert: object magritteViewDataKey isNil.
	
	^ object
]

{ #category : #'examples - fixtures' }
GtLForwardToAllViewsExamples >> objectWithMultipleViews [
	<gtExample>
	"An object that has both JSON and Magritte views."
	| object |
	object := GtLObjectWithMultipleViewsForExamples new.
	object jsonViewDataKey: #jsonData.
	object magritteViewDataKey: #magritteData.
	
	self assert: object name equals: 'Multi-View Item'.
	self assert: object amount equals: 99.
	self assert: object jsonViewDataKey equals: #jsonData.
	self assert: object magritteViewDataKey equals: #magritteData.
	
	^ object
]

{ #category : #'examples - fixtures' }
GtLForwardToAllViewsExamples >> objectWithTwoJsonViews [
	<gtExample>
	| object |
	object := GtLObjectWithJsonViewsForExamples new.
	object firstJsonViewDataKey: #first.
	object secondJsonViewDataKey: #second.
	
	self assert: object firstJsonViewEnabled.
	self assert: object secondJsonViewEnabled.
	self assert: object firstJsonViewDataKey equals: #first.
	self assert: object secondJsonViewDataKey equals: #second.
	
	^ object
]
