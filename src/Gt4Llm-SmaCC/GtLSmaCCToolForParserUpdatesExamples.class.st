Class {
	#name : #GtLSmaCCToolForParserUpdatesExamples,
	#superclass : #GtLAbstractMagritteFunctionToolExamples,
	#traits : 'TGtLInvalidInputDataAssertions',
	#classTraits : 'TGtLInvalidInputDataAssertions classTrait',
	#category : #'Gt4Llm-SmaCC-Examples'
}

{ #category : #private }
GtLSmaCCToolForParserUpdatesExamples >> expressionParserModel [
	| model |
	model := GtLSmaCCModel new.
	model
		defineParser: #ExpressionParser
		andScanner: #ExpressionScanner
		using: '<number> : \d+;
Expression: Expression "+" <number>;'.
	^ model
]

{ #category : #examples }
GtLSmaCCToolForParserUpdatesExamples >> invalidParserClass [
	<gtExample>
	| model tool call targetObject |
	model := self expressionParserModel.
	tool := GtLSmaCCToolForParserUpdates new model: model.
	call := self
		executeTool: tool
		withArguments: {'parserUpdate'
			-> {'parserClass' -> 'ExpParser'.
				'edits'
					-> {{'type' -> 'insert'.
							'newSource' -> 'Multiplication : Multiplication "*" Addition | Addition;'.
							'oldSource' -> ''} asDictionary.
						{'type' -> 'insert'.
							'newSource' -> 'Addition : Addition "+" <number> | <number>;'.
							'oldSource' -> ''} asDictionary.
						{'type' -> 'modify'.
							'oldSource' -> 'Expression: Expression "+" <number>;'.
							'newSource' -> 'Expression : Multiplication;'} asDictionary}} asDictionary} asDictionary.
	targetObject := call result targetObject.
	self assert: targetObject isErrorDomainObject.
	^ call
]

{ #category : #examples }
GtLSmaCCToolForParserUpdatesExamples >> performUpdates [
	<gtExample>
	| model tool call targetObject |
	model := self expressionParserModel.
	tool := GtLSmaCCToolForParserUpdates new model: model.
	call := self
		executeTool: tool
		withArguments: {'parserUpdate'
			-> {'parserClass' -> 'ExpressionParser'.
				'edits'
					-> {{'type' -> 'insert'.
							'newSource' -> 'Multiplication : Multiplication "*" Addition | Addition;'.
							'oldSource' -> ''} asDictionary.
						{'type' -> 'insert'.
							'newSource' -> 'Addition : Addition "+" <number> | <number>;'.
							'oldSource' -> ''} asDictionary.
						{'type' -> 'modify'.
							'oldSource' -> ('Expression: Expression "+" <number>;' copyReplaceAll: String lf with: String cr).
							'newSource' -> 'Expression : Multiplication;'} asDictionary}} asDictionary} asDictionary.
	targetObject := call result targetObject.
	self assert: (targetObject isKindOf: GtLSmaCCParserUpdateResult).
	self assert: targetObject parserClass equals: #ExpressionParser.
	self
		assert: targetObject oldGrammar source
		equals: ('<number> : \d+;
Expression: Expression "+" <number>;' copyReplaceAll: String lf with: String cr).
	self
		assert: targetObject newGrammar source
		equals: ('<number> : \d+;
Expression : Multiplication;
Multiplication : Multiplication "*" Addition | Addition;
Addition : Addition "+" <number> | <number>;' copyReplaceAll: String lf with: String cr).
	self
		assert: (model grammarFor: #ExpressionParser) source
		equals: ('<number> : \d+;
Expression : Multiplication;
Multiplication : Multiplication "*" Addition | Addition;
Addition : Addition "+" <number> | <number>;' copyReplaceAll: String lf with: String cr).
	"Now test deletion"
	call := self
		executeTool: tool
		withArguments: {'parserUpdate'
			-> {'parserClass' -> 'ExpressionParser'.
				'edits'
					-> {{'type' -> 'delete'.
							'newSource' -> ''.
							'oldSource' -> 'Expression : Multiplication;'} asDictionary}} asDictionary} asDictionary.
	self
		assert: (model grammarFor: #ExpressionParser) source
		equals: ('<number> : \d+;

Multiplication : Multiplication "*" Addition | Addition;
Addition : Addition "+" <number> | <number>;' copyReplaceAll: String lf with: String cr).
	^ model grammarFor: #ExpressionParser
]

{ #category : #examples }
GtLSmaCCToolForParserUpdatesExamples >> updatesForMissingParserUpdateArgument [
	<gtExample>
	| model tool call |
	model := self expressionParserModel.
	tool := GtLSmaCCToolForParserUpdates new model: model.
	call := self
		executeTool: tool
		withArguments: {} asDictionary.
	self
		assertMissingRequiredProperties: call result targetObject
		withPropertyNames: #('parserUpdate')
		path: {nil}
		errorMessage: 'required properties missing [parserUpdate]'.
	^ call
]
