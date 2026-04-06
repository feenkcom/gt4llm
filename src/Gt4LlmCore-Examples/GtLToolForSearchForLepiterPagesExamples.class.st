Class {
	#name : #GtLToolForSearchForLepiterPagesExamples,
	#superclass : #Object,
	#traits : 'TGtLInvalidInputDataAssertions',
	#classTraits : 'TGtLInvalidInputDataAssertions classTrait',
	#category : #'Gt4LlmCore-Examples-Tools'
}

{ #category : #examples }
GtLToolForSearchForLepiterPagesExamples >> documentationLookupDataViewSerialization [
	<gtExample>
	<return: #GtLPrimitiveMessageDataBlock>
	| domainObject compositeView dataBlock jsonData pagesData |
	domainObject := self documentationLookupForExistingPage.
	compositeView := domainObject llmDataViewsFor: GtLDataView new.
	self assert: compositeView dataViews size equals: 1.
	
	dataBlock := compositeView serializeToLlmPrimiteData.
	self assert: dataBlock isNotNil.
	self assert: dataBlock dataBlocks size equals: 1.
	self assert: dataBlock imageDataBlocks isEmpty.
	
	jsonData := dataBlock compositeJsonData.
	self assert: (jsonData at: #pages) isNotEmpty.
	pagesData := jsonData at: #pages.
	self assert: ((pagesData first at: #pageTitle) includesSubstring: 'Warmup: understanding the Money classes').
	self assert: (pagesData first includesKey: #pageUid).
	self assert: (pagesData first includesKey: #databaseId).
	
	^ dataBlock
]

{ #category : #examples }
GtLToolForSearchForLepiterPagesExamples >> documentationLookupForExistingPage [
	<gtExample>
	| tool call result domainObject |
	tool := GtLToolForSearchForLepiterPages new.
	call := GtLFunctionToolCall new.
	call rawArguments: {
		'query' -> 'Warmup: understanding the Money classes'.
		'knowledgeBases' -> { LeDatabase gtBook uuidString }
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	domainObject := result targetObject.
	self assert: (domainObject isKindOf: GtLLepiterPagesDomainObject).
	self assert: domainObject pages size equals: 1.
	^ domainObject
]

{ #category : #examples }
GtLToolForSearchForLepiterPagesExamples >> documentationLookupForMissingPage [
	<gtExample>
	| tool call result domainObject |
	tool := GtLToolForSearchForLepiterPages new.
	call := GtLFunctionToolCall new.
	call rawArguments: {
		'query' -> 'NonExistingDocumentationPage42'.
		'knowledgeBases' -> { LeDatabase gtBook uuidString }
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	domainObject := result targetObject.
	self assert: (domainObject isKindOf: GtLLepiterPagesDomainObject).
	self assert: domainObject pages equals: #().
	^ domainObject
]

{ #category : #examples }
GtLToolForSearchForLepiterPagesExamples >> documentationLookupForMultipleKnowledgeBases [
	<gtExample>
	| tool call result domainObject logicalDatabase defaultDatabase |
	tool := GtLToolForSearchForLepiterPages new.
	logicalDatabase := LeDatabasesRegistry defaultLogicalDatabase.
	defaultDatabase := logicalDatabase databases
		detect: [ :each | each databaseName = 'default' ]
		ifNone: [ LeDatabase gtBook ].
	call := GtLFunctionToolCall new.
	call rawArguments: {
		'query' -> 'Warmup: understanding the Money classes'.
		'knowledgeBases' -> {
			defaultDatabase uuidString.
			LeDatabase gtBook uuidString
		}
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	domainObject := result targetObject.
	self assert: (domainObject isKindOf: GtLLepiterPagesDomainObject).
	self assert: domainObject pages isNotEmpty.
	^ domainObject
]

{ #category : #examples }
GtLToolForSearchForLepiterPagesExamples >> documentationLookupForWrongKnowledgeBaseId [
	<gtExample>
	| tool call result domainObject |
	tool := GtLToolForSearchForLepiterPages new.
	call := GtLFunctionToolCall new.
	call rawArguments: {
		'query' -> 'Warmup: understanding the Money classes'.
		'knowledgeBases' -> { 'missing-uuid-42' }
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	domainObject := result targetObject.
	self 
		assertMissingObject: domainObject 
		withObjectName: 'missing-uuid-42' 
		errorMessage: 'missing-uuid-42 is not found'.
	^ domainObject
]
