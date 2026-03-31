Class {
	#name : #GtLExampleRunDummyExamples,
	#superclass : #Object,
	#category : 'Gt4LlmCore-Examples-Tools'
}

{ #category : #'llm-generated' }
GtLExampleRunDummyExamples >> errorExample [
	<gtExample>
	<noTest>
	self error: 'Intentional example error'.
]

{ #category : #'llm-generated' }
GtLExampleRunDummyExamples >> failingExample [
	<gtExample>
	<noTest>
	self assert: false.
]

{ #category : #'llm-generated' }
GtLExampleRunDummyExamples >> failingExampleWithComparisonFailures [
	<gtExample>
	<noTest>
	 
		(GtLExampleDataComparisonException new
			expectedData: (GtLExampleComparisonWrappedString new
				targetString: GtExampleComparisonExceptionWithDebuggingViews new expectedStringForTest);
			actualData: (GtLExampleComparisonWrappedString new
				targetString: GtExampleComparisonExceptionWithDebuggingViews new computedStringForTest)) signal
	
]

{ #category : #'llm-generated' }
GtLExampleRunDummyExamples >> regularMethod [
	^ 7
]

{ #category : #'llm-generated' }
GtLExampleRunDummyExamples >> successfulExample [
	<gtExample>
	<noTest>
	^ 42
]

{ #category : #'llm-generated' }
GtLExampleRunDummyExamples >> successfulExampleWithObjectWithADataJsonView [
	<gtExample>
	<noTest>
	^ GtLObjectWithADataJsonViewForTest new
]
