Class {
	#name : #GtLWrappedObjectModelExamples,
	#superclass : #GtLWrappedModelExamples,
	#category : #'Gt4LlmCore-Examples'
}

{ #category : #assertions }
GtLWrappedObjectModelExamples >> assertDataBlockHasOnlyJsonData: dataBlock [
	"Assert that the data block is valid and contains only JSON data (no images or secondary blocks)"
	self assert: dataBlock isNotNil.
	self assert: dataBlock class equals: GtLPrimitiveMessageDataBlock.
	self assert: dataBlock imageDataBlocks isEmpty.
	self assert: dataBlock secondaryDataBlocks isEmpty.
	self assert: dataBlock dataBlocks size equals: 1.
	self assert: dataBlock dataBlocks first == dataBlock compositeJsonDataBlock
]

{ #category : #'examples - support' }
GtLWrappedObjectModelExamples >> markdownObject [
	<gtExample>
	<return: #GtLMarkdown>
	| markdown |
	markdown := GtLMarkdown content: '# Test Content'.
	self assert: markdown content equals: '# Test Content'.
	^ markdown
]

{ #category : #'examples - support' }
GtLWrappedObjectModelExamples >> objectWithJsonView [
	<gtExample>
	<return: #GtLObjectWithJsonViewsForExamples>
	| testObject |
	testObject := GtLObjectWithJsonViewsForExamples new.
	testObject firstValue: 42.
	testObject firstJsonViewEnabled: true.
	testObject firstJsonViewDataKey: nil.
	testObject secondJsonViewEnabled: false.
	^ testObject
]

{ #category : #'examples - support' }
GtLWrappedObjectModelExamples >> objectWithTwoJsonViews [
	<gtExample>
	<return: #GtLObjectWithJsonViewsForExamples>
	| testObject |
	testObject := GtLObjectWithJsonViewsForExamples new.
	testObject firstValue: 42.
	testObject secondValue: 99.
	testObject firstJsonViewEnabled: true.
	testObject secondJsonViewEnabled: true.
	testObject firstJsonViewDataKey: 'firstKey'.
	testObject secondJsonViewDataKey: 'secondKey'.
	^ testObject
]

{ #category : #'examples - views' }
GtLWrappedObjectModelExamples >> wrappedObjectModelWithJsonViewMainDataView [
	<gtExample>
	<return: #GtLCompositeDataView>
	| wrappedObjectModel mainDataView forwardedView |
	wrappedObjectModel := self wrappedObjectModelWithObjectWithJsonView.
	mainDataView := wrappedObjectModel mainDataView.
	
	self assertCompositeDataView: mainDataView hasTitle: 'Object views' dataKey: 'testObject' viewsCount: 1.
	self assertForwardObjectDataView: mainDataView dataViews first hasTargetObject: wrappedObjectModel model.
	
	forwardedView := mainDataView dataViews first computeForwardedView.
	self assertCompositeDataView: forwardedView hasTitle: 'Object views' viewsCount: 2.
	self assertCompositeView: forwardedView hasJsonDataViewWithDataKey: nil.
	self assertCompositeView: forwardedView hasEmptyDataViewWithDataKey: nil.
	
	^ mainDataView
]

{ #category : #'examples - serialization' }
GtLWrappedObjectModelExamples >> wrappedObjectModelWithJsonViewSerialization [
	<gtExample>
	<return: #GtLPrimitiveMessageDataBlock>
	| mainDataView dataBlock jsonData expectedJsonData |
	mainDataView := self wrappedObjectModelWithJsonViewMainDataView.
	dataBlock := mainDataView serializeToLlmPrimiteData.
	
	self assertDataBlockHasOnlyJsonData: dataBlock.
	
	jsonData := dataBlock llmJsonData.
	expectedJsonData := Dictionary new
		at: 'testObject' put: (Dictionary new
			at: 'type' put: 'first';
			at: 'value' put: 42;
			yourself);
		yourself.
	self assert: jsonData equals: expectedJsonData.
	
	^ dataBlock
]

{ #category : #'examples - support' }
GtLWrappedObjectModelExamples >> wrappedObjectModelWithMarkdown [
	<gtExample>
	<return: #GtLWrappedObjectModel>
	| wrappedObjectModel |
	wrappedObjectModel := GtLWrappedObjectModel new.
	wrappedObjectModel name: 'testMarkdown'.
	wrappedObjectModel model: self markdownObject.
	
	self assert: wrappedObjectModel name equals: 'testMarkdown'.
	self assert: wrappedObjectModel model class equals: GtLMarkdown.
	self assert: wrappedObjectModel targetObject equals: wrappedObjectModel model.
	
	^ wrappedObjectModel
]

{ #category : #'examples - views' }
GtLWrappedObjectModelExamples >> wrappedObjectModelWithMarkdownMainDataView [
	<gtExample>
	<return: #GtLCompositeDataView>
	| wrappedObjectModel mainDataView forwardedView |
	wrappedObjectModel := self wrappedObjectModelWithMarkdown.
	mainDataView := wrappedObjectModel mainDataView.
	
	self assertCompositeDataView: mainDataView hasTitle: 'Object views' dataKey: 'testMarkdown' viewsCount: 1.
	self assertForwardObjectDataView: mainDataView dataViews first hasTargetObject: wrappedObjectModel model.
	
	forwardedView := mainDataView dataViews first computeForwardedView.
	self assertCompositeDataView: forwardedView hasTitle: 'Object views' viewsCount: 1.
	self assertCompositeView: forwardedView hasMagritteDataViewWithDataKey: nil.
	
	^ mainDataView
]

{ #category : #'examples - serialization' }
GtLWrappedObjectModelExamples >> wrappedObjectModelWithMarkdownSerialization [
	<gtExample>
	<return: #GtLPrimitiveMessageDataBlock>
	| mainDataView dataBlock jsonData expectedJsonData |
	mainDataView := self wrappedObjectModelWithMarkdownMainDataView.
	dataBlock := mainDataView serializeToLlmPrimiteData.
	
	self assertDataBlockHasOnlyJsonData: dataBlock.
	
	jsonData := dataBlock llmJsonData.
	expectedJsonData := Dictionary new
		at: 'testMarkdown' put: (Dictionary new
			at: #content put: '# Test Content';
			yourself);
		yourself.
	self assert: jsonData equals: expectedJsonData.
	
	^ dataBlock
]

{ #category : #'examples - support' }
GtLWrappedObjectModelExamples >> wrappedObjectModelWithObjectWithJsonView [
	<gtExample>
	<return: #GtLWrappedObjectModel>
	| wrappedObjectModel |
	wrappedObjectModel := GtLWrappedObjectModel new.
	wrappedObjectModel name: 'testObject'.
	wrappedObjectModel model: self objectWithJsonView.
	
	self assert: wrappedObjectModel name equals: 'testObject'.
	self assert: wrappedObjectModel model class equals: GtLObjectWithJsonViewsForExamples.
	self assert: wrappedObjectModel targetObject equals: wrappedObjectModel model.
	
	^ wrappedObjectModel
]

{ #category : #'examples - support' }
GtLWrappedObjectModelExamples >> wrappedObjectModelWithTwoJsonViews [
	<gtExample>
	<return: #GtLWrappedObjectModel>
	| wrappedObjectModel |
	wrappedObjectModel := GtLWrappedObjectModel new
		name: 'testTwoViews';
		model: self objectWithTwoJsonViews.
	
	self assert: wrappedObjectModel name equals: 'testTwoViews'.
	self assert: wrappedObjectModel model class equals: GtLObjectWithJsonViewsForExamples.
	
	^ wrappedObjectModel
]

{ #category : #'examples - views' }
GtLWrappedObjectModelExamples >> wrappedObjectModelWithTwoJsonViewsMainDataView [
	<gtExample>
	<return: #GtLCompositeDataView>
	| wrappedObjectModel mainDataView forwardedView |
	wrappedObjectModel := self wrappedObjectModelWithTwoJsonViews.
	mainDataView := wrappedObjectModel mainDataView.
	
	self assertCompositeDataView: mainDataView hasTitle: 'Object views' dataKey: 'testTwoViews' viewsCount: 1.
	self assertForwardObjectDataView: mainDataView dataViews first hasTargetObject: wrappedObjectModel model.
	
	forwardedView := mainDataView dataViews first computeForwardedView.
	self assertCompositeDataView: forwardedView hasTitle: 'Object views' viewsCount: 2.
	self assertCompositeView: forwardedView hasJsonDataViewWithDataKey: 'firstKey'.
	self assertCompositeView: forwardedView hasJsonDataViewWithDataKey: 'secondKey'.
	
	^ mainDataView
]

{ #category : #'examples - serialization' }
GtLWrappedObjectModelExamples >> wrappedObjectModelWithTwoJsonViewsSerialization [
	<gtExample>
	<return: #GtLPrimitiveMessageDataBlock>
	| mainDataView dataBlock jsonData innerData |
	mainDataView := self wrappedObjectModelWithTwoJsonViewsMainDataView.
	dataBlock := mainDataView serializeToLlmPrimiteData.
	
	self assertDataBlockHasOnlyJsonData: dataBlock.
	
	jsonData := dataBlock llmJsonData.
	self assert: jsonData keys asSet equals: #('testTwoViews') asSet.
	
	innerData := jsonData at: 'testTwoViews'.
	self assert: innerData keys asSet equals: #('firstKey' 'secondKey') asSet.
	self assert: (innerData at: 'firstKey') equals: (NeoJSONObject new
		at: 'type' put: 'first';
		at: 'value' put: 42;
		yourself).
	self assert: (innerData at: 'secondKey') equals: (NeoJSONObject new
		at: 'type' put: 'second';
		at: 'value' put: 99;
		yourself).
	
	^ dataBlock
]
