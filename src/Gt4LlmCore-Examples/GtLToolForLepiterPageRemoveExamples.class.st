Class {
	#name : #GtLToolForLepiterPageRemoveExamples,
	#superclass : #Object,
	#category : #'Gt4LlmCore-Examples'
}

{ #category : #examples }
GtLToolForLepiterPageRemoveExamples >> missingDatabaseId [
	<gtExample>
	| tool call result logicalDB |
	logicalDB := LeLogicalDatabase new.
	tool := GtLToolForLepiterPageRemove new.
	tool database: logicalDB.
	call := GtLFunctionToolCall new.
	call rawArguments: { 'pageUid' -> (UUID new asString36) } asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GtLMagritteInputModel).
	self assert: result model missingArgument equals: 'databaseId'.
	^ call
]

{ #category : #examples }
GtLToolForLepiterPageRemoveExamples >> missingPageUid [
	<gtExample>
	| tool call result logicalDB db |
	db := LeExplicitlyAttachedLinksExamples new primaryDatabase.
	logicalDB := LeLogicalDatabase new primaryDB: db.
	tool := GtLToolForLepiterPageRemove new.
	tool database: logicalDB.
	call := GtLFunctionToolCall new.
	call rawArguments: { 'databaseId' -> db uuidString } asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GtLMagritteInputModel).
	self assert: result model missingArgument equals: 'pageUid'.
	^ call
]

{ #category : #examples }
GtLToolForLepiterPageRemoveExamples >> successfulPageRemove [
	<gtExample>
	| tool call result logicalDB pageUid page db model |
	db := LeExplicitlyAttachedLinksExamples new primaryDatabase.
	logicalDB := LeLogicalDatabase new primaryDB: db.
	page := db pageBuilder title: 'Page To Remove'; add.
	tool := GtLToolForLepiterPageRemove new.
	tool database: logicalDB.
	pageUid := page uidString.
	call := GtLFunctionToolCall new.
	call rawArguments: {
		'databaseId' -> db uuidString.
		'pageUid' -> pageUid
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GtLMagritteInputModel).
	model := result model.
	self assert: model status equals: 'removed'.
	self assert: model databaseId equals: db uuidString.
	self assert: model pageUid equals: pageUid.
	self assert: model title equals: 'Page To Remove'.
	self assert: model page == page.
	self assert: (db pageWithID: (UUID fromString36: pageUid) ifAbsent: [ nil ]) isNil.
	^ call
]
