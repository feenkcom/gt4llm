Class {
	#name : #GtLJsonSchemaInputModel,
	#superclass : #GtLInputModel,
	#instVars : [
		'schema'
	],
	#category : #Gt4LlmCore
}

{ #category : #adding }
GtLJsonSchemaInputModel >> addContentTo: aDictionary [
	aDictionary at: name put: model  
]

{ #category : #adding }
GtLJsonSchemaInputModel >> addInstructionsTo: aMessageInstructions [

	aMessageInstructions
		addSection: (GtLlmInstructionSection new
				source: self;
				title: self name;
				body: (NeoJSONWriter toStringPretty: self schema json))
]

{ #category : #accessing }
GtLJsonSchemaInputModel >> schema [
	^ schema
]

{ #category : #accessing }
GtLJsonSchemaInputModel >> schema: anObject [
	schema := anObject
]
