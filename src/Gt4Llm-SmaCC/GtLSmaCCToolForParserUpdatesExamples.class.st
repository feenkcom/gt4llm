Class {
	#name : #GtLSmaCCToolForParserUpdatesExamples,
	#superclass : #Object,
	#traits : 'TGtLInvalidInputDataAssertions',
	#classTraits : 'TGtLInvalidInputDataAssertions classTrait',
	#category : 'Gt4Llm-SmaCC-Examples'
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
	| model tool call result domainObject |
	model := self expressionParserModel.
	tool := GtLSmaCCToolForParserUpdates new model: model.
	call := GtLFunctionToolCall new.
	call
		rawArguments: {'parserUpdate'
					-> {'parserClass' -> 'ExpParser'.
							'edits'
								-> {{'type' -> 'insert'.
											'newSource'
												-> 'Multiplication : Multiplication "*" Addition | Addition;'.
												'oldSource' -> ''}
											asDictionary.
										{'type' -> 'insert'.
											'newSource' -> 'Addition : Addition "+" <number> | <number>;'.
											'oldSource' -> ''}
											asDictionary.
										{'type' -> 'modify'.
											'oldSource' -> 'Expression: Expression "+" <number>;'.
											'newSource' -> 'Expression : Multiplication;'} asDictionary}}
							asDictionary} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	self assert: call arguments size equals: 1.
	self assert: (call arguments anyOne isKindOf: GtLSmaCCUpdateParser).
	domainObject := result targetObject.
	self assert: domainObject isErrorDomainObject.
	^ call
]

{ #category : #examples }
GtLSmaCCToolForParserUpdatesExamples >> performUpdates [
	<gtExample>
	| model tool call result domainObject |
	model := self expressionParserModel.
	tool := GtLSmaCCToolForParserUpdates new model: model.
	call := GtLFunctionToolCall new.
	call
		rawArguments: {'parserUpdate'
					-> {'parserClass' -> 'ExpressionParser'.
							'edits'
								-> {{'type' -> 'insert'.
											'newSource'
												-> 'Multiplication : Multiplication "*" Addition | Addition;'.
												'oldSource' -> ''
												}
											asDictionary.
										{'type' -> 'insert'.
											'newSource' -> 'Addition : Addition "+" <number> | <number>;'.
											'oldSource' -> ''
											}
											asDictionary.
										{'type' -> 'modify'.
											'oldSource' -> ('Expression: Expression "+" <number>;' copyReplaceAll: String lf with: String cr).
											'newSource' -> 'Expression : Multiplication;'} asDictionary}}
							asDictionary} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	self assert: call arguments size equals: 1.
	self assert: (call arguments anyOne isKindOf: GtLSmaCCUpdateParser).
	domainObject := result targetObject.
	self assert: (domainObject isKindOf: GtLSmaCCParserUpdateResult).
	self assert: domainObject parserClass equals: #ExpressionParser.
	self
		assert: domainObject oldGrammar source
		equals: ('<number> : \d+;
Expression: Expression "+" <number>;' copyReplaceAll: String lf with: String cr).
	self
		assert: domainObject newGrammar source
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

	call := GtLFunctionToolCall new.
	call
		rawArguments: {'parserUpdate'
					-> {'parserClass' -> 'ExpressionParser'.
							'edits'
								-> {{'type' -> 'delete'.
								'newSource' -> ''.
											'oldSource' -> 'Expression : Multiplication;'} asDictionary}}
							asDictionary} asDictionary.
	result := tool performToolCall: call.

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
	| model tool call result domainObject |
	model := self expressionParserModel.
	tool := GtLSmaCCToolForParserUpdates new model: model.
	call := GtLFunctionToolCall new.
	call rawArguments: {} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	domainObject := result targetObject.
	self 
		assertMissingRequiredProperties: domainObject 
		withPropertyNames: #('parserUpdate') 
		path: {nil} 
		errorMessage: 'required properties missing [parserUpdate]'.
	^ call
]
