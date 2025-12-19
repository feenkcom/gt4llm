Class {
	#name : #GtLResponseStringFormat,
	#superclass : #GtLResponseInvividualFormat,
	#instVars : [
		'schema'
	],
	#category : #Gt4LlmCore
}

{ #category : #accessing }
GtLResponseStringFormat >> asJsonSchemaDictionary [
	^ schema raw
]

{ #category : #views }
GtLResponseStringFormat >> gtViewDetailsSchemaFor: aView [
	<gtView>
	^ aView forward
		title: 'Schema Details';
		priority: 5;
		object: [ schema ];
		view: #gtViewDetailsIn:
]

{ #category : #views }
GtLResponseStringFormat >> gtViewSchemaJsonFor: aView [
	<gtView>
	^ aView forward
		title: 'Raw JSON';
		priority: 40;
		object: [ schema ];
		view: #gtViewRawJsonIn:
]

{ #category : #views }
GtLResponseStringFormat >> gtViewSchemaPropertiesFor: aView [
	<gtView>
	^ aView forward
		title: 'Schema Properties';
		priority: 10;
		object: [ schema ];
		view: #gtViewPropertiesIn:
]

{ #category : #initialization }
GtLResponseStringFormat >> initialize [
	super initialize.
	
	schema := NeoJSONSchema new
					json: (NeoJSONObject
							fromString: '
							{
			"type" : "string"
		}')
]

{ #category : #printing }
GtLResponseStringFormat >> printOn: aStream [
	super printOn: aStream.
	
	aStream parenthesize: [
		aStream << self name.
		aStream << '; '.
		aStream << self type ]
]

{ #category : #accessing }
GtLResponseStringFormat >> propertyNames [
	^ schema properties keys 
]

{ #category : #accessing }
GtLResponseStringFormat >> schema [
	^ schema
]

{ #category : #accessing }
GtLResponseStringFormat >> schema: aSchema [
	schema := aSchema
]

{ #category : #accessing }
GtLResponseStringFormat >> type [
	^ schema type
]
