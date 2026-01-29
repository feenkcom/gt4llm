Class {
	#name : #GtLUnexpectedDomainObject,
	#superclass : #GtLDomainObject,
	#instVars : [
		'objectName'
	],
	#category : 'Gt4LlmCore-Domain Objects'
}

{ #category : #visiting }
GtLUnexpectedDomainObject >> acceptVisitor: aVisitor [
	^ aVisitor visitUnexpectedDomainObject: self
]

{ #category : #'api - testing' }
GtLUnexpectedDomainObject >> isErrorDomainObject [
	^ true
]

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
GtLUnexpectedDomainObject >> serializeToOpenAIResponseJsonObject [
	"Return a JSON dictionary that represents the domain object."

	<return: #NeoJSONObject>
	^ NeoJSONObject new
		at: #error put: self messageText;
		at: #unexpectedObject put: self objectName;
		yourself
]
