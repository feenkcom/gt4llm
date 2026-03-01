Class {
	#name : #GtLSmaCCToolForParserUpdates,
	#superclass : #GtLSmaCCTool,
	#category : #'Gt4Llm-SmaCC-Tools'
}

{ #category : #accessing }
GtLSmaCCToolForParserUpdates >> description [
	^ 'Updates a SmaCC grammar with edit operations. An edit operation has a type which can be insert, delete or modify. Insert operations have a newSource property that contain the new production, token or directive rule that should be inserted into the grammar. Delete operations specify a rule that should be removed from the grammar. They should contain an oldSource property that has current source that of the rule that is to be removed. Finally, the modify operation should contain both an oldSource and a newSource property. When applied the modify operation will replace the rule with the oldSource to be newSource. 
	
Example JSON arguments:
{
	"parserClass": "SimpleMathParser",
	"edits": [
		{"type":"insert", "newSource":"%glr;"},
		{"type":"modify", "oldSource":"expression : addition | <number>;", "newSource":"expression : expression \"+\" <number>;"},
		{"type":"delete", "oldSource":"addition : expression \"+\" <number>;"}	
	]
}
'
]

{ #category : #accessing }
GtLSmaCCToolForParserUpdates >> name [
	^ 'updateSmaCCParserDefinition'
]

{ #category : #accessing }
GtLSmaCCToolForParserUpdates >> parserUpdateDescription [
	<magritteDescription>
	^ MAToOneRelationDescription new
		accessor: #parserUpdate;
		classes: {GtLSmaCCUpdateParser};
		beRequired
]

{ #category : #private }
GtLSmaCCToolForParserUpdates >> privatePerformToolCall: aToolCall [
	| arguments updates |
	arguments := aToolCall arguments ifNil: [ Dictionary new ].
	updates := arguments
			at: 'parserUpdate'
			ifAbsent: [ ^ GtLMissingArgumentDomainObject new
					arguments: arguments;
					missingArgument: 'parserUpdate' ].
	^ self
		grammarIn: updates
		do: [ :grammar | 
			| oldGrammar |
			updates edits
				do: [ :each | each validateFor: grammar onError: [ :error | ^ error ] ].
			oldGrammar := GtSmaCCGrammar new.
			oldGrammar scannerClassName: grammar scannerClassName.
			oldGrammar parserClassName: grammar parserClassName.
			oldGrammar updateSource: grammar source.
			updates edits do: [ :each | each performOn: grammar ].
			GtLSmaCCParserUpdateResult new
				parserClass: updates parserClass;
				oldGrammar: oldGrammar;
				newGrammar: grammar;
				yourself ]
		onError: [ :error | error ]
]
