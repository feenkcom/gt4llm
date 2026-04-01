Class {
	#name : #GtLSmaCCToolForParserTestExamples,
	#superclass : #Object,
	#traits : 'TGtLInvalidInputDataAssertions',
	#classTraits : 'TGtLInvalidInputDataAssertions classTrait',
	#category : #'Gt4Llm-SmaCC-Examples'
}

{ #category : #examples }
GtLSmaCCToolForParserTestExamples >> failJSParser [
	<gtExample>
	| tool call result domainObject |
	tool := GtLSmaCCToolForParserTest new model: GtLSmaCCModel new.
	call := GtLFunctionToolCall new.
	call
		rawArguments: {'testParse'
					-> {'parserClass' -> 'JSParser'.
							'example' -> 'console.log("testing\n'.
							'startingState' -> '' } asDictionary} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	self assert: call arguments size equals: 1.
	domainObject := result targetObject.
	self assert: domainObject isErrorDomainObject.
	
	self assert: (domainObject isKindOf: GtLProblemDomainObject).
	self assert: domainObject errorMessage equals: 'An error occurred during parsing near line: 1, column: 14'.
	
	^ call
]

{ #category : #examples }
GtLSmaCCToolForParserTestExamples >> testForMissingTestParseArgument [
	<gtExample>
	| tool call result domainObject |
	tool := GtLSmaCCToolForParserTest new model: GtLSmaCCModel new.
	call := GtLFunctionToolCall new.
	call rawArguments: {} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	domainObject := result targetObject.
	self 
		assertMissingRequiredProperties: domainObject 
		withPropertyNames: #('testParse') 
		path: {nil} 
		errorMessage: 'required properties missing [testParse]'.
	^ call
]

{ #category : #examples }
GtLSmaCCToolForParserTestExamples >> testJSParser [
	<gtExample>
	| tool call result domainObject |
	tool := GtLSmaCCToolForParserTest new model: GtLSmaCCModel new.
	call := GtLFunctionToolCall new.
	call
		rawArguments: {'testParse'
					-> {'parserClass' -> 'JSParser'.
							'example' -> 'console.log("testing\n");'.
							'startingState' -> '' } asDictionary} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	self assert: call arguments size equals: 1.
	self assert: (call arguments anyOne isKindOf: GtLSmaCCParserTest).
	domainObject := result targetObject.
	self assert: domainObject class equals: GtLSmaCCSuccess.
	^ domainObject
]
