"
I describe a snippet changed by the Wardley map edit tool (GtWardleyMapEditTool, in Gt4Llm-WardleyMap), which is my only user: status, page uid, snippet uid and the live snippet.

The Lepiter snippet tools answer snapshot-based results instead ({{gtClass:GtLLepiterSnippetChangeResult}}, in a {{gtClass:GtLLepiterSnippetsChangeResult}}). I am kept unchanged for the Wardley tool, which proposes changes rather than making them; moving me to Gt4Llm-WardleyMap, or replacing me, is a separate step.
"
Class {
	#name : #GtLLepiterSnippetDomainObject,
	#superclass : #Object,
	#instVars : [
		'status',
		'pageUid',
		'snippetUid',
		'snippet'
	],
	#category : #'Gt4LlmCore-Magritte Objects'
}

{ #category : #'gt-views' }
GtLLepiterSnippetDomainObject >> gtSnippetFor: aView [
	<gtView>
	<gtLlmView>
	^ aView forward
		title: 'Snippet';
		priority: 1;
		object: [ snippet ];
		view: #gtLiveFor:
]

{ #category : #'llm views' }
GtLLepiterSnippetDomainObject >> llmRawDataViewFor: aDataView [
	<gtLlmDataView>
	
	^ aDataView magritteObject: [ self ]
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
