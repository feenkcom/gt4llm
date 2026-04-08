Class {
	#name : #GtLToolForLepiterSnippetEditExamples,
	#superclass : #GtLAbstractMagritteFunctionToolExamples,
	#category : 'Gt4LlmCore-Examples-Tools'
}

{ #category : #examples }
GtLToolForLepiterSnippetEditExamples >> emptyPageUid [
	<gtExample>
	| targetObject |
	
	targetObject := self
		executeTool: GtLToolForLepiterSnippetEdit new
		withArguments: {
			'pageUid' -> ''.
			'snippetUid' -> 'someSnippetUid'.
			'updatedText' -> 'Updated text'
		} asDictionary.
	
	self
		assertMissingArgument: targetObject
		withArgumentName: 'pageUid'
		errorMessage: 'Missing argument called pageUid'.
	
	^ targetObject
]

{ #category : #examples }
GtLToolForLepiterSnippetEditExamples >> emptySnippetUid [
	<gtExample>
	| targetObject |
	
	targetObject := self
		executeTool: GtLToolForLepiterSnippetEdit new
		withArguments: {
			'pageUid' -> UUID new asString.
			'snippetUid' -> ''.
			'updatedText' -> 'Updated text'
		} asDictionary.
	
	self
		assertMissingArgument: targetObject
		withArgumentName: 'snippetUid'
		errorMessage: 'Missing argument called snippetUid'.
	
	^ targetObject
]

{ #category : #examples }
GtLToolForLepiterSnippetEditExamples >> emptyUpdatedText [
	<gtExample>
	| targetObject pageUid snippetUid |
	pageUid := UUID new asString.
	snippetUid := LeUID new uidString: UUID new asString; uidString.
	
	targetObject := self
		executeTool: GtLToolForLepiterSnippetEdit new
		withArguments: {
			'pageUid' -> pageUid.
			'snippetUid' -> snippetUid.
			'updatedText' -> ''
		} asDictionary.
	
	self
		assertMissingArgument: targetObject
		withArgumentName: 'updatedText'
		errorMessage: 'Missing argument called updatedText'.
	
	^ targetObject
]

{ #category : #examples }
GtLToolForLepiterSnippetEditExamples >> missingPageUid [
	<gtExample>
	| targetObject |
	
	targetObject := self
		executeTool: GtLToolForLepiterSnippetEdit new
		withArguments: {
			'snippetUid' -> 'invalid'.
			'updatedText' -> 'Updated text'
		} asDictionary.
	
	self
		assertMissingRequiredProperties: targetObject
		withPropertyNames: #('pageUid')
		path: #(nil)
		errorMessage: 'required properties missing [pageUid]'.
	
	^ targetObject
]

{ #category : #examples }
GtLToolForLepiterSnippetEditExamples >> missingSnippetUid [
	<gtExample>
	| targetObject |
	
	targetObject := self
		executeTool: GtLToolForLepiterSnippetEdit new
		withArguments: {
			'pageUid' -> UUID new asString.
			'updatedText' -> 'Updated text'
		} asDictionary.
	
	self
		assertMissingRequiredProperties: targetObject
		withPropertyNames: #('snippetUid')
		path: #(nil)
		errorMessage: 'required properties missing [snippetUid]'.
	
	^ targetObject
]

{ #category : #examples }
GtLToolForLepiterSnippetEditExamples >> missingUpdatedText [
	<gtExample>
	| targetObject snippetUid |
	snippetUid := LeUID new uidString: UUID new asString; uidString.
	
	targetObject := self
		executeTool: GtLToolForLepiterSnippetEdit new
		withArguments: {
			'pageUid' -> UUID new asString.
			'snippetUid' -> snippetUid
		} asDictionary.
	
	self
		assertMissingRequiredProperties: targetObject
		withPropertyNames: #('updatedText')
		path: #(nil)
		errorMessage: 'required properties missing [updatedText]'.
	
	^ targetObject
]

{ #category : #examples }
GtLToolForLepiterSnippetEditExamples >> nilPageUid [
	<gtExample>
	| targetObject |
	
	targetObject := self
		executeTool: GtLToolForLepiterSnippetEdit new
		withArguments: {
			'pageUid' -> nil.
			'snippetUid' -> 'someSnippetUid'.
			'updatedText' -> 'Updated text'
		} asDictionary.
	
	self
		assertJSONSchemaValidationError: targetObject
		withPath: #('pageUid')
		errorMessage: '@[pageUid] string expected'.
	
	^ targetObject
]

{ #category : #examples }
GtLToolForLepiterSnippetEditExamples >> nilSnippetUid [
	<gtExample>
	| targetObject |
	
	targetObject := self
		executeTool: GtLToolForLepiterSnippetEdit new
		withArguments: {
			'pageUid' -> UUID new asString.
			'snippetUid' -> nil.
			'updatedText' -> 'Updated text'
		} asDictionary.
	
	self
		assertJSONSchemaValidationError: targetObject
		withPath: #('snippetUid')
		errorMessage: '@[snippetUid] string expected'.
	
	^ targetObject
]

{ #category : #examples }
GtLToolForLepiterSnippetEditExamples >> nilUpdatedText [
	<gtExample>
	| targetObject snippetUid |
	snippetUid := LeUID new uidString: UUID new asString; uidString.
	
	targetObject := self
		executeTool: GtLToolForLepiterSnippetEdit new
		withArguments: {
			'pageUid' -> UUID new asString.
			'snippetUid' -> snippetUid.
			'updatedText' -> nil
		} asDictionary.
	
	self
		assertJSONSchemaValidationError: targetObject
		withPath: #('updatedText')
		errorMessage: '@[updatedText] string expected'.
	
	^ targetObject
]

{ #category : #examples }
GtLToolForLepiterSnippetEditExamples >> successfulSnippetEdit [
	<gtExample>
	| targetObject database page snippet updatedText tool |
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
	
	targetObject := self
		executeTool: tool
		withArguments: {
			'pageUid' -> page uidString.
			'snippetUid' -> snippet uidString.
			'updatedText' -> updatedText
		} asDictionary.
	
	self assert: (targetObject isKindOf: GtLLepiterSnippetEditDomainObject).
	self assert: targetObject status equals: 'updated'.
	self assert: targetObject oldText equals: 'one > one'.
	self assert: snippet string equals: updatedText.
	
	^ targetObject
]
