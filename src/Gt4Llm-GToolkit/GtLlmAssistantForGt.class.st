Class {
	#name : #GtLlmAssistantForGt,
	#superclass : #GtLlmAssistant,
	#category : #'Gt4Llm-GToolkit-Assistants'
}

{ #category : #'as yet unclassified' }
GtLlmAssistantForGt >> changesFormatDescription [
	<gtLlmAssistantFormat>
	^ GtLlmAssistantLibraryForGt changesFormatWithPageSnippetMethodClass
]

{ #category : #'as yet unclassified' }
GtLlmAssistantForGt >> objectFormatDescription [
	<gtLlmAssistantFormat>
	^ GtLlmAssistantFormatDescription new
		name: 'Object';
		priority: 2;
		format: 'JSON';
		example: '```
{"string":"a GtTMoneyBag","instanceSlots":[{"name":"monies","class":"OrderedCollection","value":"an OrderedCollection(a GtTCurrencyMoney a GtTCurrencyMoney)"}],"class":"GtTMoneyBag"}
```'
]

{ #category : #accessing }
GtLlmAssistantForGt >> pharoRewriteFormatDescription [
	<gtLlmAssistantFormat>
	^ GtLlmAssistantFormatDescription new
		name: 'Pharo Rewrite';
		priority: 10;
		format: 'A Pharo AST search or rewrite wrapped in a JSON object';
		example: 'The result is a JSON object that specifies a Pharo rewrite that can transform Pharo code. The rewrite is specified using the format of the RBParseTreeRewriter. The JSON object must contain a "search" property that is a string that is encoded to form a proper JSON string. The JSON object can also contain a "replace" property that specifies the replacement that is to be performed when the a match is found. Like the search property, the replace property should also be a proper JSON string. If the replace property is omitted, then it is used as a pattern to search for code.

Example:
```json
{
	"search": "``@col at: 2",
	"replace": "``@col second"
}
```'
]

{ #category : #'as yet unclassified' }
GtLlmAssistantForGt >> textFormatDescription [
	<gtLlmAssistantFormat>
	^ GtLlmAssistantLibraryForGt textFormatWithSmalltalkBlocks
]

{ #category : #'as yet unclassified' }
GtLlmAssistantForGt >> viewProposalAction [
	<gtLlmAssistantAction>
	^ GtLlmAssistantAction new
		name: 'Propose a view';
		priority: 5;
		description: 'Propose a useful Phlow view. Create it for the object if one is provided. Otherwise ask for clarification. Only reply with the Smalltalk code for the view. Look up existing views and their code for reference, especially to check what new view would be useful before proposing any code. Take into account optional user directions if applicable.';
		addArgument: 'User instruction';
		examples: {GtLlmAssistantActionExample new markUnverified
					input: {'Action' -> 'Propose a view'.
							'Arguments' -> {''}.
							'Object'
								-> '{"string":"(1@5)","instanceSlots":[{"name":"x","class":"SmallInteger","value":"1"},{"name":"y","class":"SmallInteger","value":"5"}],"class":"Point"}'}
							asDictionary;
					output: {'Action' -> 'Propose a view'.
							'Arguments' -> {''}.
							'Object'
								-> '{"string":"(1@5)","instanceSlots":[{"name":"x","class":"SmallInteger","value":"1"},{"name":"y","class":"SmallInteger","value":"5"}],"class":"Point"}'.
							'Changes'
								-> '[{"type": "method", "class": "Point", "code": "gtCoordinatesFor: aView
	<gtView>
	^ aView columnedList
		title: ''Coordinates'';
		priority: 10;
		items: [ { ''x'' -> self x. ''y'' -> self y } ];
		column: ''Axis'' text: #key;
		column: ''Value'' text: #value"}]'} asDictionary}
]
