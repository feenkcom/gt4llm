Class {
	#name : #GtLUnexpectedDomainObject,
	#superclass : #GtLErroneousConditionDomainObject,
	#instVars : [
		'objectName'
	],
	#category : #'Gt4LlmCore-Domain Objects'
}

{ #category : #'api - accessing' }
GtLUnexpectedDomainObject >> messageText [
	"Return an error message"

	^ '{1} already exists' format: {self objectName}
]

{ #category : #accessing }
GtLUnexpectedDomainObject >> objectName [
	^ objectName
]

{ #category : #accessing }
GtLUnexpectedDomainObject >> objectName: anObject [
	"Set a name of the missing object."

	objectName := anObject
]

{ #category : #'api - serializing' }
GtLUnexpectedDomainObject >> serializeToLlmJsonObject [
	"Return a JSON dictionary that represents the domain object."

	<return: #NeoJSONObject>
	^ NeoJSONObject new
		at: #error put: self messageText;
		at: #unexpectedObject put: self objectName;
		yourself
]
