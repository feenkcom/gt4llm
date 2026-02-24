Class {
	#name : #GtLSmaCCToolForDefinition,
	#superclass : #GtLSmaCCTool,
	#category : 'Gt4Llm-SmaCC-Tools'
}

{ #category : #accessing }
GtLSmaCCToolForDefinition >> description [
	^ 'Returns the SmaCC grammar for a parser given a class name.
	
Example JSON arguments:
{
	"parserClass": "JSParser"
}

Example JSON response:
{
	"parserClass": "JSParser",
	"scannerClass": "JSScanner",
	"definition": "..."
}
'
]

{ #category : #accessing }
GtLSmaCCToolForDefinition >> name [
	^ 'getSmaCCParserDefinition'
]

{ #category : #accessing }
GtLSmaCCToolForDefinition >> parserDefinitionDescription [
	<magritteDescription>
	^ MAToOneRelationDescription new
		accessor: #parserDefinition;
		classes: {GtLSmaCCParserReference};
		beRequired
]

{ #category : #execution }
GtLSmaCCToolForDefinition >> privatePerformToolCall: aToolCall [
	| arguments definitionReference |
	arguments := aToolCall arguments ifNil: [ Dictionary new ].
	definitionReference := arguments
			at: 'parserDefinition'
			ifAbsent: [ ^ GtLMissingArgumentDomainObject new
					arguments: arguments;
					missingArgument: 'parserDefinition' ].
	^ self
		grammarIn: definitionReference
		do: [ :grammar | 
			GtLSmaCCDefinition new
				parserClass: grammar parserClassName;
				scannerClass: grammar scannerClassName;
				definition: grammar source;
				yourself ]
		onError: [ :error | error ]
]
