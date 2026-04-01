Class {
	#name : #GtLSmaCCToolForDefinitionExamples,
	#superclass : #Object,
	#traits : 'TGtLInvalidInputDataAssertions',
	#classTraits : 'TGtLInvalidInputDataAssertions classTrait',
	#category : #'Gt4Llm-SmaCC-Examples'
}

{ #category : #examples }
GtLSmaCCToolForDefinitionExamples >> definitionForMissingParser [
	<gtExample>
	| tool call result domainObject |
	tool := GtLSmaCCToolForDefinition new model: GtLSmaCCModel new.
	call := GtLFunctionToolCall new.
	call
		rawArguments: {'parserDefinition' -> {'parserClass' -> 'AsdfParser'} asDictionary} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	self assert: call arguments size equals: 1.
	self assert: (call arguments anyOne isKindOf: GtLSmaCCParserReference).
	domainObject := result targetObject.
	self assert: domainObject isErrorDomainObject.
	^ call
]

{ #category : #examples }
GtLSmaCCToolForDefinitionExamples >> definitionForMissingParserArgument [
	<gtExample>
	| tool call result domainObject |
	tool := GtLSmaCCToolForDefinition new model: GtLSmaCCModel new.
	call := GtLFunctionToolCall new.
	call rawArguments: {} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	domainObject := result targetObject.
	self 
		assertMissingRequiredProperties: domainObject 
		withPropertyNames: #('parserDefinition') 
		path: {nil} 
		errorMessage: 'required properties missing [parserDefinition]'.
	^ call
]

{ #category : #examples }
GtLSmaCCToolForDefinitionExamples >> definitionForNilArguments [
	<gtExample>
	| tool call result domainObject |
	tool := GtLSmaCCToolForDefinition new model: GtLSmaCCModel new.
	call := GtLFunctionToolCall new.
	call rawArguments: nil.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	domainObject := result targetObject.
	self 
		assertJSONSchemaValidationError: domainObject 
		withPath: {nil} 
		errorMessage: 'object expected'.
	^ call
]

{ #category : #examples }
GtLSmaCCToolForDefinitionExamples >> definitionForParser [
	<gtExample>
	| tool call result domainObject |
	tool := GtLSmaCCToolForDefinition new model: GtLSmaCCModel new.
	call := GtLFunctionToolCall new.
	call
		rawArguments: {'parserDefinition' -> {'parserClass' -> 'JSParser'} asDictionary} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	self assert: call arguments size equals: 1.
	self assert: (call arguments anyOne isKindOf: GtLSmaCCParserReference).
	domainObject := result targetObject.
	self assert: domainObject parserClass equals: 'JSParser'.
	self assert: domainObject scannerClass equals: 'JSScanner'.
	self assert: domainObject package equals: 'SmaCC_Javascript_Parser'.
	self assert: domainObject definition equals: #JSParser asClass parserDefinitionString.
	^ domainObject
]
