Class {
	#name : #GtLTestCaseWithResultStatus,
	#superclass : #Object,
	#instVars : [
		'testCaseWithResult'
	],
	#category : 'Gt4LlmCore-Domain Objects'
}

{ #category : #'gt - extensions' }
GtLTestCaseWithResultStatus >> gtTestCaseFor: aView [
	<gtView>
	<gtLlmView>
	self testCase ifNil: [ ^ aView empty ].
	
	^ aView forward
		title: 'Method';
		object: [ self testCase ];
		view: #gtTestMethodFor:
]

{ #category : #'api - testing' }
GtLTestCaseWithResultStatus >> isErrorResult [
	^ self result isError
]

{ #category : #'api - testing' }
GtLTestCaseWithResultStatus >> isExpectedDefectResult [
	^ self result isExpectedDefect
]

{ #category : #'api - testing' }
GtLTestCaseWithResultStatus >> isExpectedPassResult [
	^ self isPassedResult and: [ self testCase shouldPass ]
]

{ #category : #'api - testing' }
GtLTestCaseWithResultStatus >> isFailureResult [
	^ self result isFailure
]

{ #category : #'api - testing' }
GtLTestCaseWithResultStatus >> isPassedResult [
	^ self result isPassed
]

{ #category : #'api - testing' }
GtLTestCaseWithResultStatus >> isSkippedResult [
	^ self result isSkipped
]

{ #category : #'api - testing' }
GtLTestCaseWithResultStatus >> isSuccessResult [
	^ self isPassedResult
]

{ #category : #'api - testing' }
GtLTestCaseWithResultStatus >> isUnexpectedErrorResult [
	^ self isErrorResult and: [ self testCase shouldPass ]
]

{ #category : #'api - testing' }
GtLTestCaseWithResultStatus >> isUnexpectedFailureResult [
	^ self isFailureResult and: [ self testCase shouldPass ]
]

{ #category : #'api - testing' }
GtLTestCaseWithResultStatus >> isUnexpectedPassResult [
	^ self isPassedResult and: [ self testCase shouldPass not ]
]

{ #category : #accessing }
GtLTestCaseWithResultStatus >> messageText [
	self isSkippedResult ifTrue: [ ^ 'Skipped' ].
	self isErrorResult ifTrue: [ ^ 'Error' ].
	self isFailureResult ifTrue: [ ^ 'Failure' ].
	self isSuccessResult ifTrue: [ ^ 'Passed' ].

	^ 'Unknown status'
]

{ #category : #private }
GtLTestCaseWithResultStatus >> normalizedErrorMessage [
	"Return the exception description with the class name prefix stripped if present
	to allow for cases when #description is overriden to remove the class name."
	| description exceptionClassName prefix |
	description := self result exception description.
	exceptionClassName := self result exception className.
	prefix := exceptionClassName, ': '.
	(description beginsWith: prefix)
		ifTrue: [ ^ description allButFirst: prefix size ].
	^ description
]

{ #category : #accessing }
GtLTestCaseWithResultStatus >> result [
	^ testCaseWithResult result
]

{ #category : #serialization }
GtLTestCaseWithResultStatus >> serializeToLlmJsonObject [
	"Return a JSON dictionary that represents the domain object."

	<return: #NeoJSONObject>
	| data |
	data := NeoJSONObject new
		at: #className put: self testCase class name asString;
		at: #selector put: (self testCase selector ifNil: [ '' ] ifNotNil: #asString);
		at: #status put: self statusText;
		at: #result put: self messageText;
		at: #shouldPass put: self testCase shouldPass;
		at: #expectedFailure put: self testCase isExpectedFailure;
		yourself.
		
	(self isErrorResult or: [ self isFailureResult ]) ifTrue: [
		data at: #errorDetails put: (NeoJSONObject new
			at: #errorMessage put: (self normalizedErrorMessage);
			at: #errorClass put: self result exception className;
			yourself) ].
		
	^data
]

{ #category : #accessing }
GtLTestCaseWithResultStatus >> statusText [
	self isSkippedResult ifTrue: [ ^ 'skipped' ].
	self isErrorResult ifTrue: [ ^ 'error' ].
	self isFailureResult ifTrue: [ ^ 'failure' ].
	self isSuccessResult ifTrue: [ ^ 'success' ].

	^ 'unknown'
]

{ #category : #accessing }
GtLTestCaseWithResultStatus >> testCase [
	^ testCaseWithResult testCase
]

{ #category : #accessing }
GtLTestCaseWithResultStatus >> testCaseWithResult [
	^testCaseWithResult
]

{ #category : #accessing }
GtLTestCaseWithResultStatus >> testCaseWithResult: anObject [
	testCaseWithResult := anObject
]
