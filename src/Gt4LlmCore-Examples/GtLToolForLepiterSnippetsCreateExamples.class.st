Class {
	#name : #GtLToolForLepiterSnippetsCreateExamples,
	#superclass : #Object,
	#traits : 'TGtLInvalidInputDataAssertions',
	#classTraits : 'TGtLInvalidInputDataAssertions classTrait',
	#instVars : [
		'logicalDatabase'
	],
	#category : 'Gt4LlmCore-Examples-Tools'
}

{ #category : #'examples - errors' }
GtLToolForLepiterSnippetsCreateExamples >> allSnippetsWithErrors [
	<gtExample>
	"Creates multiple snippets where all fail with different errors"
	| tool call result page domainObject |
	tool := self toolOnLogicalDatabase.
	page := self pageInLogicalDatabase.
	call := GtLFunctionToolCall new.
	call rawArguments: {
		'snippets' -> {
			Dictionary new
				at: 'TextSnippet'
				put: (Dictionary new
					at: 'pageUid' put: page uidString;
					at: 'snippetText' put: '';
					yourself);
				yourself.
			Dictionary new
				at: 'PharoSnippet'
				put: (Dictionary new
					at: 'pageUid' put: page uidString;
					at: 'pharoCode' put: '';
					yourself);
				yourself.
			Dictionary new
				at: 'PythonSnippet'
				put: (Dictionary new
					at: 'pageUid' put: page uidString;
					at: 'pythonCode' put: '';
					yourself);
				yourself.
			Dictionary new
				at: 'ShellSnippet'
				put: (Dictionary new
					at: 'pageUid' put: page uidString;
					at: 'shellCode' put: '';
					yourself);
				yourself } } asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	domainObject := result targetObject.
	self assert: domainObject snippets size equals: 4.
	self assert: (domainObject snippets allSatisfy: [ :each | each isKindOf: GtLMissingArgumentDomainObject ]).
	^ domainObject
]

{ #category : #'examples - errors' }
GtLToolForLepiterSnippetsCreateExamples >> emptyExampleClassName [
	<gtExample>
	| tool call result page domainObject |
	tool := self toolOnLogicalDatabase.
	page := self pageInLogicalDatabase.
	call := GtLFunctionToolCall new.
	call rawArguments: {
		'snippets' -> {
			Dictionary new
				at: 'ExampleSnippet'
				put: (Dictionary new
					at: 'pageUid' put: page uidString;
					at: 'exampleClassName' put: '';
					at: 'exampleMethodName' put: #someMethod;
					yourself);
				yourself } } asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	domainObject := result targetObject.
	self
		assertMissingArgument: domainObject snippets first
		withArgumentName: 'exampleClassName'
		errorMessage: 'Missing argument called exampleClassName'.
	^ domainObject
]

{ #category : #'examples - errors' }
GtLToolForLepiterSnippetsCreateExamples >> emptyExampleMethodName [
	<gtExample>
	| tool call result page domainObject |
	tool := self toolOnLogicalDatabase.
	page := self pageInLogicalDatabase.
	call := GtLFunctionToolCall new.
	call rawArguments: {
		'snippets' -> {
			Dictionary new
				at: 'ExampleSnippet'
				put: (Dictionary new
					at: 'pageUid' put: page uidString;
					at: 'exampleClassName' put: 'SomeClass';
					at: 'exampleMethodName' put: '';
					yourself);
				yourself } } asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	domainObject := result targetObject.
	self
		assertMissingArgument: domainObject snippets first
		withArgumentName: 'exampleMethodName'
		errorMessage: 'Missing argument called exampleMethodName'.
	^ domainObject
]

{ #category : #'examples - errors' }
GtLToolForLepiterSnippetsCreateExamples >> emptyPharoCode [
	<gtExample>
	| tool call result page domainObject |
	tool := self toolOnLogicalDatabase.
	page := self pageInLogicalDatabase.
	call := GtLFunctionToolCall new.
	call rawArguments: {
		'snippets' -> {
			Dictionary new
				at: 'PharoSnippet'
				put: (Dictionary new
					at: 'pageUid' put: page uidString;
					at: 'pharoCode' put: '';
					yourself);
				yourself } } asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	domainObject := result targetObject.
	self
		assertMissingArgument: domainObject snippets first
		withArgumentName: 'snippetText'
		errorMessage: 'Missing argument called snippetText'.
	^ domainObject
]

{ #category : #'examples - errors' }
GtLToolForLepiterSnippetsCreateExamples >> emptyPythonCode [
	<gtExample>
	| tool call result page domainObject |
	tool := self toolOnLogicalDatabase.
	page := self pageInLogicalDatabase.
	call := GtLFunctionToolCall new.
	call rawArguments: {
		'snippets' -> {
			Dictionary new
				at: 'PythonSnippet'
				put: (Dictionary new
					at: 'pageUid' put: page uidString;
					at: 'pythonCode' put: '';
					yourself);
				yourself } } asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	domainObject := result targetObject.
	self
		assertMissingArgument: domainObject snippets first
		withArgumentName: 'snippetText'
		errorMessage: 'Missing argument called snippetText'.
	^ domainObject
]

{ #category : #'examples - errors' }
GtLToolForLepiterSnippetsCreateExamples >> emptyShellCode [
	<gtExample>
	| tool call result page domainObject |
	tool := self toolOnLogicalDatabase.
	page := self pageInLogicalDatabase.
	call := GtLFunctionToolCall new.
	call rawArguments: {
		'snippets' -> {
			Dictionary new
				at: 'ShellSnippet'
				put: (Dictionary new
					at: 'pageUid' put: page uidString;
					at: 'shellCode' put: '';
					yourself);
				yourself } } asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	domainObject := result targetObject.
	self
		assertMissingArgument: domainObject snippets first
		withArgumentName: 'snippetText'
		errorMessage: 'Missing argument called snippetText'.
	^ domainObject
]

{ #category : #examples }
GtLToolForLepiterSnippetsCreateExamples >> logicalDatabase [
	<gtExample>
	^ logicalDatabase
		ifNil: [ | db |
			db := LeExplicitlyAttachedLinksExamples new primaryDatabase.
			logicalDatabase := LeLogicalDatabase new primaryDB: db.
			self assert: logicalDatabase primaryDB equals: db.
			logicalDatabase ]
]

{ #category : #'examples - errors' }
GtLToolForLepiterSnippetsCreateExamples >> missingSnippetPageUid [
	<gtExample>
	| tool call result domainObject |
	tool := self toolOnLogicalDatabase.
	call := GtLFunctionToolCall new.
	call rawArguments: {
		'snippets' -> {
			Dictionary new
				at: 'TextSnippet'
				put: (Dictionary new
					at: 'pageUid' put: '';
					at: 'snippetText' put: 'Updated text';
					yourself);
				yourself } } asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	domainObject := result targetObject.
	self
		assertMissingArgument: domainObject snippets first
		withArgumentName: 'pageUid'
		errorMessage: 'Missing argument called pageUid'.
	^ domainObject
]

{ #category : #'examples - errors' }
GtLToolForLepiterSnippetsCreateExamples >> missingSnippets [
	<gtExample>
	| tool call result domainObject |
	tool := GtLToolForLepiterSnippetsCreate new.
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

{ #category : #'examples - errors' }
GtLToolForLepiterSnippetsCreateExamples >> missingSnippetText [
	<gtExample>
	| tool call result page domainObject |
	tool := self toolOnLogicalDatabase.
	page := self pageInLogicalDatabase.
	call := GtLFunctionToolCall new.
	call rawArguments: {
		'snippets' -> {
			Dictionary new
				at: 'TextSnippet'
				put: (Dictionary new
					at: 'pageUid' put: page uidString;
					at: 'snippetText' put: '';
					yourself);
				yourself } } asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	domainObject := result targetObject.
	self
		assertMissingArgument: domainObject snippets first
		withArgumentName: 'snippetText'
		errorMessage: 'Missing argument called snippetText'.
	^ domainObject
]

{ #category : #'examples - errors' }
GtLToolForLepiterSnippetsCreateExamples >> mixedSuccessAndErrorSnippets [
	<gtExample>
	"Creates multiple snippets where some succeed and some fail due to empty content"
	| tool call result page domainObject |
	tool := self toolOnLogicalDatabase.
	page := self pageInLogicalDatabase.
	call := GtLFunctionToolCall new.
	call rawArguments: {
		'snippets' -> {
			Dictionary new
				at: 'TextSnippet'
				put: (Dictionary new
					at: 'pageUid' put: page uidString;
					at: 'snippetText' put: 'Valid text';
					yourself);
				yourself.
			Dictionary new
				at: 'PharoSnippet'
				put: (Dictionary new
					at: 'pageUid' put: page uidString;
					at: 'pharoCode' put: '';
					yourself);
				yourself.
			Dictionary new
				at: 'PythonSnippet'
				put: (Dictionary new
					at: 'pageUid' put: page uidString;
					at: 'pythonCode' put: 'print(1)';
					yourself);
				yourself } } asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	domainObject := result targetObject.
	self assert: domainObject snippets size equals: 3.
	self assert: domainObject snippets first status equals: 'created'.
	self assert: domainObject snippets second missingArgument equals: 'snippetText'.
	self assert: domainObject snippets third status equals: 'created'.
	^ domainObject
]

{ #category : #'examples - errors' }
GtLToolForLepiterSnippetsCreateExamples >> multipleSnippetsWithDifferentErrors [
	<gtExample>
	"Creates multiple snippets with different types of errors"
	| tool call result page domainObject |
	tool := self toolOnLogicalDatabase.
	page := self pageInLogicalDatabase.
	call := GtLFunctionToolCall new.
	call rawArguments: {
		'snippets' -> {
			Dictionary new
				at: 'TextSnippet'
				put: (Dictionary new
					at: 'pageUid' put: '';
					at: 'snippetText' put: 'Text with empty pageUid';
					yourself);
				yourself.
			Dictionary new
				at: 'PharoSnippet'
				put: (Dictionary new
					at: 'pageUid' put: page uidString;
					at: 'pharoCode' put: '';
					yourself);
				yourself.
			Dictionary new
				at: 'ExampleSnippet'
				put: (Dictionary new
					at: 'pageUid' put: page uidString;
					at: 'exampleClassName' put: '';
					at: 'exampleMethodName' put: 'someMethod';
					yourself);
				yourself } } asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	domainObject := result targetObject.
	self assert: domainObject snippets size equals: 3.
	self assert: domainObject snippets first missingArgument equals: 'pageUid'.
	self assert: domainObject snippets second missingArgument equals: 'snippetText'.
	self assert: domainObject snippets third missingArgument equals: 'exampleClassName'.
	^ domainObject
]

{ #category : #'examples - errors' }
GtLToolForLepiterSnippetsCreateExamples >> nilPageUidInTextSnippet [
	<gtExample>
	"Test that a null pageUid is caught by JSON schema validation."
	| tool call result domainObject |
	tool := self toolOnLogicalDatabase.
	call := GtLFunctionToolCall new.
	call rawArguments: {
		'snippets' -> {
			Dictionary new
				at: 'TextSnippet'
				put: (Dictionary new
					at: 'pageUid' put: nil;
					at: 'snippetText' put: 'Some text';
					yourself);
				yourself } } asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	domainObject := result targetObject.
	"JSON schema validation returns an error for null in string slot"
	self assert: (domainObject isKindOf: GtLJSONSchemaValidationErrorDomainObject).
	^ domainObject
]

{ #category : #'examples - errors' }
GtLToolForLepiterSnippetsCreateExamples >> nilSnippetTextInTextSnippet [
	<gtExample>
	"Test that a null snippetText is caught by JSON schema validation."
	| tool call result page domainObject |
	tool := self toolOnLogicalDatabase.
	page := self pageInLogicalDatabase.
	call := GtLFunctionToolCall new.
	call rawArguments: {
		'snippets' -> {
			Dictionary new
				at: 'TextSnippet'
				put: (Dictionary new
					at: 'pageUid' put: page uidString;
					at: 'snippetText' put: nil;
					yourself);
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
GtLToolForLepiterSnippetsCreateExamples >> pageInLogicalDatabase [
	<gtExample>
	| logicalDB page |
	logicalDB := self logicalDatabase.
	page := logicalDB primaryDB pageBuilder title: 'Snippet Page'; add.
	self assert: page isNotNil.
	^ page
]

{ #category : #examples }
GtLToolForLepiterSnippetsCreateExamples >> successfulAllSnippetTypesCreate [
	<gtExample>
	"Creates all supported snippet types including ExampleSnippet"
	| tool call result page domainObject |
	tool := self toolOnLogicalDatabase.
	page := self pageInLogicalDatabase.
	call := GtLFunctionToolCall new.
	call rawArguments: {
		'snippets' -> {
			Dictionary new
				at: 'TextSnippet'
				put: (Dictionary new
					at: 'pageUid' put: page uidString;
					at: 'snippetText' put: 'Text snippet';
					yourself);
				yourself.
			Dictionary new
				at: 'PharoSnippet'
				put: (Dictionary new
					at: 'pageUid' put: page uidString;
					at: 'pharoCode' put: 'Object new';
					yourself);
				yourself.
			Dictionary new
				at: 'PythonSnippet'
				put: (Dictionary new
					at: 'pageUid' put: page uidString;
					at: 'pythonCode' put: 'import os';
					yourself);
				yourself.
			Dictionary new
				at: 'ShellSnippet'
				put: (Dictionary new
					at: 'pageUid' put: page uidString;
					at: 'shellCode' put: 'pwd';
					yourself);
				yourself.
			Dictionary new
				at: 'ExampleSnippet'
				put: (Dictionary new
					at: 'pageUid' put: page uidString;
					at: 'exampleClassName' put: self class name;
					at: 'exampleMethodName' put: #successfulSnippetCreate;
					yourself);
				yourself } } asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	domainObject := result targetObject.
	self assert: domainObject snippets size equals: 5.
	self assert: (domainObject snippets allSatisfy: [ :each | each status = 'created' ]).
	^ domainObject
]

{ #category : #examples }
GtLToolForLepiterSnippetsCreateExamples >> successfulExampleSnippetCreate [
	<gtExample>
	| tool call result page domainObject |
	tool := self toolOnLogicalDatabase.
	page := self pageInLogicalDatabase.
	call := GtLFunctionToolCall new.
	call rawArguments: {
		'snippets' -> {
			Dictionary new
				at: 'ExampleSnippet'
				put: (Dictionary new
					at: 'pageUid' put: page uidString;
					at: 'exampleClassName'
						put: self class name;
					at: 'exampleMethodName'
						put: #successfulSnippetCreate;
					yourself);
				yourself } } asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	domainObject := result targetObject.
	self assert: (domainObject isKindOf: GtLLepiterSnippetsDomainObject).
	^ domainObject
]

{ #category : #examples }
GtLToolForLepiterSnippetsCreateExamples >> successfulMultipleSnippetTypesCreate [
	<gtExample>
	"Creates multiple snippets of different types: Text, Pharo, Python, Shell"
	| tool call result page domainObject |
	tool := self toolOnLogicalDatabase.
	page := self pageInLogicalDatabase.
	call := GtLFunctionToolCall new.
	call rawArguments: {
		'snippets' -> {
			Dictionary new
				at: 'TextSnippet'
				put: (Dictionary new
					at: 'pageUid' put: page uidString;
					at: 'snippetText' put: 'Introduction text';
					yourself);
				yourself.
			Dictionary new
				at: 'PharoSnippet'
				put: (Dictionary new
					at: 'pageUid' put: page uidString;
					at: 'pharoCode' put: '1 + 2';
					yourself);
				yourself.
			Dictionary new
				at: 'PythonSnippet'
				put: (Dictionary new
					at: 'pageUid' put: page uidString;
					at: 'pythonCode' put: 'x = 42';
					yourself);
				yourself.
			Dictionary new
				at: 'ShellSnippet'
				put: (Dictionary new
					at: 'pageUid' put: page uidString;
					at: 'shellCode' put: 'ls -la';
					yourself);
				yourself } } asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	domainObject := result targetObject.
	self assert: domainObject snippets size equals: 4.
	self assert: (domainObject snippets allSatisfy: [ :each | each status = 'created' ]).
	^ domainObject
]

{ #category : #examples }
GtLToolForLepiterSnippetsCreateExamples >> successfulPharoSnippetCreate [
	<gtExample>
	| tool call result page domainObject |
	tool := self toolOnLogicalDatabase.
	page := self pageInLogicalDatabase.
	call := GtLFunctionToolCall new.
	call rawArguments: {
		'snippets' -> {
			Dictionary new
				at: 'PharoSnippet'
				put: (Dictionary new
					at: 'pageUid' put: page uidString;
					at: 'pharoCode' put: 'Transcript show: 1';
					yourself);
				yourself } } asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	domainObject := result targetObject.
	self assert: (domainObject isKindOf: GtLLepiterSnippetsDomainObject).
	^ domainObject
]

{ #category : #examples }
GtLToolForLepiterSnippetsCreateExamples >> successfulPythonSnippetCreate [
	<gtExample>
	| tool call result page domainObject |
	tool := self toolOnLogicalDatabase.
	page := self pageInLogicalDatabase.
	call := GtLFunctionToolCall new.
	call rawArguments: {
		'snippets' -> {
			Dictionary new
				at: 'PythonSnippet'
				put: (Dictionary new
					at: 'pageUid' put: page uidString;
					at: 'pythonCode' put: 'print(1)';
					yourself);
				yourself } } asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	domainObject := result targetObject.
	self assert: (domainObject isKindOf: GtLLepiterSnippetsDomainObject).
	^ domainObject
]

{ #category : #examples }
GtLToolForLepiterSnippetsCreateExamples >> successfulShellSnippetCreate [
	<gtExample>
	| tool call result page domainObject |
	tool := self toolOnLogicalDatabase.
	page := self pageInLogicalDatabase.
	call := GtLFunctionToolCall new.
	call rawArguments: {
		'snippets' -> {
			Dictionary new
				at: 'ShellSnippet'
				put: (Dictionary new
					at: 'pageUid' put: page uidString;
					at: 'shellCode' put: 'echo "Hello"';
					yourself);
				yourself } } asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	domainObject := result targetObject.
	self assert: (domainObject isKindOf: GtLLepiterSnippetsDomainObject).
	^ domainObject
]

{ #category : #examples }
GtLToolForLepiterSnippetsCreateExamples >> successfulSnippetCreate [
	<gtExample>
	| tool call result page domainObject |
	tool := self toolOnLogicalDatabase.
	page := self pageInLogicalDatabase.
	call := GtLFunctionToolCall new.
	call rawArguments: {
		'snippets' -> {
			Dictionary new
				at: 'TextSnippet'
				put: (Dictionary new
					at: 'pageUid' put: page uidString;
					at: 'snippetText' put: 'New snippet text';
					yourself);
				yourself } } asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	domainObject := result targetObject.
	self assert: (domainObject isKindOf: GtLLepiterSnippetsDomainObject).
	^ domainObject
]

{ #category : #examples }
GtLToolForLepiterSnippetsCreateExamples >> successfulSnippetsCreateMultiple [
	<gtExample>
	| tool call result page domainObject |
	tool := self toolOnLogicalDatabase.
	page := self pageInLogicalDatabase.
	call := GtLFunctionToolCall new.
	call rawArguments: {
		'snippets' -> {
			Dictionary new
				at: 'TextSnippet'
				put: (Dictionary new
					at: 'pageUid' put: page uidString;
					at: 'snippetText' put: 'Notes';
					yourself);
				yourself.
			Dictionary new
				at: 'PythonSnippet'
				put: (Dictionary new
					at: 'pageUid' put: page uidString;
					at: 'pythonCode' put: 'print(2)';
					yourself);
				yourself } } asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	domainObject := result targetObject.
	self assert: (domainObject isKindOf: GtLLepiterSnippetsDomainObject).
	^ domainObject
]

{ #category : #examples }
GtLToolForLepiterSnippetsCreateExamples >> successfulTextSnippetCreate [
	<gtExample>
	| tool call result domainObject page |
	tool := self toolOnLogicalDatabase.
	page := self pageInLogicalDatabase.
	call := GtLFunctionToolCall new.
	call rawArguments: {
		'snippets' -> {
			Dictionary new
				at: 'TextSnippet'
				put: (Dictionary new
					at: 'pageUid' put: page uidString;
					at: 'snippetText' put: 'New snippet text';
					yourself);
				yourself } } asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	domainObject := result targetObject.
	self assert: (domainObject isKindOf: GtLLepiterSnippetsDomainObject).
	^ domainObject
]

{ #category : #examples }
GtLToolForLepiterSnippetsCreateExamples >> toolOnLogicalDatabase [
	<gtExample>
	| tool logicalDB |
	logicalDB := self logicalDatabase.
	tool := GtLToolForLepiterSnippetsCreate new.
	tool database: logicalDB.
	self assert: tool database equals: logicalDB.
	^ tool
]
