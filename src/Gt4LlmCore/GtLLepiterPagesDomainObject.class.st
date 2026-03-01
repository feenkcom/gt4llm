Class {
	#name : #GtLLepiterPagesDomainObject,
	#superclass : #GtLDomainObject,
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

{ #category : #accessing }
GtLLepiterPagesDomainObject >> pages [
	^ pages ifNil: [ #() ]
]

{ #category : #accessing }
GtLLepiterPagesDomainObject >> pages: anObject [
	pages := anObject
]

{ #category : #'api - serializing' }
GtLLepiterPagesDomainObject >> serializeToOpenAIResponseJsonObject [
	"Return a JSON dictionary that represents the domain object."

	<return: #NeoJSONObject>
	^ NeoJSONObject new
		at: #pages
			put: (self pages
					collect: [ :eachPage | 
						NeoJSONObject new
							at: #pageTitle put: eachPage title;
							at: #uuid put: eachPage uid asString36;
							yourself ]);
		yourself
]
