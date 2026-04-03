Class {
	#name : #GtMagritteJSONSchemaDataReader,
	#superclass : #Object,
	#instVars : [
		'modelClass'
	],
	#category : #'Gt4LlmCore-Core'
}

{ #category : #'instance creation' }
GtMagritteJSONSchemaDataReader class >> forModelClass: aModelClass [
	^ self new 
			modelClass: aModelClass
]

{ #category : #accessing }
GtMagritteJSONSchemaDataReader >> modelClass [
	^ modelClass
]

{ #category : #accessing }
GtMagritteJSONSchemaDataReader >> modelClass: aClass [
	modelClass := aClass
]

{ #category : #reading }
GtMagritteJSONSchemaDataReader >> readFrom: aStringOrStream [
	| magritteDescription mapperVisitor  neoJsonMapper |
	
	magritteDescription := modelClass new 
		magritteDescription.
	magritteDescription properties
		at: 'originalClass'
		put: modelClass.
	
	neoJsonMapper := NeoJSONReader on: aStringOrStream.
	mapperVisitor := GtMagriteJSONSchemaNEOJsonMapperVisitor 
		forNeoJsonMapper: neoJsonMapper.
	
	magritteDescription acceptMagritte: mapperVisitor.
	
	^ neoJsonMapper nextAs: modelClass
]
