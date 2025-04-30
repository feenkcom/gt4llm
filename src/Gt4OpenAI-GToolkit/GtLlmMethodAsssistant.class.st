Class {
	#name : #GtLlmMethodAsssistant,
	#superclass : #GtLlmObjectAssistant,
	#category : #'Gt4OpenAI-GToolkit'
}

{ #category : #'as yet unclassified' }
GtLlmMethodAsssistant >> chatOn: aCoderViewModel [
	| chat |
	chat := self createChat.

	chat
		onInstance: (GtLlmCustomSerializationValueHolder new
				name: 'Code Snippet';
				content: aCoderViewModel;
				serializer: [ :aModel | 
					{'Method' -> aModel coderModel sourceCode currentSourceText text asString.
						'Object' -> (GtLlmValueSerializer new serializeValue: aModel selfObject)} ];
				updater: [ :aModel :aText | aModel coderModel forSource: aText ]).

	chat provider addTool: (self getPropertyToolOn: aCoderViewModel selfObject).
	chat provider addTool: self lookupClassTool.
	chat provider addTool: self lookupPageTool.
	chat provider addTool: self getImplementorsTool.
	chat provider addTool: self getReferencesTool.
	chat provider addTool: self getMethodTool.
	chat provider addTool: self getMethodsTool.

	^ chat
]

{ #category : #'as yet unclassified' }
GtLlmMethodAsssistant >> defaultDescription [
	^ 'You are an assistant for code snippets.'
]

{ #category : #'as yet unclassified' }
GtLlmMethodAsssistant >> defaultProviderStencil [
	^ [ :anInstructionFormat| 
	GtOpenAIResponseProvider withApiKeyFromFile
		format: anInstructionFormat asJsonSchema;
		assistantMessageClass: GtOpenAICoderActionMessage;
		userMessageClass: GtOpenAICoderActionMessage;
		instructions: anInstructionFormat asInstructionPiece instructionString ]
]

{ #category : #'as yet unclassified' }
GtLlmMethodAsssistant >> proposalAction [
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
							'Method' -> 'width
	^ 15 * 30 ": subtract 5"'.
							'Object' -> '{"string":"nil","instanceSlots":[],"class":"UndefinedObject"}'} asDictionary;
					output: {'Action' -> 'Propose code'.
							'Text' -> nil.
							'Object' -> '{"string":"nil","instanceSlots":[],"class":"UndefinedObject"}'.
							'Method' -> 'width
	^ (15 * 30) ": subtract 5" - 5'} asDictionary}
]

{ #category : #'as yet unclassified' }
GtLlmMethodAsssistant >> treatBinding: aBinding in: aSnippetCoderViewModel [
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
