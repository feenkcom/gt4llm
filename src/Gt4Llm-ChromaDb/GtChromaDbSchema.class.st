"
I represent collection schema data from ChromaDb.
"
Class {
	#name : #GtChromaDbSchema,
	#superclass : #GtChromaDbObject,
	#category : #'Gt4Llm-ChromaDb-Model'
}

{ #category : #accessing }
GtChromaDbSchema >> defaults [
	| defaults |
	defaults := rawData at: 'defaults'.
	defaults ifNil: [ ^ nil ].
	^ GtChromaDbSchemaDefaults new
		rawData: defaults;
		yourself
]

{ #category : #accessing }
GtChromaDbSchema >> keys [
	| keys |
	keys := rawData at: 'keys'.
	keys ifNil: [ ^ nil ].
	^ GtChromaDbSchemaKeys new
		rawData: keys;
		yourself
]
