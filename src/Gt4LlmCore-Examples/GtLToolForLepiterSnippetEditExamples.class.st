Class {
	#name : #GtLToolForLepiterSnippetEditExamples,
	#superclass : #GtLAbstractMagritteFunctionToolExamples,
	#category : #'Gt4LlmCore-Examples-Tools'
}

{ #category : #examples }
GtLToolForLepiterSnippetEditExamples >> ambiguousSnippetIsRefused [
	"A page and snippet id pair that is in two databases (a page copied by hand) is refused, naming the databases. With the databaseId, only the snippet of that database is edited"

	<gtExample>
	^ GtLToolForLepiterSnippetsEditExamples new
		withCopiedPageInTwoDatabasesDo: [ :aLogicalDatabase :theDatabases :theSnippets | 
			| tool arguments call result |
			tool := GtLToolForLepiterSnippetEdit new
					database: aLogicalDatabase;
					yourself.
			arguments := Dictionary new
					at: 'pageUid' put: theSnippets first page uidString;
					at: 'snippetUid' put: theSnippets first uidString;
					at: 'updatedText' put: 'Edited text';
					yourself.
			result := (self
					executeTool: tool
					withArguments: {'snippetEdit' -> arguments} asDictionary) result
					targetObject.
			self assert: (result isKindOf: GtLProblemDomainObject).
			self
				assert: (result errorMessage includesSubstring: 'are in several databases').
			self
				assert: (theSnippets allSatisfy: [ :each | each string = 'Copied text' ]).
			arguments at: 'databaseId' put: theDatabases second uuidString.
			call := self
					executeTool: tool
					withArguments: {'snippetEdit' -> arguments} asDictionary.
			result := call result targetObject.
			self assert: result status equals: 'updated'.
			self
				assert: result targetSnippetReference databaseId
				equals: theDatabases second uuidString.
			self assert: theSnippets first string equals: 'Copied text'.
			self assert: theSnippets second string equals: 'Edited text'.
			call ]
]

{ #category : #examples }
GtLToolForLepiterSnippetEditExamples >> emptyPageUid [
	<gtExample>
	| call |
	call := self
			executeTool: GtLToolForLepiterSnippetEdit new
			withArguments: {'snippetEdit'
						-> {'pageUid' -> ''.
								'snippetUid' -> 'someSnippetUid'.
								'updatedText' -> 'Updated text'} asDictionary} asDictionary.
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
			withArguments: {'snippetEdit'
						-> {'pageUid' -> UUID new asString.
								'snippetUid' -> ''.
								'updatedText' -> 'Updated text'} asDictionary} asDictionary.
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
	snippetUid := LeUID new
			uidString: UUID new asString;
			uidString.
	call := self
			executeTool: GtLToolForLepiterSnippetEdit new
			withArguments: {'snippetEdit'
						-> {'pageUid' -> pageUid.
								'snippetUid' -> snippetUid.
								'updatedText' -> ''} asDictionary} asDictionary.
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
			withArguments: {'snippetEdit'
						-> {'snippetUid' -> 'invalid'.
								'updatedText' -> 'Updated text'} asDictionary} asDictionary.
	self
		assertMissingRequiredProperties: call result targetObject
		withPropertyNames: #('pageUid')
		path: #('snippetEdit')
		errorMessage: '@[snippetEdit] required properties missing [pageUid]'.
	^ call
]

{ #category : #examples }
GtLToolForLepiterSnippetEditExamples >> missingSnippetUid [
	<gtExample>
	| call |
	call := self
			executeTool: GtLToolForLepiterSnippetEdit new
			withArguments: {'snippetEdit'
						-> {'pageUid' -> UUID new asString.
								'updatedText' -> 'Updated text'} asDictionary} asDictionary.
	self
		assertMissingRequiredProperties: call result targetObject
		withPropertyNames: #('snippetUid')
		path: #('snippetEdit')
		errorMessage: '@[snippetEdit] required properties missing [snippetUid]'.
	^ call
]

{ #category : #examples }
GtLToolForLepiterSnippetEditExamples >> missingUpdatedText [
	<gtExample>
	| call snippetUid |
	snippetUid := LeUID new
			uidString: UUID new asString;
			uidString.
	call := self
			executeTool: GtLToolForLepiterSnippetEdit new
			withArguments: {'snippetEdit'
						-> {'pageUid' -> UUID new asString.
								'snippetUid' -> snippetUid} asDictionary} asDictionary.
	self
		assertMissingRequiredProperties: call result targetObject
		withPropertyNames: #('updatedText')
		path: #('snippetEdit')
		errorMessage: '@[snippetEdit] required properties missing [updatedText]'.
	^ call
]

{ #category : #examples }
GtLToolForLepiterSnippetEditExamples >> nestedRequestSchema [
	"editLepiterSnippet takes one edit request, snippetEdit, of the class that editLepiterSnippets takes a list of"

	<gtExample>
	| schema request |
	schema := GtLToolForLepiterSnippetEdit new parametersJsonSchemaDictionary.
	self assert: (schema at: 'required') asArray equals: #('snippetEdit').
	request := (schema at: 'properties') at: 'snippetEdit'.
	self
		assert: (request at: 'required') asSortedCollection asArray
		equals: #('pageUid' 'snippetUid' 'updatedText').
	self assert: ((request at: 'properties') includesKey: 'databaseId').
	^ schema
]

{ #category : #examples }
GtLToolForLepiterSnippetEditExamples >> nilPageUid [
	<gtExample>
	| call |
	call := self
			executeTool: GtLToolForLepiterSnippetEdit new
			withArguments: {'snippetEdit'
						-> {'pageUid' -> nil.
								'snippetUid' -> 'someSnippetUid'.
								'updatedText' -> 'Updated text'} asDictionary} asDictionary.
	self
		assertJSONSchemaValidationError: call result targetObject
		withPath: #('snippetEdit' 'pageUid')
		errorMessage: '@[snippetEdit/pageUid] string expected'.
	^ call
]

{ #category : #examples }
GtLToolForLepiterSnippetEditExamples >> nilSnippetUid [
	<gtExample>
	| call |
	call := self
			executeTool: GtLToolForLepiterSnippetEdit new
			withArguments: {'snippetEdit'
						-> {'pageUid' -> UUID new asString.
								'snippetUid' -> nil.
								'updatedText' -> 'Updated text'} asDictionary} asDictionary.
	self
		assertJSONSchemaValidationError: call result targetObject
		withPath: #('snippetEdit' 'snippetUid')
		errorMessage: '@[snippetEdit/snippetUid] string expected'.
	^ call
]

{ #category : #examples }
GtLToolForLepiterSnippetEditExamples >> nilUpdatedText [
	<gtExample>
	| call snippetUid |
	snippetUid := LeUID new
			uidString: UUID new asString;
			uidString.
	call := self
			executeTool: GtLToolForLepiterSnippetEdit new
			withArguments: {'snippetEdit'
						-> {'pageUid' -> UUID new asString.
								'snippetUid' -> snippetUid.
								'updatedText' -> nil} asDictionary} asDictionary.
	self
		assertJSONSchemaValidationError: call result targetObject
		withPath: #('snippetEdit' 'updatedText')
		errorMessage: '@[snippetEdit/updatedText] string expected'.
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
			withArguments: {'snippetEdit'
						-> {'pageUid' -> page uidString.
								'snippetUid' -> exampleSnippet uidString.
								'updatedText' -> 'Some text'} asDictionary} asDictionary.
	problem := call result targetObject.
	self assert: (problem isKindOf: GtLProblemDomainObject).
	self assert: (problem errorMessage includesSubstring: 'of type example').
	self assert: (problem errorMessage includesSubstring: 'removeLepiterSnippets').
	self assert: exampleSnippet exampleSelector equals: #successfulSnippetEdit.
	problem := (self
			executeTool: tool
			withArguments: {'snippetEdit'
						-> {'pageUid' -> page uidString.
								'snippetUid' -> unknownSnippet uidString.
								'updatedText' -> 'Some text'} asDictionary} asDictionary) result
			targetObject.
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
			withArguments: {'snippetEdit'
						-> {'pageUid' -> page uidString.
								'snippetUid' -> snippet uidString.
								'updatedText' -> updatedText} asDictionary} asDictionary.
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
