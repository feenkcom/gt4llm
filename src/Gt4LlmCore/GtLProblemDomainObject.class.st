Class {
	#name : #GtLProblemDomainObject,
	#superclass : #GtLDomainObject,
	#instVars : [
		'description'
	],
	#category : #'Gt4LlmCore-Domain Objects'
}

{ #category : #accessing }
GtLProblemDomainObject >> description [
	^ description
]

{ #category : #accessing }
GtLProblemDomainObject >> description: anObject [
	description := anObject
]

{ #category : #'api - testing' }
GtLProblemDomainObject >> isErrorDomainObject [
	^ true
]

{ #category : #'api - accessing' }
GtLProblemDomainObject >> messageText [
	"Return an error message"

	^ '{1}' format: {self description}
]

{ #category : #'api - serializing' }
GtLProblemDomainObject >> serializeToOpenAIResponseJsonObject [
	"Return a JSON dictionary that represents the domain object."

	<return: #NeoJSONObject>
	^ NeoJSONObject new
		at: #error put: self messageText;
		yourself
]
