Class {
	#name : #GtLSmaCCToolForParserCreationExamples,
	#superclass : #Object,
	#traits : 'TGtLInvalidInputDataAssertions',
	#classTraits : 'TGtLInvalidInputDataAssertions classTrait',
	#category : 'Gt4Llm-SmaCC-Examples'
}

{ #category : #examples }
GtLSmaCCToolForParserCreationExamples >> createOverExisting [
	<gtExample>
	| model tool call result domainObject definition grammar |
	model := GtLSmaCCModel new.
	model grammarFor: #GtPharoParser.
	tool := GtLSmaCCToolForParserCreation new model: model.
	call := GtLFunctionToolCall new.
	definition := '<number>: \\d+;
Foo: <number>+;'.
	call
		rawArguments: {'parserCreation'
					-> {'parserClass' -> 'GtPharoParser'.
							'scannerClass' -> 'GtPharoScanner'.
							'package' -> 'TestPackage'.
							'definition' -> definition} asDictionary} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	self assert: call arguments size equals: 1.
	self assert: (call arguments anyOne isKindOf: GtLSmaCCCreateParser).
	domainObject := result targetObject.
	self assert: (domainObject isKindOf: GtLSmaCCParserCreationResult).
	self assert: domainObject parserClass equals: #GtPharoParser.
	self assert: domainObject createGrammar source equals: definition.

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
	| model tool call result domainObject definition |
	model := GtLSmaCCModel new.
	tool := GtLSmaCCToolForParserCreation new model: model.
	call := GtLFunctionToolCall new.
	definition := '<number>: \\d+;
Foo: <number>+;'.
	call
		rawArguments: {'parserCreation'
					-> {'parserClass' -> 'ExpParser'.
							'scannerClass' -> 'ExpScanner'.
							'package' -> 'TestPackage'.
							'definition' -> definition} asDictionary} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: call arguments size equals: 1.
	self assert: (call arguments anyOne isKindOf: GtLSmaCCCreateParser).
	
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	domainObject := result targetObject.
	self assert: (domainObject isKindOf: GtLSmaCCParserCreationResult).
	self assert: domainObject parserClass equals: #ExpParser.
	self assert: domainObject createGrammar source equals: definition.

	self assert: (model grammarFor: #ExpParser) source equals: definition.
	self assert: (model grammarFor: #ExpParser) parserClassName equals: #ExpParser.
	self assert: (model grammarFor: #ExpParser) scannerClassName equals: #ExpScanner.
	self assert: (model grammarFor: #ExpParser) package equals: 'TestPackage'.
	
	^ domainObject
]

{ #category : #examples }
GtLSmaCCToolForParserCreationExamples >> creationForMissingParserCreationArgument [
	<gtExample>
	| model tool call result domainObject |
	model := GtLSmaCCModel new.
	tool := GtLSmaCCToolForParserCreation new model: model.
	call := GtLFunctionToolCall new.
	call rawArguments: {} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	domainObject := result targetObject.
	self 
		assertMissingRequiredProperties: domainObject 
		withPropertyNames: #('parserCreation') 
		path: {nil} 
		errorMessage: 'required properties missing [parserCreation]'.
	^ call
]

{ #category : #examples }
GtLSmaCCToolForParserCreationExamples >> invalidClassName [
	<gtExample>
	| model tool call result domainObject |
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
	self assert: call arguments size equals: 1.
	self assert: (call arguments anyOne isKindOf: GtLSmaCCCreateParser).
	
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	domainObject := result targetObject.
	self assert: domainObject isErrorDomainObject.
	^ call
]

{ #category : #examples }
GtLSmaCCToolForParserCreationExamples >> invalidDefinition [
	<gtExample>
	| model tool call result domainObject |
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
	self assert: call arguments size equals: 1.
	self assert: (call arguments anyOne isKindOf: GtLSmaCCCreateParser).
	
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	domainObject := result targetObject.
	self assert: domainObject isErrorDomainObject.
	^ call
]
