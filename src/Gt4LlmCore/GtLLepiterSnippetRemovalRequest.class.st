Class {
	#name : #GtLLepiterSnippetRemovalRequest,
	#superclass : #Object,
	#instVars : [
		'databaseId',
		'pageUid',
		'snippetUid'
	],
	#category : #'Gt4LlmCore-Magritte Objects'
}

{ #category : #accessing }
GtLLepiterSnippetRemovalRequest >> databaseId [
	^ databaseId
]

{ #category : #accessing }
GtLLepiterSnippetRemovalRequest >> databaseId: aString [
	databaseId := aString
]

{ #category : #magritte }
GtLLepiterSnippetRemovalRequest >> databaseIdDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Database id';
		accessor: #databaseId;
		comment: 'Optional id of the database of the page, from lepiterKnowledgeBases. Needed only when the page and snippet ids are in several databases: the errorMessage then lists them.';
		yourself
]

{ #category : #accessing }
GtLLepiterSnippetRemovalRequest >> pageUid [
	^ pageUid
]

{ #category : #accessing }
GtLLepiterSnippetRemovalRequest >> pageUid: aPageUid [
	pageUid := aPageUid
]

{ #category : #magritte }
GtLLepiterSnippetRemovalRequest >> pageUidDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Page uid';
		accessor: #pageUid;
		comment: 'The id of the page (base 36), from searchForLepiterPages or createLepiterPage.';
		beRequired
]

{ #category : #accessing }
GtLLepiterSnippetRemovalRequest >> snippetUid [
	^ snippetUid
]

{ #category : #accessing }
GtLLepiterSnippetRemovalRequest >> snippetUid: aSnippetUid [
	snippetUid := aSnippetUid
]

{ #category : #magritte }
GtLLepiterSnippetRemovalRequest >> snippetUidDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Snippet uid';
		accessor: #snippetUid;
		comment: 'The id of the snippet (base 64), from getLepiterPageContents with format structure or from createLepiterSnippets.';
		beRequired
]
