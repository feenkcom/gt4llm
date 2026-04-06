Class {
	#name : #GtLJsonSchemaBasedModel,
	#superclass : #GtLWrappedModel,
	#instVars : [
		'schema'
	],
	#category : 'Gt4LlmCore-Core'
}

{ #category : #adding }
GtLJsonSchemaBasedModel >> addContentOneLineSummaryTo: aWriteStream [
	| aString |
	aString := [ model printString ]
			on: Error
			do: [ :e | e return: model className ].
	aWriteStream
		nextPutAll: 'Object: ';
		nextPutAll: aString asString
]

{ #category : #adding }
GtLJsonSchemaBasedModel >> addInstructionsTo: aMessageInstructions [

	aMessageInstructions
		addSection: (GtLInstructionSection new
				title: self name;
				body: (NeoJSONWriter toStringPretty: self schema json))
]

{ #category : #accessing }
GtLJsonSchemaBasedModel >> schema [
	^ schema
]

{ #category : #accessing }
GtLJsonSchemaBasedModel >> schema: anObject [
	schema := anObject
]
