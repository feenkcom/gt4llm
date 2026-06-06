"
I represent an identity response from ChromaDb and provide accessors over the raw JSON data inherited from GtChromaDbObject.
"
Class {
	#name : #GtChromaDbIdentity,
	#superclass : #GtChromaDbObject,
	#category : #'Gt4Llm-ChromaDb-Model'
}

{ #category : #accessing }
GtChromaDbIdentity >> databases [
	^ rawData at: 'databases'
]

{ #category : #accessing }
GtChromaDbIdentity >> tenant [
	^ rawData at: 'tenant'
]

{ #category : #accessing }
GtChromaDbIdentity >> userId [
	^ rawData at: 'user_id'
]
