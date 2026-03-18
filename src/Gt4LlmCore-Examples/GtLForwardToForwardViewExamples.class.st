"
I provide examples for GtLForwardDataView forwarding to another forward view (chained forwarding).
"
Class {
	#name : #GtLForwardToForwardViewExamples,
	#superclass : #GtLForwardObjectDataViewExamples,
	#category : 'Gt4LlmCore-Examples-Data Views'
}

{ #category : #'examples - fixtures' }
GtLForwardToForwardViewExamples >> chainOfThreeForwarders [
	<gtExample>
	"Create a chain: forwarder3 -> forwarder2 -> forwarder1 -> jsonViewObject"
	| jsonObject forwarder1 forwarder2 forwarder3 |
	jsonObject := self jsonViewObject.
	
	forwarder1 := GtLObjectWithForwardViewForExamples new.
	forwarder1 targetObject: jsonObject.
	forwarder1 targetViewSymbol: #gtLlmFirstJsonViewFor:.
	
	forwarder2 := GtLObjectWithForwardViewForExamples new.
	forwarder2 targetObject: forwarder1.
	forwarder2 targetViewSymbol: #gtLlmForwardViewFor:.
	
	forwarder3 := GtLObjectWithForwardViewForExamples new.
	forwarder3 targetObject: forwarder2.
	forwarder3 targetViewSymbol: #gtLlmForwardViewFor:.
	
	self assert: forwarder3 targetObject equals: forwarder2.
	self assert: forwarder2 targetObject equals: forwarder1.
	self assert: forwarder1 targetObject equals: jsonObject.
	
	^ forwarder3
]

{ #category : #'examples - fixtures' }
GtLForwardToForwardViewExamples >> chainOfThreeForwardersWithDataKeys [
	<gtExample>
	"Create a chain with data keys: forwarder3 -> forwarder2 -> forwarder1 -> jsonViewObject"
	| jsonObject forwarder1 forwarder2 forwarder3 |
	jsonObject := self jsonViewObject.
	
	forwarder1 := GtLObjectWithForwardViewForExamples new.
	forwarder1 targetObject: jsonObject.
	forwarder1 targetViewSymbol: #gtLlmFirstJsonViewFor:.
	forwarder1 forwardViewDataKey: #level1.
	
	forwarder2 := GtLObjectWithForwardViewForExamples new.
	forwarder2 targetObject: forwarder1.
	forwarder2 targetViewSymbol: #gtLlmForwardViewFor:.
	forwarder2 forwardViewDataKey: #level2.
	
	forwarder3 := GtLObjectWithForwardViewForExamples new.
	forwarder3 targetObject: forwarder2.
	forwarder3 targetViewSymbol: #gtLlmForwardViewFor:.
	forwarder3 forwardViewDataKey: #level3.
	
	self assert: forwarder3 forwardViewDataKey equals: #level3.
	self assert: forwarder2 forwardViewDataKey equals: #level2.
	self assert: forwarder1 forwardViewDataKey equals: #level1.
	
	^ forwarder3
]

{ #category : #'examples - fixtures' }
GtLForwardToForwardViewExamples >> forwarderToJsonView [
	<gtExample>
	"An object that forwards to a JSON view object."
	| jsonObject forwarder |
	jsonObject := self jsonViewObject.
	
	forwarder := GtLObjectWithForwardViewForExamples new.
	forwarder targetObject: jsonObject.
	forwarder targetViewSymbol: #gtLlmFirstJsonViewFor:.
	
	self assert: forwarder targetObject equals: jsonObject.
	self assert: forwarder targetViewSymbol equals: #gtLlmFirstJsonViewFor:.
	self assert: forwarder forwardViewDataKey isNil.
	
	^ forwarder
]

{ #category : #'examples - fixtures' }
GtLForwardToForwardViewExamples >> forwarderToJsonViewWithDataKey [
	<gtExample>
	"An object that forwards to a JSON view object with a data key."
	| forwarder |
	forwarder := self forwarderToJsonView.
	forwarder forwardViewDataKey: #forwardedJson.
	
	self assert: forwarder forwardViewDataKey equals: #forwardedJson.
	
	^ forwarder
]

{ #category : #examples }
GtLForwardToForwardViewExamples >> forwardToChainOfForwarders [
	<gtExample>
	"Test forwarding through a chain of three forwarders to reach a JSON view."
	| forwarder3 forwardDataView |
	forwarder3 := self chainOfThreeForwarders.
	
	forwardDataView := GtLForwardObjectDataView new
		object: [ forwarder3 ];
		view: #gtLlmForwardViewFor:.
	
	self assert: forwardDataView targetObject equals: forwarder3.
	
	"The forward view should resolve through all forwarders to the final JSON view"
	self 
		assertCompositeView: forwardDataView targetDataView 
		hasSingleJsonDataViewWithDataKey: #jsonContent.
	
	^ forwardDataView
]

{ #category : #examples }
GtLForwardToForwardViewExamples >> forwardToChainOfForwardersWithDataKeys [
	<gtExample>
	"Test forwarding through a chain of forwarders with data keys."
	| forwarder3 forwardDataView |
	forwarder3 := self chainOfThreeForwardersWithDataKeys.
	
	forwardDataView := GtLForwardObjectDataView new
		object: [ forwarder3 ];
		view: #gtLlmForwardViewFor:.
	
	self assert: forwardDataView targetObject equals: forwarder3.
	
	^ forwardDataView
]

{ #category : #'examples - serialization' }
GtLForwardToForwardViewExamples >> forwardToChainOfForwardersWithDataKeys_serialization [
	<gtExample>
	"When forwarding through a chain, each forward overrides the next.
	Since the outermost forward has no dataKey, only the final JSON view's dataKey is preserved."
	| forwardDataView dataBlock actualData expectedData |
	forwardDataView := self forwardToChainOfForwardersWithDataKeys.
	dataBlock := forwardDataView serializeToLlmPrimiteData.
	
	self assert: dataBlock dataBlocks size equals: 1.
	self assert: dataBlock compositeJsonDataBlock containedJsonDataBlocksCount equals: 1.
	
	actualData := dataBlock compositeJsonDataBlock llmJsonData.
	expectedData := Dictionary new
		at: #jsonContent put: (NeoJSONObject new
			at: #type put: 'first';
			at: #value put: 100;
			yourself);
		yourself.
	self assert: actualData equals: expectedData.
	
	^ dataBlock
]

{ #category : #examples }
GtLForwardToForwardViewExamples >> forwardToChainOfForwardersWithOuterDataKey [
	<gtExample>
	"Test forwarding through a chain of forwarders where only the outer forward has a data key.
	The chain has intermediate data keys (level3, level2, level1) but they will be overridden."
	| forwarder3 forwardDataView |
	forwarder3 := self chainOfThreeForwardersWithDataKeys.
	
	forwardDataView := GtLForwardObjectDataView new
		object: [ forwarder3 ];
		view: #gtLlmForwardViewFor:;
		dataKey: #topLevel.
	
	self assert: forwardDataView targetObject equals: forwarder3.
	self assert: forwardDataView dataKey equals: #topLevel.
	
	^ forwardDataView
]

{ #category : #'examples - serialization' }
GtLForwardToForwardViewExamples >> forwardToChainOfForwardersWithOuterDataKey_serialization [
	<gtExample>
	"When the outer forward has a dataKey, it wraps the final result.
	All intermediate forward dataKeys (level3, level2, level1) are overridden.
	Only the outer dataKey (#topLevel) and the final JSON view's dataKey (#jsonContent) are preserved."
	| forwardDataView dataBlock actualData expectedData |
	forwardDataView := self forwardToChainOfForwardersWithOuterDataKey.
	dataBlock := forwardDataView serializeToLlmPrimiteData.
	
	self assert: dataBlock dataBlocks size equals: 1.
	self assert: dataBlock compositeJsonDataBlock containedJsonDataBlocksCount equals: 1.
	
	actualData := dataBlock compositeJsonDataBlock llmJsonData.
	expectedData := Dictionary new
		at: #topLevel put: (Dictionary new
			at: #jsonContent put: (NeoJSONObject new
				at: #type put: 'first';
				at: #value put: 100;
				yourself);
			yourself);
		yourself.
	self assert: actualData equals: expectedData.
	
	^ dataBlock
]

{ #category : #examples }
GtLForwardToForwardViewExamples >> forwardToChainOfForwarders_serialization [
	<gtExample>
	| forwardDataView dataBlock actualData expectedData |
	forwardDataView := self forwardToChainOfForwarders.
	dataBlock := forwardDataView serializeToLlmPrimiteData.
	
	self assert: dataBlock dataBlocks size equals: 1.
	self assert: dataBlock compositeJsonDataBlock containedJsonDataBlocksCount equals: 1.
	
	actualData := dataBlock compositeJsonDataBlock llmJsonData.
	expectedData := Dictionary new
		at: #jsonContent put: (NeoJSONObject new
			at: #type put: 'first';
			at: #value put: 100;
			yourself);
		yourself.
	self assert: actualData equals: expectedData.
	
	^ dataBlock
]

{ #category : #examples }
GtLForwardToForwardViewExamples >> forwardToForwardViewWithBothDataKeys [
	<gtExample>
	"Test forwarding to a forward view where both the outer and inner forward have data keys.
	The inner forwarder has dataKey #forwardedJson, and the outer has #outerKey."
	| forwarder forwardDataView |
	forwarder := self forwarderToJsonViewWithDataKey.
	
	forwardDataView := GtLForwardObjectDataView new
		object: [ forwarder ];
		view: #gtLlmForwardViewFor:;
		dataKey: #outerKey.
	
	self assert: forwardDataView targetObject equals: forwarder.
	self assert: forwardDataView dataKey equals: #outerKey.
	"The inner forwarder has dataKey #forwardedJson but it will be overridden"
	self assert: forwarder forwardViewDataKey equals: #forwardedJson.
	
	^ forwardDataView
]

{ #category : #'examples - serialization' }
GtLForwardToForwardViewExamples >> forwardToForwardViewWithBothDataKeys_serialization [
	<gtExample>
	"When the outer forward has a dataKey, it wraps the final result.
	The inner forwarder's dataKey (#forwardedJson) is overridden.
	Only the outer dataKey and the final JSON view's dataKey are preserved."
	| forwardDataView dataBlock actualData expectedData |
	forwardDataView := self forwardToForwardViewWithBothDataKeys.
	dataBlock := forwardDataView serializeToLlmPrimiteData.
	
	self assert: dataBlock dataBlocks size equals: 1.
	self assert: dataBlock compositeJsonDataBlock containedJsonDataBlocksCount equals: 1.
	
	actualData := dataBlock compositeJsonDataBlock llmJsonData.
	expectedData := Dictionary new
		at: #outerKey put: (Dictionary new
			at: #jsonContent put: (NeoJSONObject new
				at: #type put: 'first';
				at: #value put: 100;
				yourself);
			yourself);
		yourself.
	self assert: actualData equals: expectedData.
	
	^ dataBlock
]

{ #category : #examples }
GtLForwardToForwardViewExamples >> forwardToForwardViewWithInnerDataKey [
	<gtExample>
	"Test forwarding to a forward view that has its own data key."
	| forwarder forwardDataView |
	forwarder := self forwarderToJsonViewWithDataKey.
	
	forwardDataView := GtLForwardObjectDataView new
		object: [ forwarder ];
		view: #gtLlmForwardViewFor:.
	
	self assert: forwardDataView targetObject equals: forwarder.
	self assert: forwardDataView dataKey isNil.
	
	^ forwardDataView
]

{ #category : #'examples - serialization' }
GtLForwardToForwardViewExamples >> forwardToForwardViewWithInnerDataKey_serialization [
	<gtExample>
	"When forwarding to a forward view, the outer forward overrides the inner data key.
	Since the outer forward has no dataKey, only the final JSON view's dataKey is preserved."
	| forwardDataView dataBlock actualData expectedData |
	forwardDataView := self forwardToForwardViewWithInnerDataKey.
	dataBlock := forwardDataView serializeToLlmPrimiteData.
	
	self assert: dataBlock dataBlocks size equals: 1.
	self assert: dataBlock compositeJsonDataBlock containedJsonDataBlocksCount equals: 1.
	
	actualData := dataBlock compositeJsonDataBlock llmJsonData.
	expectedData := Dictionary new
		at: #jsonContent put: (NeoJSONObject new
			at: #type put: 'first';
			at: #value put: 100;
			yourself);
		yourself.
	self assert: actualData equals: expectedData.
	
	^ dataBlock
]

{ #category : #examples }
GtLForwardToForwardViewExamples >> forwardToForwardViewWithoutDataKey [
	<gtExample>
	"Test forwarding to another forward view without any data keys."
	| forwarder forwardDataView |
	forwarder := self forwarderToJsonView.
	
	forwardDataView := GtLForwardObjectDataView new
		object: [ forwarder ];
		view: #gtLlmForwardViewFor:.
	
	self assert: forwardDataView targetObject equals: forwarder.
	
	"The forward view should resolve through the chain to the final JSON view"
	self 
		assertCompositeView: forwardDataView targetDataView 
		hasSingleJsonDataViewWithDataKey: #jsonContent.
	
	^ forwardDataView
]

{ #category : #examples }
GtLForwardToForwardViewExamples >> forwardToForwardViewWithoutDataKey_serialization [
	<gtExample>
	| forwardDataView dataBlock actualData expectedData |
	forwardDataView := self forwardToForwardViewWithoutDataKey.
	dataBlock := forwardDataView serializeToLlmPrimiteData.
	
	self assert: dataBlock dataBlocks size equals: 1.
	self assert: dataBlock compositeJsonDataBlock containedJsonDataBlocksCount equals: 1.
	
	actualData := dataBlock compositeJsonDataBlock llmJsonData.
	expectedData := Dictionary new
		at: #jsonContent put: (NeoJSONObject new
			at: #type put: 'first';
			at: #value put: 100;
			yourself);
		yourself.
	self assert: actualData equals: expectedData.
	
	^ dataBlock
]

{ #category : #examples }
GtLForwardToForwardViewExamples >> forwardToForwardViewWithOuterDataKey [
	<gtExample>
	"Test forwarding to a forward view with a data key on the outer forward."
	| forwarder forwardDataView |
	forwarder := self forwarderToJsonView.
	
	forwardDataView := GtLForwardObjectDataView new
		object: [ forwarder ];
		view: #gtLlmForwardViewFor:;
		dataKey: #outerForward.
	
	self assert: forwardDataView targetObject equals: forwarder.
	self assert: forwardDataView dataKey equals: #outerForward.
	
	^ forwardDataView
]

{ #category : #examples }
GtLForwardToForwardViewExamples >> forwardToForwardViewWithOuterDataKey_serialization [
	<gtExample>
	| forwardDataView dataBlock actualData expectedData |
	forwardDataView := self forwardToForwardViewWithOuterDataKey.
	dataBlock := forwardDataView serializeToLlmPrimiteData.
	
	self assert: dataBlock dataBlocks size equals: 1.
	self assert: dataBlock compositeJsonDataBlock containedJsonDataBlocksCount equals: 1.
	
	actualData := dataBlock compositeJsonDataBlock llmJsonData.
	expectedData := Dictionary new
		at: #outerForward put: (Dictionary new
			at: #jsonContent put: (NeoJSONObject new
				at: #type put: 'first';
				at: #value put: 100;
				yourself);
			yourself);
		yourself.
	self assert: actualData equals: expectedData.
	
	^ dataBlock
]

{ #category : #'examples - fixtures' }
GtLForwardToForwardViewExamples >> jsonViewObject [
	<gtExample>
	"A simple object with a JSON view to use as the final target."
	| object |
	object := GtLObjectWithJsonViewsForExamples new.
	object firstJsonViewDataKey: #jsonContent.
	object secondJsonViewEnabled: false.
	
	self assert: object firstJsonViewEnabled.
	self assert: object firstJsonViewDataKey equals: #jsonContent.
	
	^ object
]
