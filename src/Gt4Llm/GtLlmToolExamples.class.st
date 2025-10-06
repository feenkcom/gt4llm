Class {
	#name : #GtLlmToolExamples,
	#superclass : #Object,
	#category : #'Gt4Llm-Examples'
}

{ #category : #'as yet unclassified' }
GtLlmToolExamples >> calledTool [
	<gtExample>
	| tool call |
	tool := self functionTool.
	call := self toolCall.


	self
		assert: (tool performToolCall: call)
		equals: call.

	^ tool
]

{ #category : #'as yet unclassified' }
GtLlmToolExamples >> functionTool [
	<gtExample>
	| tool |
	tool := self simpleFunctionTool
			name: 'example';
			description: 'Takes two arguments and passes them back unharmed.';
			parameters: {'first'.
					'second'};
			block: [:functionCall | functionCall ].

	^ tool
]

{ #category : #'as yet unclassified' }
GtLlmToolExamples >> simpleFileSearchTool [
	<gtExample>
	^ GtLlmFileSearchTool new
]

{ #category : #'as yet unclassified' }
GtLlmToolExamples >> simpleFunctionTool [
	<gtExample>
	| tool |
	tool := GtLlmFunctionTool new.
	
	self assert: tool type equals: 'function'.
	
	^ tool
]

{ #category : #'as yet unclassified' }
GtLlmToolExamples >> simpleTool [
	<gtExample>
	^ GtLlmTool new
]

{ #category : #'as yet unclassified' }
GtLlmToolExamples >> simpleToolCall [
	<gtExample>
	^ GtLlmFunctionToolCall new
]

{ #category : #'as yet unclassified' }
GtLlmToolExamples >> toolCall [
	<gtExample>
	| call |
	call := self simpleToolCall
			function: {'name' -> 'example'.
					'arguments' -> '{"first": 1, "second": 2}'} asDictionary.

	self assert: call name equals: 'example'.
	self
		assert: call arguments
		equals: {'first' -> 1.
				'second' -> 2} asDictionary.

	^ call
]
