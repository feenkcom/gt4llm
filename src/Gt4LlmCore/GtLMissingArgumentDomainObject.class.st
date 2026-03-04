Class {
	#name : #GtLMissingArgumentDomainObject,
	#superclass : #GtLErroneousConditionDomainObject,
	#instVars : [
		'arguments',
		'missingArgument',
		'errorMessage'
	],
	#category : #'Gt4LlmCore-Domain Objects'
}

{ #category : #accessing }
GtLMissingArgumentDomainObject >> arguments [
	<return: #Dictionary>
	^ arguments
]

{ #category : #accessing }
GtLMissingArgumentDomainObject >> arguments: aDictionary [
	"Set provided arguments with argument names and values."

	arguments := aDictionary
]

{ #category : #accessing }
GtLMissingArgumentDomainObject >> errorMessage [
	^ errorMessage
]

{ #category : #accessing }
GtLMissingArgumentDomainObject >> errorMessage: anObject [
	^ errorMessage := anObject
]

{ #category : #descriptions }
GtLMissingArgumentDomainObject >> errorMessageDescription [
	<magritteDescription>

	^ MAStringDescription new
			label: 'Error message';
			accessor: #errorMessage;
			beRequired
]

{ #category : #accessing }
GtLMissingArgumentDomainObject >> messageText [
	"Return an error message"

	^ self errorMessage
]

{ #category : #accessing }
GtLMissingArgumentDomainObject >> missingArgument [
	<return: #String>
	^ missingArgument
]

{ #category : #accessing }
GtLMissingArgumentDomainObject >> missingArgument: aString [
	"Set a missing argument name."

	missingArgument := aString.
	errorMessage ifNil: [
		errorMessage := 'Missing argument called {1}' format: {missingArgument}]
]

{ #category : #descriptions }
GtLMissingArgumentDomainObject >> missingArgumentDescription [
	<magritteDescription>

	^ MAStringDescription new
			label: 'Missing argument';
			accessor: #missingArgument;
			beRequired
]

{ #category : #'api - serializing' }
GtLMissingArgumentDomainObject >> serializeToLlmJsonObject [
	"Return a JSON dictionary that represents the domain object."
	
	^ GtMagritteJSONDataExporter exportObject: self.
]

{ #category : #testing }
GtLMissingArgumentDomainObject >> wasMovedToMagritteDescriptions [
	^ true
]
