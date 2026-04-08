Class {
	#name : #GtLSmaCCToolForParserCompilationExamples,
	#superclass : #GtLAbstractMagritteFunctionToolExamples,
	#traits : 'TGtLInvalidInputDataAssertions',
	#classTraits : 'TGtLInvalidInputDataAssertions classTrait',
	#category : #'Gt4Llm-SmaCC-Examples'
}

{ #category : #private }
GtLSmaCCToolForParserCompilationExamples >> cleanUp [
	#(TemporaryExpressionParser TemporaryExpressionScanner)
		do: [ :each | Smalltalk globals at: each ifPresent: [ :cls | cls removeFromSystem ] ]
]

{ #category : #examples }
GtLSmaCCToolForParserCompilationExamples >> compilationForMissingCompileParserArgument [
	<gtExample>
	| model tool call |
	model := self expressionParserModel.
	tool := GtLSmaCCToolForParserCompilation new model: model.
	call := self
		executeTool: tool
		withArguments: {} asDictionary.
	self
		assertMissingRequiredProperties: call result targetObject
		withPropertyNames: #('compileParser')
		path: {nil}
		errorMessage: 'required properties missing [compileParser]'.
	^ call
]

{ #category : #examples }
GtLSmaCCToolForParserCompilationExamples >> compile [
	<gtExample>
	<after: #cleanUp>
	| model tool call targetObject |
	model := self expressionParserModel.
	tool := GtLSmaCCToolForParserCompilation new model: model.
	call := self
		executeTool: tool
		withArguments: {'compileParser' -> {'parserClass' -> 'TemporaryExpressionParser'} asDictionary} asDictionary.
	targetObject := call result targetObject.
	self assert: (targetObject isKindOf: GtLSmaCCParserReference).
	self assert: targetObject parserClass equals: #TemporaryExpressionParser.
	self assert: (Smalltalk globals includesKey: #TemporaryExpressionParser).
	self assert: (Smalltalk globals includesKey: #TemporaryExpressionScanner).
	^ call
]

{ #category : #private }
GtLSmaCCToolForParserCompilationExamples >> expressionParserModel [
	| model |
	model := GtLSmaCCModel new.
	model
		defineParser: #TemporaryExpressionParser
		as: ((GtSmaCCGrammar
				forDefinition: '<number> : \d+;
Expression: Expression "+" <number>;')
				package: self class package name;
				parserClassName: #TemporaryExpressionParser;
				scannerClassName: #TemporaryExpressionScanner;
				yourself).
	^ model
]

{ #category : #examples }
GtLSmaCCToolForParserCompilationExamples >> invalidParserClass [
	<gtExample>
	| model tool call targetObject |
	model := self expressionParserModel.
	tool := GtLSmaCCToolForParserCompilation new model: model.
	call := self
		executeTool: tool
		withArguments: {'compileParser' -> {'parserClass' -> 'AbcParser'} asDictionary} asDictionary.
	targetObject := call result targetObject.
	self assert: targetObject isErrorDomainObject.
	^ call
]
