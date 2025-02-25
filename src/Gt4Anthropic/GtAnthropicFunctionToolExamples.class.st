Class {
	#name : #GtAnthropicFunctionToolExamples,
	#superclass : #Object,
	#category : #'Gt4Anthropic-Examples'
}

{ #category : #'as yet unclassified' }
GtAnthropicFunctionToolExamples >> anthropicFunctionToolFormat [
	<gtExample>
	| functionTool |
	functionTool := GtLlmToolExamples new functionTool.

	self assert: (functionTool functionAnthropic includesKey: 'input_schema').

	^ functionTool
]
