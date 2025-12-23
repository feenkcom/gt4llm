Class {
	#name : #GtLJsonSchemaInputModel,
	#superclass : #GtLInputModel,
	#instVars : [
		'schema'
	],
	#category : #Gt4LlmCore
}

{ #category : #'as yet unclassified' }
GtLJsonSchemaInputModel >> addContentTo: aDictionary [
	aDictionary at: name put: model  
]

{ #category : #accessing }
GtLJsonSchemaInputModel >> schema [
	^ schema
]

{ #category : #accessing }
GtLJsonSchemaInputModel >> schema: anObject [
	schema := anObject
]
