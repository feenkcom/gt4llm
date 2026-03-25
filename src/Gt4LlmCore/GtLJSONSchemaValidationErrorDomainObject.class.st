Class {
	#name : #GtLJSONSchemaValidationErrorDomainObject,
	#superclass : #GtLErroneousConditionDomainObject,
	#instVars : [
		'errorMessage',
		'path'
	],
	#category : #Gt4LlmCore
}

{ #category : #accessing }
GtLJSONSchemaValidationErrorDomainObject >> errorMessage [
	^ errorMessage
]

{ #category : #accessing }
GtLJSONSchemaValidationErrorDomainObject >> errorMessage: aString [
	errorMessage := aString
]

{ #category : #magritte }
GtLJSONSchemaValidationErrorDomainObject >> errorMessageDescription [
	<magritteDescription>

	^ MAStringDescription new
		label: 'Error message';
		accessor: #errorMessage;
		beRequired
]

{ #category : #'llm views' }
GtLJSONSchemaValidationErrorDomainObject >> llmRawDataViewFor: aDataView [
	<gtLlmDataView>
	
	^ aDataView magritteObject: [ self ]
]

{ #category : #accessing }
GtLJSONSchemaValidationErrorDomainObject >> messageText [
	"Return an error message"

	^ self errorMessage
]

{ #category : #accessing }
GtLJSONSchemaValidationErrorDomainObject >> path [
	^ path
]

{ #category : #accessing }
GtLJSONSchemaValidationErrorDomainObject >> path: aCollection [
	path := aCollection
]

{ #category : #magritte }
GtLJSONSchemaValidationErrorDomainObject >> pathDescription [
	<magritteDescription>

	^ MAToManyScalarRelationDescription new
		label: 'Path';
		accessor: #path;
		classes: {String};
		beRequired;
		yourself
]

{ #category : #printing }
GtLJSONSchemaValidationErrorDomainObject >> printOn: aStream [
	super printOn: aStream.
	
	aStream parenthesize: [
		aStream << self messageText ]
]

{ #category : #accessing }
GtLJSONSchemaValidationErrorDomainObject >> serializeToLlmJsonObject [
	"Return a JSON dictionary that represents the domain object."

	^ GtMagritteJSONDataExporter exportObject: self
]

{ #category : #accessing }
GtLJSONSchemaValidationErrorDomainObject >> wasMovedToMagritteDescriptions [
	^ true
]
