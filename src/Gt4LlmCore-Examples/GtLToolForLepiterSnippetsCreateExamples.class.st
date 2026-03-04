Class {
	#name : #GtLToolForLepiterSnippetsCreateExamples,
	#superclass : #Object,
	#instVars : [
		'logicalDatabase'
	],
	#category : #'Gt4LlmCore-Examples-Tools'
}

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

{ #category : #examples }
GtLToolForLepiterSnippetsCreateExamples >> missingSnippets [
	<gtExample>
	| tool call result |
	tool := GtLToolForLepiterSnippetsCreate new.
	call := GtLFunctionToolCall new.
	call rawArguments: {} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GtLMagritteBasedModel).
	self assert: result model missingArgument equals: 'snippets'.
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
