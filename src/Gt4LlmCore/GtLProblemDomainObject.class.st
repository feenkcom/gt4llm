Class {
	#name : #GtLProblemDomainObject,
	#superclass : #GtLErroneousConditionDomainObject,
	#instVars : [
		'errorMessage'
	],
	#category : 'Gt4LlmCore-Domain Objects'
}

{ #category : #accessing }
GtLProblemDomainObject >> description [
	^ self errorMessage
]

{ #category : #accessing }
GtLProblemDomainObject >> description: anObject [
	self errorMessage:  anObject
]

{ #category : #accessing }
GtLProblemDomainObject >> errorMessage [
	^ errorMessage
]

{ #category : #accessing }
GtLProblemDomainObject >> errorMessage: anObject [
	errorMessage := anObject
]

{ #category : #'api - accessing' }
GtLProblemDomainObject >> errorMessageDescription [
	<magritteDescription>

	^ MAStringDescription new
			label: 'Error message';
			accessor: #errorMessage;
			beRequired
]

{ #category : #'api - accessing' }
GtLProblemDomainObject >> messageText [
	"Return an error message"

	^ self errorMessage
]

{ #category : #'api - serializing' }
GtLProblemDomainObject >> serializeToLlmJsonObject [
	"Return a JSON dictionary that represents the domain object."
	
	^ GtMagritteJSONDataExporter exportObject: self
]

{ #category : #testing }
GtLProblemDomainObject >> wasMovedToMagritteDescriptions [
	^ true
]
