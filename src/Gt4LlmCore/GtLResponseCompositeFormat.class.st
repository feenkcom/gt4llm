Class {
	#name : #GtLResponseCompositeFormat,
	#superclass : #Object,
	#instVars : [
		'schemaDescriptions'
	],
	#category : #'Gt4LlmCore-Core'
}

{ #category : #adding }
GtLResponseCompositeFormat >> addCompositeFormat: aCompositeFormat [
	self addSchemaDescriptions: aCompositeFormat schemaDescriptions
]

{ #category : #adding }
GtLResponseCompositeFormat >> addResponseFormat: aSchema [
	schemaDescriptions add: aSchema
]

{ #category : #adding }
GtLResponseCompositeFormat >> addSchemaDescriptions: aCollection [
	schemaDescriptions addAll: aCollection
]

{ #category : #adding }
GtLResponseCompositeFormat >> appendNeoJsonMappingTo: neoJsonMapper [

	schemaDescriptions do: [ :aSchemaDescriptor |
		aSchemaDescriptor appendNeoJsonMappingTo: neoJsonMapper ].

	neoJsonMapper
		for: #CompositeResponse
		customDo: [ :mapping | 
			mapping reader: [ :jsonReader | | map |
				map := jsonReader mapClass new.
				jsonReader parseMapKeysDo: [ :key | 
					| value |
					schemaDescriptions 
						detect: [ :aSchemaDescriptor | 
							aSchemaDescriptor name = key ]
						ifFound: [ :aSchemaDescriptor|
							value := aSchemaDescriptor nextEntryFromNeoJsonReader: jsonReader ]
						ifNone: [ Error signal: 'Schema not found: ', key ].
					map at: key put: value ].
					map ].
			mapping writer: [ :jsonWriter :map | 
				self error: 'to be implemented' ] ].
]

{ #category : #'as yet unclassified' }
GtLResponseCompositeFormat >> asJsonSchemaDictionary [
	^ NeoJSONObject  new 
			at: 'type' put: 'object';
			at: 'properties' put: ((schemaDescriptions collect: [ :aSchema | 
				aSchema name -> aSchema asJsonSchemaDictionary ])
						asDictionary);
			at: 'required' put: (schemaDescriptions collect: [:aFormat | aFormat name ]);
			at: 'additionalProperties'  put: false;
			yourself
]

{ #category : #'as yet unclassified' }
GtLResponseCompositeFormat >> formatDescriptionsJsonSchema [
	^ self asJsonSchemaDictionary
]

{ #category : #views }
GtLResponseCompositeFormat >> gtViewRawJsonFor: aView [
	<gtView>
	^ aView forward
		title: 'Raw JSON';
		priority: 40;
		object: [ self asJsonSchemaDictionary ];
		view: #gtJsonFor:
]

{ #category : #views }
GtLResponseCompositeFormat >> gtViewSchemaDescriptionsFor: aView [
	<gtView>
	schemaDescriptions ifNil: [ ^ aView empty ].
	^ aView columnedList
		title: 'Schemas descriptions';
		priority: 10;
		items: [ schemaDescriptions ];
		column: 'Value' text: [ :each | each name ] width: 200;
		column: 'Type' text: [ :each | each type ] width: 200;
		column: 'Properties' text: [ :each | each propertyNames asCommaString ]
]

{ #category : #views }
GtLResponseCompositeFormat >> gtViewSchemaDetailsFor: aView [
	<gtView>
	^ aView forward
		title: 'Schema details';
		priority: 25;
		object: [ self asJsonSchemaDictionary ];
		view: #gtTreeFor:context:
]

{ #category : #testing }
GtLResponseCompositeFormat >> hasSchemaDescriptors [
	^ schemaDescriptions notEmpty
]

{ #category : #initialization }
GtLResponseCompositeFormat >> initialize [
	super initialize.
	
	schemaDescriptions := OrderedCollection new.
]

{ #category : #reading }
GtLResponseCompositeFormat >> nextEntryFromNeoJsonReader: jsonReader [
	^ jsonReader nextAs: #CompositeResponse
]

{ #category : #reading }
GtLResponseCompositeFormat >> readDomainObjectsFrom: aString [
	| neoJsonMapper |
	
	neoJsonMapper := NeoJSONReader on: aString readStream.
	
	self appendNeoJsonMappingTo: neoJsonMapper.
	^ self nextEntryFromNeoJsonReader: neoJsonMapper
]

{ #category : #'as yet unclassified' }
GtLResponseCompositeFormat >> schemaDescriptions [
	^ schemaDescriptions
]

{ #category : #'as yet unclassified' }
GtLResponseCompositeFormat >> size [
	^ schemaDescriptions size
]
