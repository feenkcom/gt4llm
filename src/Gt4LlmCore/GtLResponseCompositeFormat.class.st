Class {
	#name : #GtLResponseCompositeFormat,
	#superclass : #Object,
	#instVars : [
		'schemaDescriptions'
	],
	#category : #Gt4LlmCore
}

{ #category : #adding }
GtLResponseCompositeFormat >> addSchemaDescription: aSchema [
	schemaDescriptions add: aSchema
]

{ #category : #adding }
GtLResponseCompositeFormat >> addSchemaDescriptions: aCollection [
	schemaDescriptions addAll: aCollection
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
		column: 'Properties' text: [ :each | each propertyNames ]
]

{ #category : #views }
GtLResponseCompositeFormat >> gtViewSchemaDetailsFor: aView [
	<gtView>
	^ aView forward
		title: 'Schema Details';
		priority: 25;
		object: [ self asJsonSchemaDictionary ];
		view: #gtTreeFor:context:
]

{ #category : #initialization }
GtLResponseCompositeFormat >> initialize [
	super initialize.
	
	schemaDescriptions := OrderedCollection new.
]
