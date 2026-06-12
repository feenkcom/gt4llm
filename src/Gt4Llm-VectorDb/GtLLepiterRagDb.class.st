"
GtLLepiterRagDb provides RAG queries on a lepiter knowledgebase and implements the RAG strategy:

How to chunk the documents.  The current strategy is to create documents of 1200 characters with a 300 character overlap.

What to return on matches.  The current strategy is to return an entire page, since pages are typically short, and accept as many pages as fit in the context character limit.

The vector database is created and provided indepedently as the assumption is that the {{gtClass:GtSimpleInMemoryVectorDatabase}} will soon be replaced by an external, scalable database.

GtLLepiterRagDb assumes that lepiter pages are generally fairly short and topic specific, so naively splits text in to chunks of a fixed length as specified in {{gtMethod:GtLLepiterRagDb class>>#defaultChunkSize}} for indexing, however the entire lepiter page is always included as the context.


"
Class {
	#name : #GtLLepiterRagDb,
	#superclass : #Object,
	#instVars : [
		'vectorDb',
		'splitter',
		'lepiterDbName'
	],
	#category : #'Gt4Llm-VectorDb-Support'
}

{ #category : #'instance creation' }
GtLLepiterRagDb class >> createVectorDb [

	^ self new vectorDb
]

{ #category : #accessing }
GtLLepiterRagDb class >> defaultChunkOverlap [
	"Answer the default number of characters to overlap between chunks"
	
	^ 300
]

{ #category : #accessing }
GtLLepiterRagDb class >> defaultChunkSize [
	"Answer the default size of text to index"
	
	^ 1200
]

{ #category : #'instance creation' }
GtLLepiterRagDb class >> loadDefault [

	^ self loadFrom: 'gt-book.vectordb.ston'
]

{ #category : #'instance creation' }
GtLLepiterRagDb class >> loadFrom: aFileReference [
	| vectorDb |

	vectorDb := aFileReference asFileReference readStreamDo: [ :stream |
		STON fromStream: stream ].
	^ self new
		vectorDb: vectorDb.
]

{ #category : #ui }
GtLLepiterRagDb >> gtSummaryFor: aView [
	<gtView>

	^ aView forward
		  title: 'VectorDb';
		  priority: 5;
		  object: [ vectorDb ];
		  view: #gtSummaryFor:.
]

{ #category : #testing }
GtLLepiterRagDb >> hasVectorDb [

	^ vectorDb isNotNil
]

{ #category : #api }
GtLLepiterRagDb >> initialize [

	super initialize.
	splitter := GtRecursiveCharacterTextSplitter new.
	splitter
		chunkSize: self class defaultChunkSize;
		chunkOverlap: self class defaultChunkOverlap;
		separators: { String lf , String lf . ' ' . '' };
		beDropSeparator.
]

{ #category : #accessing }
GtLLepiterRagDb >> lepiterDb [

	^ LeDatabasesRegistry default defaultLogicalDatabase databaseNamed: self lepiterDbName
]

{ #category : #accessing }
GtLLepiterRagDb >> lepiterDbName [
	^ lepiterDbName ifNil: [ lepiterDbName := LeDatabase gtBookName ].
]

{ #category : #accessing }
GtLLepiterRagDb >> lepiterDbName: anObject [
	lepiterDbName := anObject
]

{ #category : #'as yet unclassified' }
GtLLepiterRagDb >> limitLength: aLepiterRagContext pages: sortedPages [
	| contextPages index totalLength |
	contextPages := OrderedCollection new.
	contextPages add: sortedPages first.
	totalLength := (GtLLepiterContentExporter new
			page: sortedPages first page;
			export) size.
	index := 2.
	[ index <= sortedPages size
		and: [ totalLength < aLepiterRagContext maxContextLength ] ]
		whileTrue: [ | ragPage pageLength |
			ragPage := sortedPages at: index.
			pageLength := (GtLLepiterContentExporter new
					strictMode: false;
					page: ragPage page;
					export) size.
			totalLength + pageLength < aLepiterRagContext maxContextLength
				ifTrue: [ contextPages add: ragPage ].
			totalLength := totalLength + pageLength.
			index := index + 1 ].
	^ contextPages
]

{ #category : #private }
GtLLepiterRagDb >> loadLepiterPage: aPage [
	| dbKey serialisedPage documents |

	aPage isEmpty ifTrue: [ ^ self ].
	aPage type isPharoClassPageType ifTrue: [ ^ self ].

	dbKey := GtVectorDbLepiterKey new
			lepiterDbName: self lepiterDbName;
			lepiterPageName: aPage title;
			lepiterSnippetUid: nil.
	serialisedPage := GtLLepiterContentExporter new
					strictMode: false;
					page: aPage;
					export.
	serialisedPage ifEmpty: 
		[ self error: 'Unexpectedly empty page' ].
	documents := serialisedPage size > splitter chunkSize ifTrue:
			[ splitter splitText: serialisedPage ]
	ifFalse:
			[ { serialisedPage } ].
	vectorDb 
		addDocuments: documents
		keys: (Array new: documents size withAll: dbKey).
]

{ #category : #private }
GtLLepiterRagDb >> loadLepiterPageBySnippet: aPage [
	"Not used.
	Index every snippet, regardless of size.
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

{ #category : #'as yet unclassified' }
GtLLepiterRagDb >> query: aLepiterRagContext [
	"Answer the pages to include as context for the supplied query using a simple bi-encoder"

	| groupedEmbeddings candidatePages contextPages matchingEmbeddings sortedPages |
	"Limit the length of the context"
	aLepiterRagContext lepiterRagDb: self.
	matchingEmbeddings := vectorDb
			query: aLepiterRagContext queryString
			maxMatches: 25.
	aLepiterRagContext addRanking: matchingEmbeddings.
	aLepiterRagContext
		optionAt: #reRank
		ifPresent: [ :ranker | 
			matchingEmbeddings := ranker reRank: matchingEmbeddings in: aLepiterRagContext.
			aLepiterRagContext addRanking: matchingEmbeddings ].
	groupedEmbeddings := matchingEmbeddings
			groupedBy: [ :each | each embedding key ].
	candidatePages := groupedEmbeddings collect: [ :each | 
				GtLLepiterRagPage new
					pageKey: each first embedding key;
					embeddingDistances: (each collect: [ :embeddingDistance | embeddingDistance distance ]) ].
	sortedPages := candidatePages
			sorted: [ :each | each embeddingDistances first ] ascending.
	aLepiterRagContext candidatePageEntries: sortedPages.
	contextPages := self limitLength: aLepiterRagContext pages: sortedPages.
	aLepiterRagContext contextPageEntries: contextPages.
	^ contextPages
]

{ #category : #private }
GtLLepiterRagDb >> removeEmbeddingKeysFrom: updatedEmbeddings [ 

	updatedEmbeddings do: [ :embedding |
		vectorDb removeEmbedding: embedding ].
]

{ #category : #private }
GtLLepiterRagDb >> removeRecordsForPage: aPage [
	| dbKey |

	dbKey := GtVectorDbLepiterKey new
			lepiterDbName: self lepiterDbName;
			lepiterPageName: aPage title;
			lepiterSnippetUid: nil.
	vectorDb removeKey: dbKey.
]

{ #category : #api }
GtLLepiterRagDb >> updateVectorDb [
	"Replace database entries for all pages modified after the DB modified time"

	self updateVectorDbSince: vectorDb lastUpdateTime.
]

{ #category : #api }
GtLLepiterRagDb >> updateVectorDbSince: dbModifiedTime [
	"Replace database entries for all pages modified after the DB modified time"
	| updatedPages |

	updatedPages := self lepiterDb pages select: [ :lepiterPage |
		lepiterPage latestEditTime time >= dbModifiedTime ].

	updatedPages do: [ :page |
		self removeRecordsForPage: page.
		self loadLepiterPage: page ].

	vectorDb save.
]

{ #category : #accessing }
GtLLepiterRagDb >> vectorDb [
	^ vectorDb
]

{ #category : #accessing }
GtLLepiterRagDb >> vectorDb: aVectorDatabase [

	vectorDb := aVectorDatabase
]
