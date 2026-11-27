Class {
	#name : #GtLToolForLepiterSnippetEditExamples,
	#superclass : #GtLAbstractMagritteFunctionToolExamples,
	#category : #'Gt4LlmCore-Examples-Tools'
}

{ #category : #examples }
GtLToolForLepiterSnippetEditExamples >> ambiguousSnippetIsRefused [
	"A page and snippet id pair that is in two databases (a page copied by hand) is refused, naming the databases. With the databaseId, only the snippet of that database is edited"

	<gtExample>
	| databases pageUid snippets logicalDatabase tool arguments call result |
	databases := #('one' 'two')
			collect: [ :aName | 
				| aFolder aStore |
				aFolder := FileSystem memory / aName.
				aFolder ensureCreateDirectory.
				aStore := LeLocalStoreLoad current.
				aStore localRoot: aFolder.
				aStore loadAndMonitorFrom: aFolder ].
	[ pageUid := UUID new.
	snippets := databases
			collect: [ :aDatabase | 
				| aPage aSnippet |
				aPage := (LePage named: 'Copied page')
						basicUid: pageUid;
						yourself.
				aDatabase addPage: aPage.
				aSnippet := LeTextSnippet string: 'Copied text'.
				aPage addSnippet: aSnippet.
				aSnippet ].
	snippets second uid: snippets first uid.
	logicalDatabase := LeLogicalDatabase new
			primaryDB: databases first;
			addDB: databases second;
			yourself.
	tool := GtLToolForLepiterSnippetEdit new.
	tool database: logicalDatabase.
	arguments := Dictionary new
			at: 'pageUid' put: pageUid asString36;
			at: 'snippetUid' put: snippets first uid uidString;
			at: 'updatedText' put: 'Edited text';
			yourself.
	result := (self executeTool: tool withArguments: arguments) result targetObject.
	self assert: (result isKindOf: GtLProblemDomainObject).
	self
		assert: (result errorMessage includesSubstring: 'are in several databases').
	self assert: (snippets allSatisfy: [ :each | each string = 'Copied text' ]).
	arguments at: 'databaseId' put: databases second uuidString.
	call := self executeTool: tool withArguments: arguments.
	result := call result targetObject.
	self assert: result status equals: 'updated'.
	self
		assert: result targetSnippetReference databaseId
		equals: databases second uuidString.
	self assert: snippets first string equals: 'Copied text'.
	self assert: snippets second string equals: 'Edited text' ]
		ensure: [ databases do: [ :each | each stopMonitoring ] ].
	^ call
]

{ #category : #examples }
GtLToolForLepiterSnippetEditExamples >> emptyPageUid [
	<gtExample>
	| call |
	call := self
		executeTool: GtLToolForLepiterSnippetEdit new
		withArguments: {
			'pageUid' -> ''.
			'snippetUid' -> 'someSnippetUid'.
			'updatedText' -> 'Updated text'
		} asDictionary.
	self
		assertMissingArgument: call result targetObject
		withArgumentName: 'pageUid'
		errorMessage: 'Missing argument called pageUid'.
	^ call
]

{ #category : #examples }
GtLToolForLepiterSnippetEditExamples >> emptySnippetUid [
	<gtExample>
	| call |
	call := self
		executeTool: GtLToolForLepiterSnippetEdit new
		withArguments: {
			'pageUid' -> UUID new asString.
			'snippetUid' -> ''.
			'updatedText' -> 'Updated text'
		} asDictionary.
	self
		assertMissingArgument: call result targetObject
		withArgumentName: 'snippetUid'
		errorMessage: 'Missing argument called snippetUid'.
	^ call
]

{ #category : #examples }
GtLToolForLepiterSnippetEditExamples >> emptyUpdatedText [
	<gtExample>
	| call pageUid snippetUid |
	pageUid := UUID new asString.
	snippetUid := LeUID new uidString: UUID new asString; uidString.
	call := self
		executeTool: GtLToolForLepiterSnippetEdit new
		withArguments: {
			'pageUid' -> pageUid.
			'snippetUid' -> snippetUid.
			'updatedText' -> ''
		} asDictionary.
	self
		assertMissingArgument: call result targetObject
		withArgumentName: 'updatedText'
		errorMessage: 'Missing argument called updatedText'.
	^ call
]

{ #category : #examples }
GtLToolForLepiterSnippetEditExamples >> missingPageUid [
	<gtExample>
	| call |
	call := self
		executeTool: GtLToolForLepiterSnippetEdit new
		withArguments: {
			'snippetUid' -> 'invalid'.
			'updatedText' -> 'Updated text'
		} asDictionary.
	self
		assertMissingRequiredProperties: call result targetObject
		withPropertyNames: #('pageUid')
		path: #(nil)
		errorMessage: 'required properties missing [pageUid]'.
	^ call
]

{ #category : #examples }
GtLToolForLepiterSnippetEditExamples >> missingSnippetUid [
	<gtExample>
	| call |
	call := self
		executeTool: GtLToolForLepiterSnippetEdit new
		withArguments: {
			'pageUid' -> UUID new asString.
			'updatedText' -> 'Updated text'
		} asDictionary.
	self
		assertMissingRequiredProperties: call result targetObject
		withPropertyNames: #('snippetUid')
		path: #(nil)
		errorMessage: 'required properties missing [snippetUid]'.
	^ call
]

{ #category : #examples }
GtLToolForLepiterSnippetEditExamples >> missingUpdatedText [
	<gtExample>
	| call snippetUid |
	snippetUid := LeUID new uidString: UUID new asString; uidString.
	call := self
		executeTool: GtLToolForLepiterSnippetEdit new
		withArguments: {
			'pageUid' -> UUID new asString.
			'snippetUid' -> snippetUid
		} asDictionary.
	self
		assertMissingRequiredProperties: call result targetObject
		withPropertyNames: #('updatedText')
		path: #(nil)
		errorMessage: 'required properties missing [updatedText]'.
	^ call
]

{ #category : #examples }
GtLToolForLepiterSnippetEditExamples >> nilPageUid [
	<gtExample>
	| call |
	call := self
		executeTool: GtLToolForLepiterSnippetEdit new
		withArguments: {
			'pageUid' -> nil.
			'snippetUid' -> 'someSnippetUid'.
			'updatedText' -> 'Updated text'
		} asDictionary.
	self
		assertJSONSchemaValidationError: call result targetObject
		withPath: #('pageUid')
		errorMessage: '@[pageUid] string expected'.
	^ call
]

{ #category : #examples }
GtLToolForLepiterSnippetEditExamples >> nilSnippetUid [
	<gtExample>
	| call |
	call := self
		executeTool: GtLToolForLepiterSnippetEdit new
		withArguments: {
			'pageUid' -> UUID new asString.
			'snippetUid' -> nil.
			'updatedText' -> 'Updated text'
		} asDictionary.
	self
		assertJSONSchemaValidationError: call result targetObject
		withPath: #('snippetUid')
		errorMessage: '@[snippetUid] string expected'.
	^ call
]

{ #category : #examples }
GtLToolForLepiterSnippetEditExamples >> nilUpdatedText [
	<gtExample>
	| call snippetUid |
	snippetUid := LeUID new uidString: UUID new asString; uidString.
	call := self
		executeTool: GtLToolForLepiterSnippetEdit new
		withArguments: {
			'pageUid' -> UUID new asString.
			'snippetUid' -> snippetUid.
			'updatedText' -> nil
		} asDictionary.
	self
		assertJSONSchemaValidationError: call result targetObject
		withPath: #('updatedText')
		errorMessage: '@[updatedText] string expected'.
	^ call
]

{ #category : #examples }
GtLToolForLepiterSnippetEditExamples >> nonTextualSnippetEditIsRefused [
	"An example snippet has no text: the edit is refused with an errorMessage that names its type and what to do, and the snippet is unchanged. An unknown snippet is refused too"

	<gtExample>
	| call database page exampleSnippet unknownSnippet tool problem |
	database := LeContentExamples new basicDatabase.
	page := database pageBuilder
			title: 'one';
			add.
	exampleSnippet := LeExampleSnippet new
			exampleBehaviorName: self class name;
			exampleSelector: #successfulSnippetEdit;
			yourself.
	page addSnippet: exampleSnippet.
	unknownSnippet := LeUnknownSnippet new.
	page addSnippet: unknownSnippet.
	tool := GtLToolForLepiterSnippetEdit new.
	tool database: database.
	call := self
			executeTool: tool
			withArguments: {'pageUid' -> page uidString.
					'snippetUid' -> exampleSnippet uidString.
					'updatedText' -> 'Some text'} asDictionary.
	problem := call result targetObject.
	self assert: (problem isKindOf: GtLProblemDomainObject).
	self assert: (problem errorMessage includesSubstring: 'of type example').
	self assert: (problem errorMessage includesSubstring: 'removeLepiterSnippets').
	self assert: exampleSnippet exampleSelector equals: #successfulSnippetEdit.
	problem := (self
			executeTool: tool
			withArguments: {'pageUid' -> page uidString.
					'snippetUid' -> unknownSnippet uidString.
					'updatedText' -> 'Some text'} asDictionary) result targetObject.
	self assert: (problem isKindOf: GtLProblemDomainObject).
	self assert: (problem errorMessage includesSubstring: 'unknown type').
	^ call
]

{ #category : #examples }
GtLToolForLepiterSnippetEditExamples >> successfulSnippetEdit [
	<gtExample>
	| call database page snippet updatedText tool result |
	database := LeContentExamples new basicDatabase.
	page := database pageBuilder
			title: 'one';
			add.
	snippet := page snippetBuilder
			string: 'one > one';
			add.
	updatedText := 'Updated snippet text'.
	tool := GtLToolForLepiterSnippetEdit new.
	tool database: database.
	call := self
			executeTool: tool
			withArguments: {'pageUid' -> page uidString.
					'snippetUid' -> snippet uidString.
					'updatedText' -> updatedText} asDictionary.
	result := call result targetObject.
	self assert: (result isKindOf: GtLLepiterSnippetModificationResult).
	self assert: result status equals: 'updated'.
	self assert: result oldSnippet contentString equals: 'one > one'.
	self assert: result newSnippet contentString equals: updatedText.
	self assert: result targetSnippetReference pageUid equals: page uidString.
	self assert: snippet string equals: updatedText.
	self
		assert: (self jsonOf: call)
		equals: (Dictionary new
				at: 'status' put: 'updated';
				at: 'targetSnippetReference'
					put: (Dictionary new
							at: 'pageUid' put: page uidString;
							at: 'snippetUid' put: snippet uidString;
							yourself);
				yourself).
	^ call
]
