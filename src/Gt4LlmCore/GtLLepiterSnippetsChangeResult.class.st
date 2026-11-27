"
I am the result of one call of createLepiterSnippets or removeLepiterSnippets: the snippet change results ({{gtClass:GtLLepiterSnippetChangeResult}}) and the error domain objects, in the order of the request. My JSON key is `snippets`. The results of removed descendants are nested in the result of the snippet that was asked for.

editLepiterSnippet changes one snippet and answers its {{gtClass:GtLLepiterSnippetModificationResult}} directly.
"
Class {
	#name : #GtLLepiterSnippetsChangeResult,
	#superclass : #Object,
	#instVars : [
		'snippetResults'
	],
	#category : #'Gt4LlmCore-Magritte Objects'
}

{ #category : #accessing }
GtLLepiterSnippetsChangeResult >> allChangeResults [
	"Return all the snippet change results, with the removed descendants after the snippet that was asked for"

	^ self successfulSnippetResults flatCollect: [ :each | each allResults ]
]

{ #category : #views }
GtLLepiterSnippetsChangeResult >> gtChangesFor: aView [
	<gtView>
	<gtLlmView>
	^ aView columnedList
		title: 'Snippet changes';
		priority: 1;
		items: [ self allChangeResults ];
		column: ''
			stencil: [ :each | each gtViewChangeIcon asElement ]
			width: 26;
		column: 'Change'
			text: [ :each | each llmChangeKind ]
			width: 140;
		column: 'Snippet' text: [ :each | each gtViewChangeTarget ];
		send: [ :each | each ]
]

{ #category : #views }
GtLLepiterSnippetsChangeResult >> gtResultsFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Results';
		priority: 2;
		items: [ self snippetResults ];
		column: 'Result' text: [ :each | each printString ];
		send: [ :each | each ]
]

{ #category : #testing }
GtLLepiterSnippetsChangeResult >> isErrorDomainObject [
	"I am a result also when some of my snippets failed: each failure is one of my snippet results"

	^ false
]

{ #category : #'llm views' }
GtLLepiterSnippetsChangeResult >> llmRawDataViewFor: aDataView [
	<gtLlmDataView>
	^ aDataView forwardCollection
		dataKey: 'snippets';
		collection: [ self snippetResults ]
]

{ #category : #printing }
GtLLepiterSnippetsChangeResult >> printOn: aStream [
	super printOn: aStream.
	aStream
		parenthesize: [ aStream
				print: self successfulSnippetResults size;
				nextPutAll: ' of ';
				print: self snippetResults size;
				nextPutAll: ' snippet changes' ]
]

{ #category : #accessing }
GtLLepiterSnippetsChangeResult >> snippetResults [
	"Return the snippet change results and the error domain objects, in the order of the request"

	^ snippetResults ifNil: [ #() ]
]

{ #category : #accessing }
GtLLepiterSnippetsChangeResult >> snippetResults: aCollection [
	snippetResults := aCollection asArray
]

{ #category : #accessing }
GtLLepiterSnippetsChangeResult >> snippets [
	"Return my snippet results, as #snippetResults; named after the key of my JSON"

	^ self snippetResults
]

{ #category : #accessing }
GtLLepiterSnippetsChangeResult >> successfulSnippetResults [
	^ self snippetResults reject: [ :each | each isErrorDomainObject ]
]
