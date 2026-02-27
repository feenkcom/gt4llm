Class {
	#name : #GtLLepiterSnippetDomainObject,
	#superclass : #Object,
	#instVars : [
		'status',
		'pageUid',
		'snippetUid',
		'snippet'
	],
	#category : #Gt4LlmCore
}

{ #category : #'gt-views' }
GtLLepiterSnippetDomainObject >> gtSnippetFor: aView [
	<gtView>
	^ aView forward
		title: 'Snippet';
		priority: 1;
		object: [ snippet ];
		view: #gtLiveFor:
]

{ #category : #accessing }
GtLLepiterSnippetDomainObject >> pageUid [
	^ pageUid
]

{ #category : #accessing }
GtLLepiterSnippetDomainObject >> pageUid: aString [
	pageUid := aString
]

{ #category : #magritte }
GtLLepiterSnippetDomainObject >> pageUidDescription [
	<magritteDescription>

	^ MAStringDescription new
		label: 'Page uid';
		accessor: #pageUid;
		beRequired
]

{ #category : #accessing }
GtLLepiterSnippetDomainObject >> snippet [
	^ snippet
]

{ #category : #accessing }
GtLLepiterSnippetDomainObject >> snippet: aSnippet [
	snippet := aSnippet
]

{ #category : #accessing }
GtLLepiterSnippetDomainObject >> snippetUid [
	^ snippetUid
]

{ #category : #accessing }
GtLLepiterSnippetDomainObject >> snippetUid: aString [
	snippetUid := aString
]

{ #category : #magritte }
GtLLepiterSnippetDomainObject >> snippetUidDescription [
	<magritteDescription>

	^ MAStringDescription new
		label: 'Snippet uid';
		accessor: #snippetUid;
		beRequired
]

{ #category : #accessing }
GtLLepiterSnippetDomainObject >> status [
	^ status
]

{ #category : #accessing }
GtLLepiterSnippetDomainObject >> status: aString [
	status := aString
]

{ #category : #magritte }
GtLLepiterSnippetDomainObject >> statusDescription [
	<magritteDescription>

	^ MAStringDescription new
		label: 'Status';
		accessor: #status;
		beRequired
]
