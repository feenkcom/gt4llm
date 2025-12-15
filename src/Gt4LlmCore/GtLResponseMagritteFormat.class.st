Class {
	#name : #GtLResponseMagritteFormat,
	#superclass : #GtLResponseInvividualFormat,
	#instVars : [
		'modelClass'
	],
	#category : #Gt4LlmCore
}

{ #category : #accessing }
GtLResponseMagritteFormat >> asJsonSchemaDictionary [
	^ self schema raw
]

{ #category : #accessing }
GtLResponseMagritteFormat >> computeSchema [
	| exporter |
	exporter := GtMagriteJSONSchemaExporter new.
	^ exporter exportSchemaForClass: modelClass
]

{ #category : #views }
GtLResponseMagritteFormat >> gtViewDetailsSchemaFor: aView [
	<gtView>
	^ aView forward
		title: 'Schema Details';
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
		title: 'Schema Properties';
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

{ #category : #accessing }
GtLResponseMagritteFormat >> schema [
	^ self computeSchema
]

{ #category : #accessing }
GtLResponseMagritteFormat >> type [
	^ self schema type
]
