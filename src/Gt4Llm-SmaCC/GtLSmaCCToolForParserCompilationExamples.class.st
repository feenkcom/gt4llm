Class {
	#name : #GtLSmaCCToolForParserCompilationExamples,
	#superclass : #Object,
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
	| model tool call result domainObject |
	model := self expressionParserModel.
	tool := GtLSmaCCToolForParserCompilation new model: model.
	call := GtLFunctionToolCall new.
	call rawArguments: {} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	domainObject := result targetObject.
	self 
		assertMissingRequiredProperties: domainObject 
		withPropertyNames: #('compileParser') 
		path: {nil} 
		errorMessage: 'required properties missing [compileParser]'.
	^ call
]

{ #category : #examples }
GtLSmaCCToolForParserCompilationExamples >> compile [
	<gtExample>
	<after: #cleanUp>
	| model tool call result domainObject |
	model := self expressionParserModel.
	tool := GtLSmaCCToolForParserCompilation new model: model.
	call := GtLFunctionToolCall new.
	call
		rawArguments: {'compileParser' -> {'parserClass' -> 'TemporaryExpressionParser'} asDictionary}
				asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	self assert: call arguments size equals: 1.
	self assert: (call arguments anyOne isKindOf: GtLSmaCCParserReference).
	domainObject := result targetObject.
	self assert: (domainObject isKindOf: GtLSmaCCParserReference).
	self assert: domainObject parserClass equals: #TemporaryExpressionParser.

	self assert: (Smalltalk globals includesKey: #TemporaryExpressionParser).
	self assert: (Smalltalk globals includesKey: #TemporaryExpressionScanner).
	^ domainObject
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
	| model tool call result domainObject |
	model := self expressionParserModel.
	tool := GtLSmaCCToolForParserCompilation new model: model.
	call := GtLFunctionToolCall new.
	call
		rawArguments: {'compileParser' -> {'parserClass' -> 'AbcParser'} asDictionary} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	self assert: call arguments size equals: 1.
	self assert: (call arguments anyOne isKindOf: GtLSmaCCParserReference).
	domainObject := result targetObject.
	self assert: domainObject isErrorDomainObject.
	^ call
]
