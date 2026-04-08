Class {
	#name : #GtLToolForLepiterSnippetsRemoveExamples,
	#superclass : #GtLAbstractMagritteFunctionToolExamples,
	#category : #'Gt4LlmCore-Examples-Tools'
}

{ #category : #'examples - errors' }
GtLToolForLepiterSnippetsRemoveExamples >> emptyKnowledgeBaseUid [
	<gtExample>
	"Test behavior when knowledgeBaseUid is an empty string.
	The schema accepts empty strings, but the tool logic validates it."
	| tool call result domainObject |
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
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	domainObject := result targetObject.
	"Empty string passes schema validation, tool proceeds to handle it"
	self assert: (domainObject isKindOf: GtLLepiterSnippetsDomainObject).
	self assert: domainObject snippets size equals: 1.
	"The snippet removal should return a missing argument error"
	self
		assertMissingArgument: domainObject snippets first
		withArgumentName: 'knowledgeBaseUid'
		errorMessage: 'Missing argument called knowledgeBaseUid'.
	^ domainObject
]

{ #category : #'examples - errors' }
GtLToolForLepiterSnippetsRemoveExamples >> emptyPageUid [
	<gtExample>
	"Test behavior when pageUid is an empty string.
	The schema accepts empty strings, but the tool logic validates it."
	| tool call result domainObject |
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
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	domainObject := result targetObject.
	"Empty string passes schema validation, tool proceeds to handle it"
	self assert: (domainObject isKindOf: GtLLepiterSnippetsDomainObject).
	self assert: domainObject snippets size equals: 1.
	"The snippet removal should return a missing argument error"
	self
		assertMissingArgument: domainObject snippets first
		withArgumentName: 'pageUid'
		errorMessage: 'Missing argument called pageUid'.
	^ domainObject
]

{ #category : #'examples - errors' }
GtLToolForLepiterSnippetsRemoveExamples >> emptySnippetUid [
	<gtExample>
	"Test behavior when snippetUid is an empty string.
	The schema accepts empty strings, but the tool logic validates it."
	| tool call result domainObject |
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
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	domainObject := result targetObject.
	"Empty string passes schema validation, tool proceeds to handle it"
	self assert: (domainObject isKindOf: GtLLepiterSnippetsDomainObject).
	self assert: domainObject snippets size equals: 1.
	"The snippet removal should return a missing argument error"
	self
		assertMissingArgument: domainObject snippets first
		withArgumentName: 'snippetUid'
		errorMessage: 'Missing argument called snippetUid'.
	^ domainObject
]

{ #category : #'examples - errors' }
GtLToolForLepiterSnippetsRemoveExamples >> missingSnippetKnowledgeBaseUid [
	<gtExample>
	| tool call result domainObject |
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
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	domainObject := result targetObject.
	self
		assertMissingRequiredProperties: domainObject
		withPropertyNames: #('knowledgeBaseUid')
		path: #(#snippets 1)
		errorMessage: '@[snippets/1] required properties missing [knowledgeBaseUid]'.
	^ domainObject
]

{ #category : #'examples - errors' }
GtLToolForLepiterSnippetsRemoveExamples >> missingSnippetPageUid [
	<gtExample>
	| tool call result domainObject |
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
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	domainObject := result targetObject.
	self
		assertMissingRequiredProperties: domainObject
		withPropertyNames: #('pageUid')
		path: #(#snippets 1)
		errorMessage: '@[snippets/1] required properties missing [pageUid]'.
	^ domainObject
]

{ #category : #'examples - errors' }
GtLToolForLepiterSnippetsRemoveExamples >> missingSnippetUid [
	<gtExample>
	| tool call result domainObject |
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
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	domainObject := result targetObject.
	self
		assertMissingRequiredProperties: domainObject
		withPropertyNames: #('snippetUid')
		path: #(#snippets 1)
		errorMessage: '@[snippets/1] required properties missing [snippetUid]'.
	^ domainObject
]

{ #category : #'examples - errors' }
GtLToolForLepiterSnippetsRemoveExamples >> missingSnippets [
	<gtExample>
	| tool call result domainObject |
	tool := GtLToolForLepiterSnippetsRemove new.
	call := GtLFunctionToolCall new.
	call rawArguments: {} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	domainObject := result targetObject.
	self
		assertMissingRequiredProperties: domainObject
		withPropertyNames: #('snippets')
		path: #(nil)
		errorMessage: 'required properties missing [snippets]'.
	^ domainObject
]

{ #category : #examples }
GtLToolForLepiterSnippetsRemoveExamples >> multipleSnippetRemoval [
	<gtExample>
	| contentExamples database |
	contentExamples := LeContentExamples new.
	database := contentExamples basicDatabaseWithMonitor.
	[ | tool call result pageOne pageTwo snippetOne snippetTwo domainObject |
		pageOne := database pageBuilder
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
		self assert: (result isKindOf: GTLDataViewWrapperModel).
		domainObject := result targetObject.
		self assert: domainObject snippets size equals: 2.
		self assert: domainObject snippets first status equals: 'removed'.
		self assert: domainObject snippets second status equals: 'removed'.
		self assert: pageOne children isEmpty.
		self assert: pageTwo children isEmpty.
		^ domainObject ]
		ensure: [ contentExamples stopDatabaseMonitor ]
]

{ #category : #'examples - errors' }
GtLToolForLepiterSnippetsRemoveExamples >> nilKnowledgeBaseUid [
	<gtExample>
	"Test that a null knowledgeBaseUid is caught by JSON schema validation."
	| tool call result domainObject |
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
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	domainObject := result targetObject.
	"JSON schema validation returns an error for null in required string slot"
	self assert: (domainObject isKindOf: GtLJSONSchemaValidationErrorDomainObject).
	^ domainObject
]

{ #category : #'examples - errors' }
GtLToolForLepiterSnippetsRemoveExamples >> nilPageUid [
	<gtExample>
	"Test that a null pageUid is caught by JSON schema validation."
	| tool call result domainObject |
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
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	domainObject := result targetObject.
	"JSON schema validation returns an error for null in required string slot"
	self assert: (domainObject isKindOf: GtLJSONSchemaValidationErrorDomainObject).
	^ domainObject
]

{ #category : #'examples - errors' }
GtLToolForLepiterSnippetsRemoveExamples >> nilSnippetUid [
	<gtExample>
	"Test that a null snippetUid is caught by JSON schema validation."
	| tool call result domainObject |
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
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	domainObject := result targetObject.
	"JSON schema validation returns an error for null in required string slot"
	self assert: (domainObject isKindOf: GtLJSONSchemaValidationErrorDomainObject).
	^ domainObject
]

{ #category : #examples }
GtLToolForLepiterSnippetsRemoveExamples >> successfulSnippetRemoval [
	<gtExample>
	| contentExamples database |
	contentExamples := LeContentExamples new.
	database := contentExamples basicDatabaseWithMonitor.
	[ | tool call result page snippet domainObject |
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
		self assert: (result isKindOf: GTLDataViewWrapperModel).
		domainObject := result targetObject.
		self assert: (domainObject isKindOf: GtLLepiterSnippetsDomainObject).
		self assert: domainObject snippets size equals: 1.
		self assert: domainObject snippets first status equals: 'removed'.
		self assert: page children isEmpty.
		^ domainObject ]
		ensure: [ contentExamples stopDatabaseMonitor ]
]
