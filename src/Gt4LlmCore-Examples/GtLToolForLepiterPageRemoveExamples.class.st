Class {
	#name : #GtLToolForLepiterPageRemoveExamples,
	#superclass : #GtLAbstractMagritteFunctionToolExamples,
	#category : #'Gt4LlmCore-Examples-Tools'
}

{ #category : #examples }
GtLToolForLepiterPageRemoveExamples >> emptyDatabaseId [
	<gtExample>
	| call logicalDB tool |
	logicalDB := LeLogicalDatabase new.
	tool := GtLToolForLepiterPageRemove new.
	tool database: logicalDB.
	call := self
		executeTool: tool
		withArguments: {
			'pageUid' -> UUID new asString36.
			'databaseId' -> ''
		} asDictionary.
	self
		assertMissingArgument: call result targetObject
		withArgumentName: 'databaseId'
		errorMessage: 'Missing argument called databaseId'.
	^ call
]

{ #category : #examples }
GtLToolForLepiterPageRemoveExamples >> emptyPageUid [
	<gtExample>
	| call db logicalDB tool |
	db := LeExplicitlyAttachedLinksExamples new primaryDatabase.
	logicalDB := LeLogicalDatabase new primaryDB: db.
	tool := GtLToolForLepiterPageRemove new.
	tool database: logicalDB.
	call := self
		executeTool: tool
		withArguments: {
			'pageUid' -> ''.
			'databaseId' -> db uuidString
		} asDictionary.
	self
		assertMissingArgument: call result targetObject
		withArgumentName: 'pageUid'
		errorMessage: 'Missing argument called pageUid'.
	^ call
]

{ #category : #examples }
GtLToolForLepiterPageRemoveExamples >> missingDatabaseId [
	<gtExample>
	| call logicalDB tool |
	logicalDB := LeLogicalDatabase new.
	tool := GtLToolForLepiterPageRemove new.
	tool database: logicalDB.
	call := self
		executeTool: tool
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
GtLToolForLepiterPageRemoveExamples >> missingPageUid [
	<gtExample>
	| call logicalDB db tool |
	db := LeExplicitlyAttachedLinksExamples new primaryDatabase.
	logicalDB := LeLogicalDatabase new primaryDB: db.
	tool := GtLToolForLepiterPageRemove new.
	tool database: logicalDB.
	call := self
		executeTool: tool
		withArguments: {
			'databaseId' -> db uuidString
		} asDictionary.
	self
		assertMissingRequiredProperties: call result targetObject
		withPropertyNames: #('pageUid')
		path: #(nil)
		errorMessage: 'required properties missing [pageUid]'.
	^ call
]

{ #category : #examples }
GtLToolForLepiterPageRemoveExamples >> nilDatabaseId [
	<gtExample>
	| call logicalDB tool |
	logicalDB := LeLogicalDatabase new.
	tool := GtLToolForLepiterPageRemove new.
	tool database: logicalDB.
	call := self
		executeTool: tool
		withArguments: {
			'pageUid' -> UUID new asString36.
			'databaseId' -> nil
		} asDictionary.
	self
		assertJSONSchemaValidationError: call result targetObject
		withPath: #('databaseId')
		errorMessage: '@[databaseId] string expected'.
	^ call
]

{ #category : #examples }
GtLToolForLepiterPageRemoveExamples >> nilPageUid [
	<gtExample>
	| call db logicalDB tool |
	db := LeExplicitlyAttachedLinksExamples new primaryDatabase.
	logicalDB := LeLogicalDatabase new primaryDB: db.
	tool := GtLToolForLepiterPageRemove new.
	tool database: logicalDB.
	call := self
		executeTool: tool
		withArguments: {
			'pageUid' -> nil.
			'databaseId' -> db uuidString
		} asDictionary.
	self
		assertJSONSchemaValidationError: call result targetObject
		withPath: #('pageUid')
		errorMessage: '@[pageUid] string expected'.
	^ call
]

{ #category : #examples }
GtLToolForLepiterPageRemoveExamples >> pageRemoveWithTheDashedPageUid [
	"The page id can also be given in the dashed form of its UUID, as the stored page JSON shows it. The response gives it in base 36, as the other Lepiter tools do"

	<gtExample>
	| call db logicalDB page tool targetObject |
	db := LeExplicitlyAttachedLinksExamples new primaryDatabase.
	logicalDB := LeLogicalDatabase new primaryDB: db.
	page := db pageBuilder
			title: 'Page To Remove';
			add.
	tool := GtLToolForLepiterPageRemove new.
	tool database: logicalDB.
	call := self
			executeTool: tool
			withArguments: {'databaseId' -> db uuidString.
					'pageUid' -> page uid asString} asDictionary.
	targetObject := call result targetObject.
	self assert: targetObject status equals: 'removed'.
	self assert: targetObject pageUid equals: page uidString.
	self assert: (db pageWithID: page uid ifAbsent: [ nil ]) isNil.
	^ call
]

{ #category : #examples }
GtLToolForLepiterPageRemoveExamples >> responseKeys [
	"The response names the page with the same keys as the other Lepiter tools: databaseId, pageUid and pageTitle"

	<gtExample>
	| call json |
	call := self successfulPageRemove.
	json := self jsonOf: call.
	self
		assert: json keys asSortedCollection asArray
		equals: #('databaseId' 'pageTitle' 'pageUid' 'status').
	self assert: (json at: 'pageTitle') equals: 'Page To Remove'.
	self assert: (json at: 'status') equals: 'removed'.
	^ json
]

{ #category : #examples }
GtLToolForLepiterPageRemoveExamples >> successfulPageRemove [
	<gtExample>
	| call db logicalDB page pageUid tool targetObject |
	db := LeExplicitlyAttachedLinksExamples new primaryDatabase.
	logicalDB := LeLogicalDatabase new primaryDB: db.
	page := db pageBuilder title: 'Page To Remove'; add.
	pageUid := page uidString.
	tool := GtLToolForLepiterPageRemove new.
	tool database: logicalDB.
	call := self
		executeTool: tool
		withArguments: {
			'databaseId' -> db uuidString.
			'pageUid' -> pageUid
		} asDictionary.
	targetObject := call result targetObject.
	self assert: (targetObject isKindOf: GtLLepiterPageRemoveDomainObject).
	self assert: targetObject status equals: 'removed'.
	self assert: targetObject databaseId equals: db uuidString.
	self assert: targetObject pageUid equals: pageUid.
	self assert: targetObject title equals: 'Page To Remove'.
	self assert: targetObject page == page.
	self assert: (db pageWithID: (UUID fromString36: pageUid) ifAbsent: [ nil ]) isNil.
	^ call
]

{ #category : #examples }
GtLToolForLepiterPageRemoveExamples >> unknownPageIsReported [
	<gtExample>
	| call db tool unknownUid |
	db := LeExplicitlyAttachedLinksExamples new primaryDatabase.
	tool := GtLToolForLepiterPageRemove new.
	tool database: (LeLogicalDatabase new primaryDB: db).
	unknownUid := UUID new asString36.
	call := self
			executeTool: tool
			withArguments: {'databaseId' -> db uuidString.
					'pageUid' -> unknownUid} asDictionary.
	self assert: call result targetObject isErrorDomainObject.
	self
		assert: (call result targetObject errorMessage
				beginsWith: 'Could not locate page with id ' , unknownUid).
	^ call
]
