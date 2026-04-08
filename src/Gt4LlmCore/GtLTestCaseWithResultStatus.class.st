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

{ #category : #accessing }
GtLTestCaseWithResultStatus >> result [
	^ testCaseWithResult result
]

{ #category : #'api - serializing' }
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
		data at: #errorDescription put: self result exception description ].
		
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
