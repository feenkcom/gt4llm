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
		instructions: anInstructionFormat asInstructionPiece instructionString ]
]

{ #category : #'as yet unclassified' }
GtCodeSnippetTutor >> explanationAction [
	<gtLlmTutorAction>
	^ GtLlmTutorAction new
		name: 'Explain the code';
		priority: 1;
		description: 'Explains the code snippet using the text field. Look up classes and documentation as needed to generate an answer.';
		examples: {GtLlmTutorActionExample new
					input: {'Action' -> 'Explain the code'.
							'Code Snippet' -> '15 * 30'} asDictionary;
					output: {'Action' -> 'Explain the code'.
							'Text'
								-> 'The snippet performs integer multiplication on the two numbers `15` and `30`. The result should be `450`.'.
							'Code Snippet' -> '15 * 30'} asDictionary}
]

{ #category : #'as yet unclassified' }
GtCodeSnippetTutor >> lookupClassTool [
	^ GtLlmFunctionTool new
		name: 'lookupClass';
		parameters: {'className'};
		description: 'Looks up documentation for a class by name and returns its content in Markdown format.';
		block: [ :arguments | 
			(arguments first asClassIfAbsent: [ nil ])
				ifNil: [ 'Class not found' ]
				ifNotNil: [ :aClass | aClass instanceSide organization classComment ] ]
]

{ #category : #'as yet unclassified' }
GtCodeSnippetTutor >> lookupPageTool [
	^ GtLlmFunctionTool new
		name: 'lookupDocumentationPage';
		parameters: {'pageName'};
		description: 'Looks up a documentation page by name and returns its content in Markdown format. `pageName` may be a substring. If multiple pages are found, only the first one will be returned.';
		block: [ :arguments | 
			(LeDatabase gtBook asyncPagesForWord: arguments first) toArray wait
				ifEmpty: [ 'No page found' ]
				ifNotEmpty: [ :pages | pages first asMarkdownPage ] ]
]

{ #category : #'as yet unclassified' }
GtCodeSnippetTutor >> proposalAction [
	<gtLlmTutorAction>
	^ GtLlmTutorAction new
		name: 'Propose code';
		priority: 3;
		description: 'Interpret the comments and proposes code using the `Code Snippet` field. The typical comment command is formatted as `": some command"`. Look up classes and documentation as needed to generate an answer.';
		examples: {GtLlmTutorActionExample new
					input: {'Action' -> 'Propose code'.
							'Code Snippet' -> '15 * 30 ": subtract 5"'} asDictionary;
					output: {'Action' -> 'Propose code'.
							'Text' -> nil.
							'Code Snippet' -> '(15 * 30) - 5'} asDictionary}
]
