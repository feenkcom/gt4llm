"
A GtLExperimentalRag manages a {{gtClass:GtLLepiterRagDb}} using a {{gtClass:GtSimpleInMemoryVectorDatabase}}. 
"
Class {
	#name : #GtLExperimentalRag,
	#superclass : #Object,
	#instVars : [
		'maxContextLength',
		'vectorDbFile',
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

{ #category : #factory }
GtLExperimentalRag class >> forLepiterDbName: aString [

	^ self instances
		at: aString
		ifAbsentPut: [ self new lepiterDbName: aString ]
]

{ #category : #factory }
GtLExperimentalRag class >> gtBook [

	^ self forLepiterDbName: 'Glamorous Toolkit Book'.
]

{ #category : #accessing }
GtLExperimentalRag class >> instances [

	^ Instances ifNil: [ Instances := Dictionary new ]
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

	^ lepiterRagDb ifNil:
		[ lepiterRagDb := self loadLepiterRagDb ].
]

{ #category : #'private - accessing' }
GtLExperimentalRag >> loadLepiterRagDb [
	"Answer a new instance of GtLLepiterRagDb"
	| ragDb vectorDb |

	ragDb := GtLLepiterRagDb new
		lepiterDbName: self lepiterDbName.

	"If the DB has been saved to disk, load it from there"
	self vectorDbFile exists ifTrue: 
		[ ragDb vectorDb: (self vectorDbFile 
			readStreamDo: [ :stream | STON fromStream: stream ]).
		^ ragDb ].

	"Otherwise, generate a new vector db"
	vectorDb := GtSimpleInMemoryVectorDatabase new.
	ragDb vectorDb: vectorDb.
	self lepiterDb pages do: [ :aPage |
		ragDb loadLepiterPage: aPage ].
	self saveVectorDb: vectorDb.

	^ ragDb
]

{ #category : #api }
GtLExperimentalRag >> query: aLepiterRagQueryContext [
	"Answer the page entries to include as context for the supplied query"

	^ self lepiterRagDb query: aLepiterRagQueryContext.
]

{ #category : #private }
GtLExperimentalRag >> saveVectorDb: vectorDb [
	vectorDb stonTo: self vectorDbFile
]

{ #category : #ui }
GtLExperimentalRag >> summaryAttributes [

	^ {
		{ 'Default max. explanation length'. self class defaultMaxContextLength. self class class >> #defaultMaxContextLength. }.
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

{ #category : #'private - accessing' }
GtLExperimentalRag >> vectorDb [
	| vectorDb |
	
	self vectorDbFile exists
		ifTrue: [ ^ self vectorDbFile readStreamDo: [ :stream | STON fromStream: stream ] ].

	"Generate a new vector db"
	vectorDb := GtLLepiterRagDb new
			lepiterDbName: self lepiterDbName;
			createVectorDb.
	utilities := GtLLepiterRagDb new vectorDb: vectorDb.
	self saveVectorDb: vectorDb.
	^ vectorDb
]

{ #category : #'private - accessing' }
GtLExperimentalRag >> vectorDbFile [

	^ vectorDbFile ifNil:
		[ vectorDbFile := FileLocator temp / 'gt-book.vectordb.ston' ]
]

{ #category : #accessing }
GtLExperimentalRag >> vectorDbFile: aFileReference [

	vectorDbFile := aFileReference
]
