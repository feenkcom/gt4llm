Class {
	#name : #GtLToolForExampleClassesRunExamples,
	#superclass : #Object,
	#category : #'Gt4LlmCore-Examples-Tools'
}

{ #category : #'llm-generated' }
GtLToolForExampleClassesRunExamples >> runExamplesForClass [
	<gtExample>
	| tool call result data |
	tool := GtLToolForExampleClassesRun new.
	call := GtLFunctionToolCall new.
	call
		function: {'name' -> tool name.
				'arguments' -> {'classNames' -> 'GtLlmExampleRunDummyExamples'} asDictionary}
				asDictionary.
	result := tool performToolCall: call.
	self assert: result isErrorDomainObject not.

	self assert: result totalCount equals: 3.
	self assert: result skippedCount equals: 3.
	self assert: result exampleWithResults size equals: 3.
	^ call
]

{ #category : #'llm-generated' }
GtLToolForExampleClassesRunExamples >> runExamplesForMultipleClasses [
	<gtExample>
	| tool call result data |
	tool := GtLToolForExampleClassesRun new.
	call := GtLFunctionToolCall new.
	call
		function: {'name' -> tool name.
				'arguments'
					-> {'classNames' -> 'GtLExampleRunDummyExamples GtLToolForExampleMethodRunExamples'}
							asDictionary} asDictionary.
	result := tool performToolCall: call.

	self assert: result isErrorDomainObject not.
	self assert: result totalCount equals: 7.
	self assert: result skippedCount equals: 3.
	self assert: result exampleWithResults size equals: 7.
	^ call
]

{ #category : #'llm-generated' }
GtLToolForExampleClassesRunExamples >> runExamplesWithUnknownInputs [
	<gtExample>
	| tool call result |
	tool := GtLToolForExampleClassesRun new.
	call := GtLFunctionToolCall new.
	call
		function: {'name' -> tool name.
				'arguments' -> {'classNames' -> 'NonExistingExampleClass'} asDictionary}
				asDictionary.
	result := tool performToolCall: call.

	self assert: result isErrorDomainObject not.
	self assert: result totalCount equals: 0.
	self assert: result skippedCount equals: 0.
	self assert: result exampleWithResults size equals: 0.
	self assert: result notFoundClassNames size equals: 1.
	self assert: result notFoundClassNames anyOne equals: 'NonExistingExampleClass'.
	^ call
]
