"
Examples for GtLJsonData testing serialization and data views.
"
Class {
	#name : #GtLJsonDataExamples,
	#superclass : #GtLDomainObjectExamples,
	#category : 'Gt4LlmCore-Examples-Domain Objects'
}

{ #category : #'examples - basic' }
GtLJsonDataExamples >> jsonDataWithArray [
	<gtExample>
	<return: #GtLJsonData>
	| jsonData value |
	
	value := {'one'. 'two'. 'three'}.
	jsonData := GtLJsonData forString: value.
	
	self assert: jsonData jsonValue equals: value.
	
	^ jsonData
]

{ #category : #'examples - views' }
GtLJsonDataExamples >> jsonDataWithArrayMainDataView [
	<gtExample>
	<return: #GtLCompositeDataView>
	| jsonData mainDataView |
	
	jsonData := self jsonDataWithArray.
	mainDataView := jsonData llmDataViewsFor: GtLDataView new.
	
	self assertCompositeDataView: mainDataView hasTitle: 'Object views' viewsCount: 1.
	self assertCompositeView: mainDataView hasJsonDataViewWithDataKey: nil.
	
	^ mainDataView
]

{ #category : #'examples - serialization' }
GtLJsonDataExamples >> jsonDataWithArraySerialization [
	<gtExample>
	<return: #GtLPrimitiveMessageDataBlock>
	| mainDataView dataBlock jsonData expectedValue |
	
	mainDataView := self jsonDataWithArrayMainDataView.
	dataBlock := mainDataView serializeToLlmPrimiteData.
	
	self assertDataBlockHasOnlyJsonData: dataBlock.
	
	expectedValue := {'one'. 'two'. 'three'}.
	jsonData := dataBlock llmJsonData.
	self assert: jsonData asArray asSet equals: expectedValue asSet.
	
	^ dataBlock
]

{ #category : #'examples - basic' }
GtLJsonDataExamples >> jsonDataWithEmptyObject [
	<gtExample>
	<return: #GtLJsonData>
	| jsonData |
	
	jsonData := GtLJsonData forString: Dictionary new.
	
	self assert: jsonData jsonValue equals: Dictionary new.
	
	^ jsonData
]

{ #category : #'examples - views' }
GtLJsonDataExamples >> jsonDataWithEmptyObjectMainDataView [
	<gtExample>
	<return: #GtLCompositeDataView>
	| jsonData mainDataView |
	
	jsonData := self jsonDataWithEmptyObject.
	mainDataView := jsonData llmDataViewsFor: GtLDataView new.
	
	self assertCompositeDataView: mainDataView hasTitle: 'Object views' viewsCount: 1.
	self assertCompositeView: mainDataView hasJsonDataViewWithDataKey: nil.
	
	^ mainDataView
]

{ #category : #'examples - serialization' }
GtLJsonDataExamples >> jsonDataWithEmptyObjectSerialization [
	<gtExample>
	<return: #GtLPrimitiveMessageDataBlock>
	| mainDataView dataBlock jsonData |
	
	mainDataView := self jsonDataWithEmptyObjectMainDataView.
	dataBlock := mainDataView serializeToLlmPrimiteData.
	
	self assertDataBlockHasOnlyJsonData: dataBlock.
	
	jsonData := dataBlock llmJsonData.
	self assert: jsonData equals: Dictionary new.
	
	^ dataBlock
]

{ #category : #'examples - basic' }
GtLJsonDataExamples >> jsonDataWithSimpleObject [
	<gtExample>
	<return: #GtLJsonData>
	| jsonData value |
	
	value := {'name' -> 'test'. 'count' -> 42} asDictionary.
	jsonData := GtLJsonData forString: value.
	
	self assert: jsonData jsonValue equals: value.
	
	^ jsonData
]

{ #category : #'examples - views' }
GtLJsonDataExamples >> jsonDataWithSimpleObjectMainDataView [
	<gtExample>
	<return: #GtLCompositeDataView>
	| jsonData mainDataView |
	
	jsonData := self jsonDataWithSimpleObject.
	mainDataView := jsonData llmDataViewsFor: GtLDataView new.
	
	self assertCompositeDataView: mainDataView hasTitle: 'Object views' viewsCount: 1.
	self assertCompositeView: mainDataView hasJsonDataViewWithDataKey: nil.
	
	^ mainDataView
]

{ #category : #'examples - serialization' }
GtLJsonDataExamples >> jsonDataWithSimpleObjectSerialization [
	<gtExample>
	<return: #GtLPrimitiveMessageDataBlock>
	| mainDataView dataBlock jsonData expectedValue |
	
	mainDataView := self jsonDataWithSimpleObjectMainDataView.
	dataBlock := mainDataView serializeToLlmPrimiteData.
	
	self assertDataBlockHasOnlyJsonData: dataBlock.
	
	expectedValue := {'name' -> 'test'. 'count' -> 42} asDictionary.
	jsonData := dataBlock llmJsonData.
	self assert: jsonData equals: expectedValue.
	
	^ dataBlock
]
