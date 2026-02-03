Class {
	#name : #GtLResponseJsonSchemaFormat,
	#superclass : #GtLResponseInvividualFormat,
	#instVars : [
		'schema'
	],
	#category : 'Gt4LlmCore-Core'
}

{ #category : #accessing }
GtLResponseJsonSchemaFormat >> asJsonSchemaDictionary [
	^ schema raw
]

{ #category : #views }
GtLResponseJsonSchemaFormat >> gtViewDetailsSchemaFor: aView [
	<gtView>
	^ aView forward
		title: 'Schema Details';
		priority: 5;
		object: [ schema ];
		view: #gtViewDetailsIn:
]

{ #category : #views }
GtLResponseJsonSchemaFormat >> gtViewSchemaJsonFor: aView [
	<gtView>
	^ aView forward
		title: 'Raw JSON';
		priority: 40;
		object: [ schema ];
		view: #gtViewRawJsonIn:
]

{ #category : #views }
GtLResponseJsonSchemaFormat >> gtViewSchemaPropertiesFor: aView [
	<gtView>
	^ aView forward
		title: 'Schema Properties';
		priority: 10;
		object: [ schema ];
		view: #gtViewPropertiesIn:
]

{ #category : #printing }
GtLResponseJsonSchemaFormat >> printOn: aStream [
	super printOn: aStream.
	
	aStream parenthesize: [
		aStream << self name.
		aStream << '; '.
		aStream << self type ]
]

{ #category : #accessing }
GtLResponseJsonSchemaFormat >> propertyNames [
	^ schema properties keys 
]

{ #category : #accessing }
GtLResponseJsonSchemaFormat >> schema [
	^ schema
]

{ #category : #accessing }
GtLResponseJsonSchemaFormat >> schema: aSchema [
	schema := aSchema
]

{ #category : #accessing }
GtLResponseJsonSchemaFormat >> type [
	^ schema type
]
