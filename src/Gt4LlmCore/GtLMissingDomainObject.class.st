Class {
	#name : #GtLMissingDomainObject,
	#superclass : #GtLDomainObject,
	#instVars : [
		'objectName'
	],
	#category : #'Gt4LlmCore-Domain Objects'
}

{ #category : #visiting }
GtLMissingDomainObject >> acceptVisitor: aVisitor [
	^ aVisitor visitMissingDomainObject: self
]

{ #category : #'api - testing' }
GtLMissingDomainObject >> isError [
	^ true
]

{ #category : #'api - accessing' }
GtLMissingDomainObject >> messageText [
	"Return an error message"

	^ '{1} is not found' format: {self objectName}
]

{ #category : #accessing }
GtLMissingDomainObject >> objectName [
	^ objectName
]

{ #category : #accessing }
GtLMissingDomainObject >> objectName: anObject [
	"Set a name of the missing object."

	objectName := anObject
]

{ #category : #'api - serializing' }
GtLMissingDomainObject >> serializeToOpenAIResponseJsonObject [
	"Return a JSON dictionary that represents the domain object."

	<return: #NeoJSONObject>
	^ NeoJSONObject new
		at: #error put: self messageText;
		at: #missingObject put: self objectName;
		yourself
]
