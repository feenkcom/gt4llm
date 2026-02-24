Class {
	#name : #GtLSmaCCToolForParserTest,
	#superclass : #GtLSmaCCTool,
	#category : 'Gt4Llm-SmaCC-Tools'
}

{ #category : #accessing }
GtLSmaCCToolForParserTest >> description [
	^ 'Checks if the SmaCC parser specified by the parserClass parses the example expression without throwing any errors.
	
Example JSON arguments:
{
	"parserClass": "JSParser",
	"example": "console.log(''Did it work'');"
}
'
]

{ #category : #accessing }
GtLSmaCCToolForParserTest >> name [
	^ 'testSmaCCParser'
]

{ #category : #execution }
GtLSmaCCToolForParserTest >> privatePerformToolCall: aToolCall [
	| arguments creation |
	arguments := aToolCall arguments ifNil: [ Dictionary new ].
	creation := arguments
			at: 'testParse'
			ifAbsent: [ ^ GtLMissingArgumentDomainObject new
					arguments: arguments;
					missingArgument: 'testParse' ].
	^ creation testParse
]

{ #category : #accessing }
GtLSmaCCToolForParserTest >> testParseDescription [
	<magritteDescription>
	^ MAToOneRelationDescription new
		accessor: #testParse;
		classes: {GtLSmaCCParserTest};
		beRequired
]
