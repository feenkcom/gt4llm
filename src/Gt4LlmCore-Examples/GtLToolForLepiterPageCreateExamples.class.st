Class {
	#name : #GtLToolForLepiterPageCreateExamples,
	#superclass : #GtLAbstractMagritteFunctionToolExamples,
	#category : #'Gt4LlmCore-Examples-Tools'
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
GtLToolForLepiterPageCreateExamples >> existingTitleIsRefused [
	"A title that a page of the database already has is refused with a message, not with the error of Lepiter"

	<gtExample>
	| call db tool |
	db := LeExplicitlyAttachedLinksExamples new primaryDatabase.
	db pageBuilder
		title: 'Existing Page';
		add.
	tool := GtLToolForLepiterPageCreate new.
	tool database: (LeLogicalDatabase new primaryDB: db).
	call := self
			executeTool: tool
			withArguments: {'title' -> 'Existing Page'.
					'databaseId' -> db uuidString} asDictionary.
	self assert: call result targetObject isErrorDomainObject.
	self
		assert: (call result targetObject errorMessage
				beginsWith: 'A page titled ''Existing Page'' is already in').
	self
		assert: (db pagesByName select: [ :each | each title = 'Existing Page' ]) size
		equals: 1.
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
GtLToolForLepiterPageCreateExamples >> responseKeys [
	"The response names the page with the same keys as the other Lepiter tools: databaseId, pageUid and pageTitle"

	<gtExample>
	| call json |
	call := self successfulPageCreate.
	json := self jsonOf: call.
	self
		assert: json keys asSortedCollection asArray
		equals: #('databaseId' 'pageTitle' 'pageUid' 'status').
	self assert: (json at: 'pageTitle') equals: 'New Page'.
	self assert: (json at: 'status') equals: 'created'.
	^ json
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

{ #category : #examples }
GtLToolForLepiterPageCreateExamples >> unknownDatabaseIsReported [
	<gtExample>
	| call tool |
	tool := GtLToolForLepiterPageCreate new.
	tool
		database: (LeLogicalDatabase new
				primaryDB: LeExplicitlyAttachedLinksExamples new primaryDatabase).
	call := self
			executeTool: tool
			withArguments: {'title' -> 'New Page'.
					'databaseId' -> 'missing-uuid-42'} asDictionary.
	self assert: call result targetObject isErrorDomainObject.
	self
		assert: call result targetObject errorMessage
		equals: 'Could not locate the database with id missing-uuid-42. The lepiterKnowledgeBases tool lists the databases and their ids.'.
	^ call
]
