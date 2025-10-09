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
- A method definition is annotated with the type `method` and has a `class` it refers to. The body including the signature is defined in a `code` property. If the method is on the class side it has a separate `classSide` boolean property.
- A class removal is provided as a snippet with the type `removeClass` and has the `class` to remove.
- A method removal is provided as a snippet with the type `removeMethod` and has the `class` and `method` names. If the method is on the class side it has a separate `classSide` boolean property.

Smalltalk comments should always be escaped inside a JSON string like this: `"code": "\"this is a comment\" 1 + 2"`.

Example:
```json
[
	{"type": "removeMethod",
	 "class": "SomeClass",
	 "method": "someMethod:"},
	{"type": "removeClass",
	 "class": "SomeOtherClass"},
	{"type": "removeMethod",
	 "class": "SomeClass",
	 "method": "someClassSideMethod",
	 "classSide": true},
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
GtLlmAssistantLibraryForGt class >> getPropertyToolOn: anObject [
	^ GtLlmFunctionTool new
		name: 'getObjectProperty';
		parameters: {'propertyName'};
		description: 'Returns the property value by name. This can be an arbitrarily deeply nested accessor separated by spaces, including numbers to access a collection’s value by index (example: `property 2 collectionChildProperty`). Indices start at 1, not 0.';
		block: [ :functionCall | 
			self traverse: anObject using: (' ' split: functionCall anyArgument) ]
]

{ #category : #'as yet unclassified' }
GtLlmAssistantLibraryForGt class >> methodToRemoveOnTheClassSide [
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

{ #category : #tools }
GtLlmAssistantLibraryForGt class >> traverse: anObject using: aChain [
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
GtLlmAssistantLibraryForGt >> methodToRemoveOnTheInstanceSide [
]
