Class {
	#name : #GtLSmaCCToolForParserCreationExamples,
	#superclass : #GtLAbstractMagritteFunctionToolExamples,
	#traits : 'TGtLInvalidInputDataAssertions',
	#classTraits : 'TGtLInvalidInputDataAssertions classTrait',
	#category : 'Gt4Llm-SmaCC-Examples'
}

{ #category : #examples }
GtLSmaCCToolForParserCreationExamples >> createOverExisting [
	<gtExample>
	| model tool call targetObject definition grammar |
	model := GtLSmaCCModel new.
	model grammarFor: #GtPharoParser.
	tool := GtLSmaCCToolForParserCreation new model: model.
	definition := '<number>: \\d+;
Foo: <number>+;'.
	call := self
		executeTool: tool
		withArguments: {'parserCreation'
			-> {'parserClass' -> 'GtPharoParser'.
				'scannerClass' -> 'GtPharoScanner'.
				'package' -> 'TestPackage'.
				'definition' -> definition} asDictionary} asDictionary.
	targetObject := call result targetObject.
	self assert: (targetObject isKindOf: GtLSmaCCParserCreationResult).
	self assert: targetObject parserClass equals: #GtPharoParser.
	self assert: targetObject createGrammar source equals: definition.
	grammar := model grammarFor: #GtPharoParser.
	self assert: grammar source equals: definition.
	self assert: grammar parserClassName equals: #GtPharoParser.
	self assert: grammar scannerClassName equals: #GtPharoScanner.
	self assert: grammar package equals: 'TestPackage'.
	^ grammar
]

{ #category : #examples }
GtLSmaCCToolForParserCreationExamples >> createParser [
	<gtExample>
	| model tool call targetObject definition |
	model := GtLSmaCCModel new.
	tool := GtLSmaCCToolForParserCreation new model: model.
	definition := '<number>: \\d+;
Foo: <number>+;'.
	call := self
		executeTool: tool
		withArguments: {'parserCreation'
			-> {'parserClass' -> 'ExpParser'.
				'scannerClass' -> 'ExpScanner'.
				'package' -> 'TestPackage'.
				'definition' -> definition} asDictionary} asDictionary.
	targetObject := call result targetObject.
	self assert: (targetObject isKindOf: GtLSmaCCParserCreationResult).
	self assert: targetObject parserClass equals: #ExpParser.
	self assert: targetObject createGrammar source equals: definition.
	self assert: (model grammarFor: #ExpParser) source equals: definition.
	self assert: (model grammarFor: #ExpParser) parserClassName equals: #ExpParser.
	self assert: (model grammarFor: #ExpParser) scannerClassName equals: #ExpScanner.
	self assert: (model grammarFor: #ExpParser) package equals: 'TestPackage'.
	^ call
]

{ #category : #examples }
GtLSmaCCToolForParserCreationExamples >> creationForMissingParserCreationArgument [
	<gtExample>
	| model tool call |
	model := GtLSmaCCModel new.
	tool := GtLSmaCCToolForParserCreation new model: model.
	call := self
		executeTool: tool
		withArguments: {} asDictionary.
	self
		assertMissingRequiredProperties: call result targetObject
		withPropertyNames: #('parserCreation')
		path: {nil}
		errorMessage: 'required properties missing [parserCreation]'.
	^ call
]

{ #category : #examples }
GtLSmaCCToolForParserCreationExamples >> invalidClassName [
	<gtExample>
	| model tool call targetObject |
	model := GtLSmaCCModel new.
	tool := GtLSmaCCToolForParserCreation new model: model.
	call := self
		executeTool: tool
		withArguments: {'parserCreation'
			-> {'parserClass' -> 'Exp Parser'.
				'scannerClass' -> 'ExpScanner'.
				'package' -> 'TestPackage'.
				'definition' -> '<number>: \d+;
Foo: <number>;'} asDictionary} asDictionary.
	targetObject := call result targetObject.
	self assert: targetObject isErrorDomainObject.
	^ call
]

{ #category : #examples }
GtLSmaCCToolForParserCreationExamples >> invalidDefinition [
	<gtExample>
	| model tool call targetObject |
	model := GtLSmaCCModel new.
	tool := GtLSmaCCToolForParserCreation new model: model.
	call := self
		executeTool: tool
		withArguments: {'parserCreation'
			-> {'parserClass' -> 'ExpParser'.
				'scannerClass' -> 'ExpScanner'.
				'package' -> 'TestPackage'.
				'definition' -> '<number>: \d+;
Foo: <number> #missing ;'} asDictionary} asDictionary.
	targetObject := call result targetObject.
	self assert: targetObject isErrorDomainObject.
	^ call
]
