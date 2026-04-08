Class {
	#name : #GtLToolForLepiterSnippetEditExamples,
	#superclass : #GtLAbstractMagritteFunctionToolExamples,
	#category : #'Gt4LlmCore-Examples-Tools'
}

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
GtLToolForLepiterSnippetEditExamples >> successfulSnippetEdit [
	<gtExample>
	| call database page snippet updatedText tool targetObject |
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
		withArguments: {
			'pageUid' -> page uidString.
			'snippetUid' -> snippet uidString.
			'updatedText' -> updatedText
		} asDictionary.
	targetObject := call result targetObject.
	self assert: (targetObject isKindOf: GtLLepiterSnippetEditDomainObject).
	self assert: targetObject status equals: 'updated'.
	self assert: targetObject oldText equals: 'one > one'.
	self assert: snippet string equals: updatedText.
	^ call
]
