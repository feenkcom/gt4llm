Class {
	#name : #GtLLepiterRagQueryContext,
	#superclass : #Object,
	#instVars : [
		'queryString',
		'lepiterRagDb',
		'contextPageEntries',
		'candidatePageEntries',
		'maxContextLength',
		'rankings',
		'options',
		'rag'
	],
	#category : #'Gt4Llm-VectorDb-Support'
}

{ #category : #defaults }
GtLLepiterRagQueryContext class >> defaultMaxContextLength [

	^ 10000
]

{ #category : #accessing }
GtLLepiterRagQueryContext >> addRanking: aCollection [

	rankings add: aCollection
]

{ #category : #converting }
GtLLepiterRagQueryContext >> asRag [

	^ rag
]

{ #category : #converting }
GtLLepiterRagQueryContext >> asRagQueryContext [

	^ self
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
GtLLepiterRagQueryContext >> gtOptionsFor: aView [
	<gtView>
	options ifNil: [ ^ aView empty ].
	^ aView columnedList
		title: 'Options';
		items: [ options associations ];
		column: 'Key' text: [ :each | each key gtDisplayString ];
		column: 'Value' text: [ :each | each value gtDisplayString ];
		send: [ :each | each value ]
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

{ #category : #views }
GtLLepiterRagQueryContext >> gtRankingsFor: aView [
	<gtView>
	rankings ifNil: [ ^ aView empty ].
	^ aView columnedList
		title: 'Rankings';
		items: [ rankings ];
		column: 'Value' text: [ :each | each gtDisplayString ]
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

{ #category : #'as yet unclassified' }
GtLLepiterRagQueryContext >> initialize [

	super initialize.
	rankings := OrderedCollection new.
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

{ #category : #options }
GtLLepiterRagQueryContext >> optionAt: aSymbol [

	^ self options
		at: aSymbol
]

{ #category : #options }
GtLLepiterRagQueryContext >> optionAt: aSymbol ifPresent: presentBlock [

	^ self options
		at: aSymbol
		ifPresent: presentBlock
]

{ #category : #options }
GtLLepiterRagQueryContext >> optionAt: aSymbol ifPresent: presentBlock ifAbsent: absentBlock [

	^ self options
		at: aSymbol
		ifPresent: presentBlock
		ifAbsent: absentBlock
]

{ #category : #options }
GtLLepiterRagQueryContext >> optionAt: aSymbol put: anObject [

	^ self options
		at: aSymbol
		put: anObject
]

{ #category : #accessing }
GtLLepiterRagQueryContext >> options [

	^ options ifNil: [ options := Dictionary new ]
]

{ #category : #accessing }
GtLLepiterRagQueryContext >> queryString [
	^ queryString
]

{ #category : #accessing }
GtLLepiterRagQueryContext >> queryString: anObject [
	queryString := anObject
]

{ #category : #accessing }
GtLLepiterRagQueryContext >> rag [
	^ rag
]

{ #category : #accessing }
GtLLepiterRagQueryContext >> rag: anObject [
	rag := anObject
]

{ #category : #ui }
GtLLepiterRagQueryContext >> summaryAttributes [
	| attributes |

	attributes := {
		{ 'Lepiter DB'. lepiterRagDb ifNotNil: #lepiterDbName. }.
		{ 'Max. context length'. self maxContextLength. }.
		}.
	^ attributes
]
