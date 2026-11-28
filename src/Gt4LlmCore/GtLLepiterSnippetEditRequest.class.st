"
I am the request to replace the text of one Lepiter snippet, as {{gtClass:GtLToolForLepiterSnippetEdit}} (editLepiterSnippet) takes one and {{gtClass:GtLToolForLepiterSnippetsEdit}} (editLepiterSnippets) takes a list of them. The snippet is named by its page id (base 36) and snippet id; the optional databaseId tells apart a page that is in several databases.
"
Class {
	#name : #GtLLepiterSnippetEditRequest,
	#superclass : #Object,
	#instVars : [
		'databaseId',
		'pageUid',
		'snippetUid',
		'updatedText'
	],
	#category : #'Gt4LlmCore-Magritte Objects'
}

{ #category : #accessing }
GtLLepiterSnippetEditRequest >> databaseId [
	^ databaseId
]

{ #category : #accessing }
GtLLepiterSnippetEditRequest >> databaseId: aString [
	databaseId := aString
]

{ #category : #magritte }
GtLLepiterSnippetEditRequest >> databaseIdDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Database id';
		accessor: #databaseId;
		comment: 'Optional id of the database of the page, from lepiterKnowledgeBases. Needed only when the page and snippet ids are in several databases: the errorMessage then lists them.';
		yourself
]

{ #category : #accessing }
GtLLepiterSnippetEditRequest >> pageUid [
	^ pageUid
]

{ #category : #accessing }
GtLLepiterSnippetEditRequest >> pageUid: aString [
	pageUid := aString
]

{ #category : #magritte }
GtLLepiterSnippetEditRequest >> pageUidDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Page uid';
		accessor: #pageUid;
		comment: 'The id of the page (base 36), from searchForLepiterPages or createLepiterPage.';
		beRequired
]

{ #category : #accessing }
GtLLepiterSnippetEditRequest >> snippetUid [
	^ snippetUid
]

{ #category : #accessing }
GtLLepiterSnippetEditRequest >> snippetUid: aString [
	snippetUid := aString
]

{ #category : #magritte }
GtLLepiterSnippetEditRequest >> snippetUidDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Snippet uid';
		accessor: #snippetUid;
		comment: 'The id of the snippet (base 64), from getLepiterPageContents with format structure or from createLepiterSnippets.';
		beRequired
]

{ #category : #accessing }
GtLLepiterSnippetEditRequest >> updatedText [
	^ updatedText
]

{ #category : #accessing }
GtLLepiterSnippetEditRequest >> updatedText: aString [
	updatedText := aString
]

{ #category : #magritte }
GtLLepiterSnippetEditRequest >> updatedTextDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Updated text';
		accessor: #updatedText;
		comment: 'The whole new text of the snippet: the string of a text snippet or the code of a code snippet. Must not be blank.';
		beRequired
]
