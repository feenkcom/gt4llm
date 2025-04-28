Class {
	#name : #GtLlmObjectTutor,
	#superclass : #GtLlmAssistant,
	#category : #'Gt4OpenAI-GToolkit'
}

{ #category : #'as yet unclassified' }
GtLlmObjectTutor >> chatOn: anObject [
	| chat |
	chat := self createChat onInstance: (self serializerFor: anObject).


	chat provider addTool: self getMethodsTool.
	chat provider addTool: self getMethodTool.
	chat provider addTool: self getImplementorsTool.
	chat provider addTool: self getReferencesTool.
	chat provider addTool: self lookupClassTool.
	chat provider addTool: self lookupPageTool.
	chat provider addTool: (self getPropertyToolOn: anObject).

	^ chat
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
GtLlmObjectTutor >> explanationAction [
	<gtLlmAssistantAction>
	^ GtLlmAssistantAction new
		name: 'Explain the object';
		priority: 2;
		description: 'Explain the object, including its layout, its purpose, and other interesting facts. Use tools if necessary. Stick to the facts you can verify and avoid speculation.';
		examples: {GtLlmAssistantActionExample new markUnverified
					input: {'Action' -> 'Explain the object'.
							'Object'
								-> '{"string":"(100@30)","instanceSlots":[{"name":"x","class":"SmallInteger","value":"100"},{"name":"y","class":"SmallInteger","value":"30"}],"class":"Point"}'}
							asDictionary;
					output: {'Action' -> 'Propose a view'.
							'Object'
								-> '{"string":"(100@30)","instanceSlots":[{"name":"x","class":"SmallInteger","value":"100"},{"name":"y","class":"SmallInteger","value":"300"}],"class":"Point"}'.
							'Method' -> ''.
							'Text'
								-> 'This object reprents a two-dimensional point at the coordinates `100` and `30`.'}
							asDictionary}
]

{ #category : #'as yet unclassified' }
GtLlmObjectTutor >> getImplementorsTool [
	^ GtLlmFunctionTool new
		name: 'getImplementors';
		parameters: {'methodName'};
		description: 'Gets a method by name and returns a list of methods that implement it.';
		block: [ :functionCall | 
			Character cr
				join: (functionCall anyArgument asSymbol gtImplementors result toArray wait collect: #name) ]
]

{ #category : #'as yet unclassified' }
GtLlmObjectTutor >> getMethodTool [
	^ GtLlmFunctionTool new
		name: 'getClassMethod';
		parameters: {'className'. 'methodName'};
		description: 'Gets a method by name and returns its source code.';
		block: [ :functionCall | 
			functionCall arguments
				at: 'className'
				ifPresent: [ :className | 
					| class |
					class := className asClassIfAbsent: [ nil ].
					class
						ifNil: [ 'Class not found' ]
						ifNotNil: [ :aClass | 
							functionCall arguments
								at: 'methodName'
								ifPresent: [ :methodName | 
									aClass allMethods
										detect: [ :aMethod | aMethod selector = methodName ]
										ifFound: #sourceCode
										ifNone: [ 'Method not found' ] ]
								ifAbsent: [ 'Method not found' ] ] ] ]
]

{ #category : #'as yet unclassified' }
GtLlmObjectTutor >> getMethodsTool [
	^ GtLlmFunctionTool new
		name: 'getClassMethods';
		parameters: {'className'};
		description: 'Gets a class by name and returns a list of its methods.';
		block: [ :functionCall | 
			(functionCall anyArgument asClassIfAbsent: [ nil ])
				ifNil: [ 'Class not found' ]
				ifNotNil: [ :aClass | Character cr join: (aClass allMethods collect: #selector) ] ]
]

{ #category : #'as yet unclassified' }
GtLlmObjectTutor >> getPropertyToolOn: anObject [
	^ GtLlmFunctionTool new
		name: 'getObjectProperty';
		parameters: {'propertyName'};
		description: 'Returns the property value by name. This can be an arbitrarily deeply nested accessor separated by spaces, including numbers to access a collection’s value by index (example: `property 2 collectionChildProperty`). Indices start at 1, not 0.';
		block: [ :functionCall | 
			self traverse: anObject using: (' ' split: functionCall anyArgument) ]
]

{ #category : #'as yet unclassified' }
GtLlmObjectTutor >> getReferencesTool [
	^ GtLlmFunctionTool new
		name: 'getReferences';
		parameters: {'methodName'};
		description: 'Gets a method by name and returns a list of methods that reference it.';
		block: [ :functionCall | 
			Character cr
				join: (functionCall anyArgument asSymbol gtReferences result toArray wait collect: #name) ]
]

{ #category : #'as yet unclassified' }
GtLlmObjectTutor >> lookupClassTool [
	^ GtLlmFunctionTool new
		name: 'lookupClass';
		parameters: {'className'};
		description: 'Looks up documentation for a class by name and returns its comment in Markdown format.';
		block: [ :functionCall | 
			((functionCall anyArgument) asClassIfAbsent: [ nil ])
				ifNil: [ 'Class not found' ]
				ifNotNil: [ :aClass | aClass instanceSide organization classComment ] ]
]

{ #category : #'as yet unclassified' }
GtLlmObjectTutor >> lookupPageTool [
	^ GtLlmFunctionTool new
		name: 'lookupDocumentationPage';
		parameters: {'pageName'};
		description: 'Looks up a documentation page by name and returns its content in Markdown format. `pageName` may be a substring. If multiple pages are found, only the first one will be returned.';
		block: [ :functionCall |
			(LeDatabase gtBook asyncPagesForWord: functionCall anyArgument) toArray wait
				ifEmpty: [ 'No page found' ]
				ifNotEmpty: [ :pages | pages first asMarkdownPage ] ]
]

{ #category : #'as yet unclassified' }
GtLlmObjectTutor >> methodFormatDescription [
	<gtLlmAssistantFormat>
	^ GtLlmAssistantFormatDescription new
		name: 'Method';
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
GtLlmObjectTutor >> objectFormatDescription [
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
		column: ''Double'' text: [ :aNumber | aNumber * 2 ]
```

Text editors:
```
gtTextEditorFor: aView
	<gtView>
	^ aView textEditor
		title: ''My editor view'';
		priority: 1;
		text: [ ''hi'' ]
```

Diffs:
```
gtDiffFor: aView
	<gtView>
	^ aView diff
		title: ''My diff view'';
		priority: 1;
		from: [ ''from text'' ];
		to: [ ''to text'' ]
```

Trees:
```
gtTreeFor: aView
	<gtView>
	^ aView tree
		title: ''My tree view'';
		priority: 1;
		items: [ { self } ];
		children: #children;
		itemText: #name;
		expandUpTo: 2
```

Columned Trees:
```
gtColumnedTreeFor: aView
	<gtView>
	^ aView columnedTree
		  title: ''My columnedTree view'';
		  priority: 1;
		  items: [ { self } ];
		  children: #childrenExpressionOrBlock;
		  expandAll;
		  column: ''A column'' text: [ :each | each columnText ]
```

Forward:
```
gtForwardFor: aView
	<gtView>
	^ aView forward
		title: ''My forward view'';
		priority: 1;
		object: [ self object ];
		view: #gtViewNameFor:
```'
]

{ #category : #'as yet unclassified' }
GtLlmObjectTutor >> responseFormatSection [
	<gtLlmInstructionSection>
	^ GtLlmInstructionSection new
		source: self;
		title: 'Response Format Concerns';
		body: 'The response format in textual responses should be Markdown. Apart from regular Markdown, it also supports annotations for classes and methods.
		
Classes may be annotated using `{{gtClass:ClassName}}`, where `ClassName` is the name of the class to be referenced.

Likewise, methods may be annotated using `{{gtMethod:ClassName>>#methodName}}`, where `ClassName` is the name of the class and `methodName` is the name of the method.'
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
GtLlmObjectTutor >> traverse: anObject using: aChain [
	| value traversed |
	value := anObject.
	traversed := OrderedCollection new.
	aChain
		do: [ :aKey | 
			traversed add: aKey.
			(value isKindOf: Dictionary)
				ifTrue: [ value := value at: aKey ifAbsent: [ ^ 'Not found: ' , (' ' join: traversed) ] ]
				ifFalse: [ (value isKindOf: SequenceableCollection)
						ifTrue: [ value := value
									at: aKey asInteger
									ifAbsent: [ ^ 'Not found: ' , (' ' join: traversed) ] ]
						ifFalse: [ value := (value class
									slotNamed: aKey asSymbol
									ifFound: #yourself
									ifNone: [ ^ 'Not found: ' , (' ' join: traversed) ]) read: value ] ] ].

	^ STONJSON toStringPretty: (GtLlmValueSerializer new serializeValue: value)
]

{ #category : #'as yet unclassified' }
GtLlmObjectTutor >> viewProposalAction [
	<gtLlmAssistantAction>
	^ GtLlmAssistantAction new
		name: 'Propose a view';
		priority: 1;
		description: 'Propose a useful Phlow view for this object. Only reply with the Smalltalk code for the view. Look up existing views and their code for reference if needed. Take into account optional user directions if applicable.';
		format: 'Propose a view (user direction: `{1}`)';
		examples: {GtLlmAssistantActionExample new markUnverified
					input: {'Action' -> 'Propose a view (user direction: ``)'.
							'Object'
								-> '{"string":"(1@5)","instanceSlots":[{"name":"x","class":"SmallInteger","value":"1"},{"name":"y","class":"SmallInteger","value":"5"}],"class":"Point"}'}
							asDictionary;
					output: {'Action' -> 'Propose a view'.
							'Object'
								-> '{"string":"(1@5)","instanceSlots":[{"name":"x","class":"SmallInteger","value":"1"},{"name":"y","class":"SmallInteger","value":"5"}],"class":"Point"}'.
							'Method'
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
