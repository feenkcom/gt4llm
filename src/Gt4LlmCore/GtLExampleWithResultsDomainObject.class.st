Class {
	#name : #GtLExampleWithResultsDomainObject,
	#superclass : #GtLDomainObject,
	#instVars : [
		'exampleWithResults',
		'notFoundClassNames'
	],
	#category : #'Gt4LlmCore-Domain Objects'
}

{ #category : #visiting }
GtLExampleWithResultsDomainObject >> acceptVisitor: aVisitor [
	^ aVisitor visitExampleWithResultsDomainObject: self
]

{ #category : #accessing }
GtLExampleWithResultsDomainObject >> exampleWithResults [
	<return: #Collection of: #GtLExampleWithResultDomainObject>
	^ exampleWithResults ifNil: [ #() ]
]

{ #category : #accessing }
GtLExampleWithResultsDomainObject >> exampleWithResults: aCollection [
	exampleWithResults := aCollection
]

{ #category : #accessing }
GtLExampleWithResultsDomainObject >> notFoundClassNames [
	^ notFoundClassNames ifNil: [ #() ]
]

{ #category : #accessing }
GtLExampleWithResultsDomainObject >> notFoundClassNames: anObject [
	notFoundClassNames := anObject
]

{ #category : #'api - serializing' }
GtLExampleWithResultsDomainObject >> serializeToOpenAIResponseJsonObject [
	"Return a JSON dictionary that represents the domain object."

	<return: #NeoJSONObject>
	^ NeoJSONObject new
		at: #total put: self exampleWithResults size;
		at: #successes put: (self exampleWithResults count: #isSuccessResult);
		at: #failures put: (self exampleWithResults count: #isFailureResult);
		at: #errors put: (self exampleWithResults count: #isErrorResult);
		at: #skips put: (self exampleWithResults count: #isSkippedResult);
		at: #notFound put: self notFoundClassNames;
		at: #details
			put: (self exampleWithResults collect: #serializeToOpenAIResponseJsonObject as: Array);
		yourself
]
