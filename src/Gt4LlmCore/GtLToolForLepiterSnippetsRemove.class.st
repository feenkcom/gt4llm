Class {
	#name : #GtLToolForLepiterSnippetsRemove,
	#superclass : #GtLAbstractMagritteFunctionTool,
	#instVars : [
		'database'
	],
	#category : #Gt4LlmCore
}

{ #category : #accessing }
GtLToolForLepiterSnippetsRemove >> database [
	^ database
]

{ #category : #accessing }
GtLToolForLepiterSnippetsRemove >> database: aDatabase [
	database := aDatabase
]

{ #category : #accessing }
GtLToolForLepiterSnippetsRemove >> description [
	^ 'Remove one or more Lepiter snippets using the knowledge base, page, and snippet identifiers.

Example JSON arguments:
{
  "snippets": [
    {"knowledgeBaseUid": "UUID", "pageUid": "UUID", "snippetUid": "UUID"},
    {"knowledgeBaseUid": "UUID", "pageUid": "UUID", "snippetUid": "UUID"}
  ]
}

Example JSON response:
{
  "snippets": [
    {"status": "removed", "pageUid": "UUID", "snippetUid": "UUID"},
    {"status": "removed", "pageUid": "UUID", "snippetUid": "UUID"}
  ]
}'
]

{ #category : #initialization }
GtLToolForLepiterSnippetsRemove >> initialize [
	super initialize.
	database := LeDatabasesRegistry defaultLogicalDatabase
]

{ #category : #accessing }
GtLToolForLepiterSnippetsRemove >> name [
	^ 'removeLepiterSnippets'
]

{ #category : #private }
GtLToolForLepiterSnippetsRemove >> privatePerformToolCall: aToolCall [
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
		(each isKindOf: GtLLepiterSnippetRemovalRequest)
			ifFalse: [ ^ GtLIncorrectArgumentArrayItemDomainObject new
				argumentName: 'snippets';
				argumentValue: snippetsArgument;
				expectedItemKind: GtLLepiterSnippetRemovalRequest;
				incorrectItems: { each } ].
		self removeSnippetFrom: each ].
	^ GtLLepiterSnippetsDomainObject new
		snippets: results;
		yourself
]

{ #category : #private }
GtLToolForLepiterSnippetsRemove >> removeSnippetFrom: snippetArguments [
	| pageUidString snippetUidString knowledgeBaseUid targetDatabase pageUid snippetUid snippets |
	knowledgeBaseUid := snippetArguments knowledgeBaseUid.
	(knowledgeBaseUid isNil or: [ knowledgeBaseUid trimBoth isEmpty ])
		ifTrue: [ ^ GtLMissingArgumentDomainObject new
			receiverName: self name;
			arguments: snippetArguments;
			missingArgument: 'knowledgeBaseUid' ].
	pageUidString := snippetArguments pageUid.
	(pageUidString isNil or: [ pageUidString trimBoth isEmpty ])
		ifTrue: [ ^ GtLMissingArgumentDomainObject new
			receiverName: self name;
			arguments: snippetArguments;
			missingArgument: 'pageUid' ].
	snippetUidString := snippetArguments snippetUid.
	(snippetUidString isNil or: [ snippetUidString trimBoth isEmpty ])
		ifTrue: [ ^ GtLMissingArgumentDomainObject new
			receiverName: self name;
			arguments: snippetArguments;
			missingArgument: 'snippetUid' ].
	targetDatabase := self database.
	(targetDatabase respondsTo: #databaseWithID:ifNone:)
		ifTrue: [ targetDatabase := targetDatabase
			databaseWithID: knowledgeBaseUid
			ifNone: [ nil ] ]
		ifFalse: [ targetDatabase := (targetDatabase respondsTo: #uuid)
			ifTrue: [ targetDatabase uuidString = knowledgeBaseUid
				ifTrue: [ targetDatabase ]
				ifFalse: [ nil ] ]
			ifFalse: [ nil ] ].
	targetDatabase ifNil: [ ^ GtLProblemDomainObject new
		description: 'Database with ' , knowledgeBaseUid asString , ' not found' ].
	pageUid := [ UUID fromString36: pageUidString ]
		on: Error
		do: [ :error |
			^ GtLExceptionDomainObject new
				freeze: error;
				description: 'Invalid page uid' ].
	snippetUid := LeUID new.
	[ snippetUid uidString: snippetUidString ]
		on: Error
		do: [ :error |
			^ GtLExceptionDomainObject new
				freeze: error;
				description: 'Invalid snippet uid' ].
	targetDatabase
		pageWithID: pageUid
		ifPresent: [ :page |
			snippets := page allChildrenSnippetsMatching: [ :aSnippet | aSnippet uid = snippetUid ].
			snippets ifEmpty: [ ^ GtLProblemDomainObject new
				description: 'Could not locate snippet with id ' , snippetUid uidString ].
			[ snippets anyOne removeSelf ]
				on: Error
				do: [ :error |
					^ GtLExceptionDomainObject new
						freeze: error;
						description: 'Error while removing snippet' ] ]
		ifAbsent: [ ^ GtLProblemDomainObject new
			description: 'Could not locate page with id ' , pageUid ].
	^ GtLLepiterSnippetDomainObject new
		status: 'removed';
		pageUid: pageUid;
		snippetUid: snippetUid uidString;
		snippet: nil
]

{ #category : #magritte }
GtLToolForLepiterSnippetsRemove >> snippetsDescription [
	<magritteDescription>

	^ MAToManyRelationDescription new
		label: 'Snippets';
		accessor: #snippets;
		classes: { GtLLepiterSnippetRemovalRequest };
		beRequired
]
