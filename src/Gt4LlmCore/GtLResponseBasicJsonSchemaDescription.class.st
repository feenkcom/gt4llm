Class {
	#name : #GtLResponseBasicJsonSchemaDescription,
	#superclass : #Object,
	#instVars : [
		'name'
	],
	#category : #Gt4LlmCore
}

{ #category : #accessing }
GtLResponseBasicJsonSchemaDescription >> asJsonSchemaDictionary [
	self subclassResponsibility
]

{ #category : #accessing }
GtLResponseBasicJsonSchemaDescription >> name [
	^ name
]

{ #category : #accessing }
GtLResponseBasicJsonSchemaDescription >> name: aString [
	name := aString
]
