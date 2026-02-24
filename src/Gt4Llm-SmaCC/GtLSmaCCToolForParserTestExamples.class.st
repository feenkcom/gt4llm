Class {
	#name : #GtLSmaCCToolForParserTestExamples,
	#superclass : #Object,
	#category : 'Gt4Llm-SmaCC-Examples'
}

{ #category : #examples }
GtLSmaCCToolForParserTestExamples >> failJSParser [
	<gtExample>
	| tool call result |
	tool := GtLSmaCCToolForParserTest new model: GtLSmaCCModel new.
	call := GtLFunctionToolCall new.
	call
		rawArguments: {'testParse'
					-> {'parserClass' -> 'JSParser'.
							'example' -> 'console.log("testing\n'} asDictionary} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GtLMagritteInputModel).
	self assert: call arguments size equals: 1.
	self assert: (call arguments anyOne isKindOf: GtLSmaCCParserTest).
	self assert: result model isErrorDomainObject.
	^ call
]

{ #category : #examples }
GtLSmaCCToolForParserTestExamples >> testJSParser [
	<gtExample>
	| tool call result |
	tool := GtLSmaCCToolForParserTest new model: GtLSmaCCModel new.
	call := GtLFunctionToolCall new.
	call
		rawArguments: {'testParse'
					-> {'parserClass' -> 'JSParser'.
							'example' -> 'console.log("testing\n");'} asDictionary} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GtLMagritteInputModel).
	self assert: call arguments size equals: 1.
	self assert: (call arguments anyOne isKindOf: GtLSmaCCParserTest).
	self assert: result model class equals: GtLSmaCCSuccess.
	^ call
]
