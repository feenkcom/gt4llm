Class {
	#name : #GtLLepiterRagQueryContext,
	#superclass : #Object,
	#instVars : [
		'queryString',
		'lepiterRagDb',
		'contextPageEntries',
		'candidatePageEntries',
		'maxContextLength'
	],
	#category : #'Gt4Llm-VectorDb-Support'
}

{ #category : #defaults }
GtLLepiterRagQueryContext class >> defaultMaxContextLength [

	^ 10000
]

{ #category : #accessing }
GtLLepiterRagQueryContext >> candidatePageEntries [
	^ candidatePageEntries
]

{ #category : #accessing }
GtLLepiterRagQueryContext >> candidatePageEntries: anObject [
	candidatePageEntries := anObject
]

{ #category : #accessing }
GtLLepiterRagQueryContext >> contextPageEntries [
	^ contextPageEntries
]

{ #category : #accessing }
GtLLepiterRagQueryContext >> contextPageEntries: anObject [
	contextPageEntries := anObject
]

{ #category : #views }
GtLLepiterRagQueryContext >> gtCandidatePageEntriesFor: aView [
	<gtView>
	candidatePageEntries ifNil: [ ^ aView empty ].
	^ aView columnedList
		title: 'CandidatePageEntries';
		priority: 15;
		items: [ candidatePageEntries ];
		column: 'Title' text: [ :each | each pageName gtDisplayString ]
]

{ #category : #views }
GtLLepiterRagQueryContext >> gtContextPageEntriesFor: aView [
	<gtView>
	contextPageEntries ifNil: [ ^ aView empty ].
	^ aView columnedList
		title: 'ContextPageEntries';
		priority: 20;
		items: [ contextPageEntries ];
		column: 'Title' text: [ :each | each pageName gtDisplayString ]
]

{ #category : #views }
GtLLepiterRagQueryContext >> gtQueryStringFor: aView [
	<gtView>
	queryString ifNil: [ ^ aView empty ].
	^ aView text
		title: 'QueryString';
		priority: 10;
		text: [ queryString ]
]

{ #category : #ui }
GtLLepiterRagQueryContext >> gtSummaryFor: aView [
	<gtView>

	^ aView columnedList
		  title: 'Summary';
		  priority: 5;
		  items: [ self summaryAttributes ];
		  column: #Attribute text: [ :item | item first ];
		  column: #Value text: [ :item | item second ];
		  send: #last.
]

{ #category : #accessing }
GtLLepiterRagQueryContext >> lepiterRagDb [
	^ lepiterRagDb
]

{ #category : #accessing }
GtLLepiterRagQueryContext >> lepiterRagDb: anObject [
	lepiterRagDb := anObject
]

{ #category : #accessing }
GtLLepiterRagQueryContext >> maxContextLength [
	^ maxContextLength ifNil: [ maxContextLength := self class defaultMaxContextLength ]
]

{ #category : #accessing }
GtLLepiterRagQueryContext >> maxContextLength: anObject [
	maxContextLength := anObject
]

{ #category : #accessing }
GtLLepiterRagQueryContext >> queryString [
	^ queryString
]

{ #category : #accessing }
GtLLepiterRagQueryContext >> queryString: anObject [
	queryString := anObject
]

{ #category : #ui }
GtLLepiterRagQueryContext >> summaryAttributes [
	| attributes |

	attributes := {
		{ 'Lepiter DB'. lepiterRagDb ifNotNil: #lepiterDbName. }.
		{ 'Max. context length'. self maxContextLength. }.
		}.
	lepiterRagDb ifNotNil:
		[ attributes := attributes, lepiterRagDb summaryAttributes ].
	^ attributes
]
