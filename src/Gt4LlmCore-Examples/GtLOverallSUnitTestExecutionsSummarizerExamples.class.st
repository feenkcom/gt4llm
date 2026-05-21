"
Examples for the overall SUnit test executions summarizer.
"
Class {
	#name : #GtLOverallSUnitTestExecutionsSummarizerExamples,
	#superclass : #GtLToolCallsSummarizerExamplesBase,
	#category : #'Gt4LlmCore-Examples-Summarizers'
}

{ #category : #examples }
GtLOverallSUnitTestExecutionsSummarizerExamples >> messagesGroupWithSUnitSummary [
	<gtExample>
	| group statuses wrapped toolCall |
	group := GtLMessagesGroup new.
	statuses := GtLTestCasesWithResultStatuses new
		testCases: {
			(GtLTestCasesWithResultStatusesDomainObjectExamples new
				createTestStatusFor: (GtLExampleDummyPassingTest >> #testSuccess)).
			(GtLTestCasesWithResultStatusesDomainObjectExamples new
				createTestStatusFor: (GtLExampleDummyMixedTest >> #testFailure)).
			(GtLTestCasesWithResultStatusesDomainObjectExamples new
				createTestStatusFor: (GtLExampleDummyMixedTest >> #testError)).
			(GtLTestCasesWithResultStatusesDomainObjectExamples new
				createTestStatusFor: (GtLExampleDummyMixedTest >> #testSkip)) };
		notFoundClassNames: #();
		notTestCaseClasses: #().
	wrapped := GtLWrappedObjectModel new
		name: 'tests';
		model: statuses;
		yourself.
	toolCall := self
		toolCallNamed: 'testsInClassesRun'
		arguments: (Dictionary new
			at: 'classNames' put: 'GtLExampleDummyPassingTest GtLExampleDummyMixedTest';
			yourself).
	toolCall result: wrapped.
	group add: (self toolMessageFrom: toolCall).
	self assert: (group toolCallsSummarizers anySatisfy: [ :each |
		each class = GtLOverallSUnitTestExecutionsSummarizer ]).
	^ group
]

{ #category : #examples }
GtLOverallSUnitTestExecutionsSummarizerExamples >> overallSUnitExecutionsSummarizer [
	<gtExample>
	<return: #GtLOverallSUnitTestExecutionsSummarizer>
	| group summarizer |
	group := self messagesGroupWithSUnitSummary.
	summarizer := group toolCallsSummarizers
		detect: [ :each | each class = GtLOverallSUnitTestExecutionsSummarizer ].
	self assert: summarizer numberOfTests > 0.
	self assert: summarizer totalRuns > 0.
	^ summarizer
]

{ #category : #private }
GtLOverallSUnitTestExecutionsSummarizerExamples >> performTool: aTool withArguments: aDictionary [
	| toolCall |
	toolCall := GtLFunctionToolCall new
		name: aTool name;
		rawArguments: aDictionary;
		yourself.
	aTool performToolCall: toolCall.
	^ toolCall
]

{ #category : #private }
GtLOverallSUnitTestExecutionsSummarizerExamples >> toolMessageFrom: aToolCall [
	^ GtLToolMessage new
		toolCall: aToolCall;
		output: aToolCall result;
		yourself
]
