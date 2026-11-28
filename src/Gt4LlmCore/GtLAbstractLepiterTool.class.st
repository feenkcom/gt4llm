"
I am the abstract superclass of the Lepiter tools: the database and page tools ({{gtClass:GtLToolForLepiterKnowledgeBases}}, {{gtClass:GtLToolForSearchForLepiterPages}}, {{gtClass:GtLToolForLepiterPageContents}}, {{gtClass:GtLToolForLepiterPageCreate}}, {{gtClass:GtLToolForLepiterPageRemove}}) and the snippet tools ({{gtClass:GtLToolForLepiterSnippetsCreate}}, {{gtClass:GtLToolForLepiterSnippetEdit}}, {{gtClass:GtLToolForLepiterSnippetsEdit}}, {{gtClass:GtLToolForLepiterSnippetsRemove}}).

I hold what they share:
- the `database` in which they look databases, pages and snippets up: the logical database unless another one is given (examples use detached databases);
- the {{gtClass:GtLLepiterSnippetLocator}} that resolves the ids, with the same refusals for every tool, and refuses ambiguous ones (`snippetLocator`);
- the check of blank arguments: the JSON schema already refuses absent and null required arguments, so only blank strings reach the tools. Snippet tools read Magritte request objects ({{gtMethod:GtLAbstractLepiterTool>>#missingArgumentAmong:in:}}), page tools the arguments of the call ({{gtMethod:GtLAbstractLepiterTool>>#missingArgumentAmong:inArguments:}});
- whether a request names the snippet of an earlier result of the same call, used to refuse a snippet edited or removed twice in one call ({{gtMethod:GtLAbstractLepiterTool>>#isReference:requestedBy:}}).
"
Class {
	#name : #GtLAbstractLepiterTool,
	#superclass : #GtLAbstractMagritteFunctionTool,
	#instVars : [
		'database'
	],
	#category : #'Gt4LlmCore-Tools'
}

{ #category : #testing }
GtLAbstractLepiterTool class >> isAbstract [
	^ self name = #GtLAbstractLepiterTool
]

{ #category : #accessing }
GtLAbstractLepiterTool >> database [
	"Return the database in which I look databases, pages and snippets up: the one I was given (a logical database or a single database), else the logical database. It is not kept, so that a tool made before a change of the logical database, or before a change of my slots, uses the current one"

	^ database ifNil: [ LeDatabasesRegistry defaultLogicalDatabase ]
]

{ #category : #accessing }
GtLAbstractLepiterTool >> database: aDatabase [
	database := aDatabase
]

{ #category : #private }
GtLAbstractLepiterTool >> isReference: aSnippetReference requestedBy: aRequest [
	"Return true if aRequest names the snippet of aSnippetReference: the same page (in base 36 or in the dashed form) and snippet ids, in the same database unless the request gives none"

	| aPageUuid aDatabaseId |
	aPageUuid := GtLLepiterSnippetLocator
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
GtLAbstractLepiterTool >> missingArgumentAmong: theArgumentNames in: aRequest [
	"Return a missing argument error for the first of theArgumentNames whose value in aRequest, a Magritte request object, is blank, or nil.
	The JSON schema already refuses absent and null required arguments: only blank strings reach the tools"

	^ self
		missingArgumentAmong: theArgumentNames
		in: aRequest
		valueOf: [ :aName | aRequest perform: aName asSymbol ]
]

{ #category : #private }
GtLAbstractLepiterTool >> missingArgumentAmong: theArgumentNames in: theArguments valueOf: aValueBlock [
	theArgumentNames
		do: [ :aName | 
			| aValue |
			aValue := aValueBlock value: aName.
			(aValue isNil or: [ aValue asString trimBoth isEmpty ])
				ifTrue: [ ^ GtLMissingArgumentDomainObject new
						arguments: theArguments;
						missingArgument: aName ] ].
	^ nil
]

{ #category : #private }
GtLAbstractLepiterTool >> missingArgumentAmong: theArgumentNames inArguments: anArgumentsDictionary [
	"Return a missing argument error for the first of theArgumentNames whose value in the arguments of a tool call is blank, or nil"

	^ self
		missingArgumentAmong: theArgumentNames
		in: anArgumentsDictionary
		valueOf: [ :aName | anArgumentsDictionary at: aName ifAbsent: [ nil ] ]
]

{ #category : #accessing }
GtLAbstractLepiterTool >> snippetLocator [
	"Return the locator that resolves databases, pages and snippets in my database, and refuses ambiguous ids"

	^ GtLLepiterSnippetLocator database: self database
]
