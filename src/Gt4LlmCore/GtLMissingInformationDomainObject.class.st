Class {
	#name : #GtLMissingInformationDomainObject,
	#superclass : #GtLErroneousConditionDomainObject,
	#instVars : [
		'missingModelName',
		'errorMessage'
	],
	#category : 'Gt4LlmCore-Domain Objects'
}

{ #category : #accessing }
GtLMissingInformationDomainObject >> defaultErrorMessage [
	^missingModelName 
		ifNil: [''] 
		ifNotNil: [ 'Missing {1}' format: { missingModelName }  ]
]

{ #category : #accessing }
GtLMissingInformationDomainObject >> errorMessage [
	^ errorMessage ifNil: [
			self defaultErrorMessage ]
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
			accessor: #errorMessage
]

{ #category : #'llm views' }
GtLMissingInformationDomainObject >> llmRawDataViewFor: aDataView [
	<gtLlmDataView>
	
	^ aDataView magritteObject: [ self ]
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
