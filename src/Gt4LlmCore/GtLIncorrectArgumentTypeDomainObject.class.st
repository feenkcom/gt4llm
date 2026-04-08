Class {
	#name : #GtLIncorrectArgumentTypeDomainObject,
	#superclass : #GtLErroneousConditionDomainObject,
	#instVars : [
		'argumentName',
		'argumentValue',
		'expectedArgumentValueKind',
		'errorMessage'
	],
	#category : 'Gt4LlmCore-Domain Objects'
}

{ #category : #accessing }
GtLIncorrectArgumentTypeDomainObject >> argumentName [
	^ argumentName
]

{ #category : #accessing }
GtLIncorrectArgumentTypeDomainObject >> argumentName: anObject [
	argumentName := anObject
]

{ #category : #descriptions }
GtLIncorrectArgumentTypeDomainObject >> argumentNameDescription [
	<magritteDescription>

	^ MAStringDescription new
			label: 'Argument name';
			accessor: #argumentName;
			beRequired
]

{ #category : #accessing }
GtLIncorrectArgumentTypeDomainObject >> argumentValue [
	^ argumentValue
]

{ #category : #accessing }
GtLIncorrectArgumentTypeDomainObject >> argumentValue: anObject [
	argumentValue := anObject
]

{ #category : #descriptions }
GtLIncorrectArgumentTypeDomainObject >> argumentValueDescription [
	<magritteDescription>

	^ MAStringDescription new
			label: 'Argument value';
			accessor: #argumentValue;
			beRequired
]

{ #category : #'api - accessing' }
GtLIncorrectArgumentTypeDomainObject >> createErrorMessage [
	"Return an error message"

	^ '{1} must be a kind of {2}, not a {3}'
		format: {self argumentName.
				self expectedArgumentValueKind.
				self argumentValue class}
]

{ #category : #accessing }
GtLIncorrectArgumentTypeDomainObject >> errorMessage [
	^ errorMessage ifNil: [ self createErrorMessage ]
]

{ #category : #accessing }
GtLIncorrectArgumentTypeDomainObject >> errorMessage: anObject [
	errorMessage := anObject
]

{ #category : #descriptions }
GtLIncorrectArgumentTypeDomainObject >> errorMessageDescription [
	<magritteDescription>

	^ MAStringDescription new
			label: 'Error message';
			accessor: #errorMessage;
			beRequired
]

{ #category : #accessing }
GtLIncorrectArgumentTypeDomainObject >> expectedArgumentValueKind [
	^ expectedArgumentValueKind
]

{ #category : #accessing }
GtLIncorrectArgumentTypeDomainObject >> expectedArgumentValueKind: anObject [
	expectedArgumentValueKind := anObject
]

{ #category : #accessing }
GtLIncorrectArgumentTypeDomainObject >> expectedArgumentValueKindName [
	^ self expectedArgumentValueKind ifNotNil: [ :each | each name ]
]

{ #category : #descriptions }
GtLIncorrectArgumentTypeDomainObject >> expectedArgumentValueKindNameDescription [
	<magritteDescription>

	^ MAStringDescription new
			label: 'Expected argument kind name name';
			accessor: #expectedArgumentValueKindName;
			beRequired
]

{ #category : #'llm views' }
GtLIncorrectArgumentTypeDomainObject >> llmRawDataViewFor: aDataView [
	<gtLlmDataView>
	
	^ aDataView magritteObject: [ self ]
]

{ #category : #'api - accessing' }
GtLIncorrectArgumentTypeDomainObject >> messageText [
	"Return an error message"

	^ self errorMessage
]

{ #category : #'api - serializing' }
GtLIncorrectArgumentTypeDomainObject >> serializeToLlmJsonObject [
	"Return a JSON dictionary that represents the domain object."
	
	^ GtMagritteJSONDataExporter exportObject: self.
]

{ #category : #testing }
GtLIncorrectArgumentTypeDomainObject >> wasMovedToMagritteDescriptions [
	^ true
]
