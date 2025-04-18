Class {
	#name : #GtLlmObjectTutor,
	#superclass : #GtLlmTutor,
	#category : #'Gt4Llm-GToolkit'
}

{ #category : #'as yet unclassified' }
GtLlmObjectTutor >> chatOn: anObject [
	| chat |
	chat := self createChat onInstance: (self serializerFor: anObject).


	chat provider addTool: (self methodsToolOn: anObject).
	chat provider addTool: (self methodToolOn: anObject).
	chat provider addTool: (self slotToolOn: anObject).

	^ chat
]

{ #category : #'as yet unclassified' }
GtLlmObjectTutor >> codeFormatDescription [
	<gtLlmTutorFormat>
	^ GtLlmTutorFormatDescription new
		name: 'Code';
		priority: 2;
		format: 'Smalltalk code';
		example: '```
15 * 5 @ 3
```
```
add: val
	^ self + val
```'
]

{ #category : #'as yet unclassified' }
GtLlmObjectTutor >> defaultDescription [
	^ 'You are an assistant for objects in Glamorous Toolkit.'
]

{ #category : #'as yet unclassified' }
GtLlmObjectTutor >> defaultProviderStencil [
	^ [ :anInstructionFormat | 
	GtOpenAIResponseProvider withApiKeyFromFile
		instructions: anInstructionFormat asInstructionPiece instructionString;
		format: anInstructionFormat asJsonSchema;
		assistantMessageClass: GtOpenAIObjectMessage;
		userMessageClass: GtOpenAIObjectMessage ]
]

{ #category : #'as yet unclassified' }
GtLlmObjectTutor >> methodToolOn: anObject [
	^ GtLlmFunctionTool new
		name: 'getObjectMethod';
		parameters: {'methodName'};
		description: 'Gets a method by name from the object and returns its source code.';
		block: [ :functionCall | 
			functionCall arguments
				at: 'methodName'
				ifPresent: [ :methodName | 
					anObject class allMethods
						detect: [ :aMethod | aMethod selector = methodName ]
						ifFound: #sourceCode
						ifNone: [ 'Method not found' ] ]
				ifAbsent: [ 'Method not found' ] ]
]

{ #category : #'as yet unclassified' }
GtLlmObjectTutor >> methodsToolOn: anObject [
	^ GtLlmFunctionTool new
		name: 'getObjectViews';
		parameters: {};
		description: 'Gets a list of the object’s views.';
		block: [ :functionCall | 
			Character cr
				join: ((Pragma
						allNamed: #gtView
						from: anObject class
						to: Object) collect: #methodSelector) ]
]

{ #category : #'as yet unclassified' }
GtLlmObjectTutor >> objectFormatDescription [
	<gtLlmTutorFormat>
	^ GtLlmTutorFormatDescription new
		name: 'Object';
		priority: 2;
		format: 'JSON';
		example: '```
{"string":"a GtTMoneyBag","instanceSlots":[{"name":"monies","class":"OrderedCollection","value":"an OrderedCollection(a GtTCurrencyMoney a GtTCurrencyMoney)"}],"class":"GtTMoneyBag"}
```'
]

{ #category : #'as yet unclassified' }
GtLlmObjectTutor >> phlowInstructionSection [
	<gtLlmInstructionSection>
	^ GtLlmInstructionSection new
		title: 'Phlow views';
		body: 'Phlow is a framework for creating various views on the object inspector in Glamorous Toolkit. What follows are some examples for views that can be created using Phlow.

Lists:
```
gtListFor: aView
	<gtView>
	^ aView list
		title: ''My list view'';
		priority: 1;
		items: [ {1. 2. 3} ];
		itemText: #asString
```

Columned lists:
```
gtColumnedListFor: aView
	<gtView>
	^ aView columnedList
		title: ''My columned list view'';
		priority: 1;
		items: [ {1. 2. 3} ];
		column: ''Number'' text: #yourself;
		column: ''Double'' text: [:aNumber | aNumber * 2 ]
```
'
]

{ #category : #'as yet unclassified' }
GtLlmObjectTutor >> serializerFor: anObject [
	^ GtLlmSerializableValueHolder new
		name: 'Object';
		content: anObject;
		serializer: [ :aModel | GtLlmValueSerializer new serializeValue: aModel ];
		updater: [ :object :aString |
			"not actually a good idea"
			object readFromString: aString ]
]

{ #category : #'as yet unclassified' }
GtLlmObjectTutor >> slotToolOn: anObject [
	^ GtLlmFunctionTool new
		name: 'getObjectProperty';
		parameters: {'propertyName'};
		description: 'Returns the property value by name. This can be an arbitrarily deeply nested accessor separated by spaces, including numbers to access a collection’s value by index (example: `property 2 collectionChildProperty`).';
		block: [ :functionCall | 
			| value |
			value := anObject.
			(' ' split: functionCall anyArgument)
				do: [ :aKey | 
					(value isKindOf: Dictionary)
						ifTrue: [ value := value at: aKey ]
						ifFalse: [ (value isKindOf: SequenceableCollection)
								ifTrue: [ value := value at: aKey asInteger ]
								ifFalse: [ value := value readSlotNamed: aKey asSymbol ] ] ].
			STONJSON toStringPretty: (GtLlmValueSerializer new serializeValue: value) ]
]

{ #category : #'as yet unclassified' }
GtLlmObjectTutor >> viewProposalAction [
	<gtLlmTutorAction>
	^ GtLlmTutorAction new
		name: 'Propose a view';
		priority: 1;
		description: 'Propose a useful Phlow view for this object. Only reply with the Smalltalk code for the view. Look up existing views and their code for reference if needed.';
		examples: {GtLlmTutorActionExample new markUnverified
					input: {'Action' -> 'Propose a view'.
							'Object'
								-> '{"string":"(1@5)","instanceSlots":[{"name":"x","class":"SmallInteger","value":"1"},{"name":"y","class":"SmallInteger","value":"5"}],"class":"Point"}'}
							asDictionary;
					output: {'Action' -> 'Propose a view'.
							'Object'
								-> '{"string":"(1@5)","instanceSlots":[{"name":"x","class":"SmallInteger","value":"1"},{"name":"y","class":"SmallInteger","value":"5"}],"class":"Point"}'.
							'Code'
								-> 'gtCoordinatesFor: aView
	<gtView>
	^ aView columnedList
		title: ''Coordinates'';
		priority: 10;
		items: [ { ''x'' -> self x. ''y'' -> self y } ];
		column: ''Axis'' text: #key;
		column: ''Value'' text: #value'}
							asDictionary}
]
