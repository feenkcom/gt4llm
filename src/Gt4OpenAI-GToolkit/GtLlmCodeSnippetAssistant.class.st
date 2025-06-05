Class {
	#name : #GtLlmCodeSnippetAssistant,
	#superclass : #GtLlmObjectAssistant,
	#category : #'Gt4OpenAI-GToolkit'
}

{ #category : #'as yet unclassified' }
GtLlmCodeSnippetAssistant >> chatOn: aCoderViewModel [
	| chat |
	chat := GtLlmActionChat new
			onInstance: (GtLlmCustomSerializationValueHolder new
					name: 'Code Snippet';
					content: aCoderViewModel;
					serializer: [ :aModel | 
						{'Code'
								-> (STONJSON
										toString: {{'type' -> 'snippet'.
													'code'
														-> aModel coderModel sourceCode currentSourceText text asString.
													'source_snippet' -> true} asDictionary}).
							'Object' -> (GtLlmValueSerializer new serializeValue: aModel selfObject).
							'Variables'
								-> (aModel sharedBindings bindings associations
										collect: [ :aPair | 
											{'name' -> aPair key.
												'value'
													-> (GtLlmValueSerializer new serializeValue: aPair value value)}
												asDictionary ])} ];
					updater: [ :aModel :aText | aModel coderModel forSource: aText ]);
			assistant: self;
			provider: self buildProvider.

	^ chat
]

{ #category : #'as yet unclassified' }
GtLlmCodeSnippetAssistant >> codeFormatDescription [
	<gtLlmAssistantFormat>
	^ GtLlmAssistantFormatDescription new
		name: 'Code';
		priority: 2;
		format: 'Smalltalk code wrapped in an array JSON objects';
		example: 'Snippets and methods should be given here. There are two types to the objects returned here: `snippet` and `method`. Method objects also have a class they refer to. It should always be an array, even if only one item is needed. Multiple items may be returned. If the method is to be installed on the class side rather than the instance side, set the optional `classSide` property to `true`. The original snippet MUST ALWAYS be annotated with `source_snippet`, no matter where in the list it is.
		
Example:
```json
[
	{"type": "snippet",
	 "code": "55 @ (13 * (5 negatedArcTan))",
	 "source_snippet": true},
	{"type": "method",
	 "class": "Number",
	 "code": "invertedArcTan
	 ^ self arcTan negated"},
	{"type": "method",
	 "class": "Number",
	 "classSide": true,
	 "code": "classSideMethod
	 ^ self new instanceSideMethod"}
]
```

Alternative order if another snippet is also added:
```json
[
	{"type": "snippet",
	 "code": "14 * 55"},
	{"type": "snippet",
	 "code": "55 @ (13 * (5 negatedArcTan))",
	 "source_snippet": true},
	{"type": "method",
	 "class": "Number",
	 "classSide": true,
	 "code": "classSideMethod
	 ^ self new instanceSideMethod"}
]
```'
]

{ #category : #'as yet unclassified' }
GtLlmCodeSnippetAssistant >> defaultDescription [
	^ 'You are an assistant for code snippets.'
]

{ #category : #'as yet unclassified' }
GtLlmCodeSnippetAssistant >> lookupBindingToolFor: aCoderViewModel [
	^ GtLlmFunctionTool new
		name: 'lookupVariableBinding';
		parameters: {'variableName'};
		description: 'Looks up a variable binding by name and returns detailed information about the binding, such as type/class information, variable type, and values of slots. This should only be used if a detailed view of the variable value or metainformation is necessary, or if the variable is not found elsewhere (might be the case for `self`, `super` and other special variables). Otherwise refer to the `Variables` key in the request.';
		block: [ :functionCall | 
			(aCoderViewModel compositeVariableBindings bindingOf: functionCall anyArgument)
				ifNil: [ 'Variable not found' ]
				ifNotNil: [ :aBinding | 
					self treatBinding: aBinding in: aCoderViewModel ] ]
]

{ #category : #'as yet unclassified' }
GtLlmCodeSnippetAssistant >> proposalAction [
	<gtLlmAssistantAction>
	^ GtLlmAssistantAction new
		name: 'Propose code';
		priority: 3;
		description: 'Interpret the comments and propose code using the `Code` field. The typical comment command is formatted as `": some command"`. Only propose Pharo code unless otherwise asked. The proposed code should leave the comments untouched.
If you want to add explanations, place them in the `Text` field. If the explanation contains code, always place code in a code block using Markdown and explicitly denoting it with smalltalk. Like this:
```smalltalk
"Smalltalk code here"
```
You can look up classes, methods and documentation in the current Glamorous Toolkit image. Only rely on such look up when absolutely needed.';
		examples: {GtLlmAssistantActionExample new
					input: {'Action' -> 'Propose code'.
							'Code' -> '[{"type": "snippet"; "code": "15 * 30 \": subtract 5\""}]'.
							'Object'
								-> '{"string":"nil","instanceSlots":[],"class":"UndefinedObject"}'.
							'Variables'
								-> {{'name' -> 'x'.
											'value' -> '12'} asDictionary}} asDictionary;
					output: {'Action' -> 'Propose code'.
							'Arguments' -> nil.
							'Text' -> nil.
							'Object'
								-> '{"string":"nil","instanceSlots":[],"class":"UndefinedObject"}'.
							'Code' -> '[{"type": "snippet"; "code": "15 * 30 \": subtract 5\" - 5"}]'.
							'Variables' -> nil} asDictionary}
]

{ #category : #'as yet unclassified' }
GtLlmCodeSnippetAssistant >> snippetExplanationAction [
	<gtLlmAssistantAction>
	^ GtLlmAssistantAction new
		name: 'Explain snippet';
		priority: 2;
		description: 'Explain the code snippet using the text field. Look up classes and documentation as needed to generate an answer.';
		examples: {GtLlmAssistantActionExample new
					input: {'Action' -> 'Explain code'.
							'Code' -> '[{"type": "snippet"; "code": "15 * 30"}]'.
							'Variables' -> {}.
							'Object'
								-> '{"string":"nil","instanceSlots":[],"class":"UndefinedObject"}'}
							asDictionary;
					output: {'Action' -> 'Explain code'.
							'Arguments' -> nil.
							'Text'
								-> 'The snippet performs integer multiplication on the two numbers `15` and `30`. The result should be `450`.'.
							'Code' -> '[{"type": "snippet"; "code": "15 * 30"}]'.
							'Object'
								-> '{"string":"nil","instanceSlots":[],"class":"UndefinedObject"}'.
							'Variables' -> nil} asDictionary}
]

{ #category : #'as yet unclassified' }
GtLlmCodeSnippetAssistant >> treatBinding: aBinding in: aSnippetCoderViewModel [
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
GtLlmCodeSnippetAssistant >> treatProvider: aProvider [
	| aCoderViewModel |
	super treatProvider: aProvider.

	aCoderViewModel := aProvider chat serializer instance content.

	aProvider tools: GtLlmToolsGroup new.
	aProvider addTool: (self lookupBindingToolFor: aCoderViewModel).
	aProvider addTool: (self getPropertyToolOn: aCoderViewModel selfObject).
	aProvider addTool: self lookupClassTool.
	aProvider addTool: self lookupPageTool.
	aProvider addTool: self getImplementorsTool.
	aProvider addTool: self getReferencesTool.
	aProvider addTool: self getMethodTool.

	aProvider
		assistantMessageClass: GtOpenAICodeSnippetActionMessage;
		userMessageClass: GtOpenAICodeSnippetActionMessage
]

{ #category : #'as yet unclassified' }
GtLlmCodeSnippetAssistant >> variablesFormatDescription [
	<gtLlmAssistantFormat>
	^ GtLlmAssistantFormatDescription new
		name: 'Variables';
		type: 'array';
		items: {'type' -> 'object'.
				'properties'
					-> {'name'
								-> {'type' -> 'string'.
										'description' -> 'Variable name'} asDictionary.
							'value'
								-> {'type' -> 'string'.
										'description' -> 'Variable value'} asDictionary} asDictionary.
				'required'
					-> {'name'.
							'value'}.
				'additionalProperties' -> false} asDictionary;
		priority: 2;
		format: 'Dictionary';
		example: '{"aVariable": "aValue"; "anotherVariable": "15"}'
]
