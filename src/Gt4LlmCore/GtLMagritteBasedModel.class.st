Class {
	#name : #GtLMagritteBasedModel,
	#superclass : #GtLWrappedModel,
	#category : #Gt4LlmCore
}

{ #category : #adding }
GtLMagritteBasedModel >> addContentOneLineSummaryTo: aStringStream [
	GtMagritteStringStreamDataExporter new
		object: model;
		stringStream: aStringStream;
		export
]

{ #category : #adding }
GtLMagritteBasedModel >> addInstructionsTo: aMessageInstructions [
	| exporter |
	exporter := GtMagritteJSONSchemaExporter
			forModelClass: model class.

	aMessageInstructions
		addSection: (GtLInstructionSection new
				title: self name;
				body: (exporter exportSchemaAsJsonString))
]

{ #category : #views }
GtLMagritteBasedModel >> llmModelDataViewsFor: aDataView [
	<gtLlmDataView>
	
	^aDataView magritteObject: [ self model]
]

{ #category : #printing }
GtLMagritteBasedModel >> printOn: aStream [
	aStream 
		<< 'Magritte Model: ';
		print: model 
]
