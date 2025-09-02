Class {
	#name : #GtLlmObjectAssistant,
	#superclass : #GtLlmAssistant,
	#category : #'Gt4OpenAI-GToolkit'
}

{ #category : #'as yet unclassified' }
GtLlmObjectAssistant >> actionProposalAction [
	<gtLlmAssistantAction>
	^ GtLlmAssistantAction new
		name: 'Propose an action';
		priority: 5;
		description: 'Propose a useful Phlow action for this object. Only reply with the Smalltalk code for the action. Look up existing actions and their code for reference, especially to check what new action would be useful before proposing any code. Take into account optional user directions if applicable.';
		addArgument: 'User Instruction';
		examples: {GtLlmAssistantActionExample new markUnverified
					input: {'Action' -> 'Propose an action'.
							'Arguments' -> {''}.
							'Object'
								-> '{"string":"(1@5)","instanceSlots":[{"name":"x","class":"SmallInteger","value":"1"},{"name":"y","class":"SmallInteger","value":"5"}],"class":"Point"}'}
							asDictionary;
					output: {'Action' -> 'Propose an action'.
							'Arguments' -> {''}.
							'Object'
								-> '{"string":"(1@5)","instanceSlots":[{"name":"x","class":"SmallInteger","value":"1"},{"name":"y","class":"SmallInteger","value":"5"}],"class":"Point"}'.
							'Code'
								-> '[{"type": "method", "class": "Point", "code": "gtGotoXActionFor: anAction
	<gtAction>
	^ anAction button
		icon: BrGlamorousVectorIcons inspect;
		label: ''Go to X'';
		priority: 10;
		action: [:aButton | aButton phlow spawnObject: self x]"}]'} asDictionary}
]

{ #category : #'as yet unclassified' }
GtLlmObjectAssistant >> chatOn: anObject [
	| chat |
	chat := GtLlmActionChat new
			assistant: self;
			onInstance: (self serializerFor: anObject);
			provider: self buildProvider.

	^ chat
]

{ #category : #'as yet unclassified' }
GtLlmObjectAssistant >> codeFormatDescription [
	<gtLlmAssistantFormat>
	^ GtLlmAssistantFormatDescription new
		name: 'Code';
		priority: 2;
		format: 'Smalltalk code wrapped in an array JSON objects';
		example: 'The result is a list of snippets, class definitions and method definitions. It is always an array, even if only one item is needed. Multiple items may be returned. Split the items based on their intent:
- A snippet is annotated with the type `snippet` it contains Smalltalk scripts that can be executed independently. The code is in the `code` property.
- A class definition is provided as a snippet, but should be specifically annotated with the type `class`.
- A method definition is annotated with the type `method` and has a class it refers to.

Smalltalk comments should always be escaped inside a JSON string like this: `"code": "\"this is a comment\" 1 + 2"`.

Example:
```json
[
	{"type": "snippet",
	 "code": "55 @ (13 * (5 negatedArcTan))"},
	{"type": "method",
	 "class": "Number",
	 "code": "invertedArcTan
	 \"arctan but inverted\"
	 ^ self arcTan negated"},
	{"type": "class",
	 "code": "Object subclass: #SomeClass
	instanceVariableNames: ''someSlotA someSlotB''
	classVariableNames: ''''
	package: ''SomePackage''"},
	{"type": "method",
	 "class": "SomeClass",
	 "classSide": true,
	 "code": "classSideMethod
	 ^ self new"}
]
```
'
]

{ #category : #'as yet unclassified' }
GtLlmObjectAssistant >> defaultDescription [
	^ 'You are an assistant for objects in Glamorous Toolkit.'
]

{ #category : #'as yet unclassified' }
GtLlmObjectAssistant >> explanationAction [
	<gtLlmAssistantAction>
	^ GtLlmAssistantAction new
		name: 'Explain the object';
		priority: 10;
		description: 'Explain the object, including its layout, its purpose, and other interesting facts. Use tools if necessary. Stick to the facts you can verify and avoid speculation.';
		examples: {GtLlmAssistantActionExample new markUnverified
					input: {'Action' -> 'Explain the object'.
							'Object'
								-> '{"string":"(100@30)","instanceSlots":[{"name":"x","class":"SmallInteger","value":"100"},{"name":"y","class":"SmallInteger","value":"30"}],"class":"Point"}'}
							asDictionary;
					output: {'Action' -> 'Propose a view'.
							'Arguments' -> nil.
							'Object'
								-> '{"string":"(100@30)","instanceSlots":[{"name":"x","class":"SmallInteger","value":"100"},{"name":"y","class":"SmallInteger","value":"300"}],"class":"Point"}'.
							'Code' -> '[]'.
							'Text'
								-> 'This object represents a two-dimensional point at the coordinates `100` and `30`.'}
							asDictionary}
]

{ #category : #'as yet unclassified' }
GtLlmObjectAssistant >> getActionsTool [
	<gtLlmTool>
	^ GtLlmFunctionTool new
		name: 'getClassActions';
		parameters: {'className'};
		description: 'Gets a class by name and returns a list of its actions.';
		block: [ :functionCall | 
			(functionCall anyArgument asClassIfAbsent: [ nil ])
				ifNil: [ 'Class not found' ]
				ifNotNil: [ :aClass | 
					Character cr
						join: ((Pragma
								allNamed: #gtAction
								from: aClass
								to: Object) collect: #methodSelector) ] ]
]

{ #category : #'as yet unclassified' }
GtLlmObjectAssistant >> getImplementorsTool [
	<gtLlmTool>
	^ GtLlmFunctionTool new
		name: 'getImplementors';
		parameters: {'methodName'};
		description: 'Gets a method by name and returns a list of methods that implement it.';
		block: [ :functionCall | 
			Character cr
				join: (functionCall anyArgument asSymbol gtImplementors result toArray wait collect: #name) ]
]

{ #category : #'as yet unclassified' }
GtLlmObjectAssistant >> getMethodTool [
	<gtLlmTool>
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
GtLlmObjectAssistant >> getPropertyToolOn: anObject [
	^ GtLlmFunctionTool new
		name: 'getObjectProperty';
		parameters: {'propertyName'};
		description: 'Returns the property value by name. This can be an arbitrarily deeply nested accessor separated by spaces, including numbers to access a collection’s value by index (example: `property 2 collectionChildProperty`). Indices start at 1, not 0.';
		block: [ :functionCall | 
			self traverse: anObject using: (' ' split: functionCall anyArgument) ]
]

{ #category : #'as yet unclassified' }
GtLlmObjectAssistant >> getReferencesTool [
	<gtLlmTool>
	^ GtLlmFunctionTool new
		name: 'getReferences';
		parameters: {'methodName'};
		description: 'Gets a method by name and returns a list of methods that reference it.';
		block: [ :functionCall | 
			Character cr
				join: (functionCall anyArgument asSymbol gtReferences result toArray wait collect: #name) ]
]

{ #category : #'as yet unclassified' }
GtLlmObjectAssistant >> getViewsTool [
	<gtLlmTool>
	^ GtLlmFunctionTool new
		name: 'getClassViews';
		parameters: {'className'};
		description: 'Gets a class by name and returns a list of its views.';
		block: [ :functionCall | 
			(functionCall anyArgument asClassIfAbsent: [ nil ])
				ifNil: [ 'Class not found' ]
				ifNotNil: [ :aClass | 
					Character cr
						join: ((Pragma
								allNamed: #gtView
								from: aClass
								to: Object) collect: #methodSelector) ] ]
]

{ #category : #'as yet unclassified' }
GtLlmObjectAssistant >> lookupClassTool [
	<gtLlmTool>
	^ GtLlmFunctionTool new
		name: 'lookupClass';
		parameters: {'className'};
		description: 'Get the details of a class as JSON.';
		block: [ :functionCall | 
			(functionCall anyArgument asClassIfAbsent: [ nil ])
				ifNil: [ 'Class not found' ]
				ifNotNil: [ :aClass | STONJSON toString: (GtLlmValueSerializer new serializeClass: aClass) ] ]
]

{ #category : #'as yet unclassified' }
GtLlmObjectAssistant >> lookupPageTool [
	<gtLlmTool>
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
GtLlmObjectAssistant >> objectFormatDescription [
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
GtLlmObjectAssistant >> phlowInstructionSection [
	<gtLlmInstructionSection>
	^ GtLlmInstructionSection new
		title: 'Phlow views';
		body: 'Phlow is a framework for creating various views on the object inspector in Glamorous Toolkit. What follows are some examples for views that can be created using Phlow.

Lists:
```smalltalk-method
gtListFor: aView
	<gtView>
	^ aView list
		title: ''My list view'';
		priority: 1;
		items: [ {1. 2. 3} ];
		itemText: #asString
```

Columned lists:
```smalltalk-method
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
```smalltalk-method
gtTextEditorFor: aView
	<gtView>
	^ aView textEditor
		title: ''My editor view'';
		priority: 1;
		text: [ ''hi'' ]
```

Diffs:
```smalltalk-method
gtDiffFor: aView
	<gtView>
	^ aView diff
		title: ''My diff view'';
		priority: 1;
		from: [ ''from text'' ];
		to: [ ''to text'' ]
```

Trees:
```smalltalk-method
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
```smalltalk-method
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
```smalltalk-method
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
GtLlmObjectAssistant >> responseFormatSection [
	<gtLlmInstructionSection>
	^ GtLlmInstructionSection new
		source: self;
		title: 'Response Format';
		body: 'The response format in all text should be Markdown. Apart from regular Markdown, it also supports annotations for classes and methods.
- Classes may be annotated using `{{gtClass:ClassName}}`, where `ClassName` is the name of the class to be referenced.
- Methods may be annotated using `{{gtMethod:ClassName>>#methodName}}`, where `ClassName` is the name of the class and `methodName` is the name of the method.

Code in text should be formatted as follows:
- Smalltalk methods appear as:

```smalltalk-method
SomeClass>>someMethodWithArgument: val
	^ self + val
```

- Smalltalk snippets appear as:

```smalltalk
Point x: 1 y: 10
```

- the definition of a new class should be provided in the form of a script:

```smalltalk
Object subclass: #SomeClass
	instanceVariableNames: ''someSlotA someSlotB''
	classVariableNames: ''
	package: ''SomePackage''
```'
]

{ #category : #'as yet unclassified' }
GtLlmObjectAssistant >> searchClassTool [
	<gtLlmTool>
	^ GtLlmFunctionTool new
		name: 'searchClasses';
		parameters: {'query'};
		description: 'Searches for classes matching the query substring (case-insensitive).';
		block: [ :functionCall | 
			STONJSON
				toString: ((GtSpotterSubstringsFilter new
						withWordsSplitter;
						beCaseSensitiveByCapitalization;
						applyInScope: SystemNavigation default allClassesAndTraits asAsyncStream
							context: (GtSpotterContext new searchQuery: functionCall anyArgument)) toArray wait
						collect: #name) ]
]

{ #category : #'as yet unclassified' }
GtLlmObjectAssistant >> serializerFor: anObject [
	^ GtLlmSerializableValueHolder new
		name: 'Object';
		content: anObject;
		serializer: [ :aModel | GtLlmValueSerializer new serializeValue: aModel ];
		updater: [ :object :aString |
			"not actually a good idea"
			object readFromString: aString ]
]

{ #category : #'as yet unclassified' }
GtLlmObjectAssistant >> traverse: anObject using: aChain [
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
GtLlmObjectAssistant >> treatProvider: aProvider [
	| anInstance |
	super treatProvider: aProvider.

	anInstance := aProvider chat serializer instance.
	anInstance
		ifNotNil: [ aProvider addTool: (self getPropertyToolOn: anInstance) ].

	aProvider
		assistantMessageClass: GtOpenAIObjectMessage;
		userMessageClass: GtOpenAIObjectMessage
]

{ #category : #'as yet unclassified' }
GtLlmObjectAssistant >> viewProposalAction [
	<gtLlmAssistantAction>
	^ GtLlmAssistantAction new
		name: 'Propose a view';
		priority: 5;
		description: 'Propose a useful Phlow view for this object. Only reply with the Smalltalk code for the view. Look up existing views and their code for reference, especially to check what new view would be useful before proposing any code. Take into account optional user directions if applicable.';
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
							'Code'
								-> '[{"type": "method", "class": "Point", "code": "gtCoordinatesFor: aView
	<gtView>
	^ aView columnedList
		title: ''Coordinates'';
		priority: 10;
		items: [ { ''x'' -> self x. ''y'' -> self y } ];
		column: ''Axis'' text: #key;
		column: ''Value'' text: #value"}]'} asDictionary}
]
