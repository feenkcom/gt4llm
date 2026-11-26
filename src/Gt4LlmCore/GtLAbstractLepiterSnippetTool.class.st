"
I am the abstract superclass of the tools that create, edit and remove Lepiter snippets: {{gtClass:GtLToolForLepiterSnippetsCreate}}, {{gtClass:GtLToolForLepiterSnippetEdit}}, {{gtClass:GtLToolForLepiterSnippetsEdit}} and {{gtClass:GtLToolForLepiterSnippetsRemove}}.

I hold what they share:
- the `database` in which they look pages and snippets up: the logical database unless another one is given (examples use detached databases);
- the {{gtClass:GtLLepiterSnippetLocator}} that resolves the ids and refuses ambiguous ones (`snippetLocator`);
- the check of blank arguments: the JSON schema already refuses absent and null required arguments, so only blank strings reach the tools ({{gtMethod:GtLAbstractLepiterSnippetTool>>#missingArgumentAmong:in:}});
- whether a request names the snippet of an earlier result of the same call, used to refuse a snippet edited or removed twice in one call ({{gtMethod:GtLAbstractLepiterSnippetTool>>#isReference:requestedBy:}}).
"
Class {
	#name : #GtLAbstractLepiterSnippetTool,
	#superclass : #GtLAbstractMagritteFunctionTool,
	#instVars : [
		'database'
	],
	#category : #'Gt4LlmCore-Tools'
}

{ #category : #testing }
GtLAbstractLepiterSnippetTool class >> isAbstract [
	^ self name = #GtLAbstractLepiterSnippetTool
]

{ #category : #accessing }
GtLAbstractLepiterSnippetTool >> database [
	"Return the database in which I look pages and snippets up: the one I was given (a logical database or a single database), else the logical database. It is not kept, so that a tool made before a change of the logical database, or before a change of my slots, uses the current one"

	^ database ifNil: [ LeDatabasesRegistry defaultLogicalDatabase ]
]

{ #category : #accessing }
GtLAbstractLepiterSnippetTool >> database: aDatabase [
	database := aDatabase
]

{ #category : #private }
GtLAbstractLepiterSnippetTool >> isReference: aSnippetReference requestedBy: aRequest [
	"Return true if aRequest names the snippet of aSnippetReference: the same page (in base 36 or in the dashed form) and snippet ids, in the same database unless the request gives none"

	| aPageUuid aDatabaseId |
	aPageUuid := self snippetLocator
			pageUuidFrom: aRequest pageUid
			ifInvalid: [ :aProblem | ^ false ].
	(aSnippetReference pageUid = aPageUuid asString36
		and: [ aSnippetReference snippetUid = aRequest snippetUid asString trimBoth ])
		ifFalse: [ ^ false ].
	aDatabaseId := aRequest databaseId
			ifNil: [ '' ]
			ifNotNil: [ :anId | anId asString trimBoth ].
	^ aDatabaseId isEmpty or: [ aDatabaseId = aSnippetReference databaseId ]
]

{ #category : #private }
GtLAbstractLepiterSnippetTool >> missingArgumentAmong: theArgumentNames in: aRequest [
	"Return a missing argument error for the first of theArgumentNames whose value in aRequest is blank, or nil.
	The JSON schema already refuses absent and null required arguments: only blank strings reach the tools"

	theArgumentNames
		do: [ :aName | 
			| aValue |
			aValue := aRequest perform: aName asSymbol.
			(aValue isNil or: [ aValue asString trimBoth isEmpty ])
				ifTrue: [ ^ GtLMissingArgumentDomainObject new
						arguments: aRequest;
						missingArgument: aName ] ].
	^ nil
]

{ #category : #accessing }
GtLAbstractLepiterSnippetTool >> snippetLocator [
	"Return the locator that resolves pages and snippets in my database, and refuses ambiguous ids"

	^ GtLLepiterSnippetLocator database: self database
]
