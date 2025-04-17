Class {
	#name : #GtLlmCodeSnippetTutor,
	#superclass : #GtLlmTutor,
	#category : #'Gt4Llm-GToolkit'
}

{ #category : #'as yet unclassified' }
GtLlmCodeSnippetTutor >> chatOnCoderViewModel: aCoderViewModel [
	| chat |
	chat := (self createChatOn: aCoderViewModel)
			onInstance: (GtLlmCustomSerializationValueHolder new
					name: 'Code Snippet';
					content: aCoderViewModel;
					serializer: [ :aModel | 
						{'Code Snippet' -> aModel coderModel sourceCode currentSourceText text asString.
							'Variables'
								-> ((aModel sharedBindings bindings associations
										collect: [ :aPair | 
											{'name' -> aPair key.
												'value' -> aPair value value asString} asDictionary ])
										asOrderedCollection
										add: {'name' -> 'self'.
												'value' -> aModel selfObject asString} asDictionary;
										asArray)} ];
					updater: [ :aModel :aText | aModel coderModel forSource: aText ]).

	^ chat
]

{ #category : #'as yet unclassified' }
GtLlmCodeSnippetTutor >> codeSnippetFormatDescription [
	<gtLlmTutorFormat>
	^ GtLlmTutorFormatDescription new
		name: 'Code Snippet';
		priority: 2;
		format: 'Smalltalk code';
		example: 'Point x: 1 y: 10'
]

{ #category : #'as yet unclassified' }
GtLlmCodeSnippetTutor >> createChatOn: aCoderViewModel [
	^ GtLlmActionChat new
		provider: (self providerStencil cull: instruction cull: aCoderViewModel);
		tutor: self
]

{ #category : #'as yet unclassified' }
GtLlmCodeSnippetTutor >> defaultDescription [
	^ 'You are an assistant for code snippets.'
]

{ #category : #'as yet unclassified' }
GtLlmCodeSnippetTutor >> defaultProviderStencil [
	^ [ :anInstructionFormat :aCoderViewModel | 
	GtOpenAIResponseProvider withApiKeyFromFile
		format: anInstructionFormat asJsonSchema;
		assistantMessageClass: GtOpenAICoderActionMessage;
		userMessageClass: GtOpenAICoderActionMessage;
		addTool: self lookupClassTool;
		addTool: self lookupPageTool;
		addTool: self getMethodTool;
		addTool: self getMethodsTool;
		addTool: self getImplementorsTool;
		addTool: self getReferencesTool;
		addTool: (self lookupBindingToolFor: aCoderViewModel);
		instructions: anInstructionFormat asInstructionPiece instructionString ]
]

{ #category : #'as yet unclassified' }
GtLlmCodeSnippetTutor >> explanationAction [
	<gtLlmTutorAction>
	^ GtLlmTutorAction new
		name: 'Explain code';
		priority: 1;
		description: 'Explain the code snippet using the text field. Look up classes and documentation as needed to generate an answer.';
		examples: {GtLlmTutorActionExample new
					input: {'Action' -> 'Explain code'.
							'Code Snippet' -> '15 * 30'.
							'Variables' -> {}} asDictionary;
					output: {'Action' -> 'Explain code'.
							'Text'
								-> 'The snippet performs integer multiplication on the two numbers `15` and `30`. The result should be `450`.'.
							'Code Snippet' -> '15 * 30'.
							'Variables' -> nil} asDictionary}
]

{ #category : #'as yet unclassified' }
GtLlmCodeSnippetTutor >> getImplementorsTool [
	^ GtLlmFunctionTool new
		name: 'getImplementors';
		parameters: {'methodName'};
		description: 'Gets a method by name and returns a list of methods that implement it.';
		block: [ :functionCall | 
			Character cr
				join: (functionCall anyArgument asSymbol gtImplementors result toArray wait collect: #name) ]
]

{ #category : #'as yet unclassified' }
GtLlmCodeSnippetTutor >> getMethodTool [
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
GtLlmCodeSnippetTutor >> getMethodsTool [
	^ GtLlmFunctionTool new
		name: 'getClassMethods';
		parameters: {'className'};
		description: 'Gets a class by name and returns a list of its methods.';
		block: [ :functionCall | 
			(functionCall anyArgument asClassIfAbsent: [ nil ])
				ifNil: [ 'Class not found' ]
				ifNotNil: [ :aClass | Character cr join: (aClass allMethods collect: #selector) ] ]
]

{ #category : #'as yet unclassified' }
GtLlmCodeSnippetTutor >> getReferencesTool [
	^ GtLlmFunctionTool new
		name: 'getReferences';
		parameters: {'methodName'};
		description: 'Gets a method by name and returns a list of methods that reference it.';
		block: [ :functionCall | 
			Character cr
				join: (functionCall anyArgument asSymbol gtReferences result toArray wait collect: #name) ]
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
GtLlmCodeSnippetTutor >> lookupClassTool [
	^ GtLlmFunctionTool new
		name: 'lookupClass';
		parameters: {'className'};
		description: 'Looks up documentation for a class by name and returns its content in Markdown format.';
		block: [ :functionCall | 
			((functionCall anyArgument) asClassIfAbsent: [ nil ])
				ifNil: [ 'Class not found' ]
				ifNotNil: [ :aClass | aClass instanceSide organization classComment ] ]
]

{ #category : #'as yet unclassified' }
GtLlmCodeSnippetTutor >> lookupPageTool [
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
							'Variables'
								-> {{'name' -> 'x'.
											'value' -> '12'} asDictionary}} asDictionary;
					output: {'Action' -> 'Propose code'.
							'Text' -> nil.
							'Code Snippet' -> '(15 * 30) ": subtract 5" - 5'.
							'Variables' -> nil} asDictionary}
]

{ #category : #'as yet unclassified' }
GtLlmCodeSnippetTutor >> responseFormatSection [
	<gtLlmInstructionSection>
	^ GtLlmInstructionSection new
		source: self;
		title: 'Response Format Concerns';
		body: 'The response format in textual responses should be Markdown. Apart from regular Markdown, it also supports annotations for classes and methods.
		
Classes may be annotated using `{{gtClass:ClassName}}`, where `ClassName` is the name of the class to be referenced.

Likewise, methods may be annotated using `{{gtMethod:ClassName>>#methodName}}`, where `ClassName` is the name of the class and `methodName` is the name of the method.'
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
