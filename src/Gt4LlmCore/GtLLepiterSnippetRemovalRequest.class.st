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
		comment: 'Optional id of the database of the page, as lepiterKnowledgeBases lists it. Needed only when the page and snippet ids are in several databases.';
		accessor: #databaseId;
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
		comment: 'The id of the page (base 36), as getLepiterPageContents gives it.';
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
		comment: 'The uid of the snippet, as getLepiterPageContents gives it.';
		beRequired
]
