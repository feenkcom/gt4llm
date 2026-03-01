Class {
	#name : #GtLToolForLepiterSnippetsRemoveExamples,
	#superclass : #Object,
	#category : #'Gt4LlmCore-Examples'
}

{ #category : #examples }
GtLToolForLepiterSnippetsRemoveExamples >> missingSnippetKnowledgeBaseUid [
	<gtExample>
	| tool call result model |
	tool := GtLToolForLepiterSnippetsRemove new.
	call := GtLFunctionToolCall new.
	call rawArguments: {
		'snippets' -> {
			Dictionary new
				at: 'pageUid' put: UUID new asString;
				at: 'snippetUid' put: 'invalid';
				yourself } } asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GtLMagritteInputModel).
	model := result model.
	self assert: model snippets first missingArgument equals: 'knowledgeBaseUid'.
	^ call
]

{ #category : #examples }
GtLToolForLepiterSnippetsRemoveExamples >> missingSnippetPageUid [
	<gtExample>
	| tool call result model |
	tool := GtLToolForLepiterSnippetsRemove new.
	call := GtLFunctionToolCall new.
	call rawArguments: {
		'snippets' -> {
			Dictionary new
				at: 'knowledgeBaseUid' put: UUID new asString;
				at: 'snippetUid' put: 'invalid';
				yourself } } asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GtLMagritteInputModel).
	model := result model.
	self assert: model snippets first missingArgument equals: 'pageUid'.
	^ call
]

{ #category : #examples }
GtLToolForLepiterSnippetsRemoveExamples >> missingSnippetUid [
	<gtExample>
	| tool call result model |
	tool := GtLToolForLepiterSnippetsRemove new.
	call := GtLFunctionToolCall new.
	call rawArguments: {
		'snippets' -> {
			Dictionary new
				at: 'knowledgeBaseUid' put: UUID new asString;
				at: 'pageUid' put: UUID new asString;
				yourself } } asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GtLMagritteInputModel).
	model := result model.
	self assert: model snippets first missingArgument equals: 'snippetUid'.
	^ call
]

{ #category : #examples }
GtLToolForLepiterSnippetsRemoveExamples >> missingSnippets [
	<gtExample>
	| tool call result |
	tool := GtLToolForLepiterSnippetsRemove new.
	call := GtLFunctionToolCall new.
	call rawArguments: {} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GtLMagritteInputModel).
	self assert: result model missingArgument equals: 'snippets'.
	^ call
]

{ #category : #examples }
GtLToolForLepiterSnippetsRemoveExamples >> multipleSnippetRemoval [
	<gtExample>
	| tool call result contentExamples database pageOne pageTwo snippetOne snippetTwo model |
	contentExamples := LeContentExamples new.
	database := contentExamples basicDatabaseWithMonitor.
	[ pageOne := database pageBuilder
		title: 'one';
		add.
	pageTwo := database pageBuilder
		title: 'two';
		add.
	snippetOne := pageOne snippetBuilder
		string: 'First';
		add.
	snippetTwo := pageTwo snippetBuilder
		string: 'Second';
		add.
	tool := GtLToolForLepiterSnippetsRemove new.
	tool database: database.
	call := GtLFunctionToolCall new.
	call rawArguments: {
		'snippets' -> {
			Dictionary new
				at: 'knowledgeBaseUid' put: database uuidString;
				at: 'pageUid' put: pageOne uidString;
				at: 'snippetUid' put: snippetOne uidString;
				yourself.
			Dictionary new
				at: 'knowledgeBaseUid' put: database uuidString;
				at: 'pageUid' put: pageTwo uidString;
				at: 'snippetUid' put: snippetTwo uidString;
				yourself } } asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GtLMagritteInputModel).
	model := result model.
	self assert: model snippets size equals: 2.
	self assert: model snippets first status equals: 'removed'.
	self assert: model snippets second status equals: 'removed'.
	self assert: pageOne children isEmpty.
	self assert: pageTwo children isEmpty.
	^ call ]
		ensure: [ contentExamples stopDatabaseMonitor ]
]

{ #category : #examples }
GtLToolForLepiterSnippetsRemoveExamples >> successfulSnippetRemoval [
	<gtExample>
	| tool call result contentExamples database page snippet model |
	contentExamples := LeContentExamples new.
	database := contentExamples basicDatabaseWithMonitor.
	[ page := database pageBuilder
		title: 'one';
		add.
	snippet := page snippetBuilder
		string: 'Remove me';
		add.
	tool := GtLToolForLepiterSnippetsRemove new.
	tool database: database.
	call := GtLFunctionToolCall new.
	call rawArguments: {
		'snippets' -> {
			Dictionary new
				at: 'knowledgeBaseUid' put: database uuidString;
				at: 'pageUid' put: page uidString;
				at: 'snippetUid' put: snippet uidString;
				yourself } } asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GtLMagritteInputModel).
	model := result model.
	self assert: model snippets size equals: 1.
	self assert: model snippets first status equals: 'removed'.
	self assert: page children isEmpty.
	^ call ]
		ensure: [ contentExamples stopDatabaseMonitor ]
]
