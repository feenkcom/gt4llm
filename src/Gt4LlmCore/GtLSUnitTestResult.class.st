Class {
	#name : #GtLSUnitTestResult,
	#superclass : #Object,
	#instVars : [
		'testCase',
		'exception',
		'state'
	],
	#category : #Gt4LlmCore
}

{ #category : #adding }
GtLSUnitTestResult >> addError: aTestCase [
	"API compatible with TestResult"
	state := 'error'
]

{ #category : #adding }
GtLSUnitTestResult >> addFailure: aTestCase [
	"API compatible with TestResult"
	state := 'failure'
]

{ #category : #adding }
GtLSUnitTestResult >> addPass: aTestCase [
	"API compatible with TestResult"
	state := 'pass'
]

{ #category : #adding }
GtLSUnitTestResult >> addSkip: aTestCase [
	"API compatible with TestResult"
	state := 'skip'
]

{ #category : #accessing }
GtLSUnitTestResult >> exception [
	^exception
]

{ #category : #views }
GtLSUnitTestResult >> gtExceptionMessageFor: aView [
	<gtView>
	exception ifNil: [ ^aView empty ].
	
	^(aView forward)
		title: 'Exception message';
		priority: 15;
		object: [exception];
		view: #gtMessageTextFor:
]

{ #category : #views }
GtLSUnitTestResult >> gtExceptionStackFor: aView [
	<gtView>
	exception ifNil: [ ^aView empty ].
	^(aView forward)
		title: 'Exception stack';
		priority: 10;
		object: [exception];
		view: #gtLiveFor:
]

{ #category : #views }
GtLSUnitTestResult >> gtSourceCodeFor: aView [
	<gtView>
	^(aView forward)
		title: 'Source';
		object: [testCase];
		view: #gtSourceCodeFor:
]

{ #category : #testing }
GtLSUnitTestResult >> isError [
	^state = 'error'
]

{ #category : #testing }
GtLSUnitTestResult >> isError: aTestCase [
	"API compatible with TestResult"
	^ self isError and:  [testCase = aTestCase]
]

{ #category : #testing }
GtLSUnitTestResult >> isExpectedDefect [
	"Indicates if the test was expected to not pass. See (<expectedFailure> pragma)"

	^  self testCase shouldPass not
]

{ #category : #testing }
GtLSUnitTestResult >> isFailure [
	^state = 'failure'
]

{ #category : #testing }
GtLSUnitTestResult >> isFailure: aTestCase [
	"API compatible with TestResult"
	^ self ifFailure and: [testCase = aTestCase ]
]

{ #category : #testing }
GtLSUnitTestResult >> isPassed [
	^state = 'pass'
]

{ #category : #testing }
GtLSUnitTestResult >> isPassed: aTestCase [
	"API compatible with TestResult"
	^ self isPassed and: [testCase = aTestCase ]
]

{ #category : #testing }
GtLSUnitTestResult >> isSkipped [
	^state = 'skip'
]

{ #category : #printing }
GtLSUnitTestResult >> printOn: aStream [
	super printOn: aStream.
	
	aStream parenthesize: [
		aStream 
			<< state;
			<< '; ';
			print: self testCase;
			<< '; ';
			print: exception ]
]

{ #category : #running }
GtLSUnitTestResult >> runCase [
	[
	testCase announce: TestCaseStarted withResult: self.
	testCase runCaseManaged.
	testCase announce: TestCaseEnded  withResult: self.
	self addPass: testCase]
		on: TestResult failure 
			, TestResult skip
			, TestResult warning
			, TestResult error
		do: [:anException | 
			exception := (GtSystemUtility freeze: anException).
			anException sunitAnnounce: testCase toResult: self]
]

{ #category : #accessing }
GtLSUnitTestResult >> state [
	^state
]

{ #category : #accessing }
GtLSUnitTestResult >> testCase [
	^testCase
]

{ #category : #accessing }
GtLSUnitTestResult >> testCase: anObject [
	testCase := anObject
]
