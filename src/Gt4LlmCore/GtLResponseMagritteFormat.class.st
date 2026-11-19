Class {
	#name : #GtLResponseMagritteFormat,
	#superclass : #GtLResponseInvividualFormat,
	#instVars : [
		'modelClass'
	],
	#category : #'Gt4LlmCore-Core'
}

{ #category : #'neo json' }
GtLResponseMagritteFormat >> appendNeoJsonMappingTo: neoJsonMapper [
	| magritteDescription mapperVisitor |
	magritteDescription := modelClass new 
		magritteDescription.
	magritteDescription properties
		at: 'originalClass'
		put: modelClass.
	
	mapperVisitor := GtMagriteJSONSchemaNEOJsonMapperVisitor 
		forNeoJsonMapper: neoJsonMapper.
	
	magritteDescription acceptMagritte: mapperVisitor.
]

{ #category : #accessing }
GtLResponseMagritteFormat >> asJsonSchemaDictionaryWithAllRequired [
	^ self computeSchemaWithAllRequired raw
]

{ #category : #accessing }
GtLResponseMagritteFormat >> computeSchema [
	| exporter |
	exporter := GtMagritteJSONSchemaExporter forModelClass: modelClass.
	^ exporter exportSchema.
]

{ #category : #accessing }
GtLResponseMagritteFormat >> computeSchemaWithAllRequired [
	| exporter |
	exporter := GtMagritteJSONSchemaExporter forModelClass: modelClass.
	exporter markAllAsRequired.
	^ exporter exportSchema.
]

{ #category : #accessing }
GtLResponseMagritteFormat >> formatDescription [
	^ 'Magritte Class: ', modelClass name
]

{ #category : #accessing }
GtLResponseMagritteFormat >> modelClass [
	^ modelClass
]

{ #category : #accessing }
GtLResponseMagritteFormat >> modelClass: anObject [
	modelClass := anObject
]

{ #category : #'neo json' }
GtLResponseMagritteFormat >> nextEntryFromNeoJsonReader: jsonReader [ 
	^ jsonReader nextAs: modelClass.
]

{ #category : #printing }
GtLResponseMagritteFormat >> printOn: aStream [
	super printOn: aStream.
	
	aStream parenthesize: [
		aStream << self name.
		aStream << '; '.
		aStream << self type ]
]

{ #category : #accessing }
GtLResponseMagritteFormat >> propertyNames [
	^ self schema properties keys 
]

{ #category : #'neo json' }
GtLResponseMagritteFormat >> readGenericDomainObjectsFrom: aString [
	| neoJsonMapper genericMapping arguments |
	neoJsonMapper := NeoJSONReader on: aString readStream.

	self appendNeoJsonMappingTo: neoJsonMapper.

	genericMapping := (neoJsonMapper mappings at: modelClass) copy.
	genericMapping subjectClass: NeoJSONObject.

	neoJsonMapper mappings at: #GenericEntity put: genericMapping.

	arguments := OrderedDictionary new.
	
	"Answer the top-level properties as an OrderedDictionary with String keys, the keys that the JSON readers (and GtLFunctionToolCall>>#arguments) give and that the tools read. NeoJSONObject has Symbol keys; the nested values are mapped to domain objects, so only the top level is converted."
	(neoJsonMapper nextAs: #GenericEntity)
		keysAndValuesDo: [ :aKey :aValue | arguments at: aKey asString put: aValue ].
	^ arguments
]

{ #category : #accessing }
GtLResponseMagritteFormat >> schema [
	^ self computeSchema
]

{ #category : #accessing }
GtLResponseMagritteFormat >> type [
	^ self schema type
]
