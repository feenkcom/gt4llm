Class {
	#name : #GtLlmToolExamples,
	#superclass : #Object,
	#traits : 'TGtExampleAssertable',
	#classTraits : 'TGtExampleAssertable classTrait',
	#category : #'Gt4Llm-Examples'
}

{ #category : #'as yet unclassified' }
GtLlmToolExamples >> calledTool [
	<gtExample>
	| tool call |
	tool := self functionTool.
	call := self toolCall.
	self assert: call isFinished not.
	self
		assert: (tool performToolCall: call)
		equals: call.
	self assert: call tool equals: tool.
	self assert: call isFinished.
	^ call
]

{ #category : #'as yet unclassified' }
GtLlmToolExamples >> calledToolWithWrongArguments [
	<gtExample>
	| tool call |
	tool := self functionTool.
	call := self simpleToolCall
			function: {'name' -> 'example'.
					'arguments' -> '{"aWrongParameter": 1, "anotherParameter": 2}'} asDictionary.
	self should: [(tool performToolCall: call)] raise: Error.
	^ call
]

{ #category : #'as yet unclassified' }
GtLlmToolExamples >> functionTool [
	<gtExample>
	| tool description name properties |
	description := 'Takes two arguments and passes them back unharmed.'.
	name := 'example'.
	tool := self simpleFunctionTool
			name: name;
			description: description;
			parameters: {'aParameter'.
					'anotherParameter'};
			block: [ :functionCall | functionCall ].
	self assert: (tool function at: 'name') equals: name.
	self assert: (tool function at: 'description') equals: description.
	self assert: (tool function at: 'strict') equals: true.
	properties := tool function at: 'parameters' at: 'properties'.
	self assert: properties size equals: 2.
	self assert: (properties includesKey: 'aParameter').
	self assert: (properties includesKey: 'anotherParameter').
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
	self assert: (tool function includesKey: 'strict').
	self assert: (tool function at: 'strict') equals: true.
	^ tool
]

{ #category : #'as yet unclassified' }
GtLlmToolExamples >> simpleToolCall [
	<gtExample>
	| call |
	call := GtLlmFunctionToolCall new.
	self assert: call tool isNil.
	^ call
]

{ #category : #'as yet unclassified' }
GtLlmToolExamples >> toolCall [
	<gtExample>
	| call |
	call := self simpleToolCall
			function: {'name' -> 'example'.
					'arguments' -> '{"aParameter": 1, "anotherParameter": 2}'} asDictionary.

	self assert: call name equals: 'example'.
	self
		assert: call arguments
		equals: {'aParameter' -> 1.
				'anotherParameter' -> 2} asDictionary.

	^ call
]
