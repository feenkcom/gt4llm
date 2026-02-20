Class {
	#name : #GtLSmaCCToolForParserCompilation,
	#superclass : #GtLSmaCCTool,
	#category : #'Gt4Llm-SmaCC-Tools'
}

{ #category : #'as yet unclassified' }
GtLSmaCCToolForParserCompilation >> compileParserDescription [
	<magritteDescription>
	^ MAToOneRelationDescription new
		accessor: #compileParser;
		classes: {GtLSmaCCParserReference};
		beRequired
]

{ #category : #'as yet unclassified' }
GtLSmaCCToolForParserCompilation >> description [
	^ 'Compiles the parser that has previously been created or modified.
	
Example JSON arguments:
{
	"parserClass": "ExpParser"
}
'
]

{ #category : #'as yet unclassified' }
GtLSmaCCToolForParserCompilation >> name [
	^ 'compileSmaCCParserDefinition'
]

{ #category : #'as yet unclassified' }
GtLSmaCCToolForParserCompilation >> privatePerformToolCall: aToolCall [
	| arguments definitionReference |
	arguments := aToolCall arguments ifNil: [ Dictionary new ].
	definitionReference := arguments
			at: 'compileParser'
			ifAbsent: [ ^ GtLMissingArgumentDomainObject new
					arguments: arguments;
					missingArgument: 'compileParser' ].
	^ self
		grammarIn: definitionReference
		do: [ :grammar | 
			grammar compileParser.
			GtLSmaCCSuccess new message: 'Parser was successfully compiled' ]
		onError: [ :error | error ]
]
