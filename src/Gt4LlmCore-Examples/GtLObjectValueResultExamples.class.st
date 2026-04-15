"
Examples for GtLObjectValueResult testing serialization and data views.
"
Class {
	#name : #GtLObjectValueResultExamples,
	#superclass : #GtLDomainObjectExamples,
	#category : #'Gt4LlmCore-Examples-Domain Objects'
}

{ #category : #assertions }
GtLObjectValueResultExamples >> assertObjectValueJson: objectValueJson includesPhlowViews: expectedMethodNames [
	"Assert that the object value JSON includes the expected phlow view method names"
	| phlowViews phlowViewMethodNames |
	phlowViews := objectValueJson at: 'phlowViews'.
	self assert: phlowViews isNotEmpty.
	phlowViewMethodNames := phlowViews collect: [ :each | each at: 'methodName' ].
	expectedMethodNames do: [ :methodName |
		self assert: (phlowViewMethodNames includes: methodName) ]
]

{ #category : #assertions }
GtLObjectValueResultExamples >> assertObjectValueResultJsonDataKeys: jsonData [
	"Assert that the JSON data contains the expected keys for an object value result"
	| expectedKeys expectedObjectValueKeys objectValueJson |
	expectedKeys := #('objectDetails' #objectValue).
	self assert: jsonData keys sorted equals: expectedKeys sorted.
	
	objectValueJson := jsonData at: #objectValue.
	expectedObjectValueKeys := #(#allInstanceSlots #objectClassName #objectPrintString #packageName #phlowViews #superclassName).
	self assert: objectValueJson keys sorted equals: expectedObjectValueKeys sorted
]

{ #category : #examples }
GtLObjectValueResultExamples >> objectValueResultForInteger [
	<gtExample>
	<return: #GtLObjectValueResult>
	| object domainObject |
	
	object := 42.
	domainObject := GtLObjectValueResult forObject: object.
	
	self assert: domainObject object equals: object.
	self assert: domainObject objectValue class equals: GtLSerializedObjectValue.
	
	^ domainObject
]

{ #category : #'examples - views' }
GtLObjectValueResultExamples >> objectValueResultForIntegerMainDataView [
	<gtExample>
	<return: #GtLCompositeDataView>
	| domainObject mainDataView forwardedView |
	
	domainObject := self objectValueResultForInteger.
	mainDataView := domainObject llmDataViewsFor: GtLDataView new.
	
	self assertCompositeDataView: mainDataView hasTitle: 'Object views' viewsCount: 2.
	
	"First view is forward for object specific details"
	self assertCompositeView: mainDataView hasJsonForwardDataViewWithDataKey: 'objectDetails' targetObject:  domainObject object.
	
	forwardedView := (mainDataView dataViews 
		detect: [ :each | each class = GtLForwardObjectDataView ]) computeForwardedView.
	self assertCompositeDataView: forwardedView hasTitle: 'Object views' viewsCount: 0.
	
	"Second view is raw data (magritte)"
	self assertCompositeView: mainDataView hasMagritteDataViewWithDataKey: nil.
	
	^ mainDataView
]

{ #category : #'examples - serialization' }
GtLObjectValueResultExamples >> objectValueResultForIntegerSerialization [
	<gtExample>
	<return: #GtLPrimitiveMessageDataBlock>
	| mainDataView dataBlock jsonData objectValueJson |
	
	mainDataView := self objectValueResultForIntegerMainDataView.
	dataBlock := mainDataView serializeToLlmPrimiteData.
	
	self assertDataBlockHasOnlyJsonData: dataBlock.
	
	jsonData := dataBlock llmJsonData.
	self assertObjectValueResultJsonDataKeys: jsonData.
	self assert: (jsonData at: 'objectDetails') equals: Dictionary new.
	
	objectValueJson := jsonData at: #objectValue.
	self assert: (objectValueJson at: 'objectClassName') equals: 'SmallInteger'.
	self assert: (objectValueJson at: 'objectPrintString') equals: '42'.
	self assert: (objectValueJson at: 'superclassName') equals: 'Integer'.
	self assert: (objectValueJson at: 'packageName') equals: 'Kernel'.
	self assert: (objectValueJson at: 'allInstanceSlots') asArray equals: #().
	self assertObjectValueJson: objectValueJson includesPhlowViews: #('gtPreviewFor:' 'gtIntegerFor:' 'gtRawFor:' 'gtPrintFor:').
	
	^ dataBlock
]

{ #category : #examples }
GtLObjectValueResultExamples >> objectValueResultForString [
	<gtExample>
	<return: #GtLObjectValueResult>
	| object domainObject |
	
	object := 'hello world'.
	domainObject := GtLObjectValueResult forObject: object.
	
	self assert: domainObject object equals: object.
	self assert: domainObject objectValue class equals: GtLSerializedObjectValue.
	
	^ domainObject
]

{ #category : #'examples - views' }
GtLObjectValueResultExamples >> objectValueResultForStringMainDataView [
	<gtExample>
	<return: #GtLCompositeDataView>
	| domainObject mainDataView forwardedView |
	
	domainObject := self objectValueResultForString.
	mainDataView := domainObject llmDataViewsFor: GtLDataView new.
	
	self assertCompositeDataView: mainDataView hasTitle: 'Object views' viewsCount: 2.
	
	"First view is forward for object specific details"
	self assertCompositeView: mainDataView hasJsonForwardDataViewWithDataKey: 'objectDetails' targetObject:  domainObject object.
	
	forwardedView := (mainDataView dataViews 
		detect: [ :each | each class = GtLForwardObjectDataView ]) computeForwardedView.
	self assertCompositeDataView: forwardedView hasTitle: 'Object views' viewsCount: 0.
	
	"Second view is raw data (magritte)"
	self assertCompositeView: mainDataView hasMagritteDataViewWithDataKey: nil.
	
	^ mainDataView
]

{ #category : #'examples - serialization' }
GtLObjectValueResultExamples >> objectValueResultForStringSerialization [
	<gtExample>
	<return: #GtLPrimitiveMessageDataBlock>
	| mainDataView dataBlock jsonData objectValueJson |
	
	mainDataView := self objectValueResultForStringMainDataView.
	dataBlock := mainDataView serializeToLlmPrimiteData.
	
	self assertDataBlockHasOnlyJsonData: dataBlock.
	
	jsonData := dataBlock llmJsonData.
	self assertObjectValueResultJsonDataKeys: jsonData.
	self assert: (jsonData at: 'objectDetails') isEmpty.
	
	objectValueJson := jsonData at: #objectValue.
	self assert: (objectValueJson at: 'objectClassName') equals: 'ByteString'.
	self assert: (objectValueJson at: 'superclassName') equals: 'String'.
	self assert: (objectValueJson at: 'packageName') equals: 'Collections-Strings'.
	self assert: (objectValueJson at: 'allInstanceSlots') isEmpty.
	self assertObjectValueJson: objectValueJson includesPhlowViews: #('gtPrintFor:' 'gtRawFor:' 'gtStringFor:').
	
	^ dataBlock
]

{ #category : #examples }
GtLObjectValueResultExamples >> objectValueResultForTestObject [
	<gtExample>
	<return: #GtLObjectValueResult>
	| testObject domainObject |
	
	testObject := GtLSerializedObjectValueTestObject exampleInstance.
	domainObject := GtLObjectValueResult forObject: testObject.
	
	self assert: domainObject object equals: testObject.
	self assert: domainObject objectValue class equals: GtLSerializedObjectValue.
	
	^ domainObject
]

{ #category : #'examples - views' }
GtLObjectValueResultExamples >> objectValueResultForTestObjectMainDataView [
	<gtExample>
	<return: #GtLCompositeDataView>
	| domainObject mainDataView forwardedView |
	
	domainObject := self objectValueResultForTestObject.
	mainDataView := domainObject llmDataViewsFor: GtLDataView new.
	
	self assertCompositeDataView: mainDataView hasTitle: 'Object views' viewsCount: 2.
	
	self assertCompositeView: mainDataView hasJsonForwardDataViewWithDataKey: 'objectDetails' targetObject:  domainObject object.
	
	forwardedView := (mainDataView dataViews 
		detect: [ :each | each class = GtLForwardObjectDataView ]) computeForwardedView.
	self assertCompositeDataView: forwardedView hasTitle: 'Object views' viewsCount: 0.
	
	"Second view is raw data (magritte)"
	self assertCompositeView: mainDataView hasMagritteDataViewWithDataKey: nil.
	
	^ mainDataView
]

{ #category : #'examples - serialization' }
GtLObjectValueResultExamples >> objectValueResultForTestObjectSerialization [
	<gtExample>
	<return: #GtLPrimitiveMessageDataBlock>
	| mainDataView dataBlock jsonData objectValueJson slotsJson |
	
	mainDataView := self objectValueResultForTestObjectMainDataView.
	dataBlock := mainDataView serializeToLlmPrimiteData.
	
	self assertDataBlockHasOnlyJsonData: dataBlock.
	
	jsonData := dataBlock llmJsonData.
	self assertObjectValueResultJsonDataKeys: jsonData.
	self assert: (jsonData at: 'objectDetails') equals: Dictionary new.
	
	objectValueJson := jsonData at: #objectValue.
	self assert: (objectValueJson at: 'objectClassName') equals: 'GtLSerializedObjectValueTestObject'.
	self assert: (objectValueJson at: 'superclassName') equals: 'Object'.
	self assert: (objectValueJson at: 'packageName') equals: 'Gt4LlmCore-Examples'.
	
	slotsJson := objectValueJson at: 'allInstanceSlots'.
	self assert: slotsJson size equals: 3.
	self assert: (slotsJson first at: 'name') equals: 'name'.
	self assert: (slotsJson first at: 'valueClassName') equals: 'ByteString'.
	self assert: (slotsJson first at: 'valuePrintString') equals: 'TestObject'.
	self assert: (slotsJson second at: 'name') equals: 'count'.
	self assert: (slotsJson second at: 'valuePrintString') equals: '42'.
	self assert: (slotsJson third at: 'name') equals: 'items'.
	self assert: (slotsJson third at: 'valueClassName') equals: 'Array'.
	
	self assertObjectValueJson: objectValueJson includesPhlowViews: #('gtDetailsFor:' 'gtItemsFor:' 'gtRawFor:' 'gtPrintFor:').
	
	^ dataBlock
]
