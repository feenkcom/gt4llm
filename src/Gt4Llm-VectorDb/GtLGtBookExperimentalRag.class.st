Class {
	#name : #GtLGtBookExperimentalRag,
	#superclass : #Object,
	#traits : 'TGtUniqueInstance',
	#classTraits : 'TGtUniqueInstance classTrait',
	#instVars : [
		'utilities',
		'maxContextLength'
	],
	#classInstVars : [
		'uniqueInstance'
	],
	#category : #'Gt4Llm-VectorDb-RAG'
}

{ #category : #accessing }
GtLGtBookExperimentalRag >> maxContextLength [

	^ maxContextLength ifNil: [ maxContextLength := 10000 ]
]

{ #category : #api }
GtLGtBookExperimentalRag >> query: aString [
	"Answer the page names to include as context for the supplied query"
	| query candidatePages contextPages totalLength |
	
	query := aString.
	candidatePages := (self utilities pageNamesFor: query maxCount: 20) removeDuplicates.
	
	"Limit the length of the context"
	totalLength := 0.
	contextPages := OrderedCollection new.
	candidatePages do: [ :pageName | | page pageLength |
		page := LeDatabasesRegistry defaultLogicalDatabase pageNamed: pageName.
		pageLength :=  (GtLLepiterContentExporter new
							page: page;
							export) size.
		(totalLength + pageLength) < self maxContextLength ifTrue:
			[ contextPages add: pageName.
			totalLength := totalLength + pageLength ] ].
	^ contextPages.
]

{ #category : #accessing }
GtLGtBookExperimentalRag >> utilities [

	^ utilities ifNil:
		[ utilities := GtLepiterVectorDbUtilities new vectorDb: self vectorDb. ].
]

{ #category : #'private - accessing' }
GtLGtBookExperimentalRag >> vectorDb [
	| vectorDb |

	self vectorDbFile exists ifTrue:
		[ ^ self vectorDbFile readStreamDo: [ :stream |
			STON fromStream: stream ] ].

	"Generate a new vector db"
	vectorDb := GtLepiterVectorDbUtilities new
		lepiterDbName: 'Glamorous Toolkit Book';
		createVectorDb.
	vectorDb stonTo: self vectorDbFile.
	^ vectorDb.
]

{ #category : #'private - accessing' }
GtLGtBookExperimentalRag >> vectorDbFile [

	^ FileLocator temp / 'gt-book.vectordb.ston'
]
