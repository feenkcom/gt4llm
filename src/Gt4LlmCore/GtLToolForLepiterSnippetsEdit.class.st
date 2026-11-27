"
I am the editLepiterSnippets tool: I replace the text of several Lepiter snippets in one call. Each request ({{gtClass:GtLLepiterSnippetEditRequest}}) is edited by {{gtClass:GtLToolForLepiterSnippetEdit}}, as compileMethods uses compileMethod, so both tools answer the same results.

I answer a {{gtClass:GtLLepiterSnippetsChangeResult}}: one entry per request, in order, each a {{gtClass:GtLLepiterSnippetModificationResult}} or an error domain object. The edits are not atomic: when one fails, the earlier ones stay. A snippet that an earlier request of the same call already edited is refused, so that each result describes one edit from the original text.
"
Class {
	#name : #GtLToolForLepiterSnippetsEdit,
	#superclass : #GtLAbstractLepiterTool,
	#category : #'Gt4LlmCore-Tools'
}

{ #category : #accessing }
GtLToolForLepiterSnippetsEdit >> description [
	^ 'Replaces the whole text of Lepiter snippets: the string of a text snippet or the code of a code snippet, as getLepiterPageContents with format structure shows them. Only text and code snippets (pharo, python, shell, ...) have a text; other snippets, such as example or picture snippets, are refused.

The response has one entry per requested snippet, in order: the reference of the updated snippet, or an errorMessage. When one fails, the others are still made. List each snippet once: a second entry for it is refused.

Example JSON arguments:
{"snippets": [
  {"pageUid": "86t968o90hlfreacjec76wapk", "snippetUid": "SgJekENeTPytZjVknCfulw==", "updatedText": "New text"},
  {"databaseId": "dklrfmltzaib6womkfkknkfap", "pageUid": "86t968o90hlfreacjec76wapk", "snippetUid": "q7Tn0dVbRZ6uJ1cE4yHw2A==", "updatedText": "Transcript show: 1"}
]}

Example JSON response:
{"snippets": [
  {"status": "updated", "targetSnippetReference": {"databaseId": "dklrfmltzaib6womkfkknkfap", "pageUid": "86t968o90hlfreacjec76wapk", "snippetUid": "SgJekENeTPytZjVknCfulw=="}},
  {"errorMessage": "Could not locate snippet with id q7Tn0dVbRZ6uJ1cE4yHw2A== in page 86t968o90hlfreacjec76wapk"}
]}'
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
