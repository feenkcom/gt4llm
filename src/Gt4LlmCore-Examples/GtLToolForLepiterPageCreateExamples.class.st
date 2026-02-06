Class {
	#name : #GtLToolForLepiterPageCreateExamples,
	#superclass : #Object,
	#category : #'Gt4LlmCore-Examples'
}

{ #category : #examples }
GtLToolForLepiterPageCreateExamples >> missingDatabaseId [
	<gtExample>
	| tool call result logicalDB |
	logicalDB := LeLogicalDatabase new.
	tool := GtLToolForLepiterPageCreate new.
	tool database: logicalDB.
	call := GtLFunctionToolCall new.
	call function: {
		'name' -> tool name.
		'arguments' -> { 'title' -> 'Untitled' } asDictionary } asDictionary.
	result := tool performToolCall: call.
	self assert: result missingArgument equals: 'databaseId'.
	^ result
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
	call function: {
		'name' -> tool name.
		'arguments' -> { 'databaseId' -> db uuidString } asDictionary } asDictionary.
	result := tool performToolCall: call.
	self assert: result missingArgument equals: 'title'.
	^ result
]

{ #category : #examples }
GtLToolForLepiterPageCreateExamples >> successfulPageCreate [
	<gtExample>
	| tool call result logicalDB pageUid page snippets db |
	db := LeExplicitlyAttachedLinksExamples new primaryDatabase.
	logicalDB := LeLogicalDatabase new primaryDB: db.
	tool := GtLToolForLepiterPageCreate new.
	tool database: logicalDB.
	call := GtLFunctionToolCall new.
	call function: {
		'name' -> tool name.
		'arguments' -> {
			'title' -> 'New Page'.
			'initialText' -> 'First snippet'.
			'databaseId' -> db uuidString.
		} asDictionary } asDictionary.
	result := tool performToolCall: call.
	self assert: (result value at: 'status') equals: 'created'.
	pageUid := result value at: 'pageUid'.
	page := logicalDB pageWithID: (UUID fromString: pageUid) ifAbsent: [ nil ].
	self assert: page notNil.
	self assert: page title equals: 'New Page'.
	snippets := page children.
	self assert: snippets size equals: 1.
	self assert: snippets first contentAsString equals: 'First snippet'.
	^ result
]
