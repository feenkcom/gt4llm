Class {
	#name : #GtLResponseInvividualFormat,
	#superclass : #Object,
	#instVars : [
		'name'
	],
	#category : #'Gt4LlmCore-Core'
}

{ #category : #'neo json' }
GtLResponseInvividualFormat >> appendNeoJsonMappingTo: mapper [
	"By default add no mappings"
]

{ #category : #converting }
GtLResponseInvividualFormat >> asJsonSchemaDictionary [
	^ self schema raw
]

{ #category : #converting }
GtLResponseInvividualFormat >> asJsonSchemaDictionaryWithAllRequired [ 
	^ self asJsonSchemaDictionary
]

{ #category : #views }
GtLResponseInvividualFormat >> gtViewDetailsSchemaFor: aView [
	<gtView>
	^ aView forward
		title: 'Schema details';
		priority: 5;
		object: [ self schema ];
		view: #gtViewDetailsIn:
]

{ #category : #views }
GtLResponseInvividualFormat >> gtViewSchemaJsonFor: aView [
	<gtView>
	^ aView forward
		title: 'Raw JSON';
		priority: 40;
		object: [ self schema ];
		view: #gtViewRawJsonIn:
]

{ #category : #views }
GtLResponseInvividualFormat >> gtViewSchemaPropertiesFor: aView [
	<gtView>
	^ aView forward
		title: 'Schema properties';
		priority: 10;
		object: [ self schema ];
		view: #gtViewPropertiesIn:
]

{ #category : #accessing }
GtLResponseInvividualFormat >> name [
	^ name
]

{ #category : #accessing }
GtLResponseInvividualFormat >> name: aString [
	name := aString
]

{ #category : #'neo json' }
GtLResponseInvividualFormat >> nextEntryFromNeoJsonReader: jsonReader [
	^ jsonReader next
]

{ #category : #'neo json' }
GtLResponseInvividualFormat >> readDomainObjectsFrom: aString [
	| neoJsonMapper |
	
	neoJsonMapper := NeoJSONReader on: aString readStream.
	
	self appendNeoJsonMappingTo: neoJsonMapper.
	^ self nextEntryFromNeoJsonReader: neoJsonMapper
]

{ #category : #'neo json' }
GtLResponseInvividualFormat >> readGenericDomainObjectsFrom: aString [
	^ self readDomainObjectsFrom: aString
]

{ #category : #accessing }
GtLResponseInvividualFormat >> schema [
	^ self subclassResponsibility
]
