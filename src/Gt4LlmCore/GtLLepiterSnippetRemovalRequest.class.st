Class {
	#name : #GtLLepiterSnippetRemovalRequest,
	#superclass : #Object,
	#instVars : [
		'knowledgeBaseUid',
		'pageUid',
		'snippetUid'
	],
	#category : #Gt4LlmCore
}

{ #category : #accessing }
GtLLepiterSnippetRemovalRequest >> knowledgeBaseUid [
	^ knowledgeBaseUid
]

{ #category : #accessing }
GtLLepiterSnippetRemovalRequest >> knowledgeBaseUid: aKnowledgeBaseUid [
	knowledgeBaseUid := aKnowledgeBaseUid
]

{ #category : #magritte }
GtLLepiterSnippetRemovalRequest >> knowledgeBaseUidDescription [
	<magritteDescription>

	^ MAStringDescription new
		label: 'Knowledge base uid';
		accessor: #knowledgeBaseUid;
		beRequired
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
		beRequired
]
