Class {
	#name : #GtLSmaCCToolForParserCreation,
	#superclass : #GtLSmaCCTool,
	#category : 'Gt4Llm-SmaCC-Tools'
}

{ #category : #accessing }
GtLSmaCCToolForParserCreation >> description [
	^ 'Creates a new SmaCC parser.
	
Example JSON arguments:
{
	"parserClass": "TestParser",
	"scannerClass": "TestScanner",
	"package": "MyPackage",
	"definition": "<number> : \\d+;\n<whitespace>: \\s+;\nNumbers: <number>+;"
}
'
]

{ #category : #accessing }
GtLSmaCCToolForParserCreation >> name [
	^ 'createSmaCCParserDefinition'
]

{ #category : #accessing }
GtLSmaCCToolForParserCreation >> parserCreationDescription [
	<magritteDescription>
	^ MAToOneRelationDescription new
		accessor: #parserCreation;
		classes: {GtLSmaCCCreateParser};
		beRequired
]

{ #category : #private }
GtLSmaCCToolForParserCreation >> privatePerformToolCall: aToolCall [
	| arguments creation grammar |
	arguments := aToolCall arguments ifNil: [ Dictionary new ].
	creation := arguments
		at: 'parserCreation'
		ifAbsent: [ ^ GtLMissingArgumentDomainObject new
			arguments: arguments;
			missingArgument: 'parserCreation' ].
	creation validateOnError: [ :error | ^ error ].
	grammar := creation createGrammar.
	model defineParser: creation parserClass as: grammar.
	^ GtLSmaCCParserCreationResult new
		parserClass: creation parserClass;
		createGrammar: grammar;
		yourself
]
