Class {
	#name : #GtLExampleWithResultStatusDomainObject,
	#superclass : #GtLDomainObject,
	#instVars : [
		'exampleWithResult',
		'objectId'
	],
	#category : 'Gt4LlmCore-Domain Objects'
}

{ #category : #accessing }
GtLExampleWithResultStatusDomainObject >> exampleWithResult [
	^ exampleWithResult
]

{ #category : #accessing }
GtLExampleWithResultStatusDomainObject >> exampleWithResult: anObject [
	self assert: [ anObject isKindOf: GtExampleWithResult ].

	exampleWithResult := anObject
]

{ #category : #views }
GtLExampleWithResultStatusDomainObject >> gtExampleSourceFor: aView [
	<gtView>
	<gtLlmView>
	^ aView forward
		title: 'Example source';
		priority: 1;
		object: [ exampleWithResult ];
		view: #gtSourceFor:
]

{ #category : #views }
GtLExampleWithResultStatusDomainObject >> gtExampleWithResultFor: aView [
	<gtView>
	<gtLlmView>
	^ aView forward
		title: 'Example result';
		priority: 2;
		object: [ exampleWithResult ];
		view: #gtLiveFor:
]

{ #category : #'api - testing' }
GtLExampleWithResultStatusDomainObject >> isErrorResult [
	^ self exampleWithResult isError
]

{ #category : #'api - testing' }
GtLExampleWithResultStatusDomainObject >> isFailureResult [
	^ self exampleWithResult isFailure
]

{ #category : #'api - testing' }
GtLExampleWithResultStatusDomainObject >> isSkippedResult [
	^ self exampleWithResult isSkipped
]

{ #category : #'api - testing' }
GtLExampleWithResultStatusDomainObject >> isSuccessResult [
	^ self exampleWithResult isSuccess
]

{ #category : #accessing }
GtLExampleWithResultStatusDomainObject >> objectId [
	^ objectId
]

{ #category : #accessing }
GtLExampleWithResultStatusDomainObject >> objectId: anObject [
	objectId := anObject
]

{ #category : #serialization }
GtLExampleWithResultStatusDomainObject >> serializeToLlmJsonObject [
	"Return a JSON dictionary that represents the domain object."
	<return: #NeoJSONObject>
	
	^ NeoJSONObject new
		at: #className put: self exampleWithResult methodClass name asString;
		at: #selector put: self exampleWithResult selector asString;
		at: #status put: self statusText;
		at: #objectId put: self objectId;
		yourself
]

{ #category : #accessing }
GtLExampleWithResultStatusDomainObject >> statusText [
	self exampleWithResult isSkipped ifTrue: [ ^ 'skipped' ].
	^ self exampleWithResult statusText asString asLowercase
]
