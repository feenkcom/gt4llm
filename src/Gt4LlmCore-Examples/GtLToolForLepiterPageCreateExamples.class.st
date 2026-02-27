Class {
	#name : #GtLToolForLepiterPageCreateExamples,
	#superclass : #Object,
	#category : #'Gt4LlmCore-Examples-Tools'
}

{ #category : #examples }
GtLToolForLepiterPageCreateExamples >> missingDatabaseId [
	<gtExample>
	| tool call result logicalDB |
	logicalDB := LeLogicalDatabase new.
	tool := GtLToolForLepiterPageCreate new.
	tool database: logicalDB.
	call := GtLFunctionToolCall new.
	call rawArguments: { 'title' -> 'Untitled' } asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GtLMagritteInputModel).
	self assert: result model missingArgument equals: 'databaseId'.
	^ call
]

{ #category : #examples }
GtLToolForLepiterPageCreateExamples >> missingInitialText [
	<gtExample>
	| tool call result db logicalDB |
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
	self assert: (result isKindOf: GtLMagritteInputModel).
	self assert: result model missingArgument equals: 'initialText'.
	^ call
]

{ #category : #examples }
GtLToolForLepiterPageCreateExamples >> missingTitle [
	<gtExample>
	| tool call result db logicalDB |
	db := LeExplicitlyAttachedLinksExamples new primaryDatabase.
	logicalDB := LeLogicalDatabase new primaryDB: db.
	tool := GtLToolForLepiterPageCreate new.
	tool database: logicalDB.
	call := GtLFunctionToolCall new.
	call rawArguments: { 'databaseId' -> db uuidString } asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GtLMagritteInputModel).
	self assert: result model missingArgument equals: 'title'.
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
		'initialText' -> 'First snippet'.
		'databaseId' -> db uuidString.
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GtLMagritteInputModel).
	model := result model.
	self assert: model status equals: 'created'.
	self assert: model databaseId equals: db uuidString.
	pageUid := model pageUid.
	page := logicalDB pageWithID: (UUID fromString36: pageUid) ifAbsent: [ nil ].
	self assert: page notNil.
	self assert: model page == page.
	self assert: page title equals: 'New Page'.
	snippets := page children.
	self assert: snippets size equals: 1.
	self assert: snippets first contentAsString equals: 'First snippet'.
	^ call
]
