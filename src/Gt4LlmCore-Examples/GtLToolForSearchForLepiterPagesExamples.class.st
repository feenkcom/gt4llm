Class {
	#name : #GtLToolForSearchForLepiterPagesExamples,
	#superclass : #GtLAbstractMagritteFunctionToolExamples,
	#category : 'Gt4LlmCore-Examples-Tools'
}

{ #category : #examples }
GtLToolForSearchForLepiterPagesExamples >> documentationLookupDataViewSerialization [
	<gtExample>
	<return: #GtLPrimitiveMessageDataBlock>
	| call domainObject compositeView dataBlock jsonData pagesData |
	call := self documentationLookupForExistingPage.
	domainObject := call result targetObject.
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
	| call targetObject |
	
	call := self
		executeTool: GtLToolForSearchForLepiterPages new
		withArguments: {
			'query' -> 'Warmup: understanding the Money classes'.
			'knowledgeBases' -> { LeDatabase gtBook uuidString }
		} asDictionary.
	targetObject := call result targetObject.
	
	self assert: (targetObject isKindOf: GtLLepiterPagesDomainObject).
	self assert: targetObject pages size equals: 1.
	
	^ call
]

{ #category : #examples }
GtLToolForSearchForLepiterPagesExamples >> documentationLookupForMissingPage [
	<gtExample>
	| call targetObject |
	
	call := self
		executeTool: GtLToolForSearchForLepiterPages new
		withArguments: {
			'query' -> 'NonExistingDocumentationPage42'.
			'knowledgeBases' -> { LeDatabase gtBook uuidString }
		} asDictionary.
	targetObject := call result targetObject.
	
	self assert: (targetObject isKindOf: GtLLepiterPagesDomainObject).
	self assert: targetObject pages equals: #().
	
	^ call
]

{ #category : #examples }
GtLToolForSearchForLepiterPagesExamples >> documentationLookupForMultipleKnowledgeBases [
	<gtExample>
	| call targetObject logicalDatabase defaultDatabase |
	logicalDatabase := LeDatabasesRegistry defaultLogicalDatabase.
	defaultDatabase := logicalDatabase databases
		detect: [ :each | each databaseName = 'default' ]
		ifNone: [ LeDatabase gtBook ].
	
	call := self
		executeTool: GtLToolForSearchForLepiterPages new
		withArguments: {
			'query' -> 'Warmup: understanding the Money classes'.
			'knowledgeBases' -> {
				defaultDatabase uuidString.
				LeDatabase gtBook uuidString
			}
		} asDictionary.
	targetObject := call result targetObject.
	
	self assert: (targetObject isKindOf: GtLLepiterPagesDomainObject).
	self assert: targetObject pages isNotEmpty.
	
	^ call
]

{ #category : #examples }
GtLToolForSearchForLepiterPagesExamples >> documentationLookupForWrongKnowledgeBaseId [
	<gtExample>
	| call |
	call := self
		executeTool: GtLToolForSearchForLepiterPages new
		withArguments: {
			'query' -> 'Warmup: understanding the Money classes'.
			'knowledgeBases' -> { 'missing-uuid-42' }
		} asDictionary.
	self
		assertMissingObject: call result targetObject
		withObjectName: 'missing-uuid-42'
		errorMessage: 'missing-uuid-42 is not found'.
	^ call
]
