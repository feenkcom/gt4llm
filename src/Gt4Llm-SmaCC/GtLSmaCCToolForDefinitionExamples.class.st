Class {
	#name : #GtLSmaCCToolForDefinitionExamples,
	#superclass : #GtLAbstractMagritteFunctionToolExamples,
	#traits : 'TGtLInvalidInputDataAssertions',
	#classTraits : 'TGtLInvalidInputDataAssertions classTrait',
	#category : 'Gt4Llm-SmaCC-Examples'
}

{ #category : #examples }
GtLSmaCCToolForDefinitionExamples >> definitionForMissingParser [
	<gtExample>
	| tool call targetObject |
	tool := GtLSmaCCToolForDefinition new model: GtLSmaCCModel new.
	call := self
		executeTool: tool
		withArguments: {'parserDefinition' -> {'parserClass' -> 'AsdfParser'} asDictionary} asDictionary.
	targetObject := call result targetObject.
	self assert: targetObject isErrorDomainObject.
	^ call
]

{ #category : #examples }
GtLSmaCCToolForDefinitionExamples >> definitionForMissingParserArgument [
	<gtExample>
	| tool call |
	tool := GtLSmaCCToolForDefinition new model: GtLSmaCCModel new.
	call := self
		executeTool: tool
		withArguments: {} asDictionary.
	self
		assertMissingRequiredProperties: call result targetObject
		withPropertyNames: #('parserDefinition')
		path: {nil}
		errorMessage: 'required properties missing [parserDefinition]'.
	^ call
]

{ #category : #examples }
GtLSmaCCToolForDefinitionExamples >> definitionForNilArguments [
	<gtExample>
	| tool call |
	tool := GtLSmaCCToolForDefinition new model: GtLSmaCCModel new.
	call := self
		executeTool: tool
		withArguments: nil.
	self
		assertJSONSchemaValidationError: call result targetObject
		withPath: {nil}
		errorMessage: 'object expected'.
	^ call
]

{ #category : #examples }
GtLSmaCCToolForDefinitionExamples >> definitionForParser [
	<gtExample>
	| tool call targetObject |
	tool := GtLSmaCCToolForDefinition new model: GtLSmaCCModel new.
	call := self
		executeTool: tool
		withArguments: {'parserDefinition' -> {'parserClass' -> 'JSParser'} asDictionary} asDictionary.
	targetObject := call result targetObject.
	self assert: targetObject parserClass equals: 'JSParser'.
	self assert: targetObject scannerClass equals: 'JSScanner'.
	self assert: targetObject package equals: 'SmaCC_Javascript_Parser'.
	self assert: targetObject definition equals: #JSParser asClass parserDefinitionString.
	^ call
]
