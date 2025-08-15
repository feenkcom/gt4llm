Class {
	#name : #GtLlmClassAssistant,
	#superclass : #GtLlmAssistant,
	#category : #'Gt4OpenAI-GToolkit'
}

{ #category : #'as yet unclassified' }
GtLlmClassAssistant >> chatOn: anObject [
	^ GtLlmActionChat new
		assistant: self;
		onInstance: (self serializerFor: anObject);
		provider: self buildProvider
]

{ #category : #'as yet unclassified' }
GtLlmClassAssistant >> codeFormatDescription [
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
	 "code": "55 @ (13 * (5 negatedArcTan))",
	 "source_snippet": true},
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
GtLlmClassAssistant >> defaultDescription [
	^ 'You are an assistant for classes in Glamorous Toolkit.'
]

{ #category : #'as yet unclassified' }
GtLlmClassAssistant >> explanationAction [
	<gtLlmAssistantAction>
	^ GtLlmAssistantAction new
		name: 'Explain the class';
		priority: 10;
		description: 'Explain the class, including its layout, its purpose, and other interesting facts. Use tools if necessary. Stick to the facts you can verify and avoid speculation.';
		examples: {}
]

{ #category : #'as yet unclassified' }
GtLlmClassAssistant >> getActionsTool [
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
GtLlmClassAssistant >> getImplementorsTool [
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
GtLlmClassAssistant >> getMethodTool [
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
GtLlmClassAssistant >> getPackageMembersTool [
	<gtLlmTool>
	^ GtLlmFunctionTool new
		name: 'getPackageMembers';
		parameters: {'packageName'};
		description: 'Gets the names of the classes in this package.';
		block: [ :functionCall | 
			(functionCall anyArgument asPackageIfAbsent: [ nil ])
				ifNil: [ 'Package not found' ]
				ifNotNil: [ :aPackage | Character cr join: (aPackage classes collect: [ :aClass | aClass name ]) ] ]
]

{ #category : #'as yet unclassified' }
GtLlmClassAssistant >> getReferencesTool [
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
GtLlmClassAssistant >> getViewsTool [
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
GtLlmClassAssistant >> gtProposeCheckExample [
 	<gtLlmAssistantAction>
 	^ GtLlmAssistantAction new
 		name: 'Propose an example';
 		priority: 20;
 		description: 'I want to check the functionality of the attached class.  Can you propose a GlamorousToolkit example method that tests its functionality.  The method should:
- be put into a new appropriately named example class,
- be annotated with the `<gtExample>` pragma,
- create an instance of the attached method''s class (from the `class` property),
- add appropriate assertions,
- and should return the object being tested.';
 		examples: {}
]

{ #category : #'as yet unclassified' }
GtLlmClassAssistant >> lookupClassTool [
	<gtLlmTool>
	^ GtLlmFunctionTool new
		name: 'lookupClass';
		parameters: {'className'};
		description: 'Looks up documentation for a class by name and returns its comment in Markdown format.';
		block: [ :functionCall | 
			(functionCall anyArgument asClassIfAbsent: [ nil ])
				ifNil: [ 'Class not found' ]
				ifNotNil: [ :aClass | STONJSON toString: (GtLlmValueSerializer new serializeClass: aClass) ] ]
]

{ #category : #'as yet unclassified' }
GtLlmClassAssistant >> lookupExamplesTool [
	<gtLlmTool>
	^ GtLlmFunctionTool new
		name: 'lookupExamples';
		parameters: {'className'};
		description: 'Looks up examples for a class by name and returns the method names.';
		block: [ :functionCall | 
			(functionCall anyArgument asClassIfAbsent: [ nil ])
				ifNil: [ 'Class not found' ]
				ifNotNil: [ :aClass | 
					Character cr
						join: (((Pragma allNamed: #gtExample)
								collect: #method
								thenSelect: [ :aMethod | 
									| pragma |
									pragma := aMethod pragmaAt: #return:.
									pragma isNotNil and: [ pragma arguments first = aClass name ] ])
								collect: #name) ] ]
]

{ #category : #'as yet unclassified' }
GtLlmClassAssistant >> lookupPageTool [
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
GtLlmClassAssistant >> phlowInstructionSection [
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
GtLlmClassAssistant >> responseFormatSection [
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
SomeClass>>add: val
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
GtLlmClassAssistant >> serializerFor: aClass [
	^ GtLlmSerializableValueHolder new
		name: 'Class';
		content: aClass;
		serializer: [ :aModel | GtLlmValueSerializer new serializeClass: aClass ];
		updater: [ :object :aString | self error: 'Unimplemented' ]
]

{ #category : #'as yet unclassified' }
GtLlmClassAssistant >> treatProvider: aProvider [
	| anInstance |
	super treatProvider: aProvider.

	anInstance := aProvider chat serializer instance.

	aProvider
		assistantMessageClass: GtOpenAIClassMessage;
		userMessageClass: GtOpenAIClassMessage
]
