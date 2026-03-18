Class {
	#name : #GtLToolForTestClassesRunExamples,
	#superclass : #Object,
	#category : #'Gt4LlmCore-Examples-Tools'
}

{ #category : #'llm-generated' }
GtLToolForTestClassesRunExamples >> runTestsForMultipleClasses [
	<gtExample>
	| tool call result |
	tool := GtLToolForTestClassesRun new.
	call := GtLFunctionToolCall new.
	call
		function: {'name' -> tool name.
				'arguments'
					-> {'classNames' -> 'GtLExampleDummyPassingTest GtLExampleDummyMixedTest'}
							asDictionary} asDictionary.
	result := tool performToolCall: call.
	
	self assert: result isErrorDomainObject not.
	self assert: result runCount equals: 5.
	self assert: result passedCount equals: 3.
	self assert: result failureCount equals: 1.
	self assert: result errorCount equals: 1.
	self assert: result skippedCount equals: 1.
	self assert: result expectedDefectCount equals: 1.
	^ call
]

{ #category : #'llm-generated' }
GtLToolForTestClassesRunExamples >> runTestsForSingleClass [
	<gtExample>
	| tool call result data detail |
	tool := GtLToolForTestClassesRun new.
	call := GtLFunctionToolCall new.
	call
		function: {'name' -> tool name.
				'arguments' -> {'classNames' -> 'GtLlmExampleDummyPassingTest'} asDictionary}
				asDictionary.
	result := tool performToolCall: call.

	self assert: result isErrorDomainObject not.
	self assert: result runCount equals: 1.
	self assert: result passedCount equals: 1.
	self assert: result testCases size equals: 1.
	detail := result testCases anyOne.
	self assert: detail statusText equals: 'success'.
	^ call
]

{ #category : #'llm-generated' }
GtLToolForTestClassesRunExamples >> runTestsWithUnknownInputs [
	<gtExample>
	| tool call result data |
	tool := GtLToolForTestClassesRun new.
	call := GtLFunctionToolCall new.
	call
		function: {'name' -> tool name.
				'arguments' -> {'classNames' -> 'NonExistingSUnitClass Object'} asDictionary}
				asDictionary.
	result := tool performToolCall: call.

	self assert: result isErrorDomainObject not.
	self assert: result runCount equals: 0.
	self assert: result testCases size equals: 0.
	self assert: result notFoundClassNames size equals: 1.
	self assert: result notFoundClassNames anyOne equals: 'NonExistingSUnitClass'.
	self assert: result notTestCaseClasses size equals: 1.
	self assert: result notTestCaseClasses anyOne equals: Object.
	^ call
]
