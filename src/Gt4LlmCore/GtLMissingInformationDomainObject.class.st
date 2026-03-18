Class {
	#name : #GtLMissingInformationDomainObject,
	#superclass : #GtLErroneousConditionDomainObject,
	#instVars : [
		'missingModelName',
		'errorMessage'
	],
	#category : #'Gt4LlmCore-Domain Objects'
}

{ #category : #accessing }
GtLMissingInformationDomainObject >> errorMessage [
	^ errorMessage
]

{ #category : #accessing }
GtLMissingInformationDomainObject >> errorMessage: anObject [
	errorMessage := anObject
]

{ #category : #accessing }
GtLMissingInformationDomainObject >> errorMessageDescription [
	<magritteDescription>

	^ MAStringDescription new
			label: 'Error message';
			accessor: #errorMessage;
			beRequired
]

{ #category : #'api - accessing' }
GtLMissingInformationDomainObject >> messageText [
	"Return an error message"

	^ self errorMessage
]

{ #category : #accessing }
GtLMissingInformationDomainObject >> missingModelName [
	^ missingModelName
]

{ #category : #accessing }
GtLMissingInformationDomainObject >> missingModelName: aString [
	"Set a missing model name."

	missingModelName := aString.
	errorMessage ifNil: [
		errorMessage := 'Missing {1}' format: { missingModelName } ]
]

{ #category : #accessing }
GtLMissingInformationDomainObject >> missingModelNameDescription [
	<magritteDescription>

	^ MAStringDescription new
			label: 'Missing model name';
			accessor: #missingModelName;
			beRequired
]

{ #category : #'api - serializing' }
GtLMissingInformationDomainObject >> serializeToLlmJsonObject [
	"Return a JSON dictionary that represents the domain object."
	
	^ GtMagritteJSONDataExporter exportObject: self
]

{ #category : #testing }
GtLMissingInformationDomainObject >> wasMovedToMagritteDescriptions [
	^ true
]
