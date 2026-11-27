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
	"Add the snippet to the page, or to the parent snippet, and answer its addition result"

	| pageUidString parentSnippetUidString locator parent snippet |
	pageUidString := snippetArguments pageUid.
	(pageUidString isNil or: [ pageUidString trimBoth isEmpty ])
		ifTrue: [ ^ GtLMissingArgumentDomainObject new
				arguments: snippetArguments;
				missingArgument: 'pageUid' ].
	^ snippetArguments
		validateSnippetArgumentsFor: self
		ifCorrect: [ locator := GtLLepiterSnippetLocator database: self database.
			parentSnippetUidString := snippetArguments parentSnippetUid
					ifNil: [ '' ]
					ifNotNil: [ :aString | aString asString trimBoth ].
			parentSnippetUidString isEmpty
				ifTrue: [ locator
						pageWithUid: pageUidString
						databaseId: snippetArguments databaseId
						ifFound: [ :aPage | parent := aPage ]
						ifNone: [ :aProblem | ^ aProblem ] ]
				ifFalse: [ locator
						snippetWithUid: parentSnippetUidString
						pageUid: pageUidString
						databaseId: snippetArguments databaseId
						ifFound: [ :aSnippet | parent := aSnippet ]
						ifNone: [ :aProblem | ^ aProblem ] ].
			[ snippet := snippetArguments buildSnippetFor: self.
			parent addSnippet: snippet ]
				on: Error
				do: [ :error | 
					^ GtLExceptionDomainObject new
						freeze: error;
						errorReason: 'Error while creating snippet' ].
			GtLLepiterSnippetAdditionResult new
				newSnippet: (GtLLepiterSnippetWithContent fromSnippet: snippet);
				yourself ]
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
	^ 'Creates new Lepiter snippets in pages identified by their page ids (base 36, as getLepiterPageContents and searchForLepiterPages give them). A snippet is added at the end of the page, or at the end of the children of parentSnippetUid when it is given.

The optional databaseId is needed only when the page id is in several databases: the response then says so and lists them.

Example JSON arguments:
{
  "snippets": [
    {"TextSnippet": {"pageUid": "PAGE_ID", "snippetText": "Notes"}},
    {"PharoSnippet": {"pageUid": "PAGE_ID", "parentSnippetUid": "SNIPPET_ID", "pharoCode": "Transcript show: 1"}},
    {"PictureSnippet": {"pageUid": "PAGE_ID", "urlString": "https://example.com/picture.png", "caption": "Optional caption", "previewHeight": 200}},
    {"ExampleSnippet": {"pageUid": "PAGE_ID", "databaseId": "DATABASE_ID", "exampleClassName": "MyExamples", "exampleMethodName": "exampleMethod"}}
  ]
}

Supported snippet types are: text, pharo, python, shell, example, picture.

The response has one entry per requested snippet, in order: the result, or an errorMessage. A result names the created snippet with its databaseId, pageUid and snippetUid.

Example JSON response:
{
  "snippets": [
    {"status": "created", "targetSnippetReference": {"databaseId": "DATABASE_ID", "pageUid": "PAGE_ID", "snippetUid": "SNIPPET_ID"}},
    {"errorMessage": "Could not locate page with id PAGE_ID"}
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
	"The JSON schema and the Magritte reader make each element of snippets a creation request of the type its key names, so the elements need no type check"

	| results |
	results := (aToolCall arguments at: 'snippets')
			collect: [ :each | self createSnippetFrom: each ].
	^ GtLLepiterSnippetsChangeResult new
		snippetResults: results;
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
		'example' -> LeExampleSnippet.
		'picture' -> LePictureSnippet } asDictionary
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
			GtLLepiterExampleSnippetCreationRequest.
			GtLLepiterPictureSnippetCreationRequest };
		useExplicitContainerForChildren;
		beRequired
]
