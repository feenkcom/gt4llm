Class {
	#name : #GtLToolForLepiterSnippetEditExamples,
	#superclass : #Object,
	#traits : 'TGtLInvalidInputDataAssertions',
	#classTraits : 'TGtLInvalidInputDataAssertions classTrait',
	#category : #'Gt4LlmCore-Examples-Tools'
}

{ #category : #'examples - errors' }
GtLToolForLepiterSnippetEditExamples >> emptyPageUid [
	<gtExample>
	| tool call result domainObject |
	tool := GtLToolForLepiterSnippetEdit new.
	call := GtLFunctionToolCall new.
	call rawArguments: {
		'pageUid' -> ''.
		'snippetUid' -> 'someSnippetUid'.
		'updatedText' -> 'Updated text' } asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	
	domainObject := result targetObject.
	self
		assertMissingArgument: domainObject
		withArgumentName: 'pageUid'
		errorMessage: 'Missing argument called pageUid'.
	^ domainObject
]

{ #category : #'examples - errors' }
GtLToolForLepiterSnippetEditExamples >> emptySnippetUid [
	<gtExample>
	| tool call result domainObject |
	tool := GtLToolForLepiterSnippetEdit new.
	call := GtLFunctionToolCall new.
	call rawArguments: {
		'pageUid' -> (UUID new asString).
		'snippetUid' -> ''.
		'updatedText' -> 'Updated text' } asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	
	domainObject := result targetObject.
	self
		assertMissingArgument: domainObject
		withArgumentName: 'snippetUid'
		errorMessage: 'Missing argument called snippetUid'.
	^ domainObject
]

{ #category : #'examples - errors' }
GtLToolForLepiterSnippetEditExamples >> emptyUpdatedText [
	<gtExample>
	| tool call result domainObject pageUid snippetUid |
	tool := GtLToolForLepiterSnippetEdit new.
	pageUid := UUID new asString.
	snippetUid := (LeUID new uidString: (UUID new asString); uidString).
	call := GtLFunctionToolCall new.
	call rawArguments: {
		'pageUid' -> pageUid.
		'snippetUid' -> snippetUid.
		'updatedText' -> '' } asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	
	domainObject := result targetObject.
	self
		assertMissingArgument: domainObject
		withArgumentName: 'updatedText'
		errorMessage: 'Missing argument called updatedText'.
	^ domainObject
]

{ #category : #'examples - errors' }
GtLToolForLepiterSnippetEditExamples >> missingPageUid [
	<gtExample>
	| tool call result domainObject |
	tool := GtLToolForLepiterSnippetEdit new.
	call := GtLFunctionToolCall new.
	call rawArguments: {
		'snippetUid' -> 'invalid'.
		'updatedText' -> 'Updated text' } asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	
	domainObject := result targetObject.
	self
		assertMissingRequiredProperties: domainObject
		withPropertyNames: #('pageUid')
		path: #(nil)
		errorMessage: 'required properties missing [pageUid]'.
	
	^ domainObject
]

{ #category : #'examples - errors' }
GtLToolForLepiterSnippetEditExamples >> missingSnippetUid [
	<gtExample>
	| tool call result domainObject |
	tool := GtLToolForLepiterSnippetEdit new.
	call := GtLFunctionToolCall new.
	call rawArguments: {
		'pageUid' -> (UUID new asString).
		'updatedText' -> 'Updated text' } asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	
	domainObject := result targetObject.
	self
		assertMissingRequiredProperties: domainObject
		withPropertyNames: #('snippetUid')
		path: #(nil)
		errorMessage: 'required properties missing [snippetUid]'.
	
	^ domainObject
]

{ #category : #'examples - errors' }
GtLToolForLepiterSnippetEditExamples >> missingUpdatedText [
	<gtExample>
	| tool call result domainObject |
	tool := GtLToolForLepiterSnippetEdit new.
	call := GtLFunctionToolCall new.
	call rawArguments: {
		'pageUid' -> (UUID new asString).
		'snippetUid' -> (LeUID new uidString: (UUID new asString); uidString) } asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GTLDataViewWrapperModel).

	domainObject := result targetObject.
	self
		assertMissingRequiredProperties: domainObject
		withPropertyNames: #('updatedText')
		path: #(nil)
		errorMessage: 'required properties missing [updatedText]'.
	
	^ domainObject
]

{ #category : #'examples - errors' }
GtLToolForLepiterSnippetEditExamples >> nilPageUid [
	<gtExample>
	| tool call result domainObject |
	tool := GtLToolForLepiterSnippetEdit new.
	call := GtLFunctionToolCall new.
	call rawArguments: '{"pageUid": null, "snippetUid": "someSnippetUid", "updatedText": "Updated text"}'.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	
	domainObject := result targetObject.
	self
		assertJSONSchemaValidationError: domainObject
		withPath: #('pageUid')
		errorMessage: '@[pageUid] string expected'.
	^ domainObject
]

{ #category : #'examples - errors' }
GtLToolForLepiterSnippetEditExamples >> nilSnippetUid [
	<gtExample>
	| tool call result domainObject |
	tool := GtLToolForLepiterSnippetEdit new.
	call := GtLFunctionToolCall new.
	call rawArguments: '{"pageUid": "', (UUID new asString), '", "snippetUid": null, "updatedText": "Updated text"}'.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	
	domainObject := result targetObject.
	self
		assertJSONSchemaValidationError: domainObject
		withPath: #('snippetUid')
		errorMessage: '@[snippetUid] string expected'.
	^ domainObject
]

{ #category : #'examples - errors' }
GtLToolForLepiterSnippetEditExamples >> nilUpdatedText [
	<gtExample>
	| tool call result domainObject pageUid snippetUid |
	tool := GtLToolForLepiterSnippetEdit new.
	pageUid := UUID new asString.
	snippetUid := (LeUID new uidString: (UUID new asString); uidString).
	call := GtLFunctionToolCall new.
	call rawArguments: '{"pageUid": "', pageUid, '", "snippetUid": "', snippetUid, '", "updatedText": null}'.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	
	domainObject := result targetObject.
	self
		assertJSONSchemaValidationError: domainObject
		withPath: #('updatedText')
		errorMessage: '@[updatedText] string expected'.
	^ domainObject
]

{ #category : #examples }
GtLToolForLepiterSnippetEditExamples >> successfulSnippetEdit [
	<gtExample>
	| database page snippet updatedText tool call result domainObject |
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
	call := GtLFunctionToolCall new.
	call rawArguments: {
		'pageUid' -> page uidString.
		'snippetUid' -> snippet uidString.
		'updatedText' -> updatedText } asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	domainObject := result targetObject.
	self assert: (domainObject isKindOf: GtLLepiterSnippetEditDomainObject).
	self assert: domainObject status equals: 'updated'.
	self assert: domainObject oldText equals: 'one > one'.
	self assert: snippet string equals: updatedText.
	^ domainObject
]
