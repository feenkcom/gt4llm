Class {
	#name : #GtLToolForLepiterPageRemoveExamples,
	#superclass : #GtLAbstractMagritteFunctionToolExamples,
	#category : 'Gt4LlmCore-Examples-Tools'
}

{ #category : #examples }
GtLToolForLepiterPageRemoveExamples >> emptyDatabaseId [
	<gtExample>
	| targetObject logicalDB tool |
	logicalDB := LeLogicalDatabase new.
	tool := GtLToolForLepiterPageRemove new.
	tool database: logicalDB.
	
	targetObject := self
		executeTool: tool
		withArguments: {
			'pageUid' -> UUID new asString36.
			'databaseId' -> ''
		} asDictionary.
	
	self
		assertMissingArgument: targetObject
		withArgumentName: 'databaseId'
		errorMessage: 'Missing argument called databaseId'.
	
	^ targetObject
]

{ #category : #examples }
GtLToolForLepiterPageRemoveExamples >> emptyPageUid [
	<gtExample>
	| targetObject db logicalDB tool |
	db := LeExplicitlyAttachedLinksExamples new primaryDatabase.
	logicalDB := LeLogicalDatabase new primaryDB: db.
	tool := GtLToolForLepiterPageRemove new.
	tool database: logicalDB.
	
	targetObject := self
		executeTool: tool
		withArguments: {
			'pageUid' -> ''.
			'databaseId' -> db uuidString
		} asDictionary.
	
	self
		assertMissingArgument: targetObject
		withArgumentName: 'pageUid'
		errorMessage: 'Missing argument called pageUid'.
	
	^ targetObject
]

{ #category : #examples }
GtLToolForLepiterPageRemoveExamples >> missingDatabaseId [
	<gtExample>
	| targetObject logicalDB tool |
	logicalDB := LeLogicalDatabase new.
	tool := GtLToolForLepiterPageRemove new.
	tool database: logicalDB.
	
	targetObject := self
		executeTool: tool
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
GtLToolForLepiterPageRemoveExamples >> missingPageUid [
	<gtExample>
	| targetObject logicalDB db tool |
	db := LeExplicitlyAttachedLinksExamples new primaryDatabase.
	logicalDB := LeLogicalDatabase new primaryDB: db.
	tool := GtLToolForLepiterPageRemove new.
	tool database: logicalDB.
	
	targetObject := self
		executeTool: tool
		withArguments: {
			'databaseId' -> db uuidString
		} asDictionary.
	
	self
		assertMissingRequiredProperties: targetObject
		withPropertyNames: #('pageUid')
		path: #(nil)
		errorMessage: 'required properties missing [pageUid]'.
	
	^ targetObject
]

{ #category : #examples }
GtLToolForLepiterPageRemoveExamples >> nilDatabaseId [
	<gtExample>
	| targetObject logicalDB tool |
	logicalDB := LeLogicalDatabase new.
	tool := GtLToolForLepiterPageRemove new.
	tool database: logicalDB.
	
	targetObject := self
		executeTool: tool
		withArguments: {
			'pageUid' -> UUID new asString36.
			'databaseId' -> nil
		} asDictionary.
	
	self
		assertJSONSchemaValidationError: targetObject
		withPath: #('databaseId')
		errorMessage: '@[databaseId] string expected'.
	
	^ targetObject
]

{ #category : #examples }
GtLToolForLepiterPageRemoveExamples >> nilPageUid [
	<gtExample>
	| targetObject db logicalDB tool |
	db := LeExplicitlyAttachedLinksExamples new primaryDatabase.
	logicalDB := LeLogicalDatabase new primaryDB: db.
	tool := GtLToolForLepiterPageRemove new.
	tool database: logicalDB.
	
	targetObject := self
		executeTool: tool
		withArguments: {
			'pageUid' -> nil.
			'databaseId' -> db uuidString
		} asDictionary.
	
	self
		assertJSONSchemaValidationError: targetObject
		withPath: #('pageUid')
		errorMessage: '@[pageUid] string expected'.
	
	^ targetObject
]

{ #category : #examples }
GtLToolForLepiterPageRemoveExamples >> successfulPageRemove [
	<gtExample>
	| targetObject db logicalDB page pageUid tool |
	db := LeExplicitlyAttachedLinksExamples new primaryDatabase.
	logicalDB := LeLogicalDatabase new primaryDB: db.
	page := db pageBuilder title: 'Page To Remove'; add.
	pageUid := page uidString.
	tool := GtLToolForLepiterPageRemove new.
	tool database: logicalDB.
	
	targetObject := self
		executeTool: tool
		withArguments: {
			'databaseId' -> db uuidString.
			'pageUid' -> pageUid
		} asDictionary.
	
	self assert: (targetObject isKindOf: GtLLepiterPageRemoveDomainObject).
	self assert: targetObject status equals: 'removed'.
	self assert: targetObject databaseId equals: db uuidString.
	self assert: targetObject pageUid equals: pageUid.
	self assert: targetObject title equals: 'Page To Remove'.
	self assert: targetObject page == page.
	self assert: (db pageWithID: (UUID fromString36: pageUid) ifAbsent: [ nil ]) isNil.
	
	^ targetObject
]
