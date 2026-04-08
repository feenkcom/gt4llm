Class {
	#name : #GtLSmaCCToolForParserTestExamples,
	#superclass : #GtLAbstractMagritteFunctionToolExamples,
	#traits : 'TGtLInvalidInputDataAssertions',
	#classTraits : 'TGtLInvalidInputDataAssertions classTrait',
	#category : #'Gt4Llm-SmaCC-Examples'
}

{ #category : #examples }
GtLSmaCCToolForParserTestExamples >> failJSParser [
	<gtExample>
	| tool call targetObject |
	tool := GtLSmaCCToolForParserTest new model: GtLSmaCCModel new.
	call := self
		executeTool: tool
		withArguments: {'testParse'
			-> {'parserClass' -> 'JSParser'.
				'example' -> 'console.log("testing\n'.
				'startingState' -> ''} asDictionary} asDictionary.
	targetObject := call result targetObject.
	self assert: targetObject isErrorDomainObject.
	self assert: (targetObject isKindOf: GtLProblemDomainObject).
	self assert: targetObject errorMessage equals: 'An error occurred during parsing near line: 1, column: 14'.
	^ call
]

{ #category : #examples }
GtLSmaCCToolForParserTestExamples >> testForMissingTestParseArgument [
	<gtExample>
	| tool call |
	tool := GtLSmaCCToolForParserTest new model: GtLSmaCCModel new.
	call := self
		executeTool: tool
		withArguments: {} asDictionary.
	self
		assertMissingRequiredProperties: call result targetObject
		withPropertyNames: #('testParse')
		path: {nil}
		errorMessage: 'required properties missing [testParse]'.
	^ call
]

{ #category : #examples }
GtLSmaCCToolForParserTestExamples >> testJSParser [
	<gtExample>
	| tool call targetObject |
	tool := GtLSmaCCToolForParserTest new model: GtLSmaCCModel new.
	call := self
		executeTool: tool
		withArguments: {'testParse'
			-> {'parserClass' -> 'JSParser'.
				'example' -> 'console.log("testing\n");'.
				'startingState' -> ''} asDictionary} asDictionary.
	targetObject := call result targetObject.
	self assert: targetObject class equals: GtLSmaCCSuccess.
	^ call
]
