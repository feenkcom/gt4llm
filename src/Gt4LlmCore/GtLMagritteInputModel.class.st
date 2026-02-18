Class {
	#name : #GtLMagritteInputModel,
	#superclass : #GtLInputModel,
	#category : #Gt4LlmCore
}

{ #category : #adding }
GtLMagritteInputModel >> addContentOneLineSummaryTo: aStringStream [
	GtMagritteStringStreamDataExporter new
		object: model;
		stringStream: aStringStream;
		export
]

{ #category : #adding }
GtLMagritteInputModel >> addContentTo: aDictionary [
	| exporter dict |
	exporter := GtMagritteJSONDataExporter forObject: model.
	dict := exporter exportObject asDictionary.
	aDictionary at: name put: dict
]

{ #category : #adding }
GtLMagritteInputModel >> addInstructionsTo: aMessageInstructions [
	| exporter |
	exporter := GtMagritteJSONSchemaExporter
			forModelClass: model class.

	aMessageInstructions
		addSection: (GtLlmInstructionSection new
				source: self;
				title: self name;
				body: (exporter exportSchemaAsJsonString))
]

{ #category : #'as yet unclassified' }
GtLMagritteInputModel >> model [
	^ model
]

{ #category : #printing }
GtLMagritteInputModel >> printOn: aStream [

	super printOn: aStream.
	
	aStream parenthesize: [
		aStream print: model ]
]
