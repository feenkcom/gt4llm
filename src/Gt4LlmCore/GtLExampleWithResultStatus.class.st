Class {
	#name : #GtLExampleWithResultStatus,
	#superclass : #Object,
	#instVars : [
		'exampleWithResult',
		'objectId'
	],
	#category : #'Gt4LlmCore-Domain Objects'
}

{ #category : #accessing }
GtLExampleWithResultStatus >> exampleReference [
	^ GtLExampleReference new
		methodName: self exampleWithResult selector asString;
		exampleClassName: self exampleWithResult methodClass name asString;
		classSide: self exampleWithResult methodClass isClassSide
]

{ #category : #accessing }
GtLExampleWithResultStatus >> exampleWithResult [
	^ exampleWithResult
]

{ #category : #accessing }
GtLExampleWithResultStatus >> exampleWithResult: anObject [
	self assert: [ anObject isKindOf: GtExampleWithResult ].

	exampleWithResult := anObject
]

{ #category : #printing }
GtLExampleWithResultStatus >> gtDisplayOn: stream [
	self exampleWithResult gtDisplayOn: stream
]

{ #category : #views }
GtLExampleWithResultStatus >> gtExampleSourceFor: aView [
	<gtView>
	<gtLlmView>
	^ aView forward
		title: 'Example source';
		priority: 1;
		object: [ exampleWithResult ];
		view: #gtSourceFor:
]

{ #category : #views }
GtLExampleWithResultStatus >> gtExampleWithResultFor: aView [
	<gtView>
	<gtLlmView>
	^ aView forward
		title: 'Example result';
		priority: 2;
		object: [ exampleWithResult ];
		view: #gtLiveFor:
]

{ #category : #'api - testing' }
GtLExampleWithResultStatus >> isErrorResult [
	^ self exampleWithResult isError
]

{ #category : #'api - testing' }
GtLExampleWithResultStatus >> isFailureResult [
	^ self exampleWithResult isFailure
]

{ #category : #'api - testing' }
GtLExampleWithResultStatus >> isSkippedResult [
	^ self exampleWithResult isSkipped
]

{ #category : #'api - testing' }
GtLExampleWithResultStatus >> isSuccessResult [
	^ self exampleWithResult isSuccess
]

{ #category : #serialization }
GtLExampleWithResultStatus >> llmJsonObject [
	"Return a JSON dictionary that represents the domain object."
	<return: #NeoJSONObject>
	| data |
	
	data := NeoJSONObject new
		at: #className put: self exampleWithResult methodClass name asString;
		at: #selector put: self exampleWithResult selector asString;
		at: #status put: self statusText;
		at: #objectId put: self objectId;
		yourself.
		
	(self isErrorResult or: [ self isFailureResult ]) ifTrue: [
		data at: #errorDetails put: (NeoJSONObject new
			at: #errorMessage put: self normalizedErrorMessage;
			at: #errorClass put: self exampleWithResult returnValue class name asString;
			yourself) ].
		
	^ data
]

{ #category : #private }
GtLExampleWithResultStatus >> normalizedErrorMessage [
	"Return the exception description with the class name prefix stripped if present
	to allow for cases when #description is overriden to remove the class name."
	| description exceptionClassName prefix |
	description := self exampleWithResult returnValue description.
	exceptionClassName := self exampleWithResult returnValue class name asString.
	prefix := exceptionClassName, ': '.
	(description beginsWith: prefix)
		ifTrue: [ ^ description allButFirst: prefix size ].
	^ description
]

{ #category : #accessing }
GtLExampleWithResultStatus >> objectId [
	^ objectId
]

{ #category : #accessing }
GtLExampleWithResultStatus >> objectId: anObject [
	objectId := anObject
]

{ #category : #accessing }
GtLExampleWithResultStatus >> statusText [
	self exampleWithResult isSkipped ifTrue: [ ^ 'skipped' ].
	^ self exampleWithResult statusText asString asLowercase
]
