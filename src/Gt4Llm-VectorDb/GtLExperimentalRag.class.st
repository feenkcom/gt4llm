"
A GtLExperimentalRag manages a {{gtClass:GtLLepiterRagDb}} using a {{gtClass:GtSimpleInMemoryVectorDatabase}}. 
"
Class {
	#name : #GtLExperimentalRag,
	#superclass : #Object,
	#instVars : [
		'maxContextLength',
		'lepiterRagDb',
		'lepiterDbName'
	],
	#classVars : [
		'Instances',
		'LocalStore'
	],
	#category : #'Gt4Llm-VectorDb-RAG'
}

{ #category : #cleanup }
GtLExperimentalRag class >> cleanUp [

	Instances := nil.
]

{ #category : #accesing }
GtLExperimentalRag class >> defaultLocalStore [
	"Answer the default file reference for the directory where local files are stored.
	See {{gtMethod:GtLExperimentalRag class>>#localStore}}."

	^ (FileLocator localDirectory / 'rag') ensureCreateDirectory
]

{ #category : #factory }
GtLExperimentalRag class >> exampleGtBook [
	<gtExample>
	| dbName |

	dbName := 'Glamorous Toolkit Book'.
	^ self instances at: dbName ifAbsent: 
		[ self new lepiterDbName: dbName ].
]

{ #category : #factory }
GtLExperimentalRag class >> forLepiterDbName: aString [

	^ self instances
		at: aString
		ifAbsentPut: [ self new lepiterDbName: aString ]
]

{ #category : #factory }
GtLExperimentalRag class >> gtBook [
	^ self instances at: 'Glamorous Toolkit Book'
]

{ #category : #accessing }
GtLExperimentalRag class >> gtBookBasename [

	^ 'gt-book.vectordb.ston'
]

{ #category : #factory }
GtLExperimentalRag class >> gtBookChromaDb [
	| dbName |

	dbName := 'Glamorous Toolkit Book'.
	^ self instances at: dbName ifAbsentPut: 
		[ self new 
			lepiterDbName: dbName;
			loadChromaDbLepiterRagDb ].
]

{ #category : #factory }
GtLExperimentalRag class >> gtBookInMemory [
	| dbName |

	dbName := 'Glamorous Toolkit Book'.
	^ self instances at: dbName ifAbsentPut: 
		[ self new 
			lepiterDbName: dbName;
			loadInMemoryLepiterRagDb: self localStore / self gtBookBasename ].
]

{ #category : #accessing }
GtLExperimentalRag class >> instances [

	^ Instances ifNil: [ Instances := Dictionary new ]
]

{ #category : #accessing }
GtLExperimentalRag class >> localStore [
	"Answer the file reference for the directory where local files are stored.
	For the in-memory database this will be the location of the db file.
	For the chroma database this will be the location of the metadata store."

	^ LocalStore ifNil: [ LocalStore := self defaultLocalStore ]
]

{ #category : #accessing }
GtLExperimentalRag class >> localStore: aFileReference [

	LocalStore := aFileReference
]

{ #category : #converting }
GtLExperimentalRag >> asRag [

	^ self
]

{ #category : #converting }
GtLExperimentalRag >> asRagQueryContext [
	"Answer a Rag Query context that can be used with the receiver"

	^ GtLLepiterRagQueryContext new
		rag: self
]

{ #category : #ui }
GtLExperimentalRag >> gtSummaryFor: aView [
	<gtView>

	^(aView columnedList)
		title: 'Summary';
		priority: 10;
		items: [ self summaryAttributes ];
		column: #Attribute text: [:item | item first];
		column: #Value text: [:item | item second];
		send: #last;
		actionUpdateButton
]

{ #category : #accessing }
GtLExperimentalRag >> lepiterDb [

	^ LeDatabasesRegistry defaultLogicalDatabase databaseNamed: self lepiterDbName
]

{ #category : #accessing }
GtLExperimentalRag >> lepiterDbName [

	^ lepiterDbName
]

{ #category : #accessing }
GtLExperimentalRag >> lepiterDbName: anObject [
	lepiterDbName := anObject
]

{ #category : #accessing }
GtLExperimentalRag >> lepiterRagDb [

	^ lepiterRagDb.
]

{ #category : #'private - accessing' }
GtLExperimentalRag >> loadChromaDbLepiterRagDb [
	"Load the receiver's GtLLepiterRagDb using ChromaDb"
	| collectionName dbMetadataFile vectorDb |

	lepiterRagDb := GtLLepiterRagDb new
		lepiterDbName: self lepiterDbName.
	collectionName := self lepiterDbName
			copyReplaceAll: ' ' with: '_'.
	dbMetadataFile := self class localStore / (collectionName, '.ston').
	vectorDb := LeChromaDb new
		collectionName: collectionName;
		dbMetadataFile: dbMetadataFile.
	vectorDb load.
	lepiterRagDb vectorDb: vectorDb.

	"If there are records in the collection, the db is already populated"
	vectorDb size > 0 ifTrue: [ ^ self ].

	self lepiterDb pages do: [ :aPage |
		lepiterRagDb loadLepiterPage: aPage ].
]

{ #category : #'as yet unclassified' }
GtLExperimentalRag >> loadInMemoryLepiterRagDb [

	^ self loadInMemoryLepiterRagDb: self class defaultVectorDbFile
]

{ #category : #'private - accessing' }
GtLExperimentalRag >> loadInMemoryLepiterRagDb: aFileReference [
	"Load the receiver's GtLLepiterRagDb using the simple in-memory db"
	| vectorDb |

	lepiterRagDb := GtLLepiterRagDb new
		lepiterDbName: self lepiterDbName.

	"If the DB has been saved to disk, load it from there"
	aFileReference exists ifTrue: 
		[ lepiterRagDb vectorDb: (LeInMemoryVectorDb new
			stonFile: aFileReference;
			load).
		^ self ].

	"Otherwise, generate a new vector db"
	vectorDb := LeInMemoryVectorDb new vectorDb: (GtSimpleInMemoryVectorDatabase new).
	lepiterRagDb vectorDb: vectorDb.
	self lepiterDb pages do: [ :aPage |
		lepiterRagDb vectorDb loadLepiterPage: aPage ].
	lepiterRagDb vectorDb save.
]

{ #category : #api }
GtLExperimentalRag >> query: aLepiterRagQueryContext [
	"Answer the page entries to include as context for the supplied query"

	^ self lepiterRagDb query: aLepiterRagQueryContext.
]

{ #category : #ui }
GtLExperimentalRag >> summaryAttributes [

	^ {
		{ 'Default max. explanation length'. GtLLepiterRagQueryContext defaultMaxContextLength. GtLLepiterRagQueryContext class >> #defaultMaxContextLength. }.
		{ 'Default embedding model'. GtSimpleInMemoryVectorDatabase  defaultEmbeddingModelName.  GtSimpleInMemoryVectorDatabase  class >> #defaultEmbeddingModelName.}.
		{ 'Default chunk size'. GtLLepiterRagDb defaultChunkSize. GtLLepiterRagDb  class >> #defaultChunkSize. }.
		{ 'Default chunk overlap'. GtLLepiterRagDb defaultChunkOverlap. GtLLepiterRagDb  class >> #defaultChunkOverlap. }.
		{ 'Default distance metric'. GtSimpleInMemoryVectorDatabase defaultDistanceMetric. GtSimpleInMemoryVectorDatabase  class >> #defaultDistanceMetric. }.
	}
]

{ #category : #api }
GtLExperimentalRag >> updateVectorDb [

	self lepiterRagDb updateVectorDb.
]
