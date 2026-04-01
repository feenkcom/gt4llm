Class {
	#name : #GtLToolForLepiterPageCreateExamples,
	#superclass : #Object,
	#traits : 'TGtLInvalidInputDataAssertions',
	#classTraits : 'TGtLInvalidInputDataAssertions classTrait',
	#category : #'Gt4LlmCore-Examples-Tools'
}

{ #category : #'examples - errors' }
GtLToolForLepiterPageCreateExamples >> emptyDatabaseId [
	<gtExample>
	| tool call result db logicalDB domainObject |
	db := LeExplicitlyAttachedLinksExamples new primaryDatabase.
	logicalDB := LeLogicalDatabase new primaryDB: db.
	tool := GtLToolForLepiterPageCreate new.
	tool database: logicalDB.
	call := GtLFunctionToolCall new.
	call rawArguments: {
		'title' -> 'New Page'.
		'databaseId' -> ''.
	} asDictionary.
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
GtLToolForLepiterPageCreateExamples >> emptyTitle [
	<gtExample>
	| tool call result db logicalDB domainObject |
	db := LeExplicitlyAttachedLinksExamples new primaryDatabase.
	logicalDB := LeLogicalDatabase new primaryDB: db.
	tool := GtLToolForLepiterPageCreate new.
	tool database: logicalDB.
	call := GtLFunctionToolCall new.
	call rawArguments: {
		'title' -> ''.
		'databaseId' -> db uuidString.
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	
	domainObject := result targetObject.
	self
		assertMissingArgument: domainObject
		withArgumentName: 'title'
		errorMessage: 'Missing argument called title'.
	^ domainObject
]

{ #category : #'examples - errors' }
GtLToolForLepiterPageCreateExamples >> missingDatabaseId [
	<gtExample>
	| tool call result db logicalDB domainObject |
	db := LeExplicitlyAttachedLinksExamples new primaryDatabase.
	logicalDB := LeLogicalDatabase new primaryDB: db.
	tool := GtLToolForLepiterPageCreate new.
	tool database: logicalDB.
	call := GtLFunctionToolCall new.
	call rawArguments: { 'title' -> 'New Page' } asDictionary.
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
GtLToolForLepiterPageCreateExamples >> missingTitle [
	<gtExample>
	| tool call result db logicalDB domainObject |
	db := LeExplicitlyAttachedLinksExamples new primaryDatabase.
	logicalDB := LeLogicalDatabase new primaryDB: db.
	tool := GtLToolForLepiterPageCreate new.
	tool database: logicalDB.
	call := GtLFunctionToolCall new.
	call rawArguments: { 'databaseId' -> db uuidString } asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	
	domainObject := result targetObject.
	self
		assertMissingRequiredProperties: domainObject
		withPropertyNames: #('title')
		path: #(nil)
		errorMessage: 'required properties missing [title]'.
	
	^ domainObject
]

{ #category : #'examples - errors' }
GtLToolForLepiterPageCreateExamples >> nilDatabaseId [
	<gtExample>
	| tool call result db logicalDB domainObject |
	db := LeExplicitlyAttachedLinksExamples new primaryDatabase.
	logicalDB := LeLogicalDatabase new primaryDB: db.
	tool := GtLToolForLepiterPageCreate new.
	tool database: logicalDB.
	call := GtLFunctionToolCall new.
	call rawArguments: '{"title": "New Page", "databaseId": null}'.
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
GtLToolForLepiterPageCreateExamples >> nilTitle [
	<gtExample>
	| tool call result db logicalDB domainObject |
	db := LeExplicitlyAttachedLinksExamples new primaryDatabase.
	logicalDB := LeLogicalDatabase new primaryDB: db.
	tool := GtLToolForLepiterPageCreate new.
	tool database: logicalDB.
	call := GtLFunctionToolCall new.
	call rawArguments: '{"title": null, "databaseId": "', db uuidString, '"}'.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	
	domainObject := result targetObject.
	self
		assertJSONSchemaValidationError: domainObject
		withPath: #('title')
		errorMessage: '@[title] string expected'.
	^ domainObject
]

{ #category : #examples }
GtLToolForLepiterPageCreateExamples >> successfulPageCreate [
	<gtExample>
	| db logicalDB tool call result domainObject pageUid page |
	db := LeExplicitlyAttachedLinksExamples new primaryDatabase.
	logicalDB := LeLogicalDatabase new primaryDB: db.
	tool := GtLToolForLepiterPageCreate new.
	tool database: logicalDB.
	call := GtLFunctionToolCall new.
	call rawArguments: {
		'title' -> 'New Page'.
		'databaseId' -> db uuidString.
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	domainObject := result targetObject.
	self assert: (domainObject isKindOf: GtLLepiterPageCreateDomainObject).
	self assert: domainObject status equals: 'created'.
	self assert: domainObject databaseId equals: db uuidString.
	pageUid := domainObject pageUid.
	page := logicalDB pageWithID: (UUID fromString36: pageUid) ifAbsent: [ nil ].
	self assert: page notNil.
	self assert: domainObject page == page.
	self assert: page title equals: 'New Page'.
	self assert: page children isEmpty.
	^ domainObject
]
