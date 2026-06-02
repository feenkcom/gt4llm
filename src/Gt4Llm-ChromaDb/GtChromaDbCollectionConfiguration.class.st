"
I represent collection configuration data from ChromaDb.
"
Class {
	#name : #GtChromaDbCollectionConfiguration,
	#superclass : #GtChromaDbObject,
	#category : #'Gt4Llm-ChromaDb-Model'
}

{ #category : #accessing }
GtChromaDbCollectionConfiguration >> embeddingFunction [
	| embeddingFunction |
	embeddingFunction := rawData at: 'embedding_function'.
	embeddingFunction ifNil: [ ^ nil ].
	^ GtChromaDbEmbeddingFunction new
		rawData: embeddingFunction;
		yourself
]

{ #category : #accessing }
GtChromaDbCollectionConfiguration >> hnsw [
	| hnsw |
	hnsw := rawData at: 'hnsw'.
	hnsw ifNil: [ ^ nil ].
	^ GtChromaDbHnswConfiguration new
		rawData: hnsw;
		yourself
]

{ #category : #accessing }
GtChromaDbCollectionConfiguration >> spann [
	^ rawData at: 'spann'
]
