Class {
	#name : #GtLResponseJsonSchemaFormat,
	#superclass : #GtLResponseInvividualFormat,
	#instVars : [
		'schema'
	],
	#category : 'Gt4LlmCore-Core'
}

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
GtLResponseJsonSchemaFormat >> schemaDictionary: aDictionary [
	self schema: (NeoJSONSchema new json:(NeoJSONObject 
			fromString: (NeoJSONWriter  toStringPretty:aDictionary)))
]

{ #category : #accessing }
GtLResponseJsonSchemaFormat >> type [
	^ schema type
]
