Class {
	#name : #GtLlmAssistantLibraryForGt,
	#superclass : #Object,
	#classInstVars : [
		'gtChat'
	],
	#category : #'Gt4Llm-GToolkit-UI'
}

{ #category : #formats }
GtLlmAssistantLibraryForGt class >> changesFormatWithPageSnippetMethodClass [
	^ GtLlmAssistantFormatDescription new
		name: 'Changes';
		priority: 2;
		format: 'Pharo code, Pharo snippets and other documentation snipepts wrapped in an array JSON objects';
		example: 'A list of snippets, class definitions and method definitions. It is always an array, even if only one item is needed. Pay attention to the Smalltalk comment syntax: Smalltalk comments should always be escaped inside a JSON string like `"\"this is a comment\""`. Split the items based on their intent:

*Pharo snippet*
A Pharo snippet is annotated with the type `pharoSnippet`. Its `content` contains Pharo scripts that can be executed independently.
- to add a new Pharo snippet:
{"type": "pharoSnippet",
"content": "55 @ (13 * (5 negatedArcTan))"}
- to modify an existing Pharo snippet:
{"type": "pharoSnippet",
"snippetId": "MI47LOX8DQC265VcBkswkA==",
"content": "55 @ (13 * (5 negatedArcTan))"}

*Text snippet*
A text snippet is annotated with the type `textSnippet` can support markdown and can also have annotations like {{gtClass:SomeClass}}, or {{gtMethod:SomeMethod}}.
- example to add a new text snippet:
{"type": "textSnippet",
"content": "This is a text snippet that can refer to {{gtClass:SomeClass}}, or {{gtMethod:SomeMethod}}"}
- example to modify an existing snippet:
{"type": "textSnippet",
"snippetId": "MI47LOX8DQC265VcBkswkA==",
"content": "This is a text snippet that can refer to {{gtClass:SomeClass}}, or {{gtMethod:SomeMethod}}"}

*Class definition*
A class definition should be specifically annotated with the type `class`. The actual definition is in the `code` property.
- example to add a class:
{"type": "class",
"code": "Object subclass: #SomeClass
instanceVariableNames: ''someSlotA someSlotB''
classVariableNames: ''''
package: ''SomePackage''"}

*Method definition*
A method definition is annotated with the type `method` and has a `class` it refers to. The body including the signature is defined in a `code` property. If the method is on the class side it has a separate `classSide` boolean property.
- example to add or modify a method:
{"type": "method",
"class": "Number",
"code": "invertedArcTan
 \"arctan but inverted\"
 ^ self arcTan negated"}
 - example to add or modify a class side method:
{"type": "method",
"class": "SomeClass",
"classSide": true,
"code": "classSideMethod
 ^ self new"}

*Class removal*
A class removal is provided as a snippet with the type `removeClass` and has the `class` to remove.
- example to remove a class:
{"type": "removeClass",
"class": "SomeOtherClass"}

*Method removal*
A method removal is provided as a snippet with the type `removeMethod` and has the `class` and `method` names. If the method is on the class side it has a separate `classSide` boolean property.
- example to remove a method
{"type": "removeMethod",
"class": "SomeClass",
"method": "someMethod:"}
- example to remove a class side method
{"type": "removeMethod",
"class": "SomeClass",
"method": "someMethod:",
"classSide": true}

Larger example:
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
	{"type": "pharoSnippet",
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

{ #category : #'as yet unclassified' }
GtLlmAssistantLibraryForGt class >> gtAssistant [
	| assistant |
	assistant := GtLlmAssistant new
			description: 'You are an assistant for Glamorous Toolkit.'.
	assistant instruction
		replaceFormatNamed: 'Text'
		with: GtLlmAssistantLibraryForGt textFormatWithSmalltalkBlocks.
	assistant instruction
		addComponent: GtLlmAssistantLibraryForGt changesFormatWithPageSnippetMethodClass.
	assistant
		addInstructionSectionForLepiterPages: #('Querying Pharo code with GT filters')
		titled: 'Code queries using GT filters'.
	assistant
		addInstructionSectionForLepiterPages: #('Inspector views' 'Inspector actions')
		titled: 'Phlow views and actions'.
	assistant
		addInstructionSectionForLepiterPages: #('Example-driven development tutorial: modeling prices' 'Warmup: understanding the Money classes')
		titled: 'Examples'.
	^ assistant
]

{ #category : #'as yet unclassified' }
GtLlmAssistantLibraryForGt class >> gtChat [
	^ gtChat
		ifNil: [ gtChat := self gtAssistant createChat.
			gtChat provider
				assistantMessageClass: GtOpenAIMessageForGT;
				userMessageClass: GtOpenAIMessageForGT.
			gtChat
				addTool: GtLlmToolForClassSearch new;
				addTool: GtLlmToolForClassSubclasses new;
				addTool: GtLlmToolForClassLookup new;
				addTool: GtLlmToolForClassReferences new;
				addTool: GtLlmToolForMethodReferences new;
				addTool: GtLlmToolForMethodImplementors new;
				addTool: GtLlmToolForMethodSource new;
				"addTool: GtLlmToolForExampleMethodRun new;"
				addTool: GtLlmToolForExampleClassesRun new;
				addTool: GtLlmToolForSearchFilter new;
				addTool: GtLlmToolForSearchForLepiterPages new;
				addTool: GtLlmToolForLepiterPageContents new;
				addTool: GtLlmToolForSmalltalkCodeEvaluation new ]
]

{ #category : #'as yet unclassified' }
GtLlmAssistantLibraryForGt class >> methodToRemoveOnTheClassSide [
]

{ #category : #'as yet unclassified' }
GtLlmAssistantLibraryForGt class >> resetGtChat [
	gtChat := nil
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

{ #category : #'as yet unclassified' }
GtLlmAssistantLibraryForGt class >> valueHolderForObject: anObject [
	^ GtLlmSerializableValueHolder new
		name: 'Object';
		content: anObject;
		serializer: [ :aModel | GtLlmValueSerializer new serializeValue: aModel ];
		updater: [  "not actually a good idea":object :aString | object readFromString: aString ]
]

{ #category : #'as yet unclassified' }
GtLlmAssistantLibraryForGt >> methodToRemoveOnTheInstanceSide [
]
