"
Examples for GtLLepiterPage testing serialization and data views.
"
Class {
	#name : #GtLLepiterPageExamples,
	#superclass : #GtLObjectExamples,
	#category : #'Gt4LlmCore-Examples-Domain Objects'
}

{ #category : #'examples - pages' }
GtLLepiterPageExamples >> emptyUnnamedPage [
	<gtExample>
	<return: #LePage>
	| page |
	
	page := LePage unnamedPage.
	
	self assert: page isUnnamedPage.
	
	^ page
]

{ #category : #examples }
GtLLepiterPageExamples >> lepiterPageWithEmptyPage [
	<gtExample>
	<return: #GtLLepiterPage>
	| page lepiterPage |
	
	page := self emptyUnnamedPage.
	lepiterPage := GtLLepiterPage forPage: page.
	
	self assert: lepiterPage targetPage equals: page.
	self assert: lepiterPage targetPage isUnnamedPage.
	
	^ lepiterPage
]

{ #category : #'examples - views' }
GtLLepiterPageExamples >> lepiterPageWithEmptyPageMainDataView [
	<gtExample>
	<return: #GtLCompositeDataView>
	| lepiterPage mainDataView |
	
	lepiterPage := self lepiterPageWithEmptyPage.
	mainDataView := lepiterPage llmDataViewsFor: GtLDataView new.
	
	self assertCompositeDataView: mainDataView hasTitle: 'Object views' viewsCount: 1.
	self assertCompositeView: mainDataView hasJsonDataViewWithDataKey: nil.
	
	^ mainDataView
]

{ #category : #'examples - serialization' }
GtLLepiterPageExamples >> lepiterPageWithEmptyPageSerialization [
	<gtExample>
	<return: #GtLPrimitiveMessageDataBlock>
	| mainDataView dataBlock jsonData children |
	
	mainDataView := self lepiterPageWithEmptyPageMainDataView.
	dataBlock := mainDataView serializeToLlmPrimiteData.
	
	self assertDataBlockHasOnlyJsonData: dataBlock.
	
	jsonData := dataBlock llmJsonData.
	self assert: jsonData isDictionary.
	self assert: (jsonData at: '__type') equals: 'page'.
	
	children := jsonData at: 'children'.
	self assert: (children at: 'items') isEmpty.
	
	^ dataBlock
]

{ #category : #examples }
GtLLepiterPageExamples >> lepiterPageWithSimplePage [
	<gtExample>
	<return: #GtLLepiterPage>
	| page lepiterPage |
	
	page := self simpleNamedPage.
	lepiterPage := GtLLepiterPage forPage: page.
	
	self assert: lepiterPage targetPage equals: page.
	self assert: lepiterPage targetPage title equals: 'Test Page for Examples'.
	
	^ lepiterPage
]

{ #category : #'examples - views' }
GtLLepiterPageExamples >> lepiterPageWithSimplePageMainDataView [
	<gtExample>
	<return: #GtLCompositeDataView>
	| lepiterPage mainDataView |
	
	lepiterPage := self lepiterPageWithSimplePage.
	mainDataView := lepiterPage llmDataViewsFor: GtLDataView new.
	
	self assertCompositeDataView: mainDataView hasTitle: 'Object views' viewsCount: 1.
	self assertCompositeView: mainDataView hasJsonDataViewWithDataKey: nil.
	
	^ mainDataView
]

{ #category : #'examples - serialization' }
GtLLepiterPageExamples >> lepiterPageWithSimplePageSerialization [
	<gtExample>
	<return: #GtLPrimitiveMessageDataBlock>
	| mainDataView dataBlock jsonData |
	
	mainDataView := self lepiterPageWithSimplePageMainDataView.
	dataBlock := mainDataView serializeToLlmPrimiteData.
	
	self assertDataBlockHasOnlyJsonData: dataBlock.
	
	jsonData := dataBlock llmJsonData.
	self assert: jsonData isDictionary.
	self assert: (jsonData at: '__type') equals: 'page'.
	self assert: (jsonData at: 'pageType' ifAbsent: [ nil ]) isNotNil.
	self assert: (jsonData at: 'uid') isNotNil.
	
	^ dataBlock
]

{ #category : #examples }
GtLLepiterPageExamples >> lepiterPageWithTextSnippet [
	<gtExample>
	<return: #GtLLepiterPage>
	| page lepiterPage |
	
	page := self pageWithTextSnippet.
	lepiterPage := GtLLepiterPage forPage: page.
	
	self assert: lepiterPage targetPage equals: page.
	self assert: lepiterPage targetPage children size equals: 1.
	
	^ lepiterPage
]

{ #category : #'examples - views' }
GtLLepiterPageExamples >> lepiterPageWithTextSnippetMainDataView [
	<gtExample>
	<return: #GtLCompositeDataView>
	| lepiterPage mainDataView |
	
	lepiterPage := self lepiterPageWithTextSnippet.
	mainDataView := lepiterPage llmDataViewsFor: GtLDataView new.
	
	self assertCompositeDataView: mainDataView hasTitle: 'Object views' viewsCount: 1.
	self assertCompositeView: mainDataView hasJsonDataViewWithDataKey: nil.
	
	^ mainDataView
]

{ #category : #'examples - serialization' }
GtLLepiterPageExamples >> lepiterPageWithTextSnippetSerialization [
	<gtExample>
	<return: #GtLPrimitiveMessageDataBlock>
	| mainDataView dataBlock jsonData children items |
	
	mainDataView := self lepiterPageWithTextSnippetMainDataView.
	dataBlock := mainDataView serializeToLlmPrimiteData.
	
	self assertDataBlockHasOnlyJsonData: dataBlock.
	
	jsonData := dataBlock llmJsonData.
	self assert: jsonData isDictionary.
	self assert: (jsonData at: '__type') equals: 'page'.
	
	children := jsonData at: 'children'.
	items := children at: 'items'.
	self assert: items size equals: 1.
	self assert: (items first at: 'string') equals: 'This is a text snippet.'.
	
	^ dataBlock
]

{ #category : #'examples - pages' }
GtLLepiterPageExamples >> pageWithTextSnippet [
	<gtExample>
	<return: #LePage>
	| page |
	
	page := LePage named: 'Page With Snippet'.
	page addSnippet: (LeTextSnippet string: 'This is a text snippet.').
	
	self assert: page title equals: 'Page With Snippet'.
	self assert: page children size equals: 1.
	self assert: page children first string equals: 'This is a text snippet.'.
	
	^ page
]

{ #category : #'examples - pages' }
GtLLepiterPageExamples >> simpleNamedPage [
	<gtExample>
	<return: #LePage>
	| page |
	
	page := LePage named: 'Test Page for Examples'.
	
	self assert: page title equals: 'Test Page for Examples'.
	self assert: page isNamedPage.
	
	^ page
]
