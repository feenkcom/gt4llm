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
	call function: {
		'name' -> tool name.
		'arguments' -> {
			'classNames' -> 'GtLlmExampleRunDummyExamples'
		} asDictionary
	} asDictionary.
	result := tool performToolCall: call.
	data := NeoJSONReader fromString: result.
	self assert: (data at: 'total') equals: 3.
	self assert: (data at: 'skips') equals: 3.
	self assert: ((data at: 'details') size) equals: 3.
	^ tool
]

{ #category : #'llm-generated' }
GtLToolForExampleClassesRunExamples >> runExamplesForMultipleClasses [
	<gtExample>
	| tool call result data |
	tool := GtLToolForExampleClassesRun new.
	call := GtLFunctionToolCall new.
	call function: {
		'name' -> tool name.
		'arguments' -> {
			'classNames' -> 'GtLExampleRunDummyExamples GtLToolForExampleMethodRunExamples'
		} asDictionary
	} asDictionary.
	result := tool performToolCall: call.
	data := NeoJSONReader fromString: result.
	self assert: (data at: 'total') equals: 7.
	self assert: (data at: 'skips') equals: 3.
	self assert: ((data at: 'details') size) equals: 7.
	^ tool
]

{ #category : #'llm-generated' }
GtLToolForExampleClassesRunExamples >> runExamplesWithUnknownInputs [
	<gtExample>
	| tool call result data |
	tool := GtLToolForExampleClassesRun new.
	call := GtLFunctionToolCall new.
	call function: {
		'name' -> tool name.
		'arguments' -> {
			'classNames' -> 'NonExistingExampleClass'
		} asDictionary
	} asDictionary.
	result := tool performToolCall: call.
	data := NeoJSONReader fromString: result.
	self assert: (data at: 'total') equals: 0.
	self assert: (data at: 'notFound') notEmpty.
	^ data
]
