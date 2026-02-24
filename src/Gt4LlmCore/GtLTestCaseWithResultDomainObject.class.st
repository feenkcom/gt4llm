Class {
	#name : #GtLTestCaseWithResultDomainObject,
	#superclass : #GtLDomainObject,
	#instVars : [
		'testCaseWithResult'
	],
	#category : #'Gt4LlmCore-Domain Objects'
}

{ #category : #visiting }
GtLTestCaseWithResultDomainObject >> acceptVisitor: aVisitor [
	^ aVisitor visitTestCaseDomainObject: self
]

{ #category : #'gt - extensions' }
GtLTestCaseWithResultDomainObject >> gtSourceCodeFor: aView [
	<gtView>
	<gtLlmView>
	self testCase ifNil: [ ^ aView empty ].
	
	^ aView forward
		title: 'Source';
		object: [ self testCase ];
		view: #gtSourceCodeFor:
]

{ #category : #'gt - extensions' }
GtLTestCaseWithResultDomainObject >> gtViewExampleComparisonFailureDiffFor: aView [
	<gtView>
	<gtLlmView>

	self testCaseWithResult isGtComparisonFailureExample	ifFalse: [ ^ aView empty ].
	
	^(aView forward)
		title: 'Comparison Diff';
		priority: 6;
		object: [ self testCaseWithResult ];
		view: #gtViewExampleComparisonFailureDiffFor:
]

{ #category : #'gt - extensions' }
GtLTestCaseWithResultDomainObject >> gtViewExampleComparisonFailureDiffImageFor: aView [
	<gtView>
	<gtLlmView>

	self testCaseWithResult isGtComparisonFailureExample	ifFalse: [ ^ aView empty ].
	
	^(aView forward)
		title: 'Comparison Image';
		priority: 6.1;
		object: [ GtLPrimitiveImageData fromElement:  (self testCaseWithResult result exception
			gtViewDiffFor: GtPhlowView empty) asElement ];
		view: #gtImageFor:
]

{ #category : #'api - testing' }
GtLTestCaseWithResultDomainObject >> isErrorResult [
	^ self result isError
]

{ #category : #'api - testing' }
GtLTestCaseWithResultDomainObject >> isExpectedDefectResult [
	^ self result isExpectedDefect
]

{ #category : #'api - testing' }
GtLTestCaseWithResultDomainObject >> isExpectedPassResult [
	^ self isPassedResult and: [ self testCase shouldPass ]
]

{ #category : #'api - testing' }
GtLTestCaseWithResultDomainObject >> isFailureResult [
	^ self result isFailure
]

{ #category : #'api - testing' }
GtLTestCaseWithResultDomainObject >> isPassedResult [
	^ self result isPassed
]

{ #category : #'api - testing' }
GtLTestCaseWithResultDomainObject >> isSkippedResult [
	^ self result isSkipped
]

{ #category : #'api - testing' }
GtLTestCaseWithResultDomainObject >> isSuccessResult [
	^ self isPassedResult
]

{ #category : #'api - testing' }
GtLTestCaseWithResultDomainObject >> isUnexpectedErrorResult [
	^ self isErrorResult and: [ self testCase shouldPass ]
]

{ #category : #'api - testing' }
GtLTestCaseWithResultDomainObject >> isUnexpectedFailureResult [
	^ self isFailureResult and: [ self testCase shouldPass ]
]

{ #category : #'api - testing' }
GtLTestCaseWithResultDomainObject >> isUnexpectedPassResult [
	^ self isPassedResult and: [ self testCase shouldPass not ]
]

{ #category : #accessing }
GtLTestCaseWithResultDomainObject >> messageText [
	self isSkippedResult ifTrue: [ ^ 'Skipped' ].
	self isErrorResult ifTrue: [ ^ 'Error' ].
	self isFailureResult ifTrue: [ ^ 'Failure' ].
	self isSuccessResult ifTrue: [ ^ 'Passed' ].

	^ 'Unknown status'
]

{ #category : #accessing }
GtLTestCaseWithResultDomainObject >> result [
	^ testCaseWithResult result
]

{ #category : #'api - serializing' }
GtLTestCaseWithResultDomainObject >> serializeToAnthropicResponseOutput [
	^ super serializeToAnthropicResponseOutput
		, (self serializeToOpenAIResponseImages collect: [ :anPrimitiveImage |
				anPrimitiveImage serializeToAnthropicResponseOutput ]).
]

{ #category : #'api - serializing' }
GtLTestCaseWithResultDomainObject >> serializeToOpenAIResponseImages [
	^ (self isErrorResult or: [ self isFailureResult ])
		ifFalse: [ #() ]
		ifTrue: [ self result exception serializeToOpenAIResponseImages ]. 
]

{ #category : #'api - serializing' }
GtLTestCaseWithResultDomainObject >> serializeToOpenAIResponseJsonObject [
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
		data
			at: #exception 
			put: self result exception serializeToOpenAIResponseOutput ].
		
	^ data
]

{ #category : #'api - serializing' }
GtLTestCaseWithResultDomainObject >> serializeToOpenAIResponseOutput [
	^ super serializeToOpenAIResponseOutput
		, (self serializeToOpenAIResponseImages collect: [ :anPrimitiveImage |
				anPrimitiveImage serializeToOpenAIResponseOutput ])
]

{ #category : #accessing }
GtLTestCaseWithResultDomainObject >> statusText [
	self isSkippedResult ifTrue: [ ^ 'skipped' ].
	self isErrorResult ifTrue: [ ^ 'error' ].
	self isFailureResult ifTrue: [ ^ 'failure' ].
	self isSuccessResult ifTrue: [ ^ 'success' ].

	^ 'unknown'
]

{ #category : #accessing }
GtLTestCaseWithResultDomainObject >> testCase [
	^ testCaseWithResult testCase
]

{ #category : #accessing }
GtLTestCaseWithResultDomainObject >> testCaseWithResult [
	^testCaseWithResult
]

{ #category : #accessing }
GtLTestCaseWithResultDomainObject >> testCaseWithResult: anObject [
	testCaseWithResult := anObject
]
