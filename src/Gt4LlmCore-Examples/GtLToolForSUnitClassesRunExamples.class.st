Class {
	#name : #GtLToolForSUnitClassesRunExamples,
	#superclass : #Object,
	#category : #'Gt4LlmCore-Examples-Tools'
}

{ #category : #'llm-generated' }
GtLToolForSUnitClassesRunExamples >> runTestsForMultipleClasses [
	<gtExample>
	| tool call result data |
	tool := GtLToolForSUnitClassesRun new.
	call := GtLFunctionToolCall new.
	call function: {
		'name' -> tool name.
		'arguments' -> {
			'classNames' -> 'GtLExampleDummyPassingTest GtLExampleDummyMixedTest' } asDictionary } asDictionary.
	result := tool performToolCall: call.
	data := NeoJSONReader fromString: result.
	self assert: (data at: 'runCount') equals: 5.
	self assert: (data at: 'successes') equals: 3.
	self assert: (data at: 'failures') equals: 1.
	self assert: (data at: 'errors') equals: 1.
	self assert: (data at: 'skips') equals: 1.
	self assert: (data at: 'expectedDefects') equals: 1.
	^ data
]

{ #category : #'llm-generated' }
GtLToolForSUnitClassesRunExamples >> runTestsForSingleClass [
	<gtExample>
	| tool call result data detail |
	tool := GtLToolForSUnitClassesRun new.
	call := GtLFunctionToolCall new.
	call function: {
		'name' -> tool name.
		'arguments' -> {
			'classNames' -> 'GtLlmExampleDummyPassingTest' } asDictionary } asDictionary.
	result := tool performToolCall: call.
	data := NeoJSONReader fromString: result.
	self assert: (data at: 'runCount') equals: 1.
	self assert: (data at: 'successes') equals: 1.
	detail := (data at: 'details') first.
	self assert: (detail at: 'status') equals: 'success'.
	^ data
]

{ #category : #'llm-generated' }
GtLToolForSUnitClassesRunExamples >> runTestsWithUnknownInputs [
	<gtExample>
	| tool call result data |
	tool := GtLToolForSUnitClassesRun new.
	call := GtLFunctionToolCall new.
	call function: {
		'name' -> tool name.
		'arguments' -> {
			'classNames' -> 'NonExistingSUnitClass Object' } asDictionary } asDictionary.
	result := tool performToolCall: call.
	data := NeoJSONReader fromString: result.
	self assert: (data at: 'runCount') equals: 0.
	self assert: ((data at: 'notFound') size) equals: 2.
	^ data
]
