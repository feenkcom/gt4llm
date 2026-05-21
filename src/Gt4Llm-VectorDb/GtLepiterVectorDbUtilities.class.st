"
Create a Vector Db loaded on the specified lepiter knowledge base.

GtLepiterVectorDbUtilities assumes that lepiter pages are generally fairly short, so naively splits text in to chunks of a fixed length as specified in {{gtMethod:GtLepiterVectorDbUtilities>>#initialize}} for indexing, however the entire lepiter page is always included as the context.
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

{ #category : #accessing }
GtLepiterVectorDbUtilities class >> defaultChunkOverlap [
	"Answer the default number of characters to overlap between chunks"
	
	^ 300
]

{ #category : #accessing }
GtLepiterVectorDbUtilities class >> defaultChunkSize [
	"Answer the default size of text to index"
	
	^ 1200
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
		self loadLepiterPage: aPage ].
	^ vectorDb
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
		chunkSize: self class defaultChunkSize;
		chunkOverlap: self class defaultChunkOverlap;
		separators: { String lf , String lf . ' ' . '' };
		beDropSeparator.
]

{ #category : #accessing }
GtLepiterVectorDbUtilities >> lepiterDb [

	^ LeDatabasesRegistry default defaultLogicalDatabase databaseNamed: self lepiterDbName
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
			lepiterDbName: self lepiterDbName;
			lepiterPageName: aPage title;
			lepiterSnippetUid: nil.
	serialisedPage := GtLLepiterContentExporter new
					strictMode: false;
					page: aPage;
					export.
	documents := serialisedPage size > splitter chunkSize ifTrue:
			[ splitter splitText: serialisedPage ]
	ifFalse:
			[ { serialisedPage } ].
	documents do: [ :document |
		document ifNotEmpty:
			[ vectorDb addDocument: document key: dbKey. ] ].
]

{ #category : #private }
GtLepiterVectorDbUtilities >> loadLepiterPageBySnippet: aPage [
	"Index every snippet, regardless of size.
	This hasn't worked well since small snippets tend to get a lot of false positives."

	aPage allChildrenDepthFirstDo: [ :snippet | | dbKey serialisedSnippet documents |
		dbKey := GtVectorDbLepiterKey new
			lepiterDbName: self lepiterDbName;
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

{ #category : #private }
GtLepiterVectorDbUtilities >> removeEmbeddingKeysFrom: updatedEmbeddings [ 

	updatedEmbeddings do: [ :embedding |
		vectorDb removeEmbedding: embedding ].
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

{ #category : #api }
GtLepiterVectorDbUtilities >> updateVectorDb [
	"Replace database entries for all pages modified after the DB modified time"
	| dbModifiedTime |

	dbModifiedTime := nil.
]

{ #category : #api }
GtLepiterVectorDbUtilities >> updateVectorDbSince: dbModifiedTime [
	"Replace database entries for all pages modified after the DB modified time"
	| embeddingsByPageName updatedPages superseededEmbeddings |

	embeddingsByPageName := self vectorDb embeddings groupedBy: [ :embedding |
		embedding key lepiterPageName ].
	updatedPages := self lepiterDb pages select: [ :lepiterPage |
		lepiterPage latestEditTime time >= dbModifiedTime ].
	superseededEmbeddings := updatedPages flatCollect: [ :page |
		embeddingsByPageName at: page title ifAbsent: [ #() ] ].

	self removeEmbeddingKeysFrom: superseededEmbeddings.

	updatedPages do: [ :page |
		self loadLepiterPage: page ].
]

{ #category : #accessing }
GtLepiterVectorDbUtilities >> vectorDb [
	^ vectorDb ifNil: [ self createVectorDb ]
]

{ #category : #accessing }
GtLepiterVectorDbUtilities >> vectorDb: anObject [
	vectorDb := anObject
]
