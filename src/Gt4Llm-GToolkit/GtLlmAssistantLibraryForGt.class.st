Class {
	#name : #GtLlmAssistantLibraryForGt,
	#superclass : #Object,
	#category : #'Gt4Llm-GToolkit-UI'
}

{ #category : #formats }
GtLlmAssistantLibraryForGt class >> codeFormatWithSnippetMethodClass [
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

{ #category : #formats }
GtLlmAssistantLibraryForGt class >> codeFormatWithSnippetMethodClassAndSourceSnippet [
	"<gtLlmAssistantFormat>"
	^ GtLlmAssistantFormatDescription new
		name: 'Code';
		priority: 2;
		format: 'Smalltalk code wrapped in an array of JSON objects';
		example: 'The result is a list of snippets, class definitions and method definitions. It is always an array, even if only one item is needed. Multiple items may be returned. Split the items based on their intent:
- A snippet is annotated with the type `snippet` it contains Smalltalk scripts that can be executed independently. The code is in the `code` property. The original snippet MUST ALWAYS be annotated with property `sourceSnippet` as `true`, no matter where in the list it is.
- A class definition is provided as a snippet, but should be specifically annotated with the type `class`.
- A method definition is annotated with the type `method` and has a class it refers to.

Smalltalk comments should always be escaped inside a JSON string like this: `"code": "\"this is a comment\" 1 + 2"`.

Example:
```json
[
	{"type": "snippet",
	 "code": "55 @ (13 * (5 negatedArcTan))",
	 "sourceSnippet": true},
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

Alternative order if another snippet is also added:
```json
[
	{"type": "snippet",
	 "code": "14 * 55"},
	{"type": "snippet",
	 "code": "55 @ (13 * (5 negatedArcTan))",
	 "sourceSnippet": true},
	{"type": "method",
	 "class": "Number",
	 "classSide": true,
	 "code": "classSideMethod
	 ^ self new instanceSideMethod"}
]
```'
]

{ #category : #tools }
GtLlmAssistantLibraryForGt class >> getActionsTool [
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

{ #category : #tools }
GtLlmAssistantLibraryForGt class >> getClassReferencesTool [
	^ GtLlmFunctionTool new
		name: 'getClassReferences';
		parameters: {'className'};
		description: 'Gets a class by name and returns a list of methods that reference it.';
		block: [ :functionCall | 
			| class |
			class := functionCall anyArgument asSymbol
					asClassInEnvironment: [ :x | x ]
					ifAbsent: [ nil ].
			class
				ifNil: [ 'Class not found' ]
				ifNotNil: [ :c | Character cr join: (c gtReferences result toArray wait collect: #name) ] ]
]

{ #category : #tools }
GtLlmAssistantLibraryForGt class >> getImplementorsTool [
	^ GtLlmFunctionTool new
		name: 'getImplementors';
		parameters: {'methodName'};
		description: 'Gets a method by name and returns a list of methods that implement it.';
		block: [ :functionCall | 
			Character cr
				join: (functionCall anyArgument asSymbol gtImplementors result toArray wait collect: #name) ]
]

{ #category : #tools }
GtLlmAssistantLibraryForGt class >> getMethodReferencesTool [
	^ GtLlmFunctionTool new
		name: 'getMethodReferences';
		parameters: {'methodName'};
		description: 'Gets a method by name and returns a list of methods that reference it.';
		block: [ :functionCall | 
			Character cr
				join: (functionCall anyArgument asSymbol gtReferences result toArray wait collect: #name) ]
]

{ #category : #tools }
GtLlmAssistantLibraryForGt class >> getMethodTool [
	^ GtLlmFunctionTool new
		name: 'getCodeOfMethod';
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

{ #category : #tools }
GtLlmAssistantLibraryForGt class >> getPropertyToolOn: anObject [
	^ GtLlmFunctionTool new
		name: 'getObjectProperty';
		parameters: {'propertyName'};
		description: 'Returns the property value by name. This can be an arbitrarily deeply nested accessor separated by spaces, including numbers to access a collection’s value by index (example: `property 2 collectionChildProperty`). Indices start at 1, not 0.';
		block: [ :functionCall | 
			self traverse: anObject using: (' ' split: functionCall anyArgument) ]
]

{ #category : #tools }
GtLlmAssistantLibraryForGt class >> getViewsTool [
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

{ #category : #tools }
GtLlmAssistantLibraryForGt class >> lookupClassTool [
	^ GtLlmFunctionTool new
		name: 'lookupClass';
		parameters: {'className'};
		description: 'Get the details of a class as JSON.';
		block: [ :functionCall | 
			(functionCall anyArgument asClassIfAbsent: [ nil ])
				ifNil: [ 'Class not found' ]
				ifNotNil: [ :aClass | STONJSON toString: (GtLlmValueSerializer new serializeClass: aClass) ] ]
]

{ #category : #tools }
GtLlmAssistantLibraryForGt class >> lookupPageTool [
	^ GtLlmFunctionTool new
		name: 'lookupDocumentationPage';
		parameters: {'pageName'};
		description: 'Looks up a documentation page by name and returns its content in Markdown format. `pageName` may be a substring. If multiple pages are found, only the first one will be returned.';
		block: [ :functionCall |
			(LeDatabase gtBook asyncPagesForWord: functionCall anyArgument) toArray wait
				ifEmpty: [ 'No page found' ]
				ifNotEmpty: [ :pages | pages first asMarkdownPage ] ]
]

{ #category : #tools }
GtLlmAssistantLibraryForGt class >> searchClassesTool [
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

{ #category : #formats }
GtLlmAssistantLibraryForGt class >> textFormatWithSmalltalkBlocks [
	^ GtLlmAssistantFormatDescription new
		name: 'Text';
		priority: 1;
		format: 'Text';
		example: 'The text is in Markdown. In addition, it also supports annotations for classes and methods.
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
