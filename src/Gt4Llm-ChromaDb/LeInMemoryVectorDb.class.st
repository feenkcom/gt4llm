Class {
	#name : #LeInMemoryVectorDb,
	#superclass : #Object,
	#instVars : [
		'vectorDb',
		'stonFile'
	],
	#category : #'Gt4Llm-ChromaDb-Model'
}

{ #category : #'as yet unclassified' }
LeInMemoryVectorDb >> addDocuments: documents keys: keys [

	keys doWithIndex: [ :key :index |
		vectorDb 
			addDocument: (documents at: index)
			key: key ].
]

{ #category : #accessing }
LeInMemoryVectorDb >> lastUpdateTime [
	"Answer the time the receiver was last updated"

	^ stonFile modificationTime
]

{ #category : #'as yet unclassified' }
LeInMemoryVectorDb >> load [

	vectorDb := stonFile readStreamDo: [ :stream |
		STON fromStream: stream ].
]

{ #category : #'as yet unclassified' }
LeInMemoryVectorDb >> removeKey: dbKey [
	"Remove all records with the specified key"
	| toBeRemoved |

	toBeRemoved := vectorDb embeddings select: [ :embedding |
		embedding key = dbKey ].
	toBeRemoved ifEmpty: [ ^ dbKey ].
	toBeRemoved do: [ :embedding |
		vectorDb removeEmbedding: embedding ].
	^ dbKey
]

{ #category : #'as yet unclassified' }
LeInMemoryVectorDb >> save [

	vectorDb stonTo: stonFile
]

{ #category : #accessing }
LeInMemoryVectorDb >> stonFile [
	^ stonFile
]

{ #category : #accessing }
LeInMemoryVectorDb >> stonFile: aFileReference [

	stonFile := aFileReference
]

{ #category : #accessing }
LeInMemoryVectorDb >> vectorDb [
	^ vectorDb
]

{ #category : #accessing }
LeInMemoryVectorDb >> vectorDb: aGtSimpleInMemoryVectorDatabase [

	vectorDb := aGtSimpleInMemoryVectorDatabase
]
