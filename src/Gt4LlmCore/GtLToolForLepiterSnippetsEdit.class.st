"
I am the editLepiterSnippets tool: I replace the text of several Lepiter snippets in one call. Each request ({{gtClass:GtLLepiterSnippetEditRequest}}) is edited by {{gtClass:GtLToolForLepiterSnippetEdit}}, as compileMethods uses compileMethod, so both tools answer the same results.

I answer a {{gtClass:GtLLepiterSnippetsChangeResult}}: one entry per request, in order, each a {{gtClass:GtLLepiterSnippetModificationResult}} or an error domain object. The edits are not atomic: when one fails, the earlier ones stay. A snippet that an earlier request of the same call already edited is refused, so that each result describes one edit from the original text.
"
Class {
	#name : #GtLToolForLepiterSnippetsEdit,
	#superclass : #GtLAbstractLepiterSnippetTool,
	#category : #'Gt4LlmCore-Tools'
}

{ #category : #accessing }
GtLToolForLepiterSnippetsEdit >> description [
	^ 'Replaces the text of one or more Lepiter snippets, identified by their page ids (base 36, as getLepiterPageContents gives them) and snippet ids. updatedText is the whole new text of the snippet. Only textual snippets (text, pharo, python, shell and other code snippets) have a text; other snippets, such as example or picture snippets, are refused.

The optional databaseId is needed only when the page and snippet ids are in several databases: the response then says so and lists them.

Example JSON arguments:
{
  "snippets": [
    {"pageUid": "PAGE_ID", "snippetUid": "SNIPPET_ID", "updatedText": "New text"},
    {"databaseId": "DATABASE_ID", "pageUid": "PAGE_ID", "snippetUid": "OTHER_SNIPPET_ID", "updatedText": "Transcript show: 1"}
  ]
}

The response has one entry per requested snippet, in order: the result, or an errorMessage. The edits are not atomic: when one fails, the others are still made. A snippet that is listed twice is answered with an errorMessage for its second entry: give all its new text in one entry.

Example JSON response:
{
  "snippets": [
    {"status": "updated", "targetSnippetReference": {"databaseId": "DATABASE_ID", "pageUid": "PAGE_ID", "snippetUid": "SNIPPET_ID"}},
    {"errorMessage": "Could not locate snippet with id OTHER_SNIPPET_ID in page PAGE_ID"}
  ]
}'
]

{ #category : #accessing }
GtLToolForLepiterSnippetsEdit >> name [
	^ 'editLepiterSnippets'
]

{ #category : #private }
GtLToolForLepiterSnippetsEdit >> privatePerformToolCall: aToolCall inContext: anExecutionContext [
	"Each request is edited by the editLepiterSnippet tool, on my database"

	| editTool results |
	editTool := GtLToolForLepiterSnippetEdit new
			database: self database;
			yourself.
	results := OrderedCollection new.
	(aToolCall arguments at: 'snippets')
		do: [ :each | 
			results
				add: ((self problemOfEditedEarlier: each in: results)
						ifNil: [ editTool editSnippetFrom: each ]) ].
	^ GtLLepiterSnippetsChangeResult new
		snippetResults: results;
		yourself
]

{ #category : #private }
GtLToolForLepiterSnippetsEdit >> problemOfEditedEarlier: anEditRequest in: theEarlierResults [
	"Return an error if an earlier request of this call already edited the snippet, or nil. A second edit would make the result of the first one describe a text that the snippet no longer has"

	theEarlierResults
		do: [ :each | 
			(each isErrorDomainObject not
				and: [ self isReference: each targetSnippetReference requestedBy: anEditRequest ])
				ifTrue: [ ^ GtLProblemDomainObject new
						errorMessage: 'The snippet ' , anEditRequest snippetUid asString trimBoth
								, ' was already edited earlier in this call: give all its new text in one entry.';
						yourself ] ].
	^ nil
]

{ #category : #magritte }
GtLToolForLepiterSnippetsEdit >> snippetsDescription [
	<magritteDescription>
	^ MAToManyRelationDescription new
		label: 'Snippets';
		accessor: #snippets;
		classes: {GtLLepiterSnippetEditRequest};
		beRequired
]
