Class {
	#name : #GtLExampleDummyMixedTest,
	#superclass : #TestCase,
	#category : #'Gt4LlmCore-Examples-Tools'
}

{ #category : #tests }
GtLExampleDummyMixedTest >> testComparisonFailure [
	(GtLExampleDataComparisonException new
		expectedData: (GtLExampleComparisonWrappedString new
			targetString: GtExampleComparisonExceptionWithDebuggingViews new expectedStringForTest);
		actualData: (GtLExampleComparisonWrappedString new
			targetString: GtExampleComparisonExceptionWithDebuggingViews new computedStringForTest)) signal
]

{ #category : #'llm-generated' }
GtLExampleDummyMixedTest >> testError [
	self error: 'Boom'
]

{ #category : #'llm-generated' }
GtLExampleDummyMixedTest >> testExpectedFailure [
	<expectedFailure>
	self assert: false
]

{ #category : #'llm-generated' }
GtLExampleDummyMixedTest >> testFailure [
	self assert: false
]

{ #category : #'llm-generated' }
GtLExampleDummyMixedTest >> testPass [
	self assert: true
]

{ #category : #'llm-generated' }
GtLExampleDummyMixedTest >> testSkip [
	self skip: 'Not today'
]
