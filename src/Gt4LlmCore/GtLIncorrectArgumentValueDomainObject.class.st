Class {
	#name : #GtLIncorrectArgumentValueDomainObject,
	#superclass : #GtLDomainObject,
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

{ #category : #accessing }
GtLIncorrectArgumentValueDomainObject >> argumentValue [
	^ argumentValue
]

{ #category : #accessing }
GtLIncorrectArgumentValueDomainObject >> argumentValue: anObject [
	argumentValue := anObject
]

{ #category : #accessing }
GtLIncorrectArgumentValueDomainObject >> errorDescription [
	^ errorDescription
]

{ #category : #accessing }
GtLIncorrectArgumentValueDomainObject >> errorDescription: anObject [
	errorDescription := anObject
]

{ #category : #'api - testing' }
GtLIncorrectArgumentValueDomainObject >> isErrorDomainObject [
	^ true
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
GtLIncorrectArgumentValueDomainObject >> serializeToOpenAIResponseJsonObject [
	"Return a JSON dictionary that represents the domain object."

	<return: #NeoJSONObject>
	^ NeoJSONObject new
			at: #error put: self messageText;
			at: #argumentName put: self argumentName;
			at: #argumentValue put: self argumentValue;
			at: #errorDescription put: self errorDescription;
			yourself
]
