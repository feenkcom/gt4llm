Class {
	#name : #GtLLepiterSnippetsDomainObject,
	#superclass : #GtLDomainObject,
	#instVars : [
		'snippets'
	],
	#category : #Gt4LlmCore
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

{ #category : #serialization }
GtLLepiterSnippetsDomainObject >> serializeToOpenAIResponseJsonObject [
	"Return a JSON dictionary that represents the domain object."

	<return: #NeoJSONObject>
	^ NeoJSONObject new
		at: #snippets
			put: (self snippets collect: [ :eachSnippet | 
				NeoJSONObject new
					at: #status put: eachSnippet status;
					at: #pageUid put: eachSnippet pageUid;
					at: #snippetUid put: eachSnippet snippetUid;
					yourself ]);
		yourself
]

{ #category : #accessing }
GtLLepiterSnippetsDomainObject >> snippets [
	^ snippets
]

{ #category : #accessing }
GtLLepiterSnippetsDomainObject >> snippets: aCollection [
	snippets := aCollection
]
