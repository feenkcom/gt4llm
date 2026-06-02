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
		'Instances'
	],
	#category : #'Gt4Llm-VectorDb-RAG'
}

{ #category : #cleanup }
GtLExperimentalRag class >> cleanUp [

	Instances := nil.
]

{ #category : #accessing }
GtLExperimentalRag class >> default [

	self hasUniqueInstance ifFalse:
		[ self error: 'Please load the Vector DB first' ].

	^ uniqueInstance
]

{ #category : #accesing }
GtLExperimentalRag class >> defaultVectorDbFile [
	"Answer the file reference for the ston file used to store the in-memory vector db.
	Not used by the Chroma DB."
	^ FileLocator temp / 'gt-book.vectordb.ston'
]

{ #category : #factory }
GtLExperimentalRag class >> forLepiterDbName: aString [

	^ self instances
		at: aString
		ifAbsentPut: [ self new lepiterDbName: aString ]
]

{ #category : #factory }
GtLExperimentalRag class >> gtBook [
	<gtExample>

	^ self forLepiterDbName: 'Glamorous Toolkit Book'.
]

{ #category : #accessing }
GtLExperimentalRag class >> instances [

	^ Instances ifNil: [ Instances := Dictionary new ]
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
	"Answer a new instance of GtLLepiterRagDb using ChromaDb"
	| vectorDb |

	lepiterRagDb := GtLLepiterRagDb new
		lepiterDbName: self lepiterDbName.
	vectorDb := LeChromaDb new
		collectionName: (self lepiterDbName
			copyReplaceAll: ' ' with: '_').
	lepiterRagDb vectorDb: vectorDb.

	"If there are records in the collection, the db is already populated"
	vectorDb size > 0 ifTrue: [ ^ lepiterRagDb ].

	self lepiterDb pages do: [ :aPage |
		lepiterRagDb loadLepiterPage: aPage ].

	^ lepiterRagDb
]

{ #category : #'private - accessing' }
GtLExperimentalRag >> loadInMemoryLepiterRagDb: aFileReference [
	"Answer a new instance of GtLLepiterRagDb using the simple in-memory db"
	| vectorDb |

	lepiterRagDb := GtLLepiterRagDb new
		lepiterDbName: self lepiterDbName.

	"If the DB has been saved to disk, load it from there"
	aFileReference exists ifTrue: 
		[ lepiterRagDb vectorDb: (aFileReference
			readStreamDo: [ :stream | STON fromStream: stream ]).
		^ lepiterRagDb ].

	"Otherwise, generate a new vector db"
	vectorDb := GtSimpleInMemoryVectorDatabase new.
	lepiterRagDb vectorDb: vectorDb.
	self lepiterDb pages do: [ :aPage |
		lepiterRagDb loadLepiterPage: aPage ].
	vectorDb stonTo: aFileReference.

	^ lepiterRagDb
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

	self lepiterRagDb updateVectorDbSince: self vectorDbFile modificationTime.
	self saveVectorDb: self lepiterRagDb vectorDb.
]
