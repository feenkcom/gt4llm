Class {
	#name : #GtLResponseMarkdownFormat,
	#superclass : #GtLResponseInvividualFormat,
	#instVars : [
		'schema'
	],
	#category : #Gt4LlmCore
}

{ #category : #accessing }
GtLResponseMarkdownFormat >> asJsonSchemaDictionary [
	^ schema raw
]

{ #category : #views }
GtLResponseMarkdownFormat >> gtViewDetailsSchemaFor: aView [
	<gtView>
	^ aView forward
		title: 'Schema Details';
		priority: 5;
		object: [ schema ];
		view: #gtViewDetailsIn:
]

{ #category : #views }
GtLResponseMarkdownFormat >> gtViewSchemaJsonFor: aView [
	<gtView>
	^ aView forward
		title: 'Raw JSON';
		priority: 40;
		object: [ schema ];
		view: #gtViewRawJsonIn:
]

{ #category : #views }
GtLResponseMarkdownFormat >> gtViewSchemaPropertiesFor: aView [
	<gtView>
	^ aView forward
		title: 'Schema Properties';
		priority: 10;
		object: [ schema ];
		view: #gtViewPropertiesIn:
]

{ #category : #initialization }
GtLResponseMarkdownFormat >> initialize [
	super initialize.
	
	schema := NeoJSONSchema new
					json: (NeoJSONObject
							fromString: '
							{
			"description" : "Markdown.
Use blockquote for code.
Denote code snippet in Smalltalk with:
```smalltalk-code
```
",
			"type" : "string"
		}')
]

{ #category : #printing }
GtLResponseMarkdownFormat >> printOn: aStream [
	super printOn: aStream.
	
	aStream parenthesize: [
		aStream << self name.
		aStream << '; '.
		aStream << self type ]
]

{ #category : #accessing }
GtLResponseMarkdownFormat >> propertyNames [
	^ #()
]

{ #category : #accessing }
GtLResponseMarkdownFormat >> schema [
	^ schema
]

{ #category : #accessing }
GtLResponseMarkdownFormat >> schema: aSchema [
	schema := aSchema
]

{ #category : #accessing }
GtLResponseMarkdownFormat >> type [
	^ schema type
]
