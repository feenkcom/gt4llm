Class {
	#name : #GtLSmaCCToolForParserCreation,
	#superclass : #GtLSmaCCTool,
	#category : #'Gt4Llm-SmaCC-Tools'
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

{ #category : #execution }
GtLSmaCCToolForParserCreation >> privatePerformToolCall: aToolCall [
	| arguments creation |
	arguments := aToolCall arguments ifNil: [ Dictionary new ].
	creation := arguments
			at: 'parserCreation'
			ifAbsent: [ ^ GtLMissingArgumentDomainObject new
					arguments: arguments;
					missingArgument: 'parserCreation' ].
	creation validateOnError: [ :error | ^ error ].
	model defineParser: creation parserClass as: creation createGrammar.
	^ GtLSmaCCSuccess new
		message: 'Parser was successfully created. It will need to be compiled to be used.'
]
