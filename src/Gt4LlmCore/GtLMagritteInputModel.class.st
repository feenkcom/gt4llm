Class {
	#name : #GtLMagritteInputModel,
	#superclass : #GtLInputModel,
	#category : #Gt4LlmCore
}

{ #category : #adding }
GtLMagritteInputModel >> addContentTo: aDictionary [
	aDictionary at: name put: model asJsonDictionary 
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

{ #category : #printing }
GtLMagritteInputModel >> printOn: aStream [

	super printOn: aStream.
	
	aStream parenthesize: [
		aStream print: model ]
]
