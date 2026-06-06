"
I represent embedding function configuration data from ChromaDb.
"
Class {
	#name : #GtChromaDbEmbeddingFunction,
	#superclass : #GtChromaDbObject,
	#category : #'Gt4Llm-ChromaDb-Model'
}

{ #category : #accessing }
GtChromaDbEmbeddingFunction >> config [
	^ rawData at: 'config'
]

{ #category : #accessing }
GtChromaDbEmbeddingFunction >> name [
	^ rawData at: 'name' ifAbsent: [ nil ]
]

{ #category : #accessing }
GtChromaDbEmbeddingFunction >> type [
	^ rawData at: 'type'
]
