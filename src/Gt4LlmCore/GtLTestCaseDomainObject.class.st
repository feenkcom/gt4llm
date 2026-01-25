Class {
	#name : #GtLTestCaseDomainObject,
	#superclass : #GtLDomainObject,
	#instVars : [
		'testCase',
		'result'
	],
	#category : #'Gt4LlmCore-Domain Objects'
}

{ #category : #visiting }
GtLTestCaseDomainObject >> acceptVisitor: aVisitor [
	^ aVisitor visitTestCaseDomainObject: self
]

{ #category : #'gt - extensions' }
GtLTestCaseDomainObject >> gtTestCaseFor: aView [
	<gtView>
	<gtLlmView>
	self testCase ifNil: [ ^ aView empty ].
	
	^ aView forward
		title: 'Method';
		object: [ self testCase ];
		view: #gtTestMethodFor:
]

{ #category : #'api - testing' }
GtLTestCaseDomainObject >> isErrorResult [
	^ self result isError: self testCase
]

{ #category : #'api - testing' }
GtLTestCaseDomainObject >> isExpectedDefectResult [
	^ self result expectedDefects includes: self testCase
]

{ #category : #'api - testing' }
GtLTestCaseDomainObject >> isExpectedPassResult [
	^ self isPassedResult and: [ self testCase shouldPass ]
]

{ #category : #'api - testing' }
GtLTestCaseDomainObject >> isFailureResult [
	^ self result isFailure: self testCase
]

{ #category : #'api - testing' }
GtLTestCaseDomainObject >> isPassedResult [
	^ self result isPassed: self testCase
]

{ #category : #'api - testing' }
GtLTestCaseDomainObject >> isSkippedResult [
	^ self result skipped includes: self testCase
]

{ #category : #'api - testing' }
GtLTestCaseDomainObject >> isSuccessResult [
	^ self isPassedResult
]

{ #category : #'api - testing' }
GtLTestCaseDomainObject >> isUnexpectedErrorResult [
	^ self isErrorResult and: [ self testCase shouldPass ]
]

{ #category : #'api - testing' }
GtLTestCaseDomainObject >> isUnexpectedFailureResult [
	^ self isFailureResult and: [ self testCase shouldPass ]
]

{ #category : #'api - testing' }
GtLTestCaseDomainObject >> isUnexpectedPassResult [
	^ self isPassedResult and: [ self testCase shouldPass not ]
]

{ #category : #accessing }
GtLTestCaseDomainObject >> messageText [
	self isSkippedResult ifTrue: [ ^ 'Skipped' ].
	self isErrorResult ifTrue: [ ^ 'Error' ].
	self isFailureResult ifTrue: [ ^ 'Failure' ].
	self isSuccessResult ifTrue: [ ^ 'Passed' ].

	^ 'Unknown status'
]

{ #category : #accessing }
GtLTestCaseDomainObject >> result [
	^ result
]

{ #category : #accessing }
GtLTestCaseDomainObject >> result: anObject [
	result := anObject
]

{ #category : #'api - serializing' }
GtLTestCaseDomainObject >> serializeToOpenAIResponseJsonObject [
	"Return a JSON dictionary that represents the domain object."

	<return: #NeoJSONObject>
	^ NeoJSONObject new
		at: #className put: self testCase class name asString;
		at: #selector put: (self testCase selector ifNil: [ '' ] ifNotNil: #asString);
		at: #status put: self statusText;
		at: #result put: self messageText;
		at: #shouldPass put: self testCase shouldPass;
		at: #expectedFailure put: self testCase isExpectedFailure;
		at: #stackTrace put: self stackTrace;
		yourself
]

{ #category : #accessing }
GtLTestCaseDomainObject >> statusText [
	self isSkippedResult ifTrue: [ ^ 'skipped' ].
	self isErrorResult ifTrue: [ ^ 'error' ].
	self isFailureResult ifTrue: [ ^ 'failure' ].
	self isSuccessResult ifTrue: [ ^ 'success' ].

	^ 'unknown'
]

{ #category : #accessing }
GtLTestCaseDomainObject >> testCase [
	^ testCase
]

{ #category : #accessing }
GtLTestCaseDomainObject >> testCase: anObject [
	testCase := anObject
]
