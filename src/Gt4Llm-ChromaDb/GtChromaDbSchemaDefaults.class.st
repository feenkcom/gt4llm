"
I represent schema defaults data from ChromaDb.
"
Class {
	#name : #GtChromaDbSchemaDefaults,
	#superclass : #GtChromaDbObject,
	#category : #'Gt4Llm-ChromaDb-Model'
}

{ #category : #accessing }
GtChromaDbSchemaDefaults >> bool [
	| definition |
	definition := rawData at: 'bool' ifAbsent: [ nil ].
	definition ifNil: [ ^ nil ].
	^ GtChromaDbSchemaTypeDefinition new
		rawData: definition;
		yourself
]

{ #category : #accessing }
GtChromaDbSchemaDefaults >> float [
	| definition |
	definition := rawData at: 'float' ifAbsent: [ nil ].
	definition ifNil: [ ^ nil ].
	^ GtChromaDbSchemaTypeDefinition new
		rawData: definition;
		yourself
]

{ #category : #accessing }
GtChromaDbSchemaDefaults >> floatList [
	| definition |
	definition := rawData at: 'float_list' ifAbsent: [ nil ].
	definition ifNil: [ ^ nil ].
	^ GtChromaDbSchemaTypeDefinition new
		rawData: definition;
		yourself
]

{ #category : #accessing }
GtChromaDbSchemaDefaults >> int [
	| definition |
	definition := rawData at: 'int' ifAbsent: [ nil ].
	definition ifNil: [ ^ nil ].
	^ GtChromaDbSchemaTypeDefinition new
		rawData: definition;
		yourself
]

{ #category : #accessing }
GtChromaDbSchemaDefaults >> sparseVector [
	| definition |
	definition := rawData at: 'sparse_vector' ifAbsent: [ nil ].
	definition ifNil: [ ^ nil ].
	^ GtChromaDbSchemaTypeDefinition new
		rawData: definition;
		yourself
]

{ #category : #accessing }
GtChromaDbSchemaDefaults >> string [
	| definition |
	definition := rawData at: 'string' ifAbsent: [ nil ].
	definition ifNil: [ ^ nil ].
	^ GtChromaDbSchemaTypeDefinition new
		rawData: definition;
		yourself
]
