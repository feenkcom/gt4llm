Class {
	#name : #GtVectorDbLepiterKey,
	#superclass : #Object,
	#instVars : [
		'lepiterDbName',
		'lepiterPageName',
		'lepiterSnippetUid'
	],
	#category : #'Gt4Llm-VectorDb-Model'
}

{ #category : #'llm-generated' }
GtVectorDbLepiterKey >> = anObject [
	self == anObject ifTrue: [ ^ true ].
	(self class = anObject class) ifFalse: [ ^ false ].
	^ self lepiterDbName = anObject lepiterDbName
		and: [ self lepiterPageName = anObject lepiterPageName
		and: [ self lepiterSnippetUid = anObject lepiterSnippetUid ] ]
]

{ #category : #ui }
GtVectorDbLepiterKey >> gtLepiterPageFor: aView [
	<gtView>
	
	(lepiterDbName isNil or: [ lepiterPageName isNil ]) ifTrue:
		[ ^ aView empty ].
	^ aView forward
		title: 'Page';
		priority: 20;
		object: [ self lepiterPage ];
		view: #gtLiveFor:
]

{ #category : #ui }
GtVectorDbLepiterKey >> gtSummaryFor: aView [
	<gtView>

	^ aView columnedList
		  title: 'Summary';
		  priority: 10;
		  items: [ self summaryAttributes ];
		  column: #Attribute text: [ :item | item first ];
		  column: #Value text: [ :item | item second ];
		  send: #last.
]

{ #category : #'llm-generated' }
GtVectorDbLepiterKey >> hash [
	^ {
		self lepiterDbName.
		self lepiterPageName.
		self lepiterSnippetUid } hash
]

{ #category : #accessing }
GtVectorDbLepiterKey >> lepiterDbName [
	^ lepiterDbName
]

{ #category : #accessing }
GtVectorDbLepiterKey >> lepiterDbName: anObject [
	lepiterDbName := anObject
]

{ #category : #accessing }
GtVectorDbLepiterKey >> lepiterPage [
	| lepiterDb |

	lepiterDb := LeDatabasesRegistry defaultLogicalDatabase databaseNamed: lepiterDbName.
	lepiterDb
		pageNamed: lepiterPageName 
		ifPresent: [ :page | ^ page ]
		ifAbsent:
			[ lepiterDb unnamedPagesDo: [ :page |
				page title = lepiterPageName ifTrue:
					[ ^ page ] ] ].
	KeyNotFound signalFor: lepiterPageName.
]

{ #category : #accessing }
GtVectorDbLepiterKey >> lepiterPageName [
	^ lepiterPageName
]

{ #category : #accessing }
GtVectorDbLepiterKey >> lepiterPageName: anObject [
	lepiterPageName := anObject
]

{ #category : #accessing }
GtVectorDbLepiterKey >> lepiterSnippetUid [
	^ lepiterSnippetUid
]

{ #category : #accessing }
GtVectorDbLepiterKey >> lepiterSnippetUid: anObject [
	lepiterSnippetUid := anObject
]

{ #category : #ui }
GtVectorDbLepiterKey >> summaryAttributes [

	^ {
		{ 'Lepiter DB'. lepiterDbName. }.
		{ 'Page name'. lepiterPageName }.
		}
]
