Class {
	#name : #GtLLepiterPagesDomainObject,
	#superclass : #Object,
	#instVars : [
		'pages'
	],
	#category : #'Gt4LlmCore-Domain Objects'
}

{ #category : #'gt - extensions' }
GtLLepiterPagesDomainObject >> gtPagesFor: aView [
	<gtView>
	<gtLlmView>
	pages ifNil: [ ^ aView empty ].
	^ aView columnedList
		title: 'Pages';
		priority: 1;
		items: [ self pages ];
		column: 'Page' text: [ :each | each title ] width: 200;
		column: 'Preview' text: [:each | each printPageSummaryLimitedTo: 100 ];
		column: 'Database' text: [ :each | each database databaseName ] width: 100
]

{ #category : #'llm views' }
GtLLepiterPagesDomainObject >> llmRawDataViewFor: aDataView [
	<gtLlmDataView>
	
	^ aDataView jsonObject: [ :json |
		json
			at: #pages
			put: (self pages collect: [ :eachPage | 
				Dictionary new
					at: #pageTitle put: eachPage title;
					at: #pageUid put: eachPage uid asString36;
					at: #databaseId put: eachPage database uuidString;
					yourself ]) ]
]

{ #category : #accessing }
GtLLepiterPagesDomainObject >> pages [
	^ pages ifNil: [ #() ]
]

{ #category : #accessing }
GtLLepiterPagesDomainObject >> pages: anObject [
	pages := anObject
]
