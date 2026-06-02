"
I represent schema keys data from ChromaDb.
"
Class {
	#name : #GtChromaDbSchemaKeys,
	#superclass : #GtChromaDbObject,
	#category : #'Gt4Llm-ChromaDb-Model'
}

{ #category : #accessing }
GtChromaDbSchemaKeys >> document [
	| definition |
	definition := rawData at: '#document' ifAbsent: [ nil ].
	definition ifNil: [ ^ nil ].
	^ GtChromaDbSchemaTypeDefinition new
		rawData: definition;
		yourself
]

{ #category : #accessing }
GtChromaDbSchemaKeys >> embedding [
	| definition |
	definition := rawData at: '#embedding' ifAbsent: [ nil ].
	definition ifNil: [ ^ nil ].
	^ GtChromaDbSchemaTypeDefinition new
		rawData: definition;
		yourself
]
