Class {
	#name : #GtCodeSnippetTutor,
	#superclass : #GtLlmTutor,
	#category : #'Gt4Llm-GToolkit'
}

{ #category : #'as yet unclassified' }
GtCodeSnippetTutor >> chatOnSnippet: aSnippet [
	^ self createChat
		onInstance: (GtLlmSerializableValueHolder new
				name: 'Code Snippet';
				content: aSnippet;
				serializer: [ :aModel | aModel sourceCode currentSourceText text asString ];
				updater: [ :aModel :aText | aModel forSource: aText ])
]

{ #category : #'as yet unclassified' }
GtCodeSnippetTutor >> codeSnippetFormatDescription [
	<gtLlmTutorFormat>
	^ GtLlmTutorFormatDescription new
		name: 'Code Snippet';
		priority: 2;
		format: 'Smalltalk code';
		example: 'Point x: 1 y: 10'
]

{ #category : #'as yet unclassified' }
GtCodeSnippetTutor >> defaultDescription [
	^ 'You are an assistant for code snippets.'
]

{ #category : #'as yet unclassified' }
GtCodeSnippetTutor >> defaultProviderStencil [
	^ [ :anInstructionFormat | 
	GtOpenAIAssistantProvider withApiKeyFromFile
		format: anInstructionFormat asJsonSchema;
		assistantMessageClass: GtOpenAICoderActionMessage;
		userMessageClass: GtOpenAICoderActionMessage;
		addTool: self lookupClassTool;
		addTool: self lookupPageTool;
		addTool: self getMethodTool;
		addTool: self getMethodsTool;
		addTool: self getImplementorsTool;
		addTool: self getReferencesTool;
		instructions: anInstructionFormat asInstructionPiece instructionString ]
]

{ #category : #'as yet unclassified' }
GtCodeSnippetTutor >> explanationAction [
	<gtLlmTutorAction>
	^ GtLlmTutorAction new
		name: 'Explain code';
		priority: 1;
		description: 'Explain the code snippet using the text field. Look up classes and documentation as needed to generate an answer.';
		examples: {GtLlmTutorActionExample new
					input: {'Action' -> 'Explain code'.
							'Code Snippet' -> '15 * 30'} asDictionary;
					output: {'Action' -> 'Explain code'.
							'Text'
								-> 'The snippet performs integer multiplication on the two numbers `15` and `30`. The result should be `450`.'.
							'Code Snippet' -> '15 * 30'} asDictionary}
]

{ #category : #'as yet unclassified' }
GtCodeSnippetTutor >> getImplementorsTool [
	^ GtLlmFunctionTool new
		name: 'getImplementors';
		parameters: {'methodName'};
		description: 'Gets a method by name and returns a list of methods that implement it.';
		block: [ :functionCall | 
			Character cr
				join: (functionCall anyArgument asSymbol gtImplementors result toArray wait collect: #name) ]
]

{ #category : #'as yet unclassified' }
GtCodeSnippetTutor >> getMethodTool [
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
GtCodeSnippetTutor >> getMethodsTool [
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
GtCodeSnippetTutor >> getReferencesTool [
	^ GtLlmFunctionTool new
		name: 'getReferences';
		parameters: {'methodName'};
		description: 'Gets a method by name and returns a list of methods that reference it.';
		block: [ :functionCall | 
			Character cr
				join: (functionCall anyArgument asSymbol gtReferences result toArray wait collect: #name) ]
]

{ #category : #'as yet unclassified' }
GtCodeSnippetTutor >> lookupClassTool [
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
GtCodeSnippetTutor >> lookupPageTool [
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
GtCodeSnippetTutor >> proposalAction [
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
							'Code Snippet' -> '15 * 30 ": subtract 5"'} asDictionary;
					output: {'Action' -> 'Propose code'.
							'Text' -> nil.
							'Code Snippet' -> '(15 * 30) ": subtract 5" - 5'} asDictionary}
]
