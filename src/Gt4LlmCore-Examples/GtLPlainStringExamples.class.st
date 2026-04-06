"
Examples for GtLPlainString testing serialization and data views.
"
Class {
	#name : #GtLPlainStringExamples,
	#superclass : #GtLObjectExamples,
	#category : 'Gt4LlmCore-Examples-Domain Objects'
}

{ #category : #examples }
GtLPlainStringExamples >> plainStringWithEmptyString [
	<gtExample>
	<return: #GtLPlainString>
	| plainString |
	
	plainString := GtLPlainString forString: ''.
	
	self assert: plainString string equals: ''.
	self assert: plainString printString equals: ''''''.
	
	^ plainString
]

{ #category : #'examples - views' }
GtLPlainStringExamples >> plainStringWithEmptyStringMainDataView [
	<gtExample>
	<return: #GtLCompositeDataView>
	| plainString mainDataView |
	
	plainString := self plainStringWithEmptyString.
	mainDataView := plainString llmDataViewsFor: GtLDataView new.
	
	self assertCompositeDataView: mainDataView hasTitle: 'Object views' viewsCount: 1.
	self assertCompositeView: mainDataView hasJsonDataViewWithDataKey: nil.
	
	^ mainDataView
]

{ #category : #'examples - serialization' }
GtLPlainStringExamples >> plainStringWithEmptyStringSerialization [
	<gtExample>
	<return: #GtLPrimitiveMessageDataBlock>
	| mainDataView dataBlock jsonData |
	
	mainDataView := self plainStringWithEmptyStringMainDataView.
	dataBlock := mainDataView serializeToLlmPrimiteData.
	
	self assertDataBlockHasOnlyJsonData: dataBlock.
	
	jsonData := dataBlock llmJsonData.
	self assert: jsonData equals: ''.
	
	^ dataBlock
]

{ #category : #examples }
GtLPlainStringExamples >> plainStringWithMultilineText [
	<gtExample>
	<return: #GtLPlainString>
	| plainString text |
	
	text := 'First line
Second line
Third line'.
	plainString := GtLPlainString forString: text.
	
	self assert: plainString string equals: text.
	
	^ plainString
]

{ #category : #'examples - views' }
GtLPlainStringExamples >> plainStringWithMultilineTextMainDataView [
	<gtExample>
	<return: #GtLCompositeDataView>
	| plainString mainDataView |
	
	plainString := self plainStringWithMultilineText.
	mainDataView := plainString llmDataViewsFor: GtLDataView new.
	
	self assertCompositeDataView: mainDataView hasTitle: 'Object views' viewsCount: 1.
	self assertCompositeView: mainDataView hasJsonDataViewWithDataKey: nil.
	
	^ mainDataView
]

{ #category : #'examples - serialization' }
GtLPlainStringExamples >> plainStringWithMultilineTextSerialization [
	<gtExample>
	<return: #GtLPrimitiveMessageDataBlock>
	| mainDataView dataBlock jsonData expectedText |
	
	mainDataView := self plainStringWithMultilineTextMainDataView.
	dataBlock := mainDataView serializeToLlmPrimiteData.
	
	self assertDataBlockHasOnlyJsonData: dataBlock.
	
	expectedText := 'First line
Second line
Third line'.
	jsonData := dataBlock llmJsonData.
	self assert: jsonData equals: expectedText.
	
	^ dataBlock
]

{ #category : #examples }
GtLPlainStringExamples >> plainStringWithSimpleText [
	<gtExample>
	<return: #GtLPlainString>
	| plainString |
	
	plainString := GtLPlainString forString: 'hello world'.
	
	self assert: plainString string equals: 'hello world'.
	self assert: plainString printString equals: '''hello world'''.
	
	^ plainString
]

{ #category : #'examples - views' }
GtLPlainStringExamples >> plainStringWithSimpleTextMainDataView [
	<gtExample>
	<return: #GtLCompositeDataView>
	| plainString mainDataView |
	
	plainString := self plainStringWithSimpleText.
	mainDataView := plainString llmDataViewsFor: GtLDataView new.
	
	self assertCompositeDataView: mainDataView hasTitle: 'Object views' viewsCount: 1.
	self assertCompositeView: mainDataView hasJsonDataViewWithDataKey: nil.
	
	^ mainDataView
]

{ #category : #'examples - serialization' }
GtLPlainStringExamples >> plainStringWithSimpleTextSerialization [
	<gtExample>
	<return: #GtLPrimitiveMessageDataBlock>
	| mainDataView dataBlock jsonData |
	
	mainDataView := self plainStringWithSimpleTextMainDataView.
	dataBlock := mainDataView serializeToLlmPrimiteData.
	
	self assertDataBlockHasOnlyJsonData: dataBlock.
	
	jsonData := dataBlock llmJsonData.
	self assert: jsonData equals: 'hello world'.
	
	^ dataBlock
]
