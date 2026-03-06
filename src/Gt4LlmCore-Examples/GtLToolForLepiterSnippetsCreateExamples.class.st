Class {
	#name : #GtLToolForLepiterSnippetsCreateExamples,
	#superclass : #Object,
	#instVars : [
		'logicalDatabase'
	],
	#category : 'Gt4LlmCore-Examples-Tools'
}

{ #category : #'examples - mixed errors' }
GtLToolForLepiterSnippetsCreateExamples >> allSnippetsWithErrors [
	<gtExample>
	"Creates multiple snippets where all fail with different errors"
	| tool call result page model |
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
	self assert: (result isKindOf: GtLMagritteBasedModel).
	model := result model.
	self assert: model snippets size equals: 4.
	self assert: (model snippets allSatisfy: [ :each | each isKindOf: GtLMissingArgumentDomainObject ]).
	^ call
]

{ #category : #'examples - nil and empty' }
GtLToolForLepiterSnippetsCreateExamples >> emptyExampleClassName [
	<gtExample>
	| tool call result page model |
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
	self assert: (result isKindOf: GtLMagritteBasedModel).
	model := result model.
	self assert: model snippets first missingArgument equals: 'exampleClassName'.
	^ call
]

{ #category : #'examples - nil and empty' }
GtLToolForLepiterSnippetsCreateExamples >> emptyExampleMethodName [
	<gtExample>
	| tool call result page model |
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
	self assert: (result isKindOf: GtLMagritteBasedModel).
	model := result model.
	self assert: model snippets first missingArgument equals: 'exampleMethodName'.
	^ call
]

{ #category : #'examples - nil and empty' }
GtLToolForLepiterSnippetsCreateExamples >> emptyPharoCode [
	<gtExample>
	| tool call result page model |
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
	self assert: (result isKindOf: GtLMagritteBasedModel).
	model := result model.
	self assert: model snippets first missingArgument equals: 'snippetText'.
	^ call
]

{ #category : #'examples - nil and empty' }
GtLToolForLepiterSnippetsCreateExamples >> emptyPythonCode [
	<gtExample>
	| tool call result page model |
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
	self assert: (result isKindOf: GtLMagritteBasedModel).
	model := result model.
	self assert: model snippets first missingArgument equals: 'snippetText'.
	^ call
]

{ #category : #'examples - nil and empty' }
GtLToolForLepiterSnippetsCreateExamples >> emptyShellCode [
	<gtExample>
	| tool call result page model |
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
	self assert: (result isKindOf: GtLMagritteBasedModel).
	model := result model.
	self assert: model snippets first missingArgument equals: 'snippetText'.
	^ call
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

{ #category : #examples }
GtLToolForLepiterSnippetsCreateExamples >> missingSnippetPageUid [
	<gtExample>
	| tool call result model |
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
	self assert: (result isKindOf: GtLMagritteBasedModel).
	model := result model.
	self assert: model snippets first missingArgument equals: 'pageUid'.
	^ call
]

{ #category : #examples }
GtLToolForLepiterSnippetsCreateExamples >> missingSnippets [
	<gtExample>
	| tool call result model |
	tool := GtLToolForLepiterSnippetsCreate new.
	call := GtLFunctionToolCall new.
	call rawArguments: {} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GtLMagritteBasedModel).
	
	model := result model.
	self assert: (model isKindOf: GtLMissingRequiredPropertiesDomainObject).
	self assert: model missingPropertyNames equals: #('snippets').
	self assert: model path equals: #(nil).
	
	^ call
]

{ #category : #examples }
GtLToolForLepiterSnippetsCreateExamples >> missingSnippetText [
	<gtExample>
	| tool call result model page |
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
	self assert: (result isKindOf: GtLMagritteBasedModel).
	model := result model.
	self assert: model snippets first missingArgument equals: 'snippetText'.
	^ call
]

{ #category : #'examples - mixed errors' }
GtLToolForLepiterSnippetsCreateExamples >> mixedSuccessAndErrorSnippets [
	<gtExample>
	"Creates multiple snippets where some succeed and some fail due to empty content"
	| tool call result page model |
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
	self assert: (result isKindOf: GtLMagritteBasedModel).
	model := result model.
	self assert: model snippets size equals: 3.
	self assert: model snippets first status equals: 'created'.
	self assert: model snippets second missingArgument equals: 'snippetText'.
	self assert: model snippets third status equals: 'created'.
	^ call
]

{ #category : #'examples - mixed errors' }
GtLToolForLepiterSnippetsCreateExamples >> multipleSnippetsWithDifferentErrors [
	<gtExample>
	"Creates multiple snippets with different types of errors"
	| tool call result page model |
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
	self assert: (result isKindOf: GtLMagritteBasedModel).
	model := result model.
	self assert: model snippets size equals: 3.
	self assert: model snippets first missingArgument equals: 'pageUid'.
	self assert: model snippets second missingArgument equals: 'snippetText'.
	self assert: model snippets third missingArgument equals: 'exampleClassName'.
	^ call
]

{ #category : #examples }
GtLToolForLepiterSnippetsCreateExamples >> nilPageUidInTextSnippet [
	<gtExample>
	"Test that a null pageUid is caught by JSON schema validation."
	| tool call result model |
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
	self assert: (result isKindOf: GtLMagritteBasedModel).
	model := result model.
	"JSON schema validation returns an error for null in string slot"
	self assert: (model isKindOf: GtLJSONSchemaValidationErrorDomainObject).
	^ call
]

{ #category : #examples }
GtLToolForLepiterSnippetsCreateExamples >> nilSnippetTextInTextSnippet [
	<gtExample>
	"Test that a null snippetText is caught by JSON schema validation."
	| tool call result model page |
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
	self assert: (result isKindOf: GtLMagritteBasedModel).
	model := result model.
	"JSON schema validation returns an error for null in required string slot"
	self assert: (model isKindOf: GtLJSONSchemaValidationErrorDomainObject).
	^ call
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

{ #category : #'examples - multiple types' }
GtLToolForLepiterSnippetsCreateExamples >> successfulAllSnippetTypesCreate [
	<gtExample>
	"Creates all supported snippet types including ExampleSnippet"
	| tool call result page model |
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
	self assert: (result isKindOf: GtLMagritteBasedModel).
	model := result model.
	self assert: model snippets size equals: 5.
	self assert: (model snippets allSatisfy: [ :each | each status = 'created' ]).
	^ call
]

{ #category : #examples }
GtLToolForLepiterSnippetsCreateExamples >> successfulExampleSnippetCreate [
	<gtExample>
	| tool call result page |
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
	self assert: (result isKindOf: GtLMagritteBasedModel).
	^ call
]

{ #category : #'examples - multiple types' }
GtLToolForLepiterSnippetsCreateExamples >> successfulMultipleSnippetTypesCreate [
	<gtExample>
	"Creates multiple snippets of different types: Text, Pharo, Python, Shell"
	| tool call result page model |
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
	self assert: (result isKindOf: GtLMagritteBasedModel).
	model := result model.
	self assert: model snippets size equals: 4.
	self assert: (model snippets allSatisfy: [ :each | each status = 'created' ]).
	^ call
]

{ #category : #examples }
GtLToolForLepiterSnippetsCreateExamples >> successfulPharoSnippetCreate [
	<gtExample>
	| tool call result page |
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
	self assert: (result isKindOf: GtLMagritteBasedModel).
	^ call
]

{ #category : #examples }
GtLToolForLepiterSnippetsCreateExamples >> successfulPythonSnippetCreate [
	<gtExample>
	| tool call result page |
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
	self assert: (result isKindOf: GtLMagritteBasedModel).
	^ call
]

{ #category : #examples }
GtLToolForLepiterSnippetsCreateExamples >> successfulShellSnippetCreate [
	<gtExample>
	| tool call result page |
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
	self assert: (result isKindOf: GtLMagritteBasedModel).
	^ call
]

{ #category : #examples }
GtLToolForLepiterSnippetsCreateExamples >> successfulSnippetCreate [
	<gtExample>
	| tool call result page |
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
	self assert: (result isKindOf: GtLMagritteBasedModel).
	^ call
]

{ #category : #examples }
GtLToolForLepiterSnippetsCreateExamples >> successfulSnippetsCreateMultiple [
	<gtExample>
	| tool call result page |
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
	self assert: (result isKindOf: GtLMagritteBasedModel).
	^ call
]

{ #category : #examples }
GtLToolForLepiterSnippetsCreateExamples >> successfulTextSnippetCreate [
	<gtExample>
	| tool call result page |
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
	self assert: (result isKindOf: GtLMagritteBasedModel).
	^ call
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
