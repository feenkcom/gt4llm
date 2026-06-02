"
I represent a schema type definition from ChromaDb.
"
Class {
	#name : #GtChromaDbSchemaTypeDefinition,
	#superclass : #GtChromaDbObject,
	#category : #'Gt4Llm-ChromaDb-Model'
}

{ #category : #accessing }
GtChromaDbSchemaTypeDefinition >> boolInvertedIndex [
	| definition |
	definition := rawData at: 'bool_inverted_index' ifAbsent: [ nil ].
	definition ifNil: [ ^ nil ].
	^ GtChromaDbIndexDefinition new
		rawData: definition;
		yourself
]

{ #category : #accessing }
GtChromaDbSchemaTypeDefinition >> floatInvertedIndex [
	| definition |
	definition := rawData at: 'float_inverted_index' ifAbsent: [ nil ].
	definition ifNil: [ ^ nil ].
	^ GtChromaDbIndexDefinition new
		rawData: definition;
		yourself
]

{ #category : #accessing }
GtChromaDbSchemaTypeDefinition >> floatList [
	| definition |
	definition := rawData at: 'float_list' ifAbsent: [ nil ].
	definition ifNil: [ ^ nil ].
	^ GtChromaDbSchemaTypeDefinition new
		rawData: definition;
		yourself
]

{ #category : #accessing }
GtChromaDbSchemaTypeDefinition >> ftsIndex [
	| definition |
	definition := rawData at: 'fts_index' ifAbsent: [ nil ].
	definition ifNil: [ ^ nil ].
	^ GtChromaDbIndexDefinition new
		rawData: definition;
		yourself
]

{ #category : #accessing }
GtChromaDbSchemaTypeDefinition >> intInvertedIndex [
	| definition |
	definition := rawData at: 'int_inverted_index' ifAbsent: [ nil ].
	definition ifNil: [ ^ nil ].
	^ GtChromaDbIndexDefinition new
		rawData: definition;
		yourself
]

{ #category : #accessing }
GtChromaDbSchemaTypeDefinition >> sparseVectorIndex [
	| definition |
	definition := rawData at: 'sparse_vector_index' ifAbsent: [ nil ].
	definition ifNil: [ ^ nil ].
	^ GtChromaDbIndexDefinition new
		rawData: definition;
		yourself
]

{ #category : #accessing }
GtChromaDbSchemaTypeDefinition >> string [
	| definition |
	definition := rawData at: 'string' ifAbsent: [ nil ].
	definition ifNil: [ ^ nil ].
	^ GtChromaDbSchemaTypeDefinition new
		rawData: definition;
		yourself
]

{ #category : #accessing }
GtChromaDbSchemaTypeDefinition >> stringInvertedIndex [
	| definition |
	definition := rawData at: 'string_inverted_index' ifAbsent: [ nil ].
	definition ifNil: [ ^ nil ].
	^ GtChromaDbIndexDefinition new
		rawData: definition;
		yourself
]

{ #category : #accessing }
GtChromaDbSchemaTypeDefinition >> vectorIndex [
	| definition |
	definition := rawData at: 'vector_index' ifAbsent: [ nil ].
	definition ifNil: [ ^ nil ].
	^ GtChromaDbIndexDefinition new
		rawData: definition;
		yourself
]
