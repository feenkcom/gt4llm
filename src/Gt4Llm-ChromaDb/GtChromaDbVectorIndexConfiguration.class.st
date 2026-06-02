"
I represent vector index configuration data from ChromaDb.
"
Class {
	#name : #GtChromaDbVectorIndexConfiguration,
	#superclass : #GtChromaDbObject,
	#category : #'Gt4Llm-ChromaDb-Model'
}

{ #category : #accessing }
GtChromaDbVectorIndexConfiguration >> bm25 [
	^ rawData at: 'bm25' ifAbsent: [ nil ]
]

{ #category : #accessing }
GtChromaDbVectorIndexConfiguration >> embeddingFunction [
	| embeddingFunction |
	embeddingFunction := rawData at: 'embedding_function' ifAbsent: [ nil ].
	embeddingFunction ifNil: [ ^ nil ].
	^ GtChromaDbEmbeddingFunction new
		rawData: embeddingFunction;
		yourself
]

{ #category : #accessing }
GtChromaDbVectorIndexConfiguration >> hnsw [
	| hnsw |
	hnsw := rawData at: 'hnsw' ifAbsent: [ nil ].
	hnsw ifNil: [ ^ nil ].
	^ GtChromaDbHnswConfiguration new
		rawData: hnsw;
		yourself
]

{ #category : #accessing }
GtChromaDbVectorIndexConfiguration >> sourceKey [
	^ rawData at: 'source_key' ifAbsent: [ nil ]
]

{ #category : #accessing }
GtChromaDbVectorIndexConfiguration >> space [
	^ rawData at: 'space' ifAbsent: [ nil ]
]
