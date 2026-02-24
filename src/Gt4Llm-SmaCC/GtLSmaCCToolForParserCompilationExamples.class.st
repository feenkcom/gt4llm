Class {
	#name : #GtLSmaCCToolForParserCompilationExamples,
	#superclass : #Object,
	#category : 'Gt4Llm-SmaCC-Examples'
}

{ #category : #private }
GtLSmaCCToolForParserCompilationExamples >> cleanUp [
	#(TemporaryExpressionParser TemporaryExpressionScanner)
		do: [ :each | Smalltalk globals at: each ifPresent: [ :cls | cls removeFromSystem ] ]
]

{ #category : #examples }
GtLSmaCCToolForParserCompilationExamples >> compile [
	<gtExample>
	<after: #cleanUp>
	| tool call result model |
	model := self expressionParserModel.
	tool := GtLSmaCCToolForParserCompilation new model: model.
	call := GtLFunctionToolCall new.
	call
		rawArguments: {'compileParser' -> {'parserClass' -> 'TemporaryExpressionParser'} asDictionary}
				asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GtLMagritteInputModel).
	self assert: call arguments size equals: 1.
	self assert: (call arguments anyOne isKindOf: GtLSmaCCParserReference).
	self assert: (result model isKindOf: GtLSmaCCParserReference).
	self assert: result model parserClass equals: #TemporaryExpressionParser.

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
	| tool call result model |
	model := self expressionParserModel.
	tool := GtLSmaCCToolForParserCompilation new model: model.
	call := GtLFunctionToolCall new.
	call
		rawArguments: {'compileParser' -> {'parserClass' -> 'AbcParser'} asDictionary} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GtLMagritteInputModel).
	self assert: call arguments size equals: 1.
	self assert: (call arguments anyOne isKindOf: GtLSmaCCParserReference).
	self assert: result model isErrorDomainObject.
	^ call
]
