Class {
	#name : #GtLToolForLepiterPageCreateExamples,
	#superclass : #GtLAbstractMagritteFunctionToolExamples,
	#category : 'Gt4LlmCore-Examples-Tools'
}

{ #category : #examples }
GtLToolForLepiterPageCreateExamples >> emptyDatabaseId [
	<gtExample>
	| call db logicalDB tool |
	db := LeExplicitlyAttachedLinksExamples new primaryDatabase.
	logicalDB := LeLogicalDatabase new primaryDB: db.
	tool := GtLToolForLepiterPageCreate new.
	tool database: logicalDB.
	call := self
		executeTool: tool
		withArguments: {
			'title' -> 'New Page'.
			'databaseId' -> ''
		} asDictionary.
	self
		assertMissingArgument: call result targetObject
		withArgumentName: 'databaseId'
		errorMessage: 'Missing argument called databaseId'.
	^ call
]

{ #category : #examples }
GtLToolForLepiterPageCreateExamples >> emptyTitle [
	<gtExample>
	| call db logicalDB tool |
	db := LeExplicitlyAttachedLinksExamples new primaryDatabase.
	logicalDB := LeLogicalDatabase new primaryDB: db.
	tool := GtLToolForLepiterPageCreate new.
	tool database: logicalDB.
	call := self
		executeTool: tool
		withArguments: {
			'title' -> ''.
			'databaseId' -> db uuidString
		} asDictionary.
	self
		assertMissingArgument: call result targetObject
		withArgumentName: 'title'
		errorMessage: 'Missing argument called title'.
	^ call
]

{ #category : #examples }
GtLToolForLepiterPageCreateExamples >> missingDatabaseId [
	<gtExample>
	| call db logicalDB tool |
	db := LeExplicitlyAttachedLinksExamples new primaryDatabase.
	logicalDB := LeLogicalDatabase new primaryDB: db.
	tool := GtLToolForLepiterPageCreate new.
	tool database: logicalDB.
	call := self
		executeTool: tool
		withArguments: {
			'title' -> 'New Page'
		} asDictionary.
	self
		assertMissingRequiredProperties: call result targetObject
		withPropertyNames: #('databaseId')
		path: #(nil)
		errorMessage: 'required properties missing [databaseId]'.
	^ call
]

{ #category : #examples }
GtLToolForLepiterPageCreateExamples >> missingTitle [
	<gtExample>
	| call db logicalDB tool |
	db := LeExplicitlyAttachedLinksExamples new primaryDatabase.
	logicalDB := LeLogicalDatabase new primaryDB: db.
	tool := GtLToolForLepiterPageCreate new.
	tool database: logicalDB.
	call := self
		executeTool: tool
		withArguments: {
			'databaseId' -> db uuidString
		} asDictionary.
	self
		assertMissingRequiredProperties: call result targetObject
		withPropertyNames: #('title')
		path: #(nil)
		errorMessage: 'required properties missing [title]'.
	^ call
]

{ #category : #examples }
GtLToolForLepiterPageCreateExamples >> nilDatabaseId [
	<gtExample>
	| call db logicalDB tool |
	db := LeExplicitlyAttachedLinksExamples new primaryDatabase.
	logicalDB := LeLogicalDatabase new primaryDB: db.
	tool := GtLToolForLepiterPageCreate new.
	tool database: logicalDB.
	call := self
		executeTool: tool
		withArguments: {
			'title' -> 'New Page'.
			'databaseId' -> nil
		} asDictionary.
	self
		assertJSONSchemaValidationError: call result targetObject
		withPath: #('databaseId')
		errorMessage: '@[databaseId] string expected'.
	^ call
]

{ #category : #examples }
GtLToolForLepiterPageCreateExamples >> nilTitle [
	<gtExample>
	| call db logicalDB tool |
	db := LeExplicitlyAttachedLinksExamples new primaryDatabase.
	logicalDB := LeLogicalDatabase new primaryDB: db.
	tool := GtLToolForLepiterPageCreate new.
	tool database: logicalDB.
	call := self
		executeTool: tool
		withArguments: {
			'title' -> nil.
			'databaseId' -> db uuidString
		} asDictionary.
	self
		assertJSONSchemaValidationError: call result targetObject
		withPath: #('title')
		errorMessage: '@[title] string expected'.
	^ call
]

{ #category : #examples }
GtLToolForLepiterPageCreateExamples >> successfulPageCreate [
	<gtExample>
	| call db logicalDB tool pageUid page targetObject |
	db := LeExplicitlyAttachedLinksExamples new primaryDatabase.
	logicalDB := LeLogicalDatabase new primaryDB: db.
	tool := GtLToolForLepiterPageCreate new.
	tool database: logicalDB.
	call := self
		executeTool: tool
		withArguments: {
			'title' -> 'New Page'.
			'databaseId' -> db uuidString
		} asDictionary.
	targetObject := call result targetObject.
	self assert: (targetObject isKindOf: GtLLepiterPageCreateDomainObject).
	self assert: targetObject status equals: 'created'.
	self assert: targetObject databaseId equals: db uuidString.
	pageUid := targetObject pageUid.
	page := logicalDB pageWithID: (UUID fromString36: pageUid) ifAbsent: [ nil ].
	self assert: page notNil.
	self assert: targetObject page == page.
	self assert: page title equals: 'New Page'.
	self assert: page children isEmpty.
	^ call
]
