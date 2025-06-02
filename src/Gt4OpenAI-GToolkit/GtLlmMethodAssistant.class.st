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
						{'Code'
								-> (STONJSON
										toString: {{'type' -> 'method'.
													'class' -> aModel coderModel methodBehavior behavior asString.
													'code'
														-> aModel coderModel sourceCode currentSourceText text asString}
													asDictionary}).
							'Object' -> (GtLlmValueSerializer new serializeValue: aModel selfObject)} ];
					updater: [ :aModel :aText | aModel coderModel forSource: aText ]);
			provider: self buildProvider.

	^ chat
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
 		priority: 20;
 		description: 'I want to check the functionality of the attached method.  Can you propose a GlamorousToolkit example method that tests it.  The method should:
- be put into a new appropriately named example class,
- be annotated with the ''<gtExample>'' pragma,
- create an instance of the attached method''s class (from the `class` property),
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
							'Code'
								-> '[{"type": "method", "class": "FixedWidthRectangle", "code": "width
	^ 15 * 30 \": subtract 5\""}]'.
							'Object'
								-> '{"string":"nil","instanceSlots":[],"class":"UndefinedObject"}'}
							asDictionary;
					output: {'Action' -> 'Propose code'.
							'Arguments' -> nil.
							'Text' -> nil.
							'Object'
								-> '{"string":"nil","instanceSlots":[],"class":"UndefinedObject"}'.
							'Code'
								-> '[{"type": "method", "class": "FixedWidthRectangle", "code": "width
	^ 15 * 30 \": subtract 5\" - 5"}]'} asDictionary}
]

{ #category : #proposals }
GtLlmMethodAssistant >> proposeRenamesAction [
	<gtLlmAssistantAction>
	^ GtLlmAssistantAction new
		name: 'Rename method';
		priority: 3;
		description: 'Propose a few potential renames for the method.';
		examples: {GtLlmAssistantActionExample new
					input: {'Action' -> 'Rename method'.
							'Arguments' -> {}.
							'Code'
								-> '[{"type": "method", "class": "FixedWidthRectangle", "code": "width
	^ 15 * 30"}]'.
							'Object'
								-> '{"string":"a FixedWidthRectangle","instanceSlots":[],"class":"FixedWidthRectangle"}'}
							asDictionary;
					output: {'Action' -> 'Rename method'.
							'Arguments' -> {}.
							'Text' -> ''.
							'Object'
								-> '{"string":"a FixedWidthRectangle","instanceSlots":[],"class":"FixedWidthRectangle"}'.
							'Code'
								-> '[{"type": "method", "class": "FixedWidthRectangle", "code": "fixedWidth
	^ 15 * 30"}, {"type": "method", "class": "FixedWidthRectangle", "code": "staticWidth
	^ 15 * 30"}]'} asDictionary}
]

{ #category : #proposals }
GtLlmMethodAssistant >> reviewAction [
	<gtLlmAssistantAction>
	^ GtLlmAssistantAction new
		name: 'Review method';
		priority: 3;
		description: 'Review the code as if you were a senior developer doing a code review.';
		examples: {GtLlmAssistantActionExample new
					input: {'Action' -> 'Review method'.
							'Arguments' -> {}.
							'Code'
								-> '[{"type": "method", "class": "FixedWidthRectangle", "code": "width
	^ 15 * 30"}]'.
							'Object'
								-> '{"string":"a FixedWidthRectangle","instanceSlots":[],"class":"FixedWidthRectangle"}'}
							asDictionary;
					output: {'Action' -> 'Review method'.
							'Arguments' -> {}.
							'Text' -> 'The method should inline the calculation. To avoid having just a magic number there, we should use a method comment explaining how the number was derived.'.
							'Object'
								-> '{"string":"a FixedWidthRectangle","instanceSlots":[],"class":"FixedWidthRectangle"}'.
							'Code'
								-> '[{"type": "method", "class": "FixedWidthRectangle", "code": "width
	\"fixed with is always 15 * 30=450\"
	^ 450"}]'} asDictionary}
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

	aProvider
		assistantMessageClass: GtOpenAICoderActionMessage;
		userMessageClass: GtOpenAICoderActionMessage
]
