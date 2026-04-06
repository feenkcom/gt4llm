"
Examples for GtLToolForLepiterPageContents demonstrating data views serialization and error handling.
"
Class {
	#name : #GtLToolForLepiterPageContentsExamples,
	#superclass : #Object,
	#traits : 'TGtLInvalidInputDataAssertions',
	#classTraits : 'TGtLInvalidInputDataAssertions classTrait',
	#category : 'Gt4LlmCore-Examples-Tools'
}

{ #category : #examples }
GtLToolForLepiterPageContentsExamples >> pageSerializationForExistingPage [
	<gtExample>
	| tool call result database page domainObject compositeView dataBlock jsonData expected |
	database := LeDatabase gtBook.
	page := database pageNamed: 'Warmup: understanding the Money classes'.
	tool := GtLToolForLepiterPageContents new.
	call := GtLFunctionToolCall new.
	call rawArguments: {
		'pageUid' -> page uidString.
		'databaseId' -> database uuidString
	} asDictionary.
	result := tool performToolCall: call.
	
	self assert: call tool == tool.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	domainObject := result targetObject.
	self assert: (domainObject isKindOf: GtLLepiterPage).
	self assert: domainObject targetPage equals: page.
	
	"Test data view serialization"
	compositeView := domainObject llmDataViewsFor: GtLDataView new.
	self assert: compositeView dataViews size equals: 1.
	dataBlock := compositeView serializeToLlmPrimiteData.
	self assert: dataBlock dataBlocks size equals: 1.
	self assert: dataBlock imageDataBlocks isEmpty.
	
	jsonData := dataBlock compositeJsonData.
	expected := NeoJSONReader fromString: (LeJsonV4 uniqueInstance serializePretty: page).
	self assert: jsonData equals: expected.
	
	^ domainObject
]

{ #category : #'examples - errors' }
GtLToolForLepiterPageContentsExamples >> pageSerializationForMissingKnowledgeBase [
	<gtExample>
	| tool call result domainObject unknownDbId |
	unknownDbId := 'missing-uuid-42'.
	tool := GtLToolForLepiterPageContents new.
	call := GtLFunctionToolCall new.
	call rawArguments: {
		'pageUid' -> UUID new asString36.
		'databaseId' -> unknownDbId
	} asDictionary.
	result := tool performToolCall: call.
	
	self assert: call tool == tool.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	domainObject := result targetObject.
	self assert: domainObject isErrorDomainObject.
	self assert: (domainObject isKindOf: GtLProblemDomainObject).
	self assert: (domainObject description includesSubstring: unknownDbId).
	
	^ domainObject
]

{ #category : #'examples - errors' }
GtLToolForLepiterPageContentsExamples >> pageSerializationForUnknownPage [
	<gtExample>
	| tool call result database unknownUid domainObject |
	database := LeDatabase gtBook.
	unknownUid := UUID new asString36.
	tool := GtLToolForLepiterPageContents new.
	call := GtLFunctionToolCall new.
	call rawArguments: {
		'pageUid' -> unknownUid.
		'databaseId' -> database uuidString
	} asDictionary.
	result := tool performToolCall: call.
	
	self assert: call tool == tool.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	domainObject := result targetObject.
	self
		assertMissingObject: domainObject
		withObjectName: unknownUid
		errorMessage: unknownUid, ' is not found'.
	
	^ domainObject
]

{ #category : #'examples - errors' }
GtLToolForLepiterPageContentsExamples >> pageSerializationWithMissingDatabaseId [
	<gtExample>
	| tool call result domainObject |
	tool := GtLToolForLepiterPageContents new.
	call := GtLFunctionToolCall new.
	call rawArguments: {
		'pageUid' -> UUID new asString36
	} asDictionary.
	result := tool performToolCall: call.
	
	self assert: call tool == tool.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	domainObject := result targetObject.
	self
		assertMissingRequiredProperties: domainObject
		withPropertyNames: #('databaseId')
		path: #(nil)
		errorMessage: 'required properties missing [databaseId]'.
	
	^ domainObject
]

{ #category : #'examples - errors' }
GtLToolForLepiterPageContentsExamples >> pageSerializationWithMissingPageUid [
	<gtExample>
	| tool call result domainObject database |
	database := LeDatabase gtBook.
	tool := GtLToolForLepiterPageContents new.
	call := GtLFunctionToolCall new.
	call rawArguments: {
		'databaseId' -> database uuidString
	} asDictionary.
	result := tool performToolCall: call.
	
	self assert: call tool == tool.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	domainObject := result targetObject.
	self
		assertMissingRequiredProperties: domainObject
		withPropertyNames: #('pageUid')
		path: #(nil)
		errorMessage: 'required properties missing [pageUid]'.
	
	^ domainObject
]
