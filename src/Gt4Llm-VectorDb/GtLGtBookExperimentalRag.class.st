Class {
	#name : #GtLGtBookExperimentalRag,
	#superclass : #Object,
	#traits : 'TGtUniqueInstance',
	#classTraits : 'TGtUniqueInstance classTrait',
	#instVars : [
		'utilities',
		'maxContextLength',
		'vectorDbFile'
	],
	#category : #'Gt4Llm-VectorDb-RAG'
}

{ #category : #accessing }
GtLGtBookExperimentalRag class >> default [

	self hasUniqueInstance ifFalse:
		[ self error: 'Please load the Vector DB first' ].

	^ uniqueInstance
]

{ #category : #accessing }
GtLGtBookExperimentalRag class >> defaultMaxContextLength [
	"Answer the default maximum length of all the context pages to be included."
	
	^ 4000
]

{ #category : #ui }
GtLGtBookExperimentalRag class >> gtInstanceButtonFor: anAction [
	<gtClassAction>
	^ anAction button
		tooltip: 'Inspect unique instance';
		priority: 10;
		icon: BrGlamorousVectorIcons playinspect;
		action: [ :aButton | aButton phlow spawnObject: self uniqueInstance]
]

{ #category : #ui }
GtLGtBookExperimentalRag >> gtSummaryFor: aView [
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
GtLGtBookExperimentalRag >> lepiterDb [

	^ LeDatabasesRegistry defaultLogicalDatabase databaseNamed: self lepiterDbName
]

{ #category : #accessing }
GtLGtBookExperimentalRag >> lepiterDbName [

	^ 'Glamorous Toolkit Book'
]

{ #category : #accessing }
GtLGtBookExperimentalRag >> maxContextLength [

	^ maxContextLength ifNil: [ maxContextLength := self class defaultMaxContextLength ]
]

{ #category : #accessing }
GtLGtBookExperimentalRag >> pageNamed: pageName [
	"Answer the page with the given name.
	Unnamed pages with the matching title won't be found by default, so search for them separately."

	LeDatabasesRegistry defaultLogicalDatabase 
		pageNamed: pageName 
		ifPresent: [ :page | ^ page ]
		ifAbsent:
			[ self lepiterDb unnamedPagesDo: [ :page |
				page title = pageName ifTrue:
					[ ^ page ] ] ].
	KeyNotFound signalFor: pageName.
]

{ #category : #api }
GtLGtBookExperimentalRag >> query: aString [
	"Answer the page names to include as context for the supplied query"

	| query candidatePages contextPages totalLength |
	query := aString.
	candidatePages := (self utilities pageNamesFor: query maxCount: 20)
			removeDuplicates.	"Limit the length of the context"
	totalLength := 0.
	contextPages := OrderedCollection new.
	candidatePages
		do: [ :pageName | 
			| page pageLength |
			page := self pageNamed: pageName.
			pageLength := (GtLLepiterContentExporter new
					page: page;
					export) size.
			totalLength + pageLength < self maxContextLength
				ifTrue: [ contextPages add: pageName.
					totalLength := totalLength + pageLength ] ].
	^ contextPages
]

{ #category : #private }
GtLGtBookExperimentalRag >> saveVectorDb: vectorDb [
	vectorDb stonTo: self vectorDbFile
]

{ #category : #ui }
GtLGtBookExperimentalRag >> summaryAttributes [

	^ {
		{ 'Default max. explanation length'. self class defaultMaxContextLength. self class class >> #defaultMaxContextLength. }.
		{ 'Default embedding model'. GtSimpleInMemoryVectorDatabase  defaultEmbeddingModelName.  GtSimpleInMemoryVectorDatabase  class >> #defaultEmbeddingModelName.}.
		{ 'Default chunk size'. GtLepiterVectorDbUtilities defaultChunkSize. GtLepiterVectorDbUtilities  class >> #defaultChunkSize. }.
		{ 'Default chunk overlap'. GtLepiterVectorDbUtilities defaultChunkOverlap. GtLepiterVectorDbUtilities  class >> #defaultChunkOverlap. }.
		{ 'Default distance metric'. GtSimpleInMemoryVectorDatabase defaultDistanceMetric. GtSimpleInMemoryVectorDatabase  class >> #defaultDistanceMetric. }.
	}
]

{ #category : #api }
GtLGtBookExperimentalRag >> updateVectorDb [

	self utilities updateVectorDbSince: self vectorDbFile modificationTime.
	self saveVectorDb: self utilities vectorDb.
]

{ #category : #accessing }
GtLGtBookExperimentalRag >> utilities [

	^ utilities ifNil:
		[ utilities := GtLepiterVectorDbUtilities new 
			lepiterDbName: self lepiterDbName;
			vectorDb: self vectorDb. ].
]

{ #category : #'private - accessing' }
GtLGtBookExperimentalRag >> vectorDb [
	| vectorDb |
	
	self vectorDbFile exists
		ifTrue: [ ^ self vectorDbFile readStreamDo: [ :stream | STON fromStream: stream ] ].

	"Generate a new vector db"
	vectorDb := GtLepiterVectorDbUtilities new
			lepiterDbName: self lepiterDbName;
			createVectorDb.
	utilities := GtLepiterVectorDbUtilities new vectorDb: vectorDb.
	self saveVectorDb: vectorDb.
	^ vectorDb
]

{ #category : #'private - accessing' }
GtLGtBookExperimentalRag >> vectorDbFile [

	^ vectorDbFile ifNil:
		[ vectorDbFile := FileLocator temp / 'gt-book.vectordb.ston' ]
]

{ #category : #accessing }
GtLGtBookExperimentalRag >> vectorDbFile: aFileReference [

	vectorDbFile := aFileReference
]
