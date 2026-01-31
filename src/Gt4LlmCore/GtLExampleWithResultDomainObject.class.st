Class {
	#name : #GtLExampleWithResultDomainObject,
	#superclass : #GtLDomainObject,
	#instVars : [
		'exampleWithResult'
	],
	#category : #'Gt4LlmCore-Domain Objects'
}

{ #category : #visiting }
GtLExampleWithResultDomainObject >> acceptVisitor: aVisitor [
	^ aVisitor visitExampleWithResultDomainObject: self
]

{ #category : #accessing }
GtLExampleWithResultDomainObject >> exampleWithResult [
	^ exampleWithResult
]

{ #category : #accessing }
GtLExampleWithResultDomainObject >> exampleWithResult: anObject [
	self assert: [ anObject isKindOf: GtExampleWithResult ].

	exampleWithResult := anObject
]

{ #category : #views }
GtLExampleWithResultDomainObject >> gtExampleSourceFor: aView [
	<gtView>
	<gtLlmView>
	^ aView forward
		title: 'Example source';
		priority: 1;
		object: [ exampleWithResult ];
		view: #gtSourceFor:
]

{ #category : #views }
GtLExampleWithResultDomainObject >> gtExampleWithResultFor: aView [
	<gtView>
	<gtLlmView>
	^ aView forward
		title: 'Example result';
		priority: 2;
		object: [ exampleWithResult ];
		view: #gtLiveFor:
]

{ #category : #'api - testing' }
GtLExampleWithResultDomainObject >> isErrorResult [
	^ self exampleWithResult isError
]

{ #category : #'api - testing' }
GtLExampleWithResultDomainObject >> isFailureResult [
	^ self exampleWithResult isFailure
]

{ #category : #'api - testing' }
GtLExampleWithResultDomainObject >> isSkippedResult [
	^ self exampleWithResult isSkipped
]

{ #category : #'api - testing' }
GtLExampleWithResultDomainObject >> isSuccessResult [
	^ self exampleWithResult isSuccess
]

{ #category : #accessing }
GtLExampleWithResultDomainObject >> safeReturnValuePrintString [
	^ [ | object |
	object := (self isErrorResult or: [ self isFailureResult ])
		ifTrue: [ self exampleWithResult returnValue 
			serializeToOpenAIResponseOutput ]
		ifFalse: [ GtLValueSerializer new
			serializeValue: self exampleWithResult returnValue ].
	object ] onErrorDo: [ :anError | anError return: 'printString error' ]
]

{ #category : #'api - serializing' }
GtLExampleWithResultDomainObject >> serializeToOpenAIResponseImages [
	^ (self isErrorResult or: [ self isFailureResult ])
		ifFalse: [ #() ]
		ifTrue: [ self exampleWithResult returnValue serializeToOpenAIResponseImages ]. 
]

{ #category : #'api - serializing' }
GtLExampleWithResultDomainObject >> serializeToOpenAIResponseJsonObject [
	"Return a JSON dictionary that represents the domain object."

	<return: #NeoJSONObject>
	
	^ NeoJSONObject new
		at: #className put: self exampleWithResult methodClass name asString;
		at: #selector put: self exampleWithResult selector asString;
		at: #status put: self statusText;
		at: #result put: self safeReturnValuePrintString;
		yourself
]

{ #category : #'api - serializing' }
GtLExampleWithResultDomainObject >> serializeToOpenAIResponseOutput [
	^ super serializeToOpenAIResponseOutput
		, self serializeToOpenAIResponseImages.
]

{ #category : #accessing }
GtLExampleWithResultDomainObject >> statusText [
	self isSkippedResult ifTrue: [ ^ 'skipped' ].
	^ self exampleWithResult statusText asString asLowercase
]
