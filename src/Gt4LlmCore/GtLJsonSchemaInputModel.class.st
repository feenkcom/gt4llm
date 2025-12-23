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

{ #category : #'as yet unclassified' }
GtLJsonSchemaInputModel >> addInstructionsTo: aMessageInstructions [

	aMessageInstructions
		addSection: (GtLlmInstructionSection new
				source: self;
				title: self name;
				body: (NeoJSONWriter toStringPretty: self schema))
]

{ #category : #accessing }
GtLJsonSchemaInputModel >> schema [
	^ schema
]

{ #category : #accessing }
GtLJsonSchemaInputModel >> schema: anObject [
	schema := anObject
]
