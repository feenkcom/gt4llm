Class {
	#name : #GtLSmaCCToolForParserCreationExamples,
	#superclass : #Object,
	#category : #'Gt4Llm-SmaCC-Examples'
}

{ #category : #examples }
GtLSmaCCToolForParserCreationExamples >> createParser [
	<gtExample>
	| tool call result model grammar definition |
	model := GtLSmaCCModel new.
	tool := GtLSmaCCToolForParserCreation new model: model.
	call := GtLFunctionToolCall new.
	definition := '<number>: \d+;
Foo: <number>+;'.
	call
		rawArguments: {'parserCreation'
					-> {'parserClass' -> 'ExpParser'.
							'scannerClass' -> 'ExpScanner'.
							'package' -> 'TestPackage'.
							'definition' -> definition} asDictionary} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GtLMagritteInputModel).
	self assert: call arguments size equals: 1.
	self assert: (call arguments anyOne isKindOf: GtLSmaCCCreateParser).

	grammar := model grammarFor: #ExpParser.
	self assert: grammar source equals: definition.
	self assert: grammar parserClassName equals: #ExpParser.
	self assert: grammar scannerClassName equals: #ExpScanner.
	self assert: grammar package equals: 'TestPackage'.
	^ grammar
]

{ #category : #examples }
GtLSmaCCToolForParserCreationExamples >> invalidClassName [
	<gtExample>
	| tool call result model |
	model := GtLSmaCCModel new.
	tool := GtLSmaCCToolForParserCreation new model: model.
	call := GtLFunctionToolCall new.
	call
		rawArguments: {'parserCreation'
					-> {'parserClass' -> 'Exp Parser'.
							'scannerClass' -> 'ExpScanner'.
							'package' -> 'TestPackage'.
							'definition'
								-> '<number>: \d+;
Foo: <number>;'} asDictionary} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GtLMagritteInputModel).
	self assert: call arguments size equals: 1.
	self assert: (call arguments anyOne isKindOf: GtLSmaCCCreateParser).
	self assert: result model isErrorDomainObject.
	^ call
]

{ #category : #examples }
GtLSmaCCToolForParserCreationExamples >> invalidDefinition [
	<gtExample>
	| tool call result model |
	model := GtLSmaCCModel new.
	tool := GtLSmaCCToolForParserCreation new model: model.
	call := GtLFunctionToolCall new.
	call
		rawArguments: {'parserCreation'
					-> {'parserClass' -> 'ExpParser'.
							'scannerClass' -> 'ExpScanner'.
							'package' -> 'TestPackage'.
							'definition'
								-> '<number>: \d+;
Foo: <number> #missing ;'} asDictionary} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GtLMagritteInputModel).
	self assert: call arguments size equals: 1.
	self assert: (call arguments anyOne isKindOf: GtLSmaCCCreateParser).
	self assert: result model isErrorDomainObject.
	^ call
]
