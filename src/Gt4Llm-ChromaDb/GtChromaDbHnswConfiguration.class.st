"
I represent HNSW configuration data from ChromaDb.
"
Class {
	#name : #GtChromaDbHnswConfiguration,
	#superclass : #GtChromaDbObject,
	#category : #'Gt4Llm-ChromaDb-Model'
}

{ #category : #accessing }
GtChromaDbHnswConfiguration >> efConstruction [
	^ rawData at: 'ef_construction'
]

{ #category : #accessing }
GtChromaDbHnswConfiguration >> efSearch [
	^ rawData at: 'ef_search'
]

{ #category : #accessing }
GtChromaDbHnswConfiguration >> maxNeighbors [
	^ rawData at: 'max_neighbors'
]

{ #category : #accessing }
GtChromaDbHnswConfiguration >> resizeFactor [
	^ rawData at: 'resize_factor'
]

{ #category : #accessing }
GtChromaDbHnswConfiguration >> space [
	^ rawData at: 'space'
]

{ #category : #accessing }
GtChromaDbHnswConfiguration >> syncThreshold [
	^ rawData at: 'sync_threshold'
]
