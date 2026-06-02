"
I represent an index definition from ChromaDb.
"
Class {
	#name : #GtChromaDbIndexDefinition,
	#superclass : #GtChromaDbObject,
	#category : #'Gt4Llm-ChromaDb-Model'
}

{ #category : #accessing }
GtChromaDbIndexDefinition >> config [
	| configuration |
	configuration := rawData at: 'config'.
	configuration ifNil: [ ^ nil ].
	((configuration includesKey: 'hnsw') or: [ configuration includesKey: 'space' or: [ configuration includesKey: 'embedding_function' or: [ configuration includesKey: 'source_key' ] ] ])
		ifTrue: [ ^ GtChromaDbVectorIndexConfiguration new
			rawData: configuration;
			yourself ].
	^ GtChromaDbObject new
		rawData: configuration;
		yourself
]

{ #category : #accessing }
GtChromaDbIndexDefinition >> enabled [
	^ rawData at: 'enabled'
]
