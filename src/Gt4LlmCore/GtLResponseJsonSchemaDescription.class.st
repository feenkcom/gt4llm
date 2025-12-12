Class {
	#name : #GtLResponseJsonSchemaDescription,
	#superclass : #GtLResponseBasicJsonSchemaDescription,
	#instVars : [
		'priority',
		'schema'
	],
	#category : #Gt4LlmCore
}

{ #category : #accessing }
GtLResponseJsonSchemaDescription >> asJsonSchemaDictionary [
	^ schema raw
]

{ #category : #views }
GtLResponseJsonSchemaDescription >> gtViewDetailsSchemaFor: aView [
	<gtView>
	^ aView forward
		title: 'Schema Details';
		priority: 5;
		object: [ schema ];
		view: #gtViewDetailsIn:
]

{ #category : #views }
GtLResponseJsonSchemaDescription >> gtViewSchemaJsonFor: aView [
	<gtView>
	^ aView forward
		title: 'Raw JSON';
		priority: 40;
		object: [ schema ];
		view: #gtViewRawJsonIn:
]

{ #category : #views }
GtLResponseJsonSchemaDescription >> gtViewSchemaPropertiesFor: aView [
	<gtView>
	^ aView forward
		title: 'Schema Properties';
		priority: 10;
		object: [ schema ];
		view: #gtViewPropertiesIn:
]

{ #category : #printing }
GtLResponseJsonSchemaDescription >> printOn: aStream [
	super printOn: aStream.
	
	aStream parenthesize: [
		aStream << self name.
		aStream << '; '.
		aStream << self type ]
]

{ #category : #accessing }
GtLResponseJsonSchemaDescription >> priority [
	^ priority
]

{ #category : #accessing }
GtLResponseJsonSchemaDescription >> priority: anInteger [
	priority := anInteger
]

{ #category : #accessing }
GtLResponseJsonSchemaDescription >> propertyNames [
	^ schema properties keys 
]

{ #category : #accessing }
GtLResponseJsonSchemaDescription >> schema [
	^ schema
]

{ #category : #accessing }
GtLResponseJsonSchemaDescription >> schema: aSchema [
	schema := aSchema
]

{ #category : #accessing }
GtLResponseJsonSchemaDescription >> type [
	^ schema type
]
