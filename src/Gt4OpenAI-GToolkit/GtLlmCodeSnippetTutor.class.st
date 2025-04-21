Class {
	#name : #GtLlmCodeSnippetTutor,
	#superclass : #GtLlmObjectTutor,
	#category : #'Gt4OpenAI-GToolkit'
}

{ #category : #'as yet unclassified' }
GtLlmCodeSnippetTutor >> chatOn: aCoderViewModel [
	| chat |
	chat := self createChat.

	chat
		onInstance: (GtLlmCustomSerializationValueHolder new
				name: 'Code Snippet';
				content: aCoderViewModel;
				serializer: [ :aModel | 
					{'Code Snippet' -> aModel coderModel sourceCode currentSourceText text asString.
						'Object' -> (GtLlmValueSerializer new serializeValue: aModel selfObject).
						'Variables'
							-> (aModel sharedBindings bindings associations
									collect: [ :aPair | 
										{'name' -> aPair key.
											'value' -> aPair value value asString} asDictionary ])} ];
				updater: [ :aModel :aText | aModel coderModel forSource: aText ]).

	chat provider addTool: (self lookupBindingToolFor: aCoderViewModel).
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
GtLlmCodeSnippetTutor >> codeSnippetFormatDescription [
	<gtLlmTutorFormat>
	^ GtLlmTutorFormatDescription new
		name: 'Code Snippet';
		priority: 2;
		format: 'Smalltalk code';
		example: '```
Point x: 1 y: 10
```'
]

{ #category : #'as yet unclassified' }
GtLlmCodeSnippetTutor >> defaultDescription [
	^ 'You are an assistant for code snippets.'
]

{ #category : #'as yet unclassified' }
GtLlmCodeSnippetTutor >> defaultProviderStencil [
	^ [ :anInstructionFormat| 
	GtOpenAIResponseProvider withApiKeyFromFile
		format: anInstructionFormat asJsonSchema;
		assistantMessageClass: GtOpenAICoderActionMessage;
		userMessageClass: GtOpenAICoderActionMessage;
		instructions: anInstructionFormat asInstructionPiece instructionString ]
]

{ #category : #'as yet unclassified' }
GtLlmCodeSnippetTutor >> lookupBindingToolFor: aCoderViewModel [
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
GtLlmCodeSnippetTutor >> proposalAction [
	<gtLlmTutorAction>
	^ GtLlmTutorAction new
		name: 'Propose code';
		priority: 3;
		description: 'Interpret the comments and propose code using the `Code Snippet` field. The typical comment command is formatted as `": some command"`. Only propose Pharo code unless otherwise asked. The proposed code should leave the comments untouched.
If you want to add explanations, place them in the `Text` field. If the explanation contains code, always place code in a code block using Markdown and explicitly denoting it with smalltalk. Like this:
```smalltalk
"Smalltalk code here"
```
You can look up classes, methods and documentation in the current Glamorous Toolkit image. Only rely on such look up when absolutely needed.';
		examples: {GtLlmTutorActionExample new
					input: {'Action' -> 'Propose code'.
							'Code Snippet' -> '15 * 30 ": subtract 5"'.
							'Object' -> '{"string":"nil","instanceSlots":[],"class":"UndefinedObject"}'.
							'Variables'
								-> {{'name' -> 'x'.
											'value' -> '12'} asDictionary}} asDictionary;
					output: {'Action' -> 'Propose code'.
							'Text' -> nil.
							'Object' -> '{"string":"nil","instanceSlots":[],"class":"UndefinedObject"}'.
							'Code Snippet' -> '(15 * 30) ": subtract 5" - 5'.
							'Variables' -> nil.
							'Method' -> nil} asDictionary}
]

{ #category : #'as yet unclassified' }
GtLlmCodeSnippetTutor >> snippetExplanationAction [
	<gtLlmTutorAction>
	^ GtLlmTutorAction new
		name: 'Explain snippet';
		priority: 2;
		description: 'Explain the code snippet using the text field. Look up classes and documentation as needed to generate an answer.';
		examples: {GtLlmTutorActionExample new
					input: {'Action' -> 'Explain code'.
							'Code Snippet' -> '15 * 30'.
							'Variables' -> {}.
							'Object'
								-> '{"string":"nil","instanceSlots":[],"class":"UndefinedObject"}'}
							asDictionary;
					output: {'Action' -> 'Explain code'.
							'Text'
								-> 'The snippet performs integer multiplication on the two numbers `15` and `30`. The result should be `450`.'.
							'Code Snippet' -> '15 * 30'.
							'Object'
								-> '{"string":"nil","instanceSlots":[],"class":"UndefinedObject"}'.
							'Variables' -> nil.
							'Method' -> nil} asDictionary}
]

{ #category : #'as yet unclassified' }
GtLlmCodeSnippetTutor >> treatBinding: aBinding in: aSnippetCoderViewModel [
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
GtLlmCodeSnippetTutor >> variablesFormatDescription [
	<gtLlmTutorFormat>
	^ GtLlmTutorFormatDescription new
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

{ #category : #'as yet unclassified' }
GtLlmCodeSnippetTutor >> viewProposalAction [
	<gtLlmTutorAction>
	^ GtLlmTutorAction new
		name: 'Propose a view';
		priority: 5;
		description: 'Propose a useful Phlow view for the object bound by `self`, on the code in the snippet. Only reply with the Smalltalk code for the view. Look up existing views and their code for reference if needed.';
		examples: {GtLlmTutorActionExample new
					input: {'Action' -> 'Propose a view'.
							'Code Snippet' -> 'self monies'.
							'Object'
								-> '{"string":"a GtTMoneyBag","instanceSlots":[{"name":"monies","class":"OrderedCollection","value":"an OrderedCollection(a GtTCurrencyMoney a GtTCurrencyMoney)"}],"class":"GtTMoneyBag"}'.
							'Variables' -> {}} asDictionary;
					output: {'Action' -> 'Propose a view'.
							'Object'
								-> '{"string":"a GtTMoneyBag","instanceSlots":[{"name":"monies","class":"OrderedCollection","value":"an OrderedCollection(a GtTCurrencyMoney a GtTCurrencyMoney)"}],"class":"GtTMoneyBag"}'.
							'Method'
								-> 'gtMoniesFor: aView
	<gtView>
	^ aView list
		title: ''Monies'';
		priority: 10;
		items: [ self monies ]'.
							'Code Snippet' -> 'self monies'.
							'Variables' -> nil.
							'Text' -> ''} asDictionary}
]
