"
Examples for GtLToolForLepiterPageContents demonstrating data views serialization and error handling.
"
Class {
	#name : #GtLToolForLepiterPageContentsExamples,
	#superclass : #GtLAbstractMagritteFunctionToolExamples,
	#category : 'Gt4LlmCore-Examples-Tools'
}

{ #category : #'examples - data views' }
GtLToolForLepiterPageContentsExamples >> pageSerializationForExistingPage [
	<gtExample>
	| call database page compositeView dataBlock expected |
	database := LeDatabase gtBook.
	page := database pageNamed: 'Warmup: understanding the Money classes'.
	call := self
		executeTool: GtLToolForLepiterPageContents new
		withArguments: {
			'pageUid' -> page uidString.
			'databaseId' -> database uuidString
		} asDictionary.
	self assert: (call result targetObject isKindOf: GtLLepiterPage).
	self assert: call result targetObject targetPage equals: page.
	compositeView := call result targetObject llmDataViewsFor: GtLDataView new.
	self assert: compositeView dataViews size equals: 1.
	
	dataBlock := compositeView serializeToLlmPrimiteData.
	self assertDataBlockHasOnlyJsonData: dataBlock.
	
	expected := (LeJsonV4 uniqueInstance serializePretty: page).
	self assertDataBlock: dataBlock hasLlmJsonData: expected.
	
	^ call
]

{ #category : #examples }
GtLToolForLepiterPageContentsExamples >> pageSerializationForMissingKnowledgeBase [
	<gtExample>
	| call unknownDbId |
	unknownDbId := 'missing-uuid-42'.
	call := self
		executeTool: GtLToolForLepiterPageContents new
		withArguments: {
			'pageUid' -> UUID new asString36.
			'databaseId' -> unknownDbId
		} asDictionary.
	self assert: call result targetObject isErrorDomainObject.
	self assert: (call result targetObject isKindOf: GtLProblemDomainObject).
	self assert: (call result targetObject description includesSubstring: unknownDbId).
	^ call
]

{ #category : #examples }
GtLToolForLepiterPageContentsExamples >> pageSerializationForUnknownPage [
	<gtExample>
	| call database unknownUid |
	database := LeDatabase gtBook.
	unknownUid := UUID new asString36.
	call := self
		executeTool: GtLToolForLepiterPageContents new
		withArguments: {
			'pageUid' -> unknownUid.
			'databaseId' -> database uuidString
		} asDictionary.
	self
		assertMissingObject: call result targetObject
		withObjectName: unknownUid
		errorMessage: unknownUid, ' is not found'.
	^ call
]

{ #category : #examples }
GtLToolForLepiterPageContentsExamples >> pageSerializationWithMissingDatabaseId [
	<gtExample>
	| call |
	call := self
		executeTool: GtLToolForLepiterPageContents new
		withArguments: {
			'pageUid' -> UUID new asString36
		} asDictionary.
	self
		assertMissingRequiredProperties: call result targetObject
		withPropertyNames: #('databaseId')
		path: #(nil)
		errorMessage: 'required properties missing [databaseId]'.
	^ call
]

{ #category : #examples }
GtLToolForLepiterPageContentsExamples >> pageSerializationWithMissingPageUid [
	<gtExample>
	| call database |
	database := LeDatabase gtBook.
	call := self
		executeTool: GtLToolForLepiterPageContents new
		withArguments: {
			'databaseId' -> database uuidString
		} asDictionary.
	self
		assertMissingRequiredProperties: call result targetObject
		withPropertyNames: #('pageUid')
		path: #(nil)
		errorMessage: 'required properties missing [pageUid]'.
	^ call
]
