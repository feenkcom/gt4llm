Class {
	#name : #GtLlmMethodAssistant,
	#superclass : #GtLlmObjectAssistant,
	#category : #'Gt4OpenAI-GToolkit'
}

{ #category : #'as yet unclassified' }
GtLlmMethodAssistant >> chatOn: aCoderViewModel [
	| chat |
	chat := GtLlmActionChat new
			assistant: self;
			onInstance: (GtLlmCustomSerializationValueHolder new
					name: 'Code Snippet';
					content: aCoderViewModel;
					serializer: [ :aModel | 
						{'Method' -> aModel coderModel sourceCode currentSourceText text asString.
							'Class' -> aModel coderModel methodBehavior asString.
							'Object' -> (GtLlmValueSerializer new serializeValue: aModel selfObject)} ];
					updater: [ :aModel :aText | aModel coderModel forSource: aText ]);
			provider: self buildProvider.

	^ chat
]

{ #category : #'as yet unclassified' }
GtLlmMethodAssistant >> classFormatDescription [
	<gtLlmAssistantFormat>
	^ GtLlmAssistantFormatDescription new
		name: 'Class';
		priority: 2;
		format: 'Text';
		example: '```
Object
```'
]

{ #category : #'as yet unclassified' }
GtLlmMethodAssistant >> defaultDescription [
	^ 'You are an assistant for code snippets.'
]

{ #category : #proposals }
GtLlmMethodAssistant >> gtProposeCheckExample [
 	<gtLlmAssistantAction>
 	^ GtLlmAssistantAction new
 		name: 'Propose an example';
 		priority: 1;
 		description: 'I want to check the functionality of the attached method.  Can you propose a GlamorousToolkit example method that tests it.  The method should:
- be annotated with the ''<gtExample>'' pragma,
- create an instance of the attached method''s class (from the `Class` property),
- add appropriate assertions,
- and should return the object being tested.';
 		examples: {}
]

{ #category : #proposals }
GtLlmMethodAssistant >> proposalAction [
	<gtLlmAssistantAction>
	^ GtLlmAssistantAction new
		name: 'Propose code';
		priority: 3;
		description: 'Interpret the comments and propose code using the `Code Snippet` field. The typical comment command is formatted as `": some command"`. Only propose Pharo code unless otherwise asked. The proposed code should leave the comments untouched.
If you want to add explanations, place them in the `Text` field. If the explanation contains code, always place code in a code block using Markdown and explicitly denoting it with smalltalk. Like this:
```smalltalk
"Smalltalk code here"
```
You can look up classes, methods and documentation in the current Glamorous Toolkit image. Only rely on such look up when absolutely needed.';
		examples: {GtLlmAssistantActionExample new
					input: {'Action' -> 'Propose code'.
							'Method'
								-> 'width
	^ 15 * 30 ": subtract 5"'.
							'Class' -> 'FixedWidthRectangle'.
							'Object'
								-> '{"string":"nil","instanceSlots":[],"class":"UndefinedObject"}'}
							asDictionary;
					output: {'Action' -> 'Propose code'.
							'Text' -> nil.
							'Object'
								-> '{"string":"nil","instanceSlots":[],"class":"UndefinedObject"}'.
							'Class' -> 'FixedWidthRectangle'.
							'Method'
								-> 'width
	^ (15 * 30) ": subtract 5" - 5'} asDictionary}
]

{ #category : #'as yet unclassified' }
GtLlmMethodAssistant >> treatBinding: aBinding in: aSnippetCoderViewModel [
	| bindingValue |
	bindingValue := aBinding value.
	aBinding isSelfVariable
		ifTrue: [ bindingValue := aSnippetCoderViewModel selfObject ].
	aBinding isSuperVariable
		ifTrue: [ bindingValue := aSnippetCoderViewModel selfObject ].
	aBinding isThisContextVariable
		ifTrue: [ bindingValue := aSnippetCoderViewModel context ].

	^ STONJSON
		toStringPretty: (GtLlmValueSerializer new serializeBinding: aBinding withValue: bindingValue)
]

{ #category : #'as yet unclassified' }
GtLlmMethodAssistant >> treatProvider: aProvider [
	| aCoderViewModel |
	super treatProvider: aProvider.
	
	aCoderViewModel := aProvider chat serializer instance content.
	
	aProvider addTool: (self getPropertyToolOn: aCoderViewModel selfObject).
	aProvider addTool: self lookupClassTool.
	aProvider addTool: self lookupPageTool.
	aProvider addTool: self getImplementorsTool.
	aProvider addTool: self getReferencesTool.
	aProvider addTool: self getMethodTool.
	aProvider addTool: self getMethodsTool.

	aProvider
		assistantMessageClass: GtOpenAICoderActionMessage;
		userMessageClass: GtOpenAICoderActionMessage
]
