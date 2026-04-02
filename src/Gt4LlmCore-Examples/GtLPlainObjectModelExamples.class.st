Class {
	#name : #GtLPlainObjectModelExamples,
	#superclass : #GtLWrappedModelExamples,
	#category : #'Gt4LlmCore-Examples'
}

{ #category : #assertions }
GtLPlainObjectModelExamples >> assertCompositeDataView: aDataView hasTitle: aTitle dataKey: aDataKey viewsCount: aCount [
	"Assert that the data view is a composite view with the expected title, data key and number of contained views"
	self assert: aDataView class equals: GtLCompositeDataView.
	self assert: aDataView title equals: aTitle.
	self assert: aDataView dataKey equals: aDataKey.
	self assert: aDataView dataViews size equals: aCount
]

{ #category : #assertions }
GtLPlainObjectModelExamples >> assertCompositeDataView: aDataView hasTitle: aTitle viewsCount: aCount [
	"Assert that the data view is a composite view with the expected title, nil data key and number of contained views"
	self assertCompositeDataView: aDataView hasTitle: aTitle dataKey: nil viewsCount: aCount
]

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

{ #category : #assertions }
GtLPlainObjectModelExamples >> assertForwardObjectDataView: aDataView hasDataKey: aDataKey targetObject: anObject [
	"Assert that the data view is a forward object data view with the expected data key, target object and default view symbol"
	self assertForwardObjectDataView: aDataView hasDataKey: aDataKey targetObject: anObject viewSymbol: #llmDataViewsFor:
]

{ #category : #assertions }
GtLPlainObjectModelExamples >> assertForwardObjectDataView: aDataView hasDataKey: aDataKey targetObject: anObject viewSymbol: aSymbol [
	"Assert that the data view is a forward object data view with the expected data key, target object and view symbol"
	self assert: aDataView class equals: GtLForwardObjectDataView.
	self assert: aDataView dataKey equals: aDataKey.
	self assert: aDataView targetObject equals: anObject.
	self assert: aDataView viewSymbol equals: aSymbol
]

{ #category : #assertions }
GtLPlainObjectModelExamples >> assertForwardObjectDataView: aDataView hasTargetObject: anObject [
	"Assert that the data view is a forward object data view with no data key and the expected target object"
	self assertForwardObjectDataView: aDataView hasDataKey: nil targetObject: anObject
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

{ #category : #'examples - views' }
GtLPlainObjectModelExamples >> plainObjectModelWithJsonViewMainDataView [
	<gtExample>
	<return: #GtLCompositeDataView>
	| plainObjectModel mainDataView |
	plainObjectModel := self plainObjectModelWithObjectWithJsonView.
	mainDataView := plainObjectModel mainDataView.
	
	self assertCompositeDataView: mainDataView hasTitle: 'Object views' dataKey: 'testObject' viewsCount: 1.
	self assertForwardObjectDataView: mainDataView dataViews first hasTargetObject: plainObjectModel model.
	self assertCompositeDataView: mainDataView dataViews first computeForwardedView hasTitle: 'Object views' viewsCount: 2.
	
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

{ #category : #'examples - views' }
GtLPlainObjectModelExamples >> plainObjectModelWithMarkdownMainDataView [
	<gtExample>
	<return: #GtLCompositeDataView>
	| plainObjectModel mainDataView |
	plainObjectModel := self plainObjectModelWithMarkdown.
	mainDataView := plainObjectModel mainDataView.
	
	self assertCompositeDataView: mainDataView hasTitle: 'Object views' dataKey: 'testMarkdown' viewsCount: 1.
	self assertForwardObjectDataView: mainDataView dataViews first hasTargetObject: plainObjectModel model.
	self assertCompositeDataView: mainDataView dataViews first computeForwardedView hasTitle: 'Object views' viewsCount: 1.
	
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
