Class {
	#name : #GtLSmaCCToolForParserUpdatesExamples,
	#superclass : #Object,
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
	| tool call result model |
	model := self expressionParserModel.
	tool := GtLSmaCCToolForParserUpdates new model: model.
	call := GtLFunctionToolCall new.
	call
		rawArguments: {'parserUpdate'
					-> {'parserClass' -> 'ExpParser'.
							'edits'
								-> {{'type' -> 'insert'.
											'newSource'
												-> 'Multiplication : Multiplication "*" Addition | Addition;'}
											asDictionary.
										{'type' -> 'insert'.
											'newSource' -> 'Addition : Addition "+" <number> | <number>;'}
											asDictionary.
										{'type' -> 'modify'.
											'oldSource' -> 'Expression: Expression "+" <number>;'.
											'newSource' -> 'Expression : Multiplication;'} asDictionary}}
							asDictionary} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GtLMagritteInputModel).
	self assert: call arguments size equals: 1.
	self assert: (call arguments anyOne isKindOf: GtLSmaCCUpdateParser).
	self assert: result model isErrorDomainObject.
	^ call
]

{ #category : #examples }
GtLSmaCCToolForParserUpdatesExamples >> performUpdates [
	<gtExample>
	| tool call result model |
	model := self expressionParserModel.
	tool := GtLSmaCCToolForParserUpdates new model: model.
	call := GtLFunctionToolCall new.
	call
		rawArguments: {'parserUpdate'
					-> {'parserClass' -> 'ExpressionParser'.
							'edits'
								-> {{'type' -> 'insert'.
											'newSource'
												-> 'Multiplication : Multiplication "*" Addition | Addition;'}
											asDictionary.
										{'type' -> 'insert'.
											'newSource' -> 'Addition : Addition "+" <number> | <number>;'}
											asDictionary.
										{'type' -> 'modify'.
											'oldSource' -> 'Expression: Expression "+" <number>;'.
											'newSource' -> 'Expression : Multiplication;'} asDictionary}}
							asDictionary} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GtLMagritteInputModel).
	self assert: call arguments size equals: 1.
	self assert: (call arguments anyOne isKindOf: GtLSmaCCUpdateParser).
	self assert: (result model isKindOf: GtLSmaCCParserUpdateResult).
	self assert: result model parserClass equals: #ExpressionParser.
	self
		assert: result model oldGrammar source
		equals: '<number> : \d+;
Expression: Expression "+" <number>;'.
	self
		assert: result model newGrammar source
		equals: '<number> : \d+;
Expression : Multiplication;
Multiplication : Multiplication "*" Addition | Addition;
Addition : Addition "+" <number> | <number>;'.

	self
		assert: (model grammarFor: #ExpressionParser) source
		equals: '<number> : \d+;
Expression : Multiplication;
Multiplication : Multiplication "*" Addition | Addition;
Addition : Addition "+" <number> | <number>;'.

	call := GtLFunctionToolCall new.
	call
		rawArguments: {'parserUpdate'
					-> {'parserClass' -> 'ExpressionParser'.
							'edits'
								-> {{'type' -> 'delete'.
											'oldSource' -> 'Expression : Multiplication;'} asDictionary}}
							asDictionary} asDictionary.
	result := tool performToolCall: call.

	self
		assert: (model grammarFor: #ExpressionParser) source
		equals: '<number> : \d+;

Multiplication : Multiplication "*" Addition | Addition;
Addition : Addition "+" <number> | <number>;'.

	^ model grammarFor: #ExpressionParser
]
