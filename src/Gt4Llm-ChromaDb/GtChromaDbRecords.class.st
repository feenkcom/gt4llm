Class {
	#name : #GtChromaDbRecords,
	#superclass : #GtLGroup,
	#instVars : [
		'collection'
	],
	#category : #'Gt4Llm-ChromaDb-Model'
}

{ #category : #'instance creation' }
GtChromaDbRecords class >> collection: aGtChromaDbCollection columns: aCollection [
	| ids documents uris metadatas include |

	ids := aCollection at: 'ids'.
	documents := aCollection at: 'documents'.
	uris := aCollection at: 'uris'.
	metadatas := aCollection at: 'metadatas'.
	include := aCollection at: 'include'.
	^ self new items: 
	(ids collectWithIndex: [ :id :index | | record |
		record := GtChromaDbRecord new 
			id: id;
			include: include.
		documents ifNotNil: 
			[ record document: (documents at: index) ].
		uris ifNotNil:
			[ record uri: (uris at: index) ].
		metadatas ifNotNil:
			[ record metadata: (metadatas at: index) ]. ]).
]

{ #category : #accessing }
GtChromaDbRecords >> collection [
	^ collection
]

{ #category : #accessing }
GtChromaDbRecords >> collection: anObject [
	collection := anObject
]
