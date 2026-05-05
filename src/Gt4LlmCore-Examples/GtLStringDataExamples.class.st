"
Examples for GtLPlainString testing serialization and data views.
"
Class {
	#name : #GtLStringDataExamples,
	#superclass : #GtLDomainObjectExamples,
	#category : #'Gt4LlmCore-Examples-Domain Objects'
}

{ #category : #examples }
GtLStringDataExamples >> plainStringWithEmptyString [
	<gtExample>
	<return: #GtLString>
	| plainString |
	
	plainString := GtLString forString: ''.
	
	self assert: plainString stringValue equals: ''.
	self assert: plainString printString equals: ''''''.
	
	^ plainString
]

{ #category : #'examples - views' }
GtLStringDataExamples >> plainStringWithEmptyStringMainDataView [
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
GtLStringDataExamples >> plainStringWithEmptyStringSerialization [
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
GtLStringDataExamples >> plainStringWithMultilineText [
	<gtExample>
	<return: #GtLString>
	| plainString text |
	
	text := 'First line
Second line
Third line'.
	plainString := GtLString forString: text.
	
	self assert: plainString stringValue equals: text.
	
	^ plainString
]

{ #category : #'examples - views' }
GtLStringDataExamples >> plainStringWithMultilineTextMainDataView [
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
GtLStringDataExamples >> plainStringWithMultilineTextSerialization [
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
GtLStringDataExamples >> plainStringWithSimpleText [
	<gtExample>
	<return: #GtLString>
	| plainString |
	
	plainString := GtLString forString: 'hello world'.
	
	self assert: plainString stringValue equals: 'hello world'.
	self assert: plainString printString equals: '''hello world'''.
	
	^ plainString
]

{ #category : #'examples - views' }
GtLStringDataExamples >> plainStringWithSimpleTextMainDataView [
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
GtLStringDataExamples >> plainStringWithSimpleTextSerialization [
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
