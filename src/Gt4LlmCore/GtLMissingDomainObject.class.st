Class {
	#name : #GtLMissingDomainObject,
	#superclass : #GtLErroneousConditionDomainObject,
	#instVars : [
		'missingObjectName',
		'errorMessage'
	],
	#category : 'Gt4LlmCore-Domain Objects'
}

{ #category : #accessing }
GtLMissingDomainObject >> defaultErrorMessage [
	^missingObjectName 
		ifNil: [''] 
		ifNotNil: [ '{1} is not found' format: {missingObjectName}  ]
]

{ #category : #'api - accessing' }
GtLMissingDomainObject >> errorMessage [
	^ errorMessage ifNil: [
			self defaultErrorMessage ]
]

{ #category : #'api - accessing' }
GtLMissingDomainObject >> errorMessage: aString [
	errorMessage := aString
]

{ #category : #descriptions }
GtLMissingDomainObject >> errorMessageDescription [
	<magritteDescription>

	^ MAStringDescription new
			label: 'Error message';
			accessor: #errorMessage;
			beRequired
]

{ #category : #printing }
GtLMissingDomainObject >> gtDisplayOn: stream [
	stream nextPutAll: self errorMessage
]

{ #category : #'llm views' }
GtLMissingDomainObject >> llmRawDataViewFor: aDataView [
	<gtLlmDataView>
	
	^ aDataView magritteObject: [ self ]
]

{ #category : #'api - accessing' }
GtLMissingDomainObject >> messageText [
	^ self errorMessage
]

{ #category : #accessing }
GtLMissingDomainObject >> missingObjectName [
	^ missingObjectName
]

{ #category : #accessing }
GtLMissingDomainObject >> missingObjectName: aName [
	missingObjectName := aName.
]

{ #category : #descriptions }
GtLMissingDomainObject >> missingObjectNameDescription [
	<magritteDescription>

	^ MAStringDescription new
			label: 'Missing object name';
			accessor: #missingObjectName;
			beRequired
]

{ #category : #accessing }
GtLMissingDomainObject >> objectName [
	^ self missingObjectName
]

{ #category : #accessing }
GtLMissingDomainObject >> objectName: anObject [
	"Set a name of the missing object."

	self missingObjectName: anObject
]

{ #category : #'api - serializing' }
GtLMissingDomainObject >> serializeToLlmJsonObject [
	"Return a JSON dictionary that represents the domain object."
	
	^ GtMagritteJSONDataExporter exportObject: self
]

{ #category : #testing }
GtLMissingDomainObject >> wasMovedToMagritteDescriptions [
	^ true
]
