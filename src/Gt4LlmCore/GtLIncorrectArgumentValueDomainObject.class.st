Class {
	#name : #GtLIncorrectArgumentValueDomainObject,
	#superclass : #GtLErroneousConditionDomainObject,
	#instVars : [
		'argumentName',
		'argumentValue',
		'errorDescription'
	],
	#category : #'Gt4LlmCore-Domain Objects'
}

{ #category : #accessing }
GtLIncorrectArgumentValueDomainObject >> argumentName [
	^ argumentName
]

{ #category : #accessing }
GtLIncorrectArgumentValueDomainObject >> argumentName: anObject [
	argumentName := anObject
]

{ #category : #magritte }
GtLIncorrectArgumentValueDomainObject >> argumentNameDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Argument name';
		accessor: #argumentName;
		beRequired
]

{ #category : #accessing }
GtLIncorrectArgumentValueDomainObject >> argumentValue [
	^ argumentValue
]

{ #category : #accessing }
GtLIncorrectArgumentValueDomainObject >> argumentValue: anObject [
	argumentValue := anObject
]

{ #category : #magritte }
GtLIncorrectArgumentValueDomainObject >> argumentValueDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Argument value';
		accessor: #argumentValue;
		beRequired
]

{ #category : #accessing }
GtLIncorrectArgumentValueDomainObject >> errorDescription [
	^ errorDescription
]

{ #category : #accessing }
GtLIncorrectArgumentValueDomainObject >> errorDescription: anObject [
	errorDescription := anObject
]

{ #category : #magritte }
GtLIncorrectArgumentValueDomainObject >> errorDescriptionMagritteDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Error description';
		accessor: #errorDescription;
		beRequired
]

{ #category : #'api - accessing' }
GtLIncorrectArgumentValueDomainObject >> messageText [
	"Return an error message"

	^ 'Argument {1} with value {2} has error {3}'
		format: {self argumentName.
				self argumentValue asString.
				self errorDescription }
]

{ #category : #'api - serializing' }
GtLIncorrectArgumentValueDomainObject >> serializeToLlmJsonObject [
	"Return a JSON dictionary that represents the domain object."

	<return: #NeoJSONObject>
	^ NeoJSONObject new
			at: #error put: self messageText;
			at: #argumentName put: self argumentName;
			at: #argumentValue put: self argumentValue;
			at: #errorDescription put: self errorDescription;
			yourself
]

{ #category : #testing }
GtLIncorrectArgumentValueDomainObject >> wasMovedToMagritteDescriptions [
	^ true
]
