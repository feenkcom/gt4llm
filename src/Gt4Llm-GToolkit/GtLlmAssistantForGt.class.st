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
