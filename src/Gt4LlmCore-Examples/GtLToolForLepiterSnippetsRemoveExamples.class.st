Class {
	#name : #GtLToolForLepiterSnippetsRemoveExamples,
	#superclass : #GtLAbstractMagritteFunctionToolExamples,
	#category : #'Gt4LlmCore-Examples-Tools'
}

{ #category : #examples }
GtLToolForLepiterSnippetsRemoveExamples >> emptyKnowledgeBaseUid [
	<gtExample>
	"Test behavior when knowledgeBaseUid is an empty string.
	The schema accepts empty strings, but the tool logic validates it."
	| call targetObject |
	
	call := self
		executeTool: GtLToolForLepiterSnippetsRemove new
		withArguments: {
			'snippets' -> {
				Dictionary new
					at: 'knowledgeBaseUid' put: '';
					at: 'pageUid' put: UUID new asString;
					at: 'snippetUid' put: UUID new asString;
					yourself
			}
		} asDictionary.
	targetObject := call result targetObject.
	
	"Empty string passes schema validation, tool proceeds to handle it"
	self assert: (targetObject isKindOf: GtLLepiterSnippetsDomainObject).
	self assert: targetObject snippets size equals: 1.
	"The snippet removal should return a missing argument error"
	self
		assertMissingArgument: targetObject snippets first
		withArgumentName: 'knowledgeBaseUid'
		errorMessage: 'Missing argument called knowledgeBaseUid'.
	
	^ call
]

{ #category : #examples }
GtLToolForLepiterSnippetsRemoveExamples >> emptyPageUid [
	<gtExample>
	"Test behavior when pageUid is an empty string.
	The schema accepts empty strings, but the tool logic validates it."
	| call targetObject |
	
	call := self
		executeTool: GtLToolForLepiterSnippetsRemove new
		withArguments: {
			'snippets' -> {
				Dictionary new
					at: 'knowledgeBaseUid' put: UUID new asString;
					at: 'pageUid' put: '';
					at: 'snippetUid' put: UUID new asString;
					yourself
			}
		} asDictionary.
	targetObject := call result targetObject.
	
	"Empty string passes schema validation, tool proceeds to handle it"
	self assert: (targetObject isKindOf: GtLLepiterSnippetsDomainObject).
	self assert: targetObject snippets size equals: 1.
	"The snippet removal should return a missing argument error"
	self
		assertMissingArgument: targetObject snippets first
		withArgumentName: 'pageUid'
		errorMessage: 'Missing argument called pageUid'.
	
	^ call
]

{ #category : #examples }
GtLToolForLepiterSnippetsRemoveExamples >> emptySnippetUid [
	<gtExample>
	"Test behavior when snippetUid is an empty string.
	The schema accepts empty strings, but the tool logic validates it."
	| call targetObject |
	
	call := self
		executeTool: GtLToolForLepiterSnippetsRemove new
		withArguments: {
			'snippets' -> {
				Dictionary new
					at: 'knowledgeBaseUid' put: UUID new asString;
					at: 'pageUid' put: UUID new asString;
					at: 'snippetUid' put: '';
					yourself
			}
		} asDictionary.
	targetObject := call result targetObject.
	
	"Empty string passes schema validation, tool proceeds to handle it"
	self assert: (targetObject isKindOf: GtLLepiterSnippetsDomainObject).
	self assert: targetObject snippets size equals: 1.
	"The snippet removal should return a missing argument error"
	self
		assertMissingArgument: targetObject snippets first
		withArgumentName: 'snippetUid'
		errorMessage: 'Missing argument called snippetUid'.
	
	^ call
]

{ #category : #examples }
GtLToolForLepiterSnippetsRemoveExamples >> missingSnippetKnowledgeBaseUid [
	<gtExample>
	| call targetObject |
	
	call := self
		executeTool: GtLToolForLepiterSnippetsRemove new
		withArguments: {
			'snippets' -> {
				Dictionary new
					at: 'pageUid' put: UUID new asString;
					at: 'snippetUid' put: 'invalid';
					yourself
			}
		} asDictionary.
	targetObject := call result targetObject.
	
	self
		assertMissingRequiredProperties: targetObject
		withPropertyNames: #('knowledgeBaseUid')
		path: #(#snippets 1)
		errorMessage: '@[snippets/1] required properties missing [knowledgeBaseUid]'.
	
	^ call
]

{ #category : #examples }
GtLToolForLepiterSnippetsRemoveExamples >> missingSnippetPageUid [
	<gtExample>
	| call targetObject |
	
	call := self
		executeTool: GtLToolForLepiterSnippetsRemove new
		withArguments: {
			'snippets' -> {
				Dictionary new
					at: 'knowledgeBaseUid' put: UUID new asString;
					at: 'snippetUid' put: 'invalid';
					yourself
			}
		} asDictionary.
	targetObject := call result targetObject.
	
	self
		assertMissingRequiredProperties: targetObject
		withPropertyNames: #('pageUid')
		path: #(#snippets 1)
		errorMessage: '@[snippets/1] required properties missing [pageUid]'.
	
	^ call
]

{ #category : #examples }
GtLToolForLepiterSnippetsRemoveExamples >> missingSnippetUid [
	<gtExample>
	| call targetObject |
	
	call := self
		executeTool: GtLToolForLepiterSnippetsRemove new
		withArguments: {
			'snippets' -> {
				Dictionary new
					at: 'knowledgeBaseUid' put: UUID new asString;
					at: 'pageUid' put: UUID new asString;
					yourself
			}
		} asDictionary.
	targetObject := call result targetObject.
	
	self
		assertMissingRequiredProperties: targetObject
		withPropertyNames: #('snippetUid')
		path: #(#snippets 1)
		errorMessage: '@[snippets/1] required properties missing [snippetUid]'.
	
	^ call
]

{ #category : #examples }
GtLToolForLepiterSnippetsRemoveExamples >> missingSnippets [
	<gtExample>
	| call |
	call := self
		executeTool: GtLToolForLepiterSnippetsRemove new
		withArguments: Dictionary new.
	self
		assertMissingRequiredProperties: call result targetObject
		withPropertyNames: #('snippets')
		path: #(nil)
		errorMessage: 'required properties missing [snippets]'.
	^ call
]

{ #category : #examples }
GtLToolForLepiterSnippetsRemoveExamples >> multipleSnippetRemoval [
	<gtExample>
	| contentExamples database |
	contentExamples := LeContentExamples new.
	database := contentExamples basicDatabaseWithMonitor.
	[ | call targetObject tool pageOne pageTwo snippetOne snippetTwo |
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
		call := self
			executeTool: tool
			withArguments: {
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
						yourself
				}
			} asDictionary.
		targetObject := call result targetObject.
		self assert: targetObject snippets size equals: 2.
		self assert: targetObject snippets first status equals: 'removed'.
		self assert: targetObject snippets second status equals: 'removed'.
		self assert: pageOne children isEmpty.
		self assert: pageTwo children isEmpty.
		^ call ]
		ensure: [ contentExamples stopDatabaseMonitor ]
]

{ #category : #examples }
GtLToolForLepiterSnippetsRemoveExamples >> nilKnowledgeBaseUid [
	<gtExample>
	"Test that a null knowledgeBaseUid is caught by JSON schema validation."
	| call targetObject |
	
	call := self
		executeTool: GtLToolForLepiterSnippetsRemove new
		withArguments: {
			'snippets' -> {
				Dictionary new
					at: 'knowledgeBaseUid' put: nil;
					at: 'pageUid' put: UUID new asString;
					at: 'snippetUid' put: UUID new asString;
					yourself
			}
		} asDictionary.
	targetObject := call result targetObject.
	
	"JSON schema validation returns an error for null in required string slot"
	self assert: (targetObject isKindOf: GtLJSONSchemaValidationErrorDomainObject).
	
	^ call
]

{ #category : #examples }
GtLToolForLepiterSnippetsRemoveExamples >> nilPageUid [
	<gtExample>
	"Test that a null pageUid is caught by JSON schema validation."
	| call targetObject |
	
	call := self
		executeTool: GtLToolForLepiterSnippetsRemove new
		withArguments: {
			'snippets' -> {
				Dictionary new
					at: 'knowledgeBaseUid' put: UUID new asString;
					at: 'pageUid' put: nil;
					at: 'snippetUid' put: UUID new asString;
					yourself
			}
		} asDictionary.
	targetObject := call result targetObject.
	
	"JSON schema validation returns an error for null in required string slot"
	self assert: (targetObject isKindOf: GtLJSONSchemaValidationErrorDomainObject).
	
	^ call
]

{ #category : #examples }
GtLToolForLepiterSnippetsRemoveExamples >> nilSnippetUid [
	<gtExample>
	"Test that a null snippetUid is caught by JSON schema validation."
	| call targetObject |
	
	call := self
		executeTool: GtLToolForLepiterSnippetsRemove new
		withArguments: {
			'snippets' -> {
				Dictionary new
					at: 'knowledgeBaseUid' put: UUID new asString;
					at: 'pageUid' put: UUID new asString;
					at: 'snippetUid' put: nil;
					yourself
			}
		} asDictionary.
	targetObject := call result targetObject.
	
	"JSON schema validation returns an error for null in required string slot"
	self assert: (targetObject isKindOf: GtLJSONSchemaValidationErrorDomainObject).
	
	^ call
]

{ #category : #examples }
GtLToolForLepiterSnippetsRemoveExamples >> successfulSnippetRemoval [
	<gtExample>
	| contentExamples database |
	contentExamples := LeContentExamples new.
	database := contentExamples basicDatabaseWithMonitor.
	[ | call targetObject tool page snippet |
		page := database pageBuilder
			title: 'one';
			add.
		snippet := page snippetBuilder
			string: 'Remove me';
			add.
		tool := GtLToolForLepiterSnippetsRemove new.
		tool database: database.
		call := self
			executeTool: tool
			withArguments: {
				'snippets' -> {
					Dictionary new
						at: 'knowledgeBaseUid' put: database uuidString;
						at: 'pageUid' put: page uidString;
						at: 'snippetUid' put: snippet uidString;
						yourself
				}
			} asDictionary.
		targetObject := call result targetObject.
		self assert: (targetObject isKindOf: GtLLepiterSnippetsDomainObject).
		self assert: targetObject snippets size equals: 1.
		self assert: targetObject snippets first status equals: 'removed'.
		self assert: page children isEmpty.
		^ call ]
		ensure: [ contentExamples stopDatabaseMonitor ]
]
