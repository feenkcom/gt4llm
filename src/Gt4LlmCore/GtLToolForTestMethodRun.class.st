Class {
	#name : #GtLToolForTestMethodRun,
	#superclass : #GtLAbstractMagritteFunctionTool,
	#category : #'Gt4LlmCore-Tools'
}

{ #category : #accessing }
GtLToolForTestMethodRun >> description [
	^ 'Execute a single SUnit test method on a subclass of TestCase and report the resulting status (success, failure, error, skipped).'
]

{ #category : #accessing }
GtLToolForTestMethodRun >> isUsingDataViews [
	^ true
]

{ #category : #accessing }
GtLToolForTestMethodRun >> name [
	^ 'testMethodRun'
]

{ #category : #'private - execution' }
GtLToolForTestMethodRun >> privatePerformToolCall: aToolCall inContext: anExecutionContext [
	| arguments testReference |
	arguments := aToolCall arguments ifNil: [ Dictionary new ].
	testReference := arguments at: 'testReference'.
	
	^ testReference 
		compiledMethodIfPresent: [ :aMethod :aTestClass | 
			self 
				runTest: aMethod 
				inClass: aTestClass
				fromReference: testReference ]
		ifMissing: [ :anErrorResult | anErrorResult ]
]

{ #category : #'private - execution' }
GtLToolForTestMethodRun >> runTest: aMethod inClass: aTestClass fromReference: testReference [
	| testCase testCaseWithResult |
	
	testCase := aTestClass selector: aMethod selector.
	[ testCaseWithResult := testCase gtRunWithExplicitResult ]
		on: Error
		do: [ :ex |
			^ GtLExceptionDomainObject new
				freeze: ex;
				errorReason: ('Running test {1} failed' 
					format: { testReference methodSignature }) ].
	
	^ GtLTestCaseWithResultDomainObject new
		testCaseWithResult: testCaseWithResult
]

{ #category : #'magritte description' }
GtLToolForTestMethodRun >> testReferenceDescription [
	<magritteDescription>
	
	^ MAToOneRelationDescription new
		accessor: #testReference;
		classes: {GtLTestReference};
		beRequired
]
