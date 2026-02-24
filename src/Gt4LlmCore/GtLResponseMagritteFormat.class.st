Class {
	#name : #GtLResponseMagritteFormat,
	#superclass : #GtLResponseInvividualFormat,
	#instVars : [
		'modelClass'
	],
	#category : 'Gt4LlmCore-Core'
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
GtLResponseMagritteFormat >> asJsonSchemaDictionary [
	^ self schema raw
]

{ #category : #accessing }
GtLResponseMagritteFormat >> computeSchema [
	| exporter |
	exporter := GtMagritteJSONSchemaExporter forModelClass: modelClass.
	^ exporter exportSchema.
]

{ #category : #views }
GtLResponseMagritteFormat >> gtViewDetailsSchemaFor: aView [
	<gtView>
	^ aView forward
		title: 'Schema details';
		priority: 5;
		object: [ self schema ];
		view: #gtViewDetailsIn:
]

{ #category : #views }
GtLResponseMagritteFormat >> gtViewSchemaJsonFor: aView [
	<gtView>
	^ aView forward
		title: 'Raw JSON';
		priority: 40;
		object: [ self schema ];
		view: #gtViewRawJsonIn:
]

{ #category : #views }
GtLResponseMagritteFormat >> gtViewSchemaPropertiesFor: aView [
	<gtView>
	^ aView forward
		title: 'Schema properties';
		priority: 10;
		object: [ self schema ];
		view: #gtViewPropertiesIn:
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
	| neoJsonMapper genericMapping |
	
	neoJsonMapper := NeoJSONReader on: aString readStream.
	
	self appendNeoJsonMappingTo: neoJsonMapper.
	
	genericMapping := (neoJsonMapper mappings  at: modelClass) copy.
	genericMapping subjectClass: NeoJSONObject.
	
	neoJsonMapper mappings 
		at: #GenericEntity
		put: genericMapping.
	
	^ (neoJsonMapper nextAs: #GenericEntity)
			asOrderedDictionary.
]

{ #category : #accessing }
GtLResponseMagritteFormat >> schema [
	^ self computeSchema
]

{ #category : #accessing }
GtLResponseMagritteFormat >> type [
	^ self schema type
]
