"
Examples for GtLToolForLepiterPageContents demonstrating data views serialization and error handling.
"
Class {
	#name : #GtLToolForLepiterPageContentsExamples,
	#superclass : #GtLAbstractMagritteFunctionToolExamples,
	#category : 'Gt4LlmCore-Examples-Tools'
}

{ #category : #examples }
GtLToolForLepiterPageContentsExamples >> pageSerializationForExistingPage [
	<gtExample>
	| targetObject database page compositeView dataBlock jsonData expected |
	database := LeDatabase gtBook.
	page := database pageNamed: 'Warmup: understanding the Money classes'.
	
	targetObject := self
		executeTool: GtLToolForLepiterPageContents new
		withArguments: {
			'pageUid' -> page uidString.
			'databaseId' -> database uuidString
		} asDictionary.
	
	self assert: (targetObject isKindOf: GtLLepiterPage).
	self assert: targetObject targetPage equals: page.
	
	"Test data view serialization"
	compositeView := targetObject llmDataViewsFor: GtLDataView new.
	self assert: compositeView dataViews size equals: 1.
	dataBlock := compositeView serializeToLlmPrimiteData.
	self assert: dataBlock dataBlocks size equals: 1.
	self assert: dataBlock imageDataBlocks isEmpty.
	
	jsonData := dataBlock compositeJsonData.
	expected := NeoJSONReader fromString: (LeJsonV4 uniqueInstance serializePretty: page).
	self assert: jsonData equals: expected.
	
	^ targetObject
]

{ #category : #examples }
GtLToolForLepiterPageContentsExamples >> pageSerializationForMissingKnowledgeBase [
	<gtExample>
	| targetObject unknownDbId |
	unknownDbId := 'missing-uuid-42'.
	
	targetObject := self
		executeTool: GtLToolForLepiterPageContents new
		withArguments: {
			'pageUid' -> UUID new asString36.
			'databaseId' -> unknownDbId
		} asDictionary.
	
	self assert: targetObject isErrorDomainObject.
	self assert: (targetObject isKindOf: GtLProblemDomainObject).
	self assert: (targetObject description includesSubstring: unknownDbId).
	
	^ targetObject
]

{ #category : #examples }
GtLToolForLepiterPageContentsExamples >> pageSerializationForUnknownPage [
	<gtExample>
	| targetObject database unknownUid |
	database := LeDatabase gtBook.
	unknownUid := UUID new asString36.
	
	targetObject := self
		executeTool: GtLToolForLepiterPageContents new
		withArguments: {
			'pageUid' -> unknownUid.
			'databaseId' -> database uuidString
		} asDictionary.
	
	self
		assertMissingObject: targetObject
		withObjectName: unknownUid
		errorMessage: unknownUid, ' is not found'.
	
	^ targetObject
]

{ #category : #examples }
GtLToolForLepiterPageContentsExamples >> pageSerializationWithMissingDatabaseId [
	<gtExample>
	| targetObject |
	
	targetObject := self
		executeTool: GtLToolForLepiterPageContents new
		withArguments: {
			'pageUid' -> UUID new asString36
		} asDictionary.
	
	self
		assertMissingRequiredProperties: targetObject
		withPropertyNames: #('databaseId')
		path: #(nil)
		errorMessage: 'required properties missing [databaseId]'.
	
	^ targetObject
]

{ #category : #examples }
GtLToolForLepiterPageContentsExamples >> pageSerializationWithMissingPageUid [
	<gtExample>
	| targetObject database |
	database := LeDatabase gtBook.
	
	targetObject := self
		executeTool: GtLToolForLepiterPageContents new
		withArguments: {
			'databaseId' -> database uuidString
		} asDictionary.
	
	self
		assertMissingRequiredProperties: targetObject
		withPropertyNames: #('pageUid')
		path: #(nil)
		errorMessage: 'required properties missing [pageUid]'.
	
	^ targetObject
]
