Class {
	#name : #GtLlmToolForExampleClassesRunExamples,
	#superclass : #Object,
	#category : #'Gt4Llm-Examples'
}

{ #category : #'llm-generated' }
GtLlmToolForExampleClassesRunExamples >> runExamplesForClass [
	<gtExample>
	<noTest>
	| tool call result data |
	tool := GtLlmToolForExampleClassesRun new.
	call := GtLlmFunctionToolCall new.
	call function: {
		'name' -> tool name.
		'arguments' -> {
			'classNames' -> #('GtLlmExampleRunDummyExamples')
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
GtLlmToolForExampleClassesRunExamples >> runExamplesForMethod [
	"<gtExample>"
	| tool call result data detail |
	tool := GtLlmToolForExampleClassesRun new.
	call := GtLlmFunctionToolCall new.
	call function: {
		'name' -> tool name.
		'arguments' -> {
			'methods' -> { {
				'className' -> 'GtLlmToolForExampleMethodRunExamples'.
				'methodName' -> 'exampleRunSuccess'
			} asDictionary }
		} asDictionary
	} asDictionary.
	result := tool performToolCall: call.
	data := NeoJSONReader fromString: result.
	self assert: (data at: 'successes') equals: 1.
	self assert: (data at: 'failures') equals: 0.
	detail := (data at: 'details') first.
	self assert: (detail at: 'status') equals: 'success'.
	^ data
]

{ #category : #'llm-generated' }
GtLlmToolForExampleClassesRunExamples >> runExamplesWithUnknownInputs [
	<gtExample>
	| tool call result data |
	tool := GtLlmToolForExampleClassesRun new.
	call := GtLlmFunctionToolCall new.
	call function: {
		'name' -> tool name.
		'arguments' -> {
			'classNames' -> #('NonExistingExampleClass')
		} asDictionary
	} asDictionary.
	result := tool performToolCall: call.
	data := NeoJSONReader fromString: result.
	self assert: (data at: 'total') equals: 0.
	self assert: (data at: 'notFound') notEmpty.
	^ data
]
