"
I represent a databases response from ChromaDb and provide accessors over the raw JSON data inherited from GtChromaDbObject.
"
Class {
	#name : #GtChromaDbDatabase,
	#superclass : #GtChromaDbObject,
	#category : #'Gt4Llm-ChromaDb-Model'
}

{ #category : #accessing }
GtChromaDbDatabase >> id [
	^ rawData at: 'id'
]

{ #category : #accessing }
GtChromaDbDatabase >> name [
	^ rawData at: 'name'
]

{ #category : #accessing }
GtChromaDbDatabase >> tenant [
	^ rawData at: 'tenant'
]
