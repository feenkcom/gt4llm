Class {
	#name : #GtLToolForLepiterSnippetsCreateExamples,
	#superclass : #GtLAbstractMagritteFunctionToolExamples,
	#instVars : [
		'logicalDatabase'
	],
	#category : 'Gt4LlmCore-Examples-Tools'
}

{ #category : #examples }
GtLToolForLepiterSnippetsCreateExamples >> allSnippetsWithErrors [
	<gtExample>
	"Creates multiple snippets where all fail with different errors"
	| targetObject tool page |
	tool := self toolOnLogicalDatabase.
	page := self pageInLogicalDatabase.
	
	targetObject := self
		executeTool: tool
		withArguments: {
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
					yourself
			}
		} asDictionary.
	
	self assert: targetObject snippets size equals: 4.
	self assert: (targetObject snippets allSatisfy: [ :each | each isKindOf: GtLMissingArgumentDomainObject ]).
	
	^ targetObject
]

{ #category : #examples }
GtLToolForLepiterSnippetsCreateExamples >> emptyExampleClassName [
	<gtExample>
	| targetObject tool page |
	tool := self toolOnLogicalDatabase.
	page := self pageInLogicalDatabase.
	
	targetObject := self
		executeTool: tool
		withArguments: {
			'snippets' -> {
				Dictionary new
					at: 'ExampleSnippet'
					put: (Dictionary new
						at: 'pageUid' put: page uidString;
						at: 'exampleClassName' put: '';
						at: 'exampleMethodName' put: #someMethod;
						yourself);
					yourself
			}
		} asDictionary.
	
	self
		assertMissingArgument: targetObject snippets first
		withArgumentName: 'exampleClassName'
		errorMessage: 'Missing argument called exampleClassName'.
	
	^ targetObject
]

{ #category : #examples }
GtLToolForLepiterSnippetsCreateExamples >> emptyExampleMethodName [
	<gtExample>
	| targetObject tool page |
	tool := self toolOnLogicalDatabase.
	page := self pageInLogicalDatabase.
	
	targetObject := self
		executeTool: tool
		withArguments: {
			'snippets' -> {
				Dictionary new
					at: 'ExampleSnippet'
					put: (Dictionary new
						at: 'pageUid' put: page uidString;
						at: 'exampleClassName' put: 'SomeClass';
						at: 'exampleMethodName' put: '';
						yourself);
					yourself
			}
		} asDictionary.
	
	self
		assertMissingArgument: targetObject snippets first
		withArgumentName: 'exampleMethodName'
		errorMessage: 'Missing argument called exampleMethodName'.
	
	^ targetObject
]

{ #category : #examples }
GtLToolForLepiterSnippetsCreateExamples >> emptyPharoCode [
	<gtExample>
	| targetObject tool page |
	tool := self toolOnLogicalDatabase.
	page := self pageInLogicalDatabase.
	
	targetObject := self
		executeTool: tool
		withArguments: {
			'snippets' -> {
				Dictionary new
					at: 'PharoSnippet'
					put: (Dictionary new
						at: 'pageUid' put: page uidString;
						at: 'pharoCode' put: '';
						yourself);
					yourself
			}
		} asDictionary.
	
	self
		assertMissingArgument: targetObject snippets first
		withArgumentName: 'snippetText'
		errorMessage: 'Missing argument called snippetText'.
	
	^ targetObject
]

{ #category : #examples }
GtLToolForLepiterSnippetsCreateExamples >> emptyPythonCode [
	<gtExample>
	| targetObject tool page |
	tool := self toolOnLogicalDatabase.
	page := self pageInLogicalDatabase.
	
	targetObject := self
		executeTool: tool
		withArguments: {
			'snippets' -> {
				Dictionary new
					at: 'PythonSnippet'
					put: (Dictionary new
						at: 'pageUid' put: page uidString;
						at: 'pythonCode' put: '';
						yourself);
					yourself
			}
		} asDictionary.
	
	self
		assertMissingArgument: targetObject snippets first
		withArgumentName: 'snippetText'
		errorMessage: 'Missing argument called snippetText'.
	
	^ targetObject
]

{ #category : #examples }
GtLToolForLepiterSnippetsCreateExamples >> emptyShellCode [
	<gtExample>
	| targetObject tool page |
	tool := self toolOnLogicalDatabase.
	page := self pageInLogicalDatabase.
	
	targetObject := self
		executeTool: tool
		withArguments: {
			'snippets' -> {
				Dictionary new
					at: 'ShellSnippet'
					put: (Dictionary new
						at: 'pageUid' put: page uidString;
						at: 'shellCode' put: '';
						yourself);
					yourself
			}
		} asDictionary.
	
	self
		assertMissingArgument: targetObject snippets first
		withArgumentName: 'snippetText'
		errorMessage: 'Missing argument called snippetText'.
	
	^ targetObject
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
	| targetObject tool |
	tool := self toolOnLogicalDatabase.
	
	targetObject := self
		executeTool: tool
		withArguments: {
			'snippets' -> {
				Dictionary new
					at: 'TextSnippet'
					put: (Dictionary new
						at: 'pageUid' put: '';
						at: 'snippetText' put: 'Updated text';
						yourself);
					yourself
			}
		} asDictionary.
	
	self
		assertMissingArgument: targetObject snippets first
		withArgumentName: 'pageUid'
		errorMessage: 'Missing argument called pageUid'.
	
	^ targetObject
]

{ #category : #examples }
GtLToolForLepiterSnippetsCreateExamples >> missingSnippets [
	<gtExample>
	| targetObject |
	
	targetObject := self
		executeTool: GtLToolForLepiterSnippetsCreate new
		withArguments: Dictionary new.
	
	self
		assertMissingRequiredProperties: targetObject
		withPropertyNames: #('snippets')
		path: #(nil)
		errorMessage: 'required properties missing [snippets]'.
	
	^ targetObject
]

{ #category : #examples }
GtLToolForLepiterSnippetsCreateExamples >> missingSnippetText [
	<gtExample>
	| targetObject tool page |
	tool := self toolOnLogicalDatabase.
	page := self pageInLogicalDatabase.
	
	targetObject := self
		executeTool: tool
		withArguments: {
			'snippets' -> {
				Dictionary new
					at: 'TextSnippet'
					put: (Dictionary new
						at: 'pageUid' put: page uidString;
						at: 'snippetText' put: '';
						yourself);
					yourself
			}
		} asDictionary.
	
	self
		assertMissingArgument: targetObject snippets first
		withArgumentName: 'snippetText'
		errorMessage: 'Missing argument called snippetText'.
	
	^ targetObject
]

{ #category : #examples }
GtLToolForLepiterSnippetsCreateExamples >> mixedSuccessAndErrorSnippets [
	<gtExample>
	"Creates multiple snippets where some succeed and some fail due to empty content"
	| targetObject tool page |
	tool := self toolOnLogicalDatabase.
	page := self pageInLogicalDatabase.
	
	targetObject := self
		executeTool: tool
		withArguments: {
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
					yourself
			}
		} asDictionary.
	
	self assert: targetObject snippets size equals: 3.
	self assert: targetObject snippets first status equals: 'created'.
	self assert: targetObject snippets second missingArgument equals: 'snippetText'.
	self assert: targetObject snippets third status equals: 'created'.
	
	^ targetObject
]

{ #category : #examples }
GtLToolForLepiterSnippetsCreateExamples >> multipleSnippetsWithDifferentErrors [
	<gtExample>
	"Creates multiple snippets with different types of errors"
	| targetObject tool page |
	tool := self toolOnLogicalDatabase.
	page := self pageInLogicalDatabase.
	
	targetObject := self
		executeTool: tool
		withArguments: {
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
					yourself
			}
		} asDictionary.
	
	self assert: targetObject snippets size equals: 3.
	self assert: targetObject snippets first missingArgument equals: 'pageUid'.
	self assert: targetObject snippets second missingArgument equals: 'snippetText'.
	self assert: targetObject snippets third missingArgument equals: 'exampleClassName'.
	
	^ targetObject
]

{ #category : #examples }
GtLToolForLepiterSnippetsCreateExamples >> nilPageUidInTextSnippet [
	<gtExample>
	"Test that a null pageUid is caught by JSON schema validation."
	| targetObject tool |
	tool := self toolOnLogicalDatabase.
	
	targetObject := self
		executeTool: tool
		withArguments: {
			'snippets' -> {
				Dictionary new
					at: 'TextSnippet'
					put: (Dictionary new
						at: 'pageUid' put: nil;
						at: 'snippetText' put: 'Some text';
						yourself);
					yourself
			}
		} asDictionary.
	
	"JSON schema validation returns an error for null in string slot"
	self assert: (targetObject isKindOf: GtLJSONSchemaValidationErrorDomainObject).
	
	^ targetObject
]

{ #category : #examples }
GtLToolForLepiterSnippetsCreateExamples >> nilSnippetTextInTextSnippet [
	<gtExample>
	"Test that a null snippetText is caught by JSON schema validation."
	| targetObject tool page |
	tool := self toolOnLogicalDatabase.
	page := self pageInLogicalDatabase.
	
	targetObject := self
		executeTool: tool
		withArguments: {
			'snippets' -> {
				Dictionary new
					at: 'TextSnippet'
					put: (Dictionary new
						at: 'pageUid' put: page uidString;
						at: 'snippetText' put: nil;
						yourself);
					yourself
			}
		} asDictionary.
	
	"JSON schema validation returns an error for null in required string slot"
	self assert: (targetObject isKindOf: GtLJSONSchemaValidationErrorDomainObject).
	
	^ targetObject
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
	| targetObject tool page |
	tool := self toolOnLogicalDatabase.
	page := self pageInLogicalDatabase.
	
	targetObject := self
		executeTool: tool
		withArguments: {
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
					yourself
			}
		} asDictionary.
	
	self assert: targetObject snippets size equals: 5.
	self assert: (targetObject snippets allSatisfy: [ :each | each status = 'created' ]).
	
	^ targetObject
]

{ #category : #examples }
GtLToolForLepiterSnippetsCreateExamples >> successfulExampleSnippetCreate [
	<gtExample>
	| targetObject tool page |
	tool := self toolOnLogicalDatabase.
	page := self pageInLogicalDatabase.
	
	targetObject := self
		executeTool: tool
		withArguments: {
			'snippets' -> {
				Dictionary new
					at: 'ExampleSnippet'
					put: (Dictionary new
						at: 'pageUid' put: page uidString;
						at: 'exampleClassName' put: self class name;
						at: 'exampleMethodName' put: #successfulSnippetCreate;
						yourself);
					yourself
			}
		} asDictionary.
	
	self assert: (targetObject isKindOf: GtLLepiterSnippetsDomainObject).
	
	^ targetObject
]

{ #category : #examples }
GtLToolForLepiterSnippetsCreateExamples >> successfulMultipleSnippetTypesCreate [
	<gtExample>
	"Creates multiple snippets of different types: Text, Pharo, Python, Shell"
	| targetObject tool page |
	tool := self toolOnLogicalDatabase.
	page := self pageInLogicalDatabase.
	
	targetObject := self
		executeTool: tool
		withArguments: {
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
					yourself
			}
		} asDictionary.
	
	self assert: targetObject snippets size equals: 4.
	self assert: (targetObject snippets allSatisfy: [ :each | each status = 'created' ]).
	
	^ targetObject
]

{ #category : #examples }
GtLToolForLepiterSnippetsCreateExamples >> successfulPharoSnippetCreate [
	<gtExample>
	| targetObject tool page |
	tool := self toolOnLogicalDatabase.
	page := self pageInLogicalDatabase.
	
	targetObject := self
		executeTool: tool
		withArguments: {
			'snippets' -> {
				Dictionary new
					at: 'PharoSnippet'
					put: (Dictionary new
						at: 'pageUid' put: page uidString;
						at: 'pharoCode' put: 'Transcript show: 1';
						yourself);
					yourself
			}
		} asDictionary.
	
	self assert: (targetObject isKindOf: GtLLepiterSnippetsDomainObject).
	
	^ targetObject
]

{ #category : #examples }
GtLToolForLepiterSnippetsCreateExamples >> successfulPythonSnippetCreate [
	<gtExample>
	| targetObject tool page |
	tool := self toolOnLogicalDatabase.
	page := self pageInLogicalDatabase.
	
	targetObject := self
		executeTool: tool
		withArguments: {
			'snippets' -> {
				Dictionary new
					at: 'PythonSnippet'
					put: (Dictionary new
						at: 'pageUid' put: page uidString;
						at: 'pythonCode' put: 'print(1)';
						yourself);
					yourself
			}
		} asDictionary.
	
	self assert: (targetObject isKindOf: GtLLepiterSnippetsDomainObject).
	
	^ targetObject
]

{ #category : #examples }
GtLToolForLepiterSnippetsCreateExamples >> successfulShellSnippetCreate [
	<gtExample>
	| targetObject tool page |
	tool := self toolOnLogicalDatabase.
	page := self pageInLogicalDatabase.
	
	targetObject := self
		executeTool: tool
		withArguments: {
			'snippets' -> {
				Dictionary new
					at: 'ShellSnippet'
					put: (Dictionary new
						at: 'pageUid' put: page uidString;
						at: 'shellCode' put: 'echo "Hello"';
						yourself);
					yourself
			}
		} asDictionary.
	
	self assert: (targetObject isKindOf: GtLLepiterSnippetsDomainObject).
	
	^ targetObject
]

{ #category : #examples }
GtLToolForLepiterSnippetsCreateExamples >> successfulSnippetCreate [
	<gtExample>
	| targetObject tool page |
	tool := self toolOnLogicalDatabase.
	page := self pageInLogicalDatabase.
	
	targetObject := self
		executeTool: tool
		withArguments: {
			'snippets' -> {
				Dictionary new
					at: 'TextSnippet'
					put: (Dictionary new
						at: 'pageUid' put: page uidString;
						at: 'snippetText' put: 'New snippet text';
						yourself);
					yourself
			}
		} asDictionary.
	
	self assert: (targetObject isKindOf: GtLLepiterSnippetsDomainObject).
	
	^ targetObject
]

{ #category : #examples }
GtLToolForLepiterSnippetsCreateExamples >> successfulSnippetsCreateMultiple [
	<gtExample>
	| targetObject tool page |
	tool := self toolOnLogicalDatabase.
	page := self pageInLogicalDatabase.
	
	targetObject := self
		executeTool: tool
		withArguments: {
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
					yourself
			}
		} asDictionary.
	
	self assert: (targetObject isKindOf: GtLLepiterSnippetsDomainObject).
	
	^ targetObject
]

{ #category : #examples }
GtLToolForLepiterSnippetsCreateExamples >> successfulTextSnippetCreate [
	<gtExample>
	| targetObject tool page |
	tool := self toolOnLogicalDatabase.
	page := self pageInLogicalDatabase.
	
	targetObject := self
		executeTool: tool
		withArguments: {
			'snippets' -> {
				Dictionary new
					at: 'TextSnippet'
					put: (Dictionary new
						at: 'pageUid' put: page uidString;
						at: 'snippetText' put: 'New snippet text';
						yourself);
					yourself
			}
		} asDictionary.
	
	self assert: (targetObject isKindOf: GtLLepiterSnippetsDomainObject).
	
	^ targetObject
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
