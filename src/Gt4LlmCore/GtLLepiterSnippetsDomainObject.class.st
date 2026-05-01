Class {
	#name : #GtLLepiterSnippetsDomainObject,
	#superclass : #Object,
	#instVars : [
		'snippets'
	],
	#category : #'Gt4LlmCore-Magritte Objects'
}

{ #category : #'gt-views' }
GtLLepiterSnippetsDomainObject >> gtSnippetsFor: aView [
	<gtView>
	<gtLlmView>
	snippets ifNil: [ ^ aView empty ].
	^ aView columnedList
		title: 'Snippets';
		priority: 1;
		items: [ self snippets ];
		column: 'Status' text: [ :each | each status ] width: 80;
		column: 'Page uid' text: [ :each | each pageUid ] width: 160;
		column: 'Snippet uid' text: [ :each | each snippetUid ] width: 160
]

{ #category : #'llm views' }
GtLLepiterSnippetsDomainObject >> llmRawDataViewFor: aDataView [
	<gtLlmDataView>
	
	^ aDataView magritteObject: [ self ]
]

{ #category : #accessing }
GtLLepiterSnippetsDomainObject >> snippets [
	^ snippets
]

{ #category : #accessing }
GtLLepiterSnippetsDomainObject >> snippets: aCollection [
	snippets := aCollection
]

{ #category : #serialization }
GtLLepiterSnippetsDomainObject >> snippetsDescription [
	<magritteDescription>

	^ MAToManyRelationDescription new
		label: 'Snippets';
		accessor: #snippets;
		classes: {GtLLepiterSnippetDomainObject};
		beRequired
]
