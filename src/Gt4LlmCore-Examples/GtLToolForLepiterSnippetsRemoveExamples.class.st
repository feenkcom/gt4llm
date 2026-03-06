Class {
	#name : #GtLToolForLepiterSnippetsRemoveExamples,
	#superclass : #Object,
	#category : 'Gt4LlmCore-Examples-Tools'
}

{ #category : #'examples - empty values' }
GtLToolForLepiterSnippetsRemoveExamples >> emptyKnowledgeBaseUid [
	<gtExample>
	"Test behavior when knowledgeBaseUid is an empty string.
	The schema accepts empty strings, but the tool logic validates it."
	| tool call result model |
	tool := GtLToolForLepiterSnippetsRemove new.
	call := GtLFunctionToolCall new.
	call rawArguments: {
		'snippets' -> {
			Dictionary new
				at: 'knowledgeBaseUid' put: '';
				at: 'pageUid' put: UUID new asString;
				at: 'snippetUid' put: UUID new asString;
				yourself } } asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GtLMagritteBasedModel).
	model := result model.
	"Empty string passes schema validation, tool proceeds to handle it"
	self assert: (model isKindOf: GtLLepiterSnippetsDomainObject).
	self assert: model snippets size equals: 1.
	"The snippet removal should return a missing argument error"
	self assert: (model snippets first isKindOf: GtLMissingArgumentDomainObject).
	self assert: model snippets first missingArgument equals: 'knowledgeBaseUid'.
	^ call
]

{ #category : #'examples - empty values' }
GtLToolForLepiterSnippetsRemoveExamples >> emptyPageUid [
	<gtExample>
	"Test behavior when pageUid is an empty string.
	The schema accepts empty strings, but the tool logic validates it."
	| tool call result model |
	tool := GtLToolForLepiterSnippetsRemove new.
	call := GtLFunctionToolCall new.
	call rawArguments: {
		'snippets' -> {
			Dictionary new
				at: 'knowledgeBaseUid' put: UUID new asString;
				at: 'pageUid' put: '';
				at: 'snippetUid' put: UUID new asString;
				yourself } } asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GtLMagritteBasedModel).
	model := result model.
	"Empty string passes schema validation, tool proceeds to handle it"
	self assert: (model isKindOf: GtLLepiterSnippetsDomainObject).
	self assert: model snippets size equals: 1.
	"The snippet removal should return a missing argument error"
	self assert: (model snippets first isKindOf: GtLMissingArgumentDomainObject).
	self assert: model snippets first missingArgument equals: 'pageUid'.
	^ call
]

{ #category : #'examples - empty values' }
GtLToolForLepiterSnippetsRemoveExamples >> emptySnippetUid [
	<gtExample>
	"Test behavior when snippetUid is an empty string.
	The schema accepts empty strings, but the tool logic validates it."
	| tool call result model |
	tool := GtLToolForLepiterSnippetsRemove new.
	call := GtLFunctionToolCall new.
	call rawArguments: {
		'snippets' -> {
			Dictionary new
				at: 'knowledgeBaseUid' put: UUID new asString;
				at: 'pageUid' put: UUID new asString;
				at: 'snippetUid' put: '';
				yourself } } asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GtLMagritteBasedModel).
	model := result model.
	"Empty string passes schema validation, tool proceeds to handle it"
	self assert: (model isKindOf: GtLLepiterSnippetsDomainObject).
	self assert: model snippets size equals: 1.
	"The snippet removal should return a missing argument error"
	self assert: (model snippets first isKindOf: GtLMissingArgumentDomainObject).
	self assert: model snippets first missingArgument equals: 'snippetUid'.
	^ call
]

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
	self assert: (result isKindOf: GtLMagritteBasedModel).
	model := result model.
	self assert: (model isKindOf: GtLMissingRequiredPropertiesDomainObject).
	self assert: model missingPropertyNames equals: #('knowledgeBaseUid').
	self assert: model path equals: #('snippets' 1).
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
	self assert: (result isKindOf: GtLMagritteBasedModel).
	model := result model.
	self assert: (model isKindOf: GtLMissingRequiredPropertiesDomainObject).
	self assert: model missingPropertyNames equals: #('pageUid').
	self assert: model path equals: #('snippets' 1).
	^ call
]

{ #category : #examples }
GtLToolForLepiterSnippetsRemoveExamples >> missingSnippets [
	<gtExample>
	| tool call result model |
	tool := GtLToolForLepiterSnippetsRemove new.
	call := GtLFunctionToolCall new.
	call rawArguments: {} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GtLMagritteBasedModel).
	model := result model.
	self assert: (model isKindOf: GtLMissingRequiredPropertiesDomainObject).
	self assert: model missingPropertyNames equals: #('snippets').
	self assert: model path asArray equals: #(nil).
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
	self assert: (result isKindOf: GtLMagritteBasedModel).
	model := result model.
	self assert: (model isKindOf: GtLMissingRequiredPropertiesDomainObject).
	self assert: model missingPropertyNames equals: #('snippetUid').
	self assert: model path equals: #('snippets' 1).
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
	self assert: (result isKindOf: GtLMagritteBasedModel).
	model := result model.
	self assert: model snippets size equals: 2.
	self assert: model snippets first status equals: 'removed'.
	self assert: model snippets second status equals: 'removed'.
	self assert: pageOne children isEmpty.
	self assert: pageTwo children isEmpty.
	^ call ]
		ensure: [ contentExamples stopDatabaseMonitor ]
]

{ #category : #'examples - nil values' }
GtLToolForLepiterSnippetsRemoveExamples >> nilKnowledgeBaseUid [
	<gtExample>
	"Test that a null knowledgeBaseUid is caught by JSON schema validation."
	| tool call result model |
	tool := GtLToolForLepiterSnippetsRemove new.
	call := GtLFunctionToolCall new.
	call rawArguments: {
		'snippets' -> {
			Dictionary new
				at: 'knowledgeBaseUid' put: nil;
				at: 'pageUid' put: UUID new asString;
				at: 'snippetUid' put: UUID new asString;
				yourself } } asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GtLMagritteBasedModel).
	model := result model.
	"JSON schema validation returns an error for null in required string slot"
	self assert: (model isKindOf: GtLJSONSchemaValidationErrorDomainObject).
	^ call
]

{ #category : #'examples - nil values' }
GtLToolForLepiterSnippetsRemoveExamples >> nilPageUid [
	<gtExample>
	"Test that a null pageUid is caught by JSON schema validation."
	| tool call result model |
	tool := GtLToolForLepiterSnippetsRemove new.
	call := GtLFunctionToolCall new.
	call rawArguments: {
		'snippets' -> {
			Dictionary new
				at: 'knowledgeBaseUid' put: UUID new asString;
				at: 'pageUid' put: nil;
				at: 'snippetUid' put: UUID new asString;
				yourself } } asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GtLMagritteBasedModel).
	model := result model.
	"JSON schema validation returns an error for null in required string slot"
	self assert: (model isKindOf: GtLJSONSchemaValidationErrorDomainObject).
	^ call
]

{ #category : #'examples - nil values' }
GtLToolForLepiterSnippetsRemoveExamples >> nilSnippetUid [
	<gtExample>
	"Test that a null snippetUid is caught by JSON schema validation."
	| tool call result model |
	tool := GtLToolForLepiterSnippetsRemove new.
	call := GtLFunctionToolCall new.
	call rawArguments: {
		'snippets' -> {
			Dictionary new
				at: 'knowledgeBaseUid' put: UUID new asString;
				at: 'pageUid' put: UUID new asString;
				at: 'snippetUid' put: nil;
				yourself } } asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GtLMagritteBasedModel).
	model := result model.
	"JSON schema validation returns an error for null in required string slot"
	self assert: (model isKindOf: GtLJSONSchemaValidationErrorDomainObject).
	^ call
]

{ #category : #examples }
GtLToolForLepiterSnippetsRemoveExamples >> successfulSnippetRemoval [
	<gtExample>
	|  contentExamples database  |
	contentExamples := LeContentExamples new.
	database := contentExamples basicDatabaseWithMonitor.
	[ |tool call result page snippet model |
		page := database pageBuilder
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
	self assert: (result isKindOf: GtLMagritteBasedModel).
	model := result model.
	self assert: model snippets size equals: 1.
	self assert: model snippets first status equals: 'removed'.
	self assert: page children isEmpty.
	^ call ]
		ensure: [ contentExamples stopDatabaseMonitor ]
]
