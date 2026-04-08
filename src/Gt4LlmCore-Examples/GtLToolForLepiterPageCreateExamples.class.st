Class {
	#name : #GtLToolForLepiterPageCreateExamples,
	#superclass : #GtLAbstractMagritteFunctionToolExamples,
	#category : 'Gt4LlmCore-Examples-Tools'
}

{ #category : #examples }
GtLToolForLepiterPageCreateExamples >> emptyDatabaseId [
	<gtExample>
	| targetObject db logicalDB tool |
	db := LeExplicitlyAttachedLinksExamples new primaryDatabase.
	logicalDB := LeLogicalDatabase new primaryDB: db.
	tool := GtLToolForLepiterPageCreate new.
	tool database: logicalDB.
	
	targetObject := self
		executeTool: tool
		withArguments: {
			'title' -> 'New Page'.
			'databaseId' -> ''
		} asDictionary.
	
	self
		assertMissingArgument: targetObject
		withArgumentName: 'databaseId'
		errorMessage: 'Missing argument called databaseId'.
	
	^ targetObject
]

{ #category : #examples }
GtLToolForLepiterPageCreateExamples >> emptyTitle [
	<gtExample>
	| targetObject db logicalDB tool |
	db := LeExplicitlyAttachedLinksExamples new primaryDatabase.
	logicalDB := LeLogicalDatabase new primaryDB: db.
	tool := GtLToolForLepiterPageCreate new.
	tool database: logicalDB.
	
	targetObject := self
		executeTool: tool
		withArguments: {
			'title' -> ''.
			'databaseId' -> db uuidString
		} asDictionary.
	
	self
		assertMissingArgument: targetObject
		withArgumentName: 'title'
		errorMessage: 'Missing argument called title'.
	
	^ targetObject
]

{ #category : #examples }
GtLToolForLepiterPageCreateExamples >> missingDatabaseId [
	<gtExample>
	| targetObject db logicalDB tool |
	db := LeExplicitlyAttachedLinksExamples new primaryDatabase.
	logicalDB := LeLogicalDatabase new primaryDB: db.
	tool := GtLToolForLepiterPageCreate new.
	tool database: logicalDB.
	
	targetObject := self
		executeTool: tool
		withArguments: {
			'title' -> 'New Page'
		} asDictionary.
	
	self
		assertMissingRequiredProperties: targetObject
		withPropertyNames: #('databaseId')
		path: #(nil)
		errorMessage: 'required properties missing [databaseId]'.
	
	^ targetObject
]

{ #category : #examples }
GtLToolForLepiterPageCreateExamples >> missingTitle [
	<gtExample>
	| targetObject db logicalDB tool |
	db := LeExplicitlyAttachedLinksExamples new primaryDatabase.
	logicalDB := LeLogicalDatabase new primaryDB: db.
	tool := GtLToolForLepiterPageCreate new.
	tool database: logicalDB.
	
	targetObject := self
		executeTool: tool
		withArguments: {
			'databaseId' -> db uuidString
		} asDictionary.
	
	self
		assertMissingRequiredProperties: targetObject
		withPropertyNames: #('title')
		path: #(nil)
		errorMessage: 'required properties missing [title]'.
	
	^ targetObject
]

{ #category : #examples }
GtLToolForLepiterPageCreateExamples >> nilDatabaseId [
	<gtExample>
	| targetObject db logicalDB tool |
	db := LeExplicitlyAttachedLinksExamples new primaryDatabase.
	logicalDB := LeLogicalDatabase new primaryDB: db.
	tool := GtLToolForLepiterPageCreate new.
	tool database: logicalDB.
	
	targetObject := self
		executeTool: tool
		withArguments: {
			'title' -> 'New Page'.
			'databaseId' -> nil
		} asDictionary.
	
	self
		assertJSONSchemaValidationError: targetObject
		withPath: #('databaseId')
		errorMessage: '@[databaseId] string expected'.
	
	^ targetObject
]

{ #category : #examples }
GtLToolForLepiterPageCreateExamples >> nilTitle [
	<gtExample>
	| targetObject db logicalDB tool |
	db := LeExplicitlyAttachedLinksExamples new primaryDatabase.
	logicalDB := LeLogicalDatabase new primaryDB: db.
	tool := GtLToolForLepiterPageCreate new.
	tool database: logicalDB.
	
	targetObject := self
		executeTool: tool
		withArguments: {
			'title' -> nil.
			'databaseId' -> db uuidString
		} asDictionary.
	
	self
		assertJSONSchemaValidationError: targetObject
		withPath: #('title')
		errorMessage: '@[title] string expected'.
	
	^ targetObject
]

{ #category : #examples }
GtLToolForLepiterPageCreateExamples >> successfulPageCreate [
	<gtExample>
	| targetObject db logicalDB tool pageUid page |
	db := LeExplicitlyAttachedLinksExamples new primaryDatabase.
	logicalDB := LeLogicalDatabase new primaryDB: db.
	tool := GtLToolForLepiterPageCreate new.
	tool database: logicalDB.
	
	targetObject := self
		executeTool: tool
		withArguments: {
			'title' -> 'New Page'.
			'databaseId' -> db uuidString
		} asDictionary.
	
	self assert: (targetObject isKindOf: GtLLepiterPageCreateDomainObject).
	self assert: targetObject status equals: 'created'.
	self assert: targetObject databaseId equals: db uuidString.
	pageUid := targetObject pageUid.
	page := logicalDB pageWithID: (UUID fromString36: pageUid) ifAbsent: [ nil ].
	self assert: page notNil.
	self assert: targetObject page == page.
	self assert: page title equals: 'New Page'.
	self assert: page children isEmpty.
	
	^ targetObject
]
