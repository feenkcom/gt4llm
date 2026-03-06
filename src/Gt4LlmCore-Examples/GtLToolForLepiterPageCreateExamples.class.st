Class {
	#name : #GtLToolForLepiterPageCreateExamples,
	#superclass : #Object,
	#category : 'Gt4LlmCore-Examples-Tools'
}

{ #category : #examples }
GtLToolForLepiterPageCreateExamples >> emptyDatabaseId [
	<gtExample>
	| tool call result logicalDB model |
	logicalDB := LeLogicalDatabase new.
	tool := GtLToolForLepiterPageCreate new.
	tool database: logicalDB.
	call := GtLFunctionToolCall new.
	call rawArguments: { 'title' -> 'New Page'. 'databaseId' -> '' } asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GtLMagritteBasedModel).
	
	model := result model.
	self assert: (model isKindOf: GtLMissingArgumentDomainObject).
	self assert: model missingArgument equals: 'databaseId'.
	^ call
]

{ #category : #examples }
GtLToolForLepiterPageCreateExamples >> emptyTitle [
	<gtExample>
	| tool call result db logicalDB model |
	db := LeExplicitlyAttachedLinksExamples new primaryDatabase.
	logicalDB := LeLogicalDatabase new primaryDB: db.
	tool := GtLToolForLepiterPageCreate new.
	tool database: logicalDB.
	call := GtLFunctionToolCall new.
	call rawArguments: { 'title' -> ''. 'databaseId' -> db uuidString } asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GtLMagritteBasedModel).
	
	model := result model.
	self assert: (model isKindOf: GtLMissingArgumentDomainObject).
	self assert: model missingArgument equals: 'title'.
	^ call
]

{ #category : #examples }
GtLToolForLepiterPageCreateExamples >> missingDatabaseId [
	<gtExample>
	| tool call result logicalDB model |
	logicalDB := LeLogicalDatabase new.
	tool := GtLToolForLepiterPageCreate new.
	tool database: logicalDB.
	call := GtLFunctionToolCall new.
	call rawArguments: { 'title' -> 'Untitled' } asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GtLMagritteBasedModel).
	
	model := result model.
	self assert: (model isKindOf: GtLMissingRequiredPropertiesDomainObject).
	self assert: model missingPropertyNames equals: #('databaseId').
	self assert: model path equals: #(nil).
	^ call
]

{ #category : #examples }
GtLToolForLepiterPageCreateExamples >> missingTitle [
	<gtExample>
	| tool call result db logicalDB model |
	db := LeExplicitlyAttachedLinksExamples new primaryDatabase.
	logicalDB := LeLogicalDatabase new primaryDB: db.
	tool := GtLToolForLepiterPageCreate new.
	tool database: logicalDB.
	call := GtLFunctionToolCall new.
	call rawArguments: { 'databaseId' -> db uuidString } asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GtLMagritteBasedModel).
	
	model := result model.
	self assert: (model isKindOf: GtLMissingRequiredPropertiesDomainObject).
	self assert: model missingPropertyNames equals: #('title').
	self assert: model path equals: #(nil).
	
	^ call
]

{ #category : #examples }
GtLToolForLepiterPageCreateExamples >> nilDatabaseId [
	<gtExample>
	| tool call result logicalDB model |
	logicalDB := LeLogicalDatabase new.
	tool := GtLToolForLepiterPageCreate new.
	tool database: logicalDB.
	call := GtLFunctionToolCall new.
	call rawArguments: '{"title": "New Page", "databaseId": null}'.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GtLMagritteBasedModel).
	
	model := result model.
	self assert: (model isKindOf: GtLJSONSchemaValidationErrorDomainObject).
	^ call
]

{ #category : #examples }
GtLToolForLepiterPageCreateExamples >> nilTitle [
	<gtExample>
	| tool call result db logicalDB model |
	db := LeExplicitlyAttachedLinksExamples new primaryDatabase.
	logicalDB := LeLogicalDatabase new primaryDB: db.
	tool := GtLToolForLepiterPageCreate new.
	tool database: logicalDB.
	call := GtLFunctionToolCall new.
	call rawArguments: '{"title": null, "databaseId": "', db uuidString, '"}'.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GtLMagritteBasedModel).
	
	model := result model.
	self assert: (model isKindOf: GtLJSONSchemaValidationErrorDomainObject).
	^ call
]

{ #category : #examples }
GtLToolForLepiterPageCreateExamples >> successfulPageCreate [
	<gtExample>
	| tool call result logicalDB pageUid page snippets db model |
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
	self assert: (result isKindOf: GtLMagritteBasedModel).
	model := result model.
	self assert: model status equals: 'created'.
	self assert: model databaseId equals: db uuidString.
	pageUid := model pageUid.
	page := logicalDB pageWithID: (UUID fromString36: pageUid) ifAbsent: [ nil ].
	self assert: page notNil.
	self assert: model page == page.
	self assert: page title equals: 'New Page'.
	snippets := page children.
	self assert: snippets isEmpty.
	^ call
]
