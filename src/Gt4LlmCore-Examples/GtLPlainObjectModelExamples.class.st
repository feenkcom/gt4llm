Class {
	#name : #GtLPlainObjectModelExamples,
	#superclass : #GtLWrappedModelExamples,
	#category : #'Gt4LlmCore-Examples'
}

{ #category : #assertions }
GtLPlainObjectModelExamples >> assertDataBlockHasOnlyJsonData: dataBlock [
	"Assert that the data block is valid and contains only JSON data (no images or secondary blocks)"
	self assert: dataBlock isNotNil.
	self assert: dataBlock class equals: GtLPrimitiveMessageDataBlock.
	self assert: dataBlock imageDataBlocks isEmpty.
	self assert: dataBlock secondaryDataBlocks isEmpty.
	self assert: dataBlock dataBlocks size equals: 1.
	self assert: dataBlock dataBlocks first == dataBlock compositeJsonDataBlock
]

{ #category : #'examples - support' }
GtLPlainObjectModelExamples >> markdownObject [
	<gtExample>
	<return: #GtLMarkdown>
	| markdown |
	markdown := GtLMarkdown content: '# Test Content'.
	self assert: markdown content equals: '# Test Content'.
	^ markdown
]

{ #category : #'examples - support' }
GtLPlainObjectModelExamples >> objectWithJsonView [
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
GtLPlainObjectModelExamples >> objectWithTwoJsonViews [
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

{ #category : #examples }
GtLPlainObjectModelExamples >> plainObjectModelWithJsonViewMainDataView [
	<gtExample>
	<return: #GtLCompositeDataView>
	| plainObjectModel mainDataView forwardedView |
	plainObjectModel := self plainObjectModelWithObjectWithJsonView.
	mainDataView := plainObjectModel mainDataView.
	
	self assertCompositeDataView: mainDataView hasTitle: 'Object views' dataKey: 'testObject' viewsCount: 1.
	self assertForwardObjectDataView: mainDataView dataViews first hasTargetObject: plainObjectModel model.
	
	forwardedView := mainDataView dataViews first computeForwardedView.
	self assertCompositeDataView: forwardedView hasTitle: 'Object views' viewsCount: 2.
	self assertCompositeView: forwardedView hasJsonDataViewWithDataKey: nil.
	self assertCompositeView: forwardedView hasEmptyDataViewWithDataKey: nil.
	
	^ mainDataView
]

{ #category : #'examples - serialization' }
GtLPlainObjectModelExamples >> plainObjectModelWithJsonViewSerialization [
	<gtExample>
	<return: #GtLPrimitiveMessageDataBlock>
	| mainDataView dataBlock jsonData expectedJsonData |
	mainDataView := self plainObjectModelWithJsonViewMainDataView.
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

{ #category : #examples }
GtLPlainObjectModelExamples >> plainObjectModelWithMarkdown [
	<gtExample>
	<return: #GtLPlainObjectModel>
	| plainObjectModel |
	plainObjectModel := GtLPlainObjectModel new.
	plainObjectModel name: 'testMarkdown'.
	plainObjectModel model: self markdownObject.
	
	self assert: plainObjectModel name equals: 'testMarkdown'.
	self assert: plainObjectModel model class equals: GtLMarkdown.
	self assert: plainObjectModel targetObject equals: plainObjectModel model.
	
	^ plainObjectModel
]

{ #category : #examples }
GtLPlainObjectModelExamples >> plainObjectModelWithMarkdownMainDataView [
	<gtExample>
	<return: #GtLCompositeDataView>
	| plainObjectModel mainDataView forwardedView |
	plainObjectModel := self plainObjectModelWithMarkdown.
	mainDataView := plainObjectModel mainDataView.
	
	self assertCompositeDataView: mainDataView hasTitle: 'Object views' dataKey: 'testMarkdown' viewsCount: 1.
	self assertForwardObjectDataView: mainDataView dataViews first hasTargetObject: plainObjectModel model.
	
	forwardedView := mainDataView dataViews first computeForwardedView.
	self assertCompositeDataView: forwardedView hasTitle: 'Object views' viewsCount: 1.
	self assertCompositeView: forwardedView hasMagritteDataViewWithDataKey: nil.
	
	^ mainDataView
]

{ #category : #'examples - serialization' }
GtLPlainObjectModelExamples >> plainObjectModelWithMarkdownSerialization [
	<gtExample>
	<return: #GtLPrimitiveMessageDataBlock>
	| mainDataView dataBlock jsonData expectedJsonData |
	mainDataView := self plainObjectModelWithMarkdownMainDataView.
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

{ #category : #examples }
GtLPlainObjectModelExamples >> plainObjectModelWithObjectWithJsonView [
	<gtExample>
	<return: #GtLPlainObjectModel>
	| plainObjectModel |
	plainObjectModel := GtLPlainObjectModel new.
	plainObjectModel name: 'testObject'.
	plainObjectModel model: self objectWithJsonView.
	
	self assert: plainObjectModel name equals: 'testObject'.
	self assert: plainObjectModel model class equals: GtLObjectWithJsonViewsForExamples.
	self assert: plainObjectModel targetObject equals: plainObjectModel model.
	
	^ plainObjectModel
]

{ #category : #'examples - support' }
GtLPlainObjectModelExamples >> plainObjectModelWithTwoJsonViews [
	<gtExample>
	<return: #GtLPlainObjectModel>
	| plainObjectModel |
	plainObjectModel := GtLPlainObjectModel new
		name: 'testTwoViews';
		model: self objectWithTwoJsonViews.
	
	self assert: plainObjectModel name equals: 'testTwoViews'.
	self assert: plainObjectModel model class equals: GtLObjectWithJsonViewsForExamples.
	
	^ plainObjectModel
]

{ #category : #'examples - views' }
GtLPlainObjectModelExamples >> plainObjectModelWithTwoJsonViewsMainDataView [
	<gtExample>
	<return: #GtLCompositeDataView>
	| plainObjectModel mainDataView forwardedView |
	plainObjectModel := self plainObjectModelWithTwoJsonViews.
	mainDataView := plainObjectModel mainDataView.
	
	self assertCompositeDataView: mainDataView hasTitle: 'Object views' dataKey: 'testTwoViews' viewsCount: 1.
	self assertForwardObjectDataView: mainDataView dataViews first hasTargetObject: plainObjectModel model.
	
	forwardedView := mainDataView dataViews first computeForwardedView.
	self assertCompositeDataView: forwardedView hasTitle: 'Object views' viewsCount: 2.
	self assertCompositeView: forwardedView hasJsonDataViewWithDataKey: 'firstKey'.
	self assertCompositeView: forwardedView hasJsonDataViewWithDataKey: 'secondKey'.
	
	^ mainDataView
]

{ #category : #'examples - serialization' }
GtLPlainObjectModelExamples >> plainObjectModelWithTwoJsonViewsSerialization [
	<gtExample>
	<return: #GtLPrimitiveMessageDataBlock>
	| mainDataView dataBlock jsonData innerData |
	mainDataView := self plainObjectModelWithTwoJsonViewsMainDataView.
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
