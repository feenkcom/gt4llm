Class {
	#name : #GtLToolForLepiterSnippetEdit,
	#superclass : #GtLAbstractMagritteFunctionTool,
	#instVars : [
		'database'
	],
	#category : #'Gt4LlmCore-Tools'
}

{ #category : #accessing }
GtLToolForLepiterSnippetEdit >> database [
	^ database
]

{ #category : #accessing }
GtLToolForLepiterSnippetEdit >> database: aDatabase [
	database := aDatabase
]

{ #category : #magritte }
GtLToolForLepiterSnippetEdit >> databaseIdDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Database id';
		comment: 'Optional id of the database of the page, as lepiterKnowledgeBases lists it. Needed only when the page and snippet ids are in several databases.';
		accessor: #databaseId;
		yourself
]

{ #category : #accessing }
GtLToolForLepiterSnippetEdit >> description [
	^ 'Replaces the text of a Lepiter snippet identified by its page id (base 36, as getLepiterPageContents gives it) and snippet id. Only textual snippets (text, pharo, python, shell and other code snippets) have a text; other snippets, such as example or picture snippets, are refused.

The optional databaseId is needed only when the page and snippet ids are in several databases: the response then says so and lists them.

Example JSON arguments:
{"pageUid": "PAGE_ID", "snippetUid": "SNIPPET_ID", "updatedText": "New text"}

Example JSON response:
{"status": "updated", "targetSnippetReference": {"databaseId": "DATABASE_ID", "pageUid": "PAGE_ID", "snippetUid": "SNIPPET_ID"}}'
]

{ #category : #initialization }
GtLToolForLepiterSnippetEdit >> initialize [
	super initialize.
	database := LeDatabasesRegistry defaultLogicalDatabase
]

{ #category : #private }
GtLToolForLepiterSnippetEdit >> missingArgumentIn: arguments [
	"Return a missing argument error for the first required argument that is blank, or nil.
	The JSON schema already refuses absent and null arguments. The ids are trimmed; the text is not, since spaces can be the new text"

	#('pageUid' 'snippetUid')
		do: [ :aName | 
			(arguments at: aName) trimBoth isEmpty
				ifTrue: [ ^ GtLMissingArgumentDomainObject new
						arguments: arguments;
						missingArgument: aName ] ].
	(arguments at: 'updatedText') isEmpty
		ifTrue: [ ^ GtLMissingArgumentDomainObject new
				arguments: arguments;
				missingArgument: 'updatedText' ].
	^ nil
]

{ #category : #accessing }
GtLToolForLepiterSnippetEdit >> name [
	^ 'editLepiterSnippet'
]

{ #category : #magritte }
GtLToolForLepiterSnippetEdit >> pageUidDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Page uid';
		accessor: #pageUid;
		comment: 'The id of the page (base 36), as getLepiterPageContents gives it.';
		beRequired
]

{ #category : #private }
GtLToolForLepiterSnippetEdit >> privatePerformToolCall: aToolCall inContext: anExecutionContext [
	| arguments snippet oldSnippet |
	arguments := aToolCall arguments.
	(self missingArgumentIn: arguments) ifNotNil: [ :aProblem | ^ aProblem ].
	snippet := self snippetToEditFrom: arguments ifNone: [ :aProblem | ^ aProblem ].
	oldSnippet := GtLLepiterSnippetWithContent fromSnippet: snippet.
	[ snippet updateString: (arguments at: 'updatedText') ]
		on: Error
		do: [ :error | 
			^ GtLExceptionDomainObject new
				freeze: error;
				errorReason: 'Error while applying snippet change' ].
	^ GtLLepiterSnippetModificationResult new
		oldSnippet: oldSnippet;
		newSnippet: (GtLLepiterSnippetWithContent fromSnippet: snippet);
		yourself
]

{ #category : #private }
GtLToolForLepiterSnippetEdit >> refusalToEdit: aSnippet [
	"Return why the snippet cannot be edited, or nil. Only the text of a textual snippet can be replaced"

	| aType |
	(aSnippet isKindOf: LeUnknownSnippet)
		ifTrue: [ ^ GtLProblemDomainObject new
				errorMessage: 'The snippet ' , aSnippet uid uidString
						, ' is of an unknown type (Lepiter could not load its class), so it cannot be edited. Change it in the Glamorous Toolkit, or remove it with removeLepiterSnippets.';
				yourself ].
	(aSnippet isKindOf: LeTextualSnippet) ifTrue: [ ^ nil ].
	aType := GtLLepiterSnippetWithContent snippetTypeOf: aSnippet.
	^ GtLProblemDomainObject new
		errorMessage: 'The snippet ' , aSnippet uid uidString , ' is a snippet of type ' , aType
				, ', which has no text: editLepiterSnippet only replaces the text of textual snippets (text, pharo, python, shell and other code snippets). To change an example or picture snippet, remove it with removeLepiterSnippets and create a new one with createLepiterSnippets: the removal also removes its child snippets, and the new snippet gets a new id and is added at the end of the page or of its parent. Other types can only be changed in the Glamorous Toolkit.';
		yourself
]

{ #category : #private }
GtLToolForLepiterSnippetEdit >> snippetToEditFrom: arguments ifNone: aBlock [
	"Return the snippet named by the arguments, or the value of aBlock with the problem: not found, ambiguous, or not editable"

	| snippet |
	snippet := (GtLLepiterSnippetLocator database: self database)
			snippetWithUid: (arguments at: 'snippetUid')
			pageUid: (arguments at: 'pageUid')
			databaseId: (arguments at: 'databaseId' ifAbsent: [ nil ])
			ifFound: [ :aSnippet | aSnippet ]
			ifNone: [ :aProblem | ^ aBlock value: aProblem ].
	(self refusalToEdit: snippet)
		ifNotNil: [ :aProblem | ^ aBlock value: aProblem ].
	^ snippet
]

{ #category : #magritte }
GtLToolForLepiterSnippetEdit >> snippetUidDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Snippet uid';
		accessor: #snippetUid;
		comment: 'The uid of the snippet, as getLepiterPageContents gives it.';
		beRequired
]

{ #category : #magritte }
GtLToolForLepiterSnippetEdit >> updatedTextDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Updated text';
		accessor: #updatedText;
		comment: 'The whole new text of the snippet. It replaces the current text and must not be empty.';
		beRequired
]
