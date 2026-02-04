Class {
	#name : #GtLToolForLepiterPageCreateExamples,
	#superclass : #Object,
	#category : #'Gt4LlmCore-Examples'
}

{ #category : #examples }
GtLToolForLepiterPageCreateExamples >> missingDatabaseId [
	<gtExample>
	| tool call result database |
	database := LeContentExamples new basicDatabase.
	tool := GtLToolForLepiterPageCreate new.
	tool database: database.
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
	| tool call result database |
	database := LeContentExamples new basicDatabase.
	tool := GtLToolForLepiterPageCreate new.
	tool database: database.
	call := GtLFunctionToolCall new.
	call function: {
		'name' -> tool name.
		'arguments' -> { 'databaseId' -> database uuid asString } asDictionary } asDictionary.
	result := tool performToolCall: call.
	self assert: result missingArgument equals: 'title'.
	^ result
]

{ #category : #examples }
GtLToolForLepiterPageCreateExamples >> successfulPageCreate [
	<gtExample>
	| tool call result database pageUid page snippets |
	database := LeContentExamples new basicDatabase.
	tool := GtLToolForLepiterPageCreate new.
	tool database: database.
	call := GtLFunctionToolCall new.
	call function: {
		'name' -> tool name.
		'arguments' -> {
			'title' -> 'New Page'.
			'initialText' -> 'First snippet'.
			'databaseId' -> database uuid asString.
		} asDictionary } asDictionary.
	result := tool performToolCall: call.
	self assert: (result value at: 'status') equals: 'created'.
	pageUid := result value at: 'pageUid'.
	page := database pageWithID: (UUID fromString: pageUid) ifAbsent: [ nil ].
	self assert: page notNil.
	self assert: page title equals: 'New Page'.
	snippets := page children.
	self assert: snippets size equals: 1.
	self assert: snippets first contentAsString equals: 'First snippet'.
	^ result
]
