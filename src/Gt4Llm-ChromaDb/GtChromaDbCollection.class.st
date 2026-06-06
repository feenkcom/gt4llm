Class {
	#name : #GtChromaDbCollection,
	#superclass : #GtChromaDbObject,
	#category : #'Gt4Llm-ChromaDb-Model'
}

{ #category : #accessing }
GtChromaDbCollection >> configurationJson [
	| configuration |
	configuration := rawData at: 'configuration_json'.
	configuration ifNil: [ ^ nil ].
	^ GtChromaDbCollectionConfiguration new
		rawData: configuration;
		yourself
]

{ #category : #accessing }
GtChromaDbCollection >> databaseName [
	^ rawData at: 'database'
]

{ #category : #accessing }
GtChromaDbCollection >> dimension [
	^ rawData at: 'dimension'
]

{ #category : #accessing }
GtChromaDbCollection >> id [
	^ rawData at: 'id'
]

{ #category : #accessing }
GtChromaDbCollection >> logPosition [
	^ rawData at: 'log_position'
]

{ #category : #accessing }
GtChromaDbCollection >> metadata [
	^ rawData at: 'metadata'
]

{ #category : #accessing }
GtChromaDbCollection >> name [
	^ rawData at: 'name'
]

{ #category : #accessing }
GtChromaDbCollection >> schema [
	| schema |
	schema := rawData at: 'schema'.
	schema ifNil: [ ^ nil ].
	^ GtChromaDbSchema new
		rawData: schema;
		yourself
]

{ #category : #accessing }
GtChromaDbCollection >> tenant [
	^ rawData at: 'tenant'
]

{ #category : #accessing }
GtChromaDbCollection >> version [
	^ rawData at: 'version'
]
