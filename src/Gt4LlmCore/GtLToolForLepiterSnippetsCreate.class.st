Class {
	#name : #GtLToolForLepiterSnippetsCreate,
	#superclass : #GtLAbstractMagritteFunctionTool,
	#instVars : [
		'database'
	],
	#category : #'Gt4LlmCore-Tools'
}

{ #category : #private }
GtLToolForLepiterSnippetsCreate >> createSnippetFrom: snippetArguments [
	| pageUidString pageUid snippet snippetValidation |
	pageUidString := snippetArguments pageUid.
	(pageUidString isNil or: [ pageUidString trimBoth isEmpty ])
		ifTrue: [ ^ GtLMissingArgumentDomainObject new
				arguments: snippetArguments;
				missingArgument: 'pageUid' ].
	pageUid := [ UUID fromString36: pageUidString ]
			on: Error
			do: [ :error | 
				^ GtLExceptionDomainObject new
					freeze: error;
					description: 'Invalid page uid' ].
	^ snippetArguments
		validateSnippetArgumentsFor: self
		ifCorrect: [ self database
				pageWithID: pageUid
				ifPresent: [ :page | 
					[ snippet := snippetArguments buildSnippetFor: self.
					page addSnippet: snippet ]
						on: Error
						do: [ :error | 
							^ GtLExceptionDomainObject new
								freeze: error;
								description: 'Error while creating snippet' ] ]
				ifAbsent: [ ^ GtLProblemDomainObject new
						description: 'Could not locate page with id ' , pageUid asString ].
			^ GtLLepiterSnippetDomainObject new
				status: 'created';
				pageUid: pageUid asString;
				snippetUid: snippet uidString;
				snippet: snippet ]
]

{ #category : #accessing }
GtLToolForLepiterSnippetsCreate >> database [
	^ database
]

{ #category : #accessing }
GtLToolForLepiterSnippetsCreate >> database: aDatabase [
	database := aDatabase
]

{ #category : #accessing }
GtLToolForLepiterSnippetsCreate >> description [
	^ 'Creates new Lepiter snippets for pages identified by their page ids.

Example JSON arguments:
{
  "snippets": [
    {"TextSnippet": {"pageUid": "UUID", "snippetText": "Notes"}},
    {"PharoSnippet": {"pageUid": "UUID", "pharoCode": "Transcript show: 1"}},
    {"ExampleSnippet": {"pageUid": "UUID", "exampleClassName": "MyExamples", "exampleMethodName": "exampleMethod"}}
  ]
}

Supported snippet types are: text, pharo, python, shell, example.

Example JSON response:
{
  "snippets": [
    {"status": "created", "pageUid": "UUID", "snippetUid": "UUID"},
    {"status": "created", "pageUid": "UUID", "snippetUid": "UUID"}
  ]
}'
]

{ #category : #initialization }
GtLToolForLepiterSnippetsCreate >> initialize [
	super initialize.
	database := LeDatabasesRegistry defaultLogicalDatabase
]

{ #category : #accessing }
GtLToolForLepiterSnippetsCreate >> name [
	^ 'createLepiterSnippets'
]

{ #category : #private }
GtLToolForLepiterSnippetsCreate >> privatePerformToolCall: aToolCall inContext: anExecutionContext [
	| arguments snippets results |
	arguments := aToolCall arguments ifNil: [ Dictionary new ].
	snippets := arguments at: 'snippets'.
			
	results := snippets collect: [ :each |
		(each isKindOf: GtLLepiterSnippetCreationRequest)
			ifFalse: [ ^ GtLIncorrectArgumentArrayItemDomainObject new
				argumentName: 'snippets';
				argumentValue: snippets;
				expectedItemKind: GtLLepiterSnippetCreationRequest;
				incorrectItems: { each } ].
		self createSnippetFrom: each ].
		
	^ GtLLepiterSnippetsDomainObject new
		snippets: results;
		yourself
]

{ #category : #private }
GtLToolForLepiterSnippetsCreate >> snippetClassForType: snippetType [
	| normalizedType |
	normalizedType := snippetType asString trimBoth.
	normalizedType isEmpty ifTrue: [ normalizedType := 'text' ].
	^ {
		'text' -> LeTextSnippet.
		'pharo' -> LePharoSnippet.
		'python' -> LePythonSnippet.
		'shell' -> LeShellScriptSnippet.
		'example' -> LeExampleSnippet } asDictionary
			at: normalizedType
			ifAbsent: [ nil ]
]

{ #category : #magritte }
GtLToolForLepiterSnippetsCreate >> snippetsDescription [
	<magritteDescription>

	^ MAToManyRelationDescription new
		label: 'Snippets';
		accessor: #snippets;
		classes: {
			GtLLepiterTextSnippetCreationRequest.
			GtLLepiterPharoSnippetCreationRequest.
			GtLLepiterPythonSnippetCreationRequest.
			GtLLepiterShellSnippetCreationRequest.
			GtLLepiterExampleSnippetCreationRequest };
		useExplicitContainerForChildren;
		beRequired
]
