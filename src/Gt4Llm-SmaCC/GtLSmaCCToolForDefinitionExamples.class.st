Class {
	#name : #GtLSmaCCToolForDefinitionExamples,
	#superclass : #Object,
	#category : #'Gt4Llm-SmaCC-Examples'
}

{ #category : #examples }
GtLSmaCCToolForDefinitionExamples >> definitionForMissingParser [
	<gtExample>
	| tool call result model |
	tool := GtLSmaCCToolForDefinition new model: GtLSmaCCModel new.
	call := GtLFunctionToolCall new.
	call
		rawArguments: {'parserDefinition' -> {'parserClass' -> 'AsdfParser'} asDictionary} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GtLMagritteInputModel).
	self assert: call arguments size equals: 1.
	self assert: (call arguments anyOne isKindOf: GtLSmaCCParserReference).
	model := result model.
	self assert: model isErrorDomainObject.
	^ call
]

{ #category : #examples }
GtLSmaCCToolForDefinitionExamples >> definitionForParser [
	<gtExample>
	| tool call result model |
	tool := GtLSmaCCToolForDefinition new model: GtLSmaCCModel new.
	call := GtLFunctionToolCall new.
	call
		rawArguments: {'parserDefinition' -> {'parserClass' -> 'JSParser'} asDictionary} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GtLMagritteInputModel).
	self assert: call arguments size equals: 1.
	self assert: (call arguments anyOne isKindOf: GtLSmaCCParserReference).
	model := result model.
	self assert: model parserClass equals: 'JSParser'.
	self assert: model scannerClass equals: 'JSScanner'.
	self assert: model definition equals: #JSParser asClass parserDefinitionString.
	^ call
]
