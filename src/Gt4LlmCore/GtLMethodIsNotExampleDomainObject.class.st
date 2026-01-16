Class {
	#name : #GtLMethodIsNotExampleDomainObject,
	#superclass : #GtLDomainObject,
	#instVars : [
		'method'
	],
	#category : #'Gt4LlmCore-Domain Objects'
}

{ #category : #visiting }
GtLMethodIsNotExampleDomainObject >> acceptVisitor: aVisitor [
	^ aVisitor visitMethodIsNotExampleDomainObject: self
]

{ #category : #'api - testing' }
GtLMethodIsNotExampleDomainObject >> isErrorDomainObject [
	^ true
]

{ #category : #'api - accessing' }
GtLMethodIsNotExampleDomainObject >> messageText [
	"Return an error message"

	^ 'Method is not an example: {1}' format: {self method name}
]

{ #category : #accessing }
GtLMethodIsNotExampleDomainObject >> method [
	^ method
]

{ #category : #accessing }
GtLMethodIsNotExampleDomainObject >> method: anObject [
	method := anObject
]

{ #category : #'api - serializing' }
GtLMethodIsNotExampleDomainObject >> serializeToOpenAIResponseJsonObject [
	"Return a JSON dictionary that represents the domain object."

	<return: #NeoJSONObject>
	^ NeoJSONObject new
		at: #error put: self messageText;
		at: #method put: self method name;
		yourself
]
