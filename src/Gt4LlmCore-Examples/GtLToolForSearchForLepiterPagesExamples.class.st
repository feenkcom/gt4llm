Class {
	#name : #GtLToolForSearchForLepiterPagesExamples,
	#superclass : #GtLAbstractMagritteFunctionToolExamples,
	#category : #'Gt4LlmCore-Examples-Tools'
}

{ #category : #examples }
GtLToolForSearchForLepiterPagesExamples >> blankQueryIsRefused [
	<gtExample>
	| call |
	call := self
			executeTool: GtLToolForSearchForLepiterPages new
			withArguments: {'query' -> '  '} asDictionary.
	self
		assertMissingArgument: call result targetObject
		withArgumentName: 'query'
		errorMessage: 'Missing argument called query'.
	^ call
]

{ #category : #'examples - data views' }
GtLToolForSearchForLepiterPagesExamples >> documentationLookupDataViewSerialization [
	<gtExample>
	<return: #GtLPrimitiveMessageDataBlock>
	| call domainObject compositeView dataBlock jsonData pagesData |
	call := self documentationLookupForExistingPage.
	domainObject := call result targetObject.
	compositeView := domainObject llmDataViewsFor: GtLDataView new.
	self assert: compositeView dataViews size equals: 1.
	
	dataBlock := compositeView serializeToLlmPrimiteData.
	self assertDataBlockHasOnlyJsonData: dataBlock.
	
	jsonData := dataBlock llmJsonData.
	self assert: (jsonData at: 'pages') isNotEmpty.
	pagesData := jsonData at: 'pages'.
	self assert: ((pagesData first at: 'pageTitle') includesSubstring: 'Warmup: understanding the Money classes').
	self assert: (pagesData first includesKey: 'pageUid').
	self assert: (pagesData first includesKey: 'databaseId').
	
	^ dataBlock
]

{ #category : #examples }
GtLToolForSearchForLepiterPagesExamples >> documentationLookupForExistingPage [
	<gtExample>
	| call targetObject |
	call := self
			executeTool: GtLToolForSearchForLepiterPages new
			withArguments: {'query' -> 'Warmup: understanding the Money classes'.
					'databaseIds' -> {LeDatabase gtBook uuidString}} asDictionary.
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
			withArguments: {'query' -> 'NonExistingDocumentationPage42'.
					'databaseIds' -> {LeDatabase gtBook uuidString}} asDictionary.
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
			withArguments: {'query' -> 'Warmup: understanding the Money classes'.
					'databaseIds'
						-> {defaultDatabase uuidString.
								LeDatabase gtBook uuidString}} asDictionary.
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
			withArguments: {'query' -> 'Warmup: understanding the Money classes'.
					'databaseIds' -> {'missing-uuid-42'}} asDictionary.
	self assert: call result targetObject isErrorDomainObject.
	self
		assert: call result targetObject errorMessage
		equals: 'Could not locate the database with id missing-uuid-42. The lepiterKnowledgeBases tool lists the databases and their ids.'.
	^ call
]

{ #category : #examples }
GtLToolForSearchForLepiterPagesExamples >> searchWithoutDatabaseIdsSearchesAllDatabases [
	"databaseIds is optional: without it, every database of the logical database is searched. Pages are given with their base 36 pageUid"

	<gtExample>
	| firstDatabase secondDatabase firstPage secondPage tool call pages schema |
	firstDatabase := LeExplicitlyAttachedLinksExamples new primaryDatabase.
	secondDatabase := LeExplicitlyAttachedLinksExamples new primaryDatabase.
	firstPage := firstDatabase pageBuilder
			title: 'Searched page in the first database';
			add.
	secondPage := secondDatabase pageBuilder
			title: 'Searched page in the second database';
			add.
	tool := GtLToolForSearchForLepiterPages new
			database: (LeLogicalDatabase new
					primaryDB: firstDatabase;
					addDB: secondDatabase;
					yourself);
			yourself.
	call := self
			executeTool: tool
			withArguments: {'query' -> 'Searched page'} asDictionary.
	pages := (self jsonOf: call) at: 'pages'.
	self
		assert: (pages collect: [ :each | (each at: 'databaseId') -> (each at: 'pageUid') ])
				asSet
		equals: {firstDatabase uuidString -> firstPage uid asString36.
				secondDatabase uuidString -> secondPage uid asString36} asSet.
	schema := tool parametersJsonSchemaDictionary.
	self assert: (schema at: 'required') asArray equals: #('query').
	self assert: ((schema at: 'properties') includesKey: 'databaseIds').
	^ call
]
