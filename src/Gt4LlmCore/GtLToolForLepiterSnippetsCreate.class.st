Class {
	#name : #GtLToolForLepiterSnippetsCreate,
	#superclass : #GtLAbstractMagritteFunctionTool,
	#instVars : [
		'database'
	],
	#category : #Gt4LlmCore
}

{ #category : #private }
GtLToolForLepiterSnippetsCreate >> createSnippetFrom: snippetArguments [
	| pageUidString snippetText pageUid snippetType snippetClass snippet |
	pageUidString := snippetArguments pageUid.
	(pageUidString isNil or: [ pageUidString trimBoth isEmpty ])
		ifTrue: [ ^ GtLMissingArgumentDomainObject new
			receiverName: self name;
			arguments: snippetArguments;
			missingArgument: 'pageUid' ].
	pageUid := [ UUID fromString36: pageUidString ]
		on: Error
		do: [ :error |
			^ GtLExceptionDomainObject new
				freeze: error;
				description: 'Invalid page uid' ].
	snippetText := snippetArguments snippetText.
	(snippetText isNil or: [ snippetText asString isEmpty ])
		ifTrue: [ ^ GtLMissingArgumentDomainObject new
			receiverName: self name;
			arguments: snippetArguments;
			missingArgument: 'snippetText' ].
	snippetText := snippetText asString.
	snippetType := snippetArguments snippetType ifNil: [ 'text' ].
	snippetClass := self snippetClassForType: snippetType.
	snippetClass ifNil: [ ^ GtLProblemDomainObject new
		description: 'Unknown snippet type ' , snippetType asString ].
	self database
		pageWithID: pageUid
		ifPresent: [ :page |
			[ snippet := snippetClass = LeTextSnippet
				ifTrue: [ LeTextSnippet string: snippetText ]
				ifFalse: [ snippetClass code: snippetText ].
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
		snippet: snippet
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
    {"pageUid": "UUID", "snippetText": "Transcript show: 1", "snippetType": "pharo"},
    {"pageUid": "UUID", "snippetText": "Notes", "snippetType": "text"}
  ]
}

Supported snippet types are: text, pharo, python, shell.

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
	^ 'createLepiterSnippet'
]

{ #category : #private }
GtLToolForLepiterSnippetsCreate >> privatePerformToolCall: aToolCall [
	| arguments snippetsArgument results |
	arguments := aToolCall arguments ifNil: [ Dictionary new ].
	snippetsArgument := arguments
		at: 'snippets'
		ifAbsent: [ ^ GtLMissingArgumentDomainObject new
			receiverName: self name;
			arguments: arguments;
			missingArgument: 'snippets' ].
	(snippetsArgument isCollection and: [ snippetsArgument isString not ])
		ifFalse: [ ^ GtLIncorrectArgumentTypeDomainObject new
			argumentName: 'snippets';
			argumentValue: snippetsArgument;
			expectedArgumentValueKind: Array ].
	results := snippetsArgument collect: [ :each |
		(each isKindOf: GtLLepiterSnippetCreationRequest)
			ifFalse: [ ^ GtLIncorrectArgumentArrayItemDomainObject new
				argumentName: 'snippets';
				argumentValue: snippetsArgument;
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
		'shell' -> LeShellScriptSnippet } asDictionary
			at: normalizedType
			ifAbsent: [ nil ]
]

{ #category : #accessing }
GtLToolForLepiterSnippetsCreate >> snippetsDescription [
	<magritteDescription>

	^ MAToManyRelationDescription new
		label: 'Snippets';
		accessor: #snippets;
		classes: { GtLLepiterSnippetCreationRequest };
		beRequired
]
