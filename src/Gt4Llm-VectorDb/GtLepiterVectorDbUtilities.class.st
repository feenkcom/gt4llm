"
Create a Vector Db loaded with the GT Book.
"
Class {
	#name : #GtLepiterVectorDbUtilities,
	#superclass : #Object,
	#instVars : [
		'vectorDb',
		'splitter',
		'lepiterDbName'
	],
	#category : #'Gt4Llm-VectorDb-Support'
}

{ #category : #'instance creation' }
GtLepiterVectorDbUtilities class >> createVectorDb [

	^ self new vectorDb
]

{ #category : #'instance creation' }
GtLepiterVectorDbUtilities class >> loadDefault [

	^ self loadFrom: 'gt-book.vectordb.ston'
]

{ #category : #'instance creation' }
GtLepiterVectorDbUtilities class >> loadFrom: aFileReference [
	| vectorDb |

	vectorDb := aFileReference asFileReference readStreamDo: [ :stream |
		STON fromStream: stream ].
	^ self new
		vectorDb: vectorDb.
]

{ #category : #api }
GtLepiterVectorDbUtilities >> createVectorDb [
	| pages |
	
	vectorDb := GtSimpleInMemoryVectorDatabase new.
	pages := (LeDatabasesRegistry defaultLogicalDatabase databaseNamed: self lepiterDbName) pages.
	pages doWithIndex: [ :aPage :index |
		Stdio stdout
			print: index;
			<< ': ';
			<< aPage title asString;
			lf; flush.
		self loadLepiterPage: aPage ].
	^ vectorDb
]

{ #category : #'as yet unclassified' }
GtLepiterVectorDbUtilities >> databaseName [

	^ LeDatabase gtBookName.
]

{ #category : #ui }
GtLepiterVectorDbUtilities >> gtSummaryFor: aView [
	<gtView>

	^ aView columnedList
		  title: 'Summary';
		  priority: 5;
		  items: [ self summaryAttributes ];
		  column: #Attribute text: [ :item | item first ];
		  column: #Value text: [ :item | item second ];
		  send: #last.
]

{ #category : #api }
GtLepiterVectorDbUtilities >> initialize [

	super initialize.
	splitter := GtRecursiveCharacterTextSplitter new.
	splitter
		chunkSize: 1200;
		chunkOverlap: 300;
		separators: { String lf , String lf . ' ' . '' };
		beDropSeparator.
]

{ #category : #accessing }
GtLepiterVectorDbUtilities >> lepiterDbName [
	^ lepiterDbName ifNil: [ lepiterDbName := LeDatabase gtBookName ].
]

{ #category : #accessing }
GtLepiterVectorDbUtilities >> lepiterDbName: anObject [
	lepiterDbName := anObject
]

{ #category : #private }
GtLepiterVectorDbUtilities >> loadLepiterPage: aPage [
	| dbKey serialisedPage documents |

	dbKey := GtVectorDbLepiterKey new
			lepiterDbName: self databaseName;
			lepiterPageName: aPage title;
			lepiterSnippetUid: nil.
	serialisedPage := GtLLepiterContentExporter new
					strictMode: false;
					page: aPage;
					export.
	documents := serialisedPage size > 1200 ifTrue:
			[ splitter splitText: serialisedPage ]
	ifFalse:
			[ { serialisedPage } ].
	documents do: [ :document |
		document ifNotEmpty:
			[ vectorDb addDocument: document key: dbKey. ] ].
]

{ #category : #private }
GtLepiterVectorDbUtilities >> loadLepiterPageBySnippet: aPage [

	aPage allChildrenDepthFirstDo: [ :snippet | | dbKey serialisedSnippet documents |
		dbKey := GtVectorDbLepiterKey new
			lepiterDbName: self databaseName;
			lepiterPageName: aPage title;
			lepiterSnippetUid: snippet uid.
		serialisedSnippet := (GtLLepiterContentExporter new
							page: snippet;
							export) trimBoth.
		documents := serialisedSnippet size > 1200 ifTrue:
			[ splitter splitText: serialisedSnippet ]
		ifFalse:
			[ { serialisedSnippet } ].
		documents do: [ :document |
			document ifNotEmpty:
				[ vectorDb addDocument: document key: dbKey. ] ] ].
]

{ #category : #querying }
GtLepiterVectorDbUtilities >> pageNamesFor: aString maxCount: anInteger [
	"Answer the page names that semantically match the supplied string"
	| matchingEmbeddings |

	matchingEmbeddings := vectorDb query: aString maxMatches: anInteger.
	^ matchingEmbeddings collect: [ :each | each embedding key lepiterPageName ]
]

{ #category : #ui }
GtLepiterVectorDbUtilities >> summaryAttributes [
	| pageNamesIndexed |
	
	pageNamesIndexed := vectorDb embeddings
		collect: [ :embedding | embedding key lepiterPageName ] 
		as: Set.
	^ {
		{ 'Number of index entries'. vectorDb embeddings size. }.
		{ 'Number of pages indexed'. pageNamesIndexed size }.
		{ 'Vector size'. vectorDb embeddings first embedding size. }.
		}.
]

{ #category : #accessing }
GtLepiterVectorDbUtilities >> vectorDb [
	^ vectorDb ifNil: [ self createVectorDb ]
]

{ #category : #accessing }
GtLepiterVectorDbUtilities >> vectorDb: anObject [
	vectorDb := anObject
]
