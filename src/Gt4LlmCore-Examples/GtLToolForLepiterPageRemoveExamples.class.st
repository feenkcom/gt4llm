Class {
	#name : #GtLToolForLepiterPageRemoveExamples,
	#superclass : #GtLAbstractMagritteFunctionToolExamples,
	#category : #'Gt4LlmCore-Examples-Tools'
}

{ #category : #'examples - errors' }
GtLToolForLepiterPageRemoveExamples >> emptyDatabaseId [
	<gtExample>
	| tool call result logicalDB domainObject |
	logicalDB := LeLogicalDatabase new.
	tool := GtLToolForLepiterPageRemove new.
	tool database: logicalDB.
	call := GtLFunctionToolCall new.
	call rawArguments: { 'pageUid' -> (UUID new asString36). 'databaseId' -> '' } asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	
	domainObject := result targetObject.
	self
		assertMissingArgument: domainObject
		withArgumentName: 'databaseId'
		errorMessage: 'Missing argument called databaseId'.
	^ domainObject
]

{ #category : #'examples - errors' }
GtLToolForLepiterPageRemoveExamples >> emptyPageUid [
	<gtExample>
	| tool call result db logicalDB domainObject |
	db := LeExplicitlyAttachedLinksExamples new primaryDatabase.
	logicalDB := LeLogicalDatabase new primaryDB: db.
	tool := GtLToolForLepiterPageRemove new.
	tool database: logicalDB.
	call := GtLFunctionToolCall new.
	call rawArguments: { 'pageUid' -> ''. 'databaseId' -> db uuidString } asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	
	domainObject := result targetObject.
	self
		assertMissingArgument: domainObject
		withArgumentName: 'pageUid'
		errorMessage: 'Missing argument called pageUid'.
	^ domainObject
]

{ #category : #'examples - errors' }
GtLToolForLepiterPageRemoveExamples >> missingDatabaseId [
	<gtExample>
	| tool call result logicalDB domainObject |
	logicalDB := LeLogicalDatabase new.
	tool := GtLToolForLepiterPageRemove new.
	tool database: logicalDB.
	call := GtLFunctionToolCall new.
	call rawArguments: { 'pageUid' -> (UUID new asString36) } asDictionary.
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
GtLToolForLepiterPageRemoveExamples >> missingPageUid [
	<gtExample>
	| tool call result logicalDB db domainObject |
	db := LeExplicitlyAttachedLinksExamples new primaryDatabase.
	logicalDB := LeLogicalDatabase new primaryDB: db.
	tool := GtLToolForLepiterPageRemove new.
	tool database: logicalDB.
	call := GtLFunctionToolCall new.
	call rawArguments: { 'databaseId' -> db uuidString } asDictionary.
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

{ #category : #'examples - errors' }
GtLToolForLepiterPageRemoveExamples >> nilDatabaseId [
	<gtExample>
	| tool call result logicalDB domainObject |
	logicalDB := LeLogicalDatabase new.
	tool := GtLToolForLepiterPageRemove new.
	tool database: logicalDB.
	call := GtLFunctionToolCall new.
	call rawArguments: '{"pageUid": "', (UUID new asString36), '", "databaseId": null}'.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	
	domainObject := result targetObject.
	self
		assertJSONSchemaValidationError: domainObject
		withPath: #('databaseId')
		errorMessage: '@[databaseId] string expected'.
	^ domainObject
]

{ #category : #'examples - errors' }
GtLToolForLepiterPageRemoveExamples >> nilPageUid [
	<gtExample>
	| tool call result db logicalDB domainObject |
	db := LeExplicitlyAttachedLinksExamples new primaryDatabase.
	logicalDB := LeLogicalDatabase new primaryDB: db.
	tool := GtLToolForLepiterPageRemove new.
	tool database: logicalDB.
	call := GtLFunctionToolCall new.
	call rawArguments: '{"pageUid": null, "databaseId": "', db uuidString, '"}'.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	
	domainObject := result targetObject.
	self
		assertJSONSchemaValidationError: domainObject
		withPath: #('pageUid')
		errorMessage: '@[pageUid] string expected'.
	^ domainObject
]

{ #category : #examples }
GtLToolForLepiterPageRemoveExamples >> successfulPageRemove [
	<gtExample>
	| db logicalDB page pageUid tool call result domainObject |
	db := LeExplicitlyAttachedLinksExamples new primaryDatabase.
	logicalDB := LeLogicalDatabase new primaryDB: db.
	page := db pageBuilder title: 'Page To Remove'; add.
	pageUid := page uidString.
	tool := GtLToolForLepiterPageRemove new.
	tool database: logicalDB.
	call := GtLFunctionToolCall new.
	call rawArguments: {
		'databaseId' -> db uuidString.
		'pageUid' -> pageUid
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	domainObject := result targetObject.
	self assert: (domainObject isKindOf: GtLLepiterPageRemoveDomainObject).
	self assert: domainObject status equals: 'removed'.
	self assert: domainObject databaseId equals: db uuidString.
	self assert: domainObject pageUid equals: pageUid.
	self assert: domainObject title equals: 'Page To Remove'.
	self assert: domainObject page == page.
	self assert: (db pageWithID: (UUID fromString36: pageUid) ifAbsent: [ nil ]) isNil.
	^ domainObject
]
