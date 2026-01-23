Class {
	#name : #GtLChatOpenAILiveExamples,
	#superclass : #Object,
	#instVars : [
		'theChat',
		'isSynchronous'
	],
	#classVars : [
		'IsSynchronous'
	],
	#category : #'Gt4LlmCore-Examples-OpenAI'
}

{ #category : #accessing }
GtLChatOpenAILiveExamples class >> isSynchronous [
	"Return true if an example should wait for a chat completion, false otherwise.
	I am an utility settings to easily demo written examples, without waiting for a chat to complete."

	^ IsSynchronous ifNil: [ IsSynchronous := true ]
]

{ #category : #accessing }
GtLChatOpenAILiveExamples class >> isSynchronous: aBoolean [
	IsSynchronous := aBoolean
]

{ #category : #'examples - calls' }
GtLChatOpenAILiveExamples >> chatWithTwoBasicMessages [
	<gtExample>
	<noTest>
	| chat |
	chat := self currentChat.
	chat sendMarkdown: 'Write a script for adding 2 and 40 in Smalltalk'.

	self
		waitForChatRunIsDoneThen: [ self assert: self currentChat messages size equals: 2.
			self assert: self currentChat isFinishedSuccesss ].

	chat sendMarkdown: 'Extend the script to multiply the overall result by 10'.

	self
		waitForChatRunIsDoneThen: [ self assert: self currentChat messages size equals: 4.
			self assert: self currentChat isFinishedSuccesss ].

	^ self currentChat
]

{ #category : #examples }
GtLChatOpenAILiveExamples >> createChat [
	<gtExample>
	<noTest>
	| newChat provider |
	newChat := GtLChat new.
	
	provider := self createGpt51CodexConnection	buildProvider.
	newChat provider: provider.
	
	^ newChat
]

{ #category : #examples }
GtLChatOpenAILiveExamples >> createGpt51CodexConnection [
	<gtExample>
	<noTest>
	^ GtLConnection new
		providerClass: GtLOpenAIProvider;
		label: 'GPT 5.1 Codex';
		model: 'gpt-5.1-codex';
		addOption: 'isStreaming' withValue: false
]

{ #category : #examples }
GtLChatOpenAILiveExamples >> currentChat [
	<gtExample>
	<noTest>
	^ theChat ifNil: [ theChat := self createChat ]
]

{ #category : #'examples - calls' }
GtLChatOpenAILiveExamples >> howAreYouCallExample [
	<gtExample>
	<noTest>
	| responseMessage  |
	responseMessage := self currentChat sendMarkdown: 'How are you?'.
	
	self
		waitForChatRunIsDoneThen: [ self assert: self currentChat messages size equals: 2 ].
	
	^ self currentChat
]

{ #category : #'examples - calls' }
GtLChatOpenAILiveExamples >> howAreYouCallExample_withStringSchema [
	<gtExample>
	<noTest>
	| messageString currentMessage responseMessage  |
	messageString := 'How are you?'.
	
	currentMessage := self currentChat createUserMessage.
	currentMessage 
		addInputMagritteObject: (GtLMarkdown new
			content: messageString)
		named: 'Markdown'.
		
	currentMessage addResponseFormat: (GtLResponseStringFormat new
			name: 'Response').
	
	responseMessage := self currentChat sendMessage: currentMessage.
	
	self
		waitForChatRunIsDoneThen: [ self assert: self currentChat messages size equals: 2 ].
	
	^ self currentChat
]

{ #category : #accessing }
GtLChatOpenAILiveExamples >> isSynchronous [
	"Return true if an example should wait for a chat completion, false otherwise.
	I am an utility settings to easily demo written examples, without waiting for a chat to complete."

	^ isSynchronous ifNil: [ self class isSynchronous ]
]

{ #category : #accessing }
GtLChatOpenAILiveExamples >> isSynchronous: aBoolean [
	isSynchronous := aBoolean
]

{ #category : #utils }
GtLChatOpenAILiveExamples >> mathResponseSchemaForMathTutor [
	<gtExample>
	| jsonObject |
	jsonObject := NeoJSONObject fromString: '{
      "type": "object",
      "properties": {
                    "steps": {
                        "type": "array",
                        "items": {
                            "type": "object",
                            "properties": {
                                "explanation": {"type": "string"},
                                "output": {"type": "string"}
                            },
                            "required": ["explanation", "output"],
                            "additionalProperties": false
                        }
                    },
                    "final_answer": {"type": "string"}
                },
                "required": ["steps", "final_answer"],
                "additionalProperties": false
            }'.
	^ NeoJSONSchema new json: jsonObject.
]

{ #category : #'examples - calls' }
GtLChatOpenAILiveExamples >> messageExample_lepiterPage_improveSingleTextSnippet [
	<gtExample>
	<noTest>
	| messageString currentMessage responseMessage lepiterPage |
	messageString :='Improve the content of the first snippet in this page. Use a LepiterTransformation to express the change.'.
	lepiterPage := LeDatabasesRegistry defaultLogicalDatabase
		pageNamed: 'Releaser'.
	
	currentMessage := self currentChat createUserMessage.
	currentMessage 
		addInputMagritteObject: (GtLMarkdown new
			content: messageString)
		named: 'Markdown'.
	currentMessage 
		addInputModel: (GtLLepiterPageInputModel new
			name: lepiterPage title;
			model: lepiterPage).
	currentMessage
		addResponseFormat: (GtLResponseMagritteFormat new
				name: 'LepiterTransformations';
				modelClass: GtLLepiterTransformations).

	responseMessage := self currentChat sendMessage: currentMessage.

	self
		waitForChatRunIsDoneThen: [ self assert: self currentChat messages size equals: 2 ].

	^ self currentChat
]

{ #category : #'examples - calls' }
GtLChatOpenAILiveExamples >> messageExample_lepiterPage_improveSnippets [
	<gtExample>
	<noTest>
	| messageString currentMessage responseMessage lepiterPage |
	messageString :='Improve the content of the snippets in this lepiter page. Use change transformations to express the changes.'.
	lepiterPage := LeDatabasesRegistry defaultLogicalDatabase
		pageNamed: 'Releaser'.
	
	currentMessage := self currentChat createUserMessage.
	currentMessage tools: (GtLTools gtSearch, GtLTools leSearch).
	currentMessage 
		addInputMagritteObject: (GtLMarkdown new
			content: messageString)
		named: 'Markdown'.
	currentMessage 
		addInputModel: (GtLLepiterPageInputModel new
			name: lepiterPage title;
			model: lepiterPage).
	currentMessage
		addResponseFormat: (GtLResponseMagritteFormat new
				name: 'ChangeTransformations';
				modelClass: GtLChangeTransformations).

	responseMessage := self currentChat sendMessage: currentMessage.

	self
		waitForChatRunIsDoneThen: [ 
			self assert: self currentChat messages size > 2 ].

	^ self currentChat
]

{ #category : #'examples - calls' }
GtLChatOpenAILiveExamples >> messageExample_lepiterPage_improveTextSnippets [
	<gtExample>
	<noTest>
	| messageString currentMessage responseMessage lepiterPage |
	messageString :='Improve the content of the text snippets in this lepiter page. Use  Lepiter transformations to express the changes.'.
	lepiterPage := LeDatabasesRegistry defaultLogicalDatabase
		pageNamed: 'Releaser'.
	
	currentMessage := self currentChat createUserMessage.
	currentMessage 
		addInputMagritteObject: (GtLMarkdown new
			content: messageString)
		named: 'Markdown'.
	currentMessage 
		addInputModel: (GtLLepiterPageInputModel new
			name: lepiterPage title;
			model: lepiterPage).
	currentMessage
		addResponseFormat: (GtLResponseMagritteFormat new
				name: 'LepiterTransformations';
				modelClass: GtLLepiterTransformations).

	responseMessage := self currentChat sendMessage: currentMessage.

	self
		waitForChatRunIsDoneThen: [ 
			self assert: self currentChat messages size equals: 2 ].

	^ self currentChat
]

{ #category : #'examples - calls' }
GtLChatOpenAILiveExamples >> messageExample_lepiterPage_locatePageUid [
	<gtExample>
	<noTest>
	| messageString currentMessage responseMessage lepiterPage |
	messageString :='Return the id of this lepiter page.'.
	lepiterPage := LeDatabasesRegistry defaultLogicalDatabase
		pageNamed: 'An example of moldable logging using Beacon'.
	
	currentMessage := self currentChat createUserMessage.
	currentMessage 
		addInputMagritteObject: (GtLMarkdown new
			content: messageString)
		named: 'Markdown'.
	currentMessage 
		addInputModel: (GtLLepiterPageInputModel new
			name: lepiterPage title;
			model: lepiterPage).
		currentMessage
		addResponseFormat: (GtLResponseStringFormat new
				name: 'uid').

	responseMessage := self currentChat sendMessage: currentMessage.
	"Page ID is e203cda7-b896-0d00-8c81-252704a2e9a0"

	self
		waitForChatRunIsDoneThen: [ 
			self assert: self currentChat messages size equals: 2 ].

	^ self currentChat
]

{ #category : #'examples - calls' }
GtLChatOpenAILiveExamples >> messageExample_lepiterPage_locateSnippetUid [
	<gtExample>
	<noTest>
	| messageString currentMessage responseMessage lepiterPage |
	messageString :='Return the uid of the fourth snippet in the page. Take nesting of snippets into account when counting snippets'.
	lepiterPage := LeDatabasesRegistry defaultLogicalDatabase
		pageNamed: 'An example of moldable logging using Beacon'.
	
	currentMessage := self currentChat createUserMessage.
	currentMessage 
		addInputMagritteObject: (GtLMarkdown new
			content: messageString)
		named: 'Markdown'.
	currentMessage 
		addInputModel: (GtLLepiterPageInputModel new
			name: lepiterPage title;
			model: lepiterPage).
		currentMessage
		addResponseFormat: (GtLResponseMagritteFormat new
				name: 'uid';
				modelClass: LeUID).

	responseMessage := self currentChat sendMessage: currentMessage.
	"Fourth uid should be nYByMyTODQCyFRtBDMk7GQ=="

	self
		waitForChatRunIsDoneThen: [ 
			self assert: self currentChat messages size equals: 2 ].

	^ self currentChat
]

{ #category : #'examples - calls' }
GtLChatOpenAILiveExamples >> messageExample_lepiterPage_summarize [
	<gtExample>
	<noTest>
	| messageString currentMessage responseMessage lepiterPage |
	messageString :='Create a summary of this lepiter page.'.
	lepiterPage := LeDatabasesRegistry defaultLogicalDatabase
		pageNamed: 'An example of moldable logging using Beacon'.
	
	currentMessage := self currentChat createUserMessage.
	currentMessage 
		addInputMagritteObject: (GtLMarkdown new
			content: messageString)
		named: 'Markdown'.
	currentMessage 
		addInputModel: (GtLLepiterPageInputModel new
			name: lepiterPage title;
			model: lepiterPage).
	currentMessage
		addResponseFormat: (GtLResponseMagritteFormat new
				name: 'Summary';
				modelClass: GtLMarkdown).

	responseMessage := self currentChat sendMessage: currentMessage.

	self
		waitForChatRunIsDoneThen: [ self assert: self currentChat messages size equals: 2 ].

	^ self currentChat
]

{ #category : #'examples - calls' }
GtLChatOpenAILiveExamples >> messageExample_magritteMarkdown_codeChanges [
	<gtExample>
	<noTest>
	| messageString currentMessage responseMessage |
	messageString :='Create a class for a Person with a first and last name. Create a printing method. Use CodeTransformations to express the changes.'.

	currentMessage := self currentChat createUserMessage.
	currentMessage 
		addInputMagritteObject: (GtLMarkdown new
			content: messageString)
		named: 'Markdown'.
	currentMessage
		addResponseFormat: (GtLResponseMagritteFormat new
				name: 'CodeTransformations';
				modelClass: GtLCodeTransformations).

	responseMessage := self currentChat sendMessage: currentMessage.

	self
		waitForChatRunIsDoneThen: [ self assert: self currentChat messages size equals: 2 ].

	^ self currentChat
]

{ #category : #'examples - calls' }
GtLChatOpenAILiveExamples >> messageExample_magritteMarkdown_codeChanges_refactorings [
	<gtExample>
	<noTest>
	| currentMessage model responseMessage chat |
	model := RBNamespace new.
	chat := self currentChat.
	chat
		tools: (GtLTools
				withAll: {GtLRefactoringToolForClassSearch new model: model.
						GtLRefactoringToolForClassSubclasses new model: model.
						GtLRefactoringToolForClassLookup new model: model.
						GtLRefactoringToolForClassReferences new model: model.
						GtLRefactoringToolForMethodReferences new model: model.
						GtLRefactoringToolForMethodImplementors new model: model.
						GtLRefactoringToolForMethodSource new model: model}).
	currentMessage := chat createUserMessage.
	currentMessage
		addInputMagritteObject: (GtLMarkdown new
				content: 'Push up common methods and slots from the subclasses in the DiffVisitor class. Use CodeTransformations.')
		named: 'Markdown'.
	chat markdownResponse.
	chat
		addResponseFormatForMagritte: GtLCodeTransformations
		named: 'CodeTransformations'.
	responseMessage := chat sendMessage: currentMessage.

	^ chat
]

{ #category : #'examples - calls' }
GtLChatOpenAILiveExamples >> messageWithFormatCallExample [
	<gtExample>
	<noTest>
	| messageString currentMessage responseMessage |
	messageString := 'Return a list of the most popular programming languages.'.

	currentMessage := self currentChat createUserMessage.
	currentMessage
		addInputModel: (GtLJsonSchemaInputModel new
				name: 'String';
				model: messageString;
				schema: (NeoJSONSchema new
						json: (NeoJSONObject
								fromString: '{
				"type" : "string"
				}'))).

	currentMessage
		addResponseFormat: (GtLResponseJsonSchemaFormat new
				name: 'List';
				schema: (NeoJSONSchema new
						json: (NeoJSONObject
								fromString: '{
			"type" : "array",
			"items" : {
				"type" : "string"
			},
			"additionalProperties": false
		}'))).

	responseMessage := self currentChat sendMessage: currentMessage.

	self
		waitForChatRunIsDoneThen: [ self assert: self currentChat messages size equals: 2 ].

	^ self currentChat
]

{ #category : #'examples - calls' }
GtLChatOpenAILiveExamples >> messageWithFormatCallExample_mathTutor_jsonString [
	<gtExample>
	<noTest>
	| messageString currentMessage responseMessage |
	messageString := 'You are a helpful math tutor. Guide the user through the solution step by step for the equation 8x + 7 = -23'.
	
	currentMessage := self currentChat createUserMessage.
	currentMessage 
		addInputMagritteObject: (GtLMarkdown new
			content: messageString)
		named: 'Markdown'.
		
	currentMessage addResponseFormat: (GtLResponseJsonSchemaFormat new
		name: 'MathReasoning';
		schema: self mathResponseSchemaForMathTutor).
	
	responseMessage := self currentChat sendMessage: currentMessage.
	
	self
		waitForChatRunIsDoneThen: [ self assert: self currentChat messages size equals: 2 ].
	
	^ self currentChat
]

{ #category : #'examples - calls' }
GtLChatOpenAILiveExamples >> messageWithFormatCallExample_mathTutor_magritteSchema [
	<gtExample>
	<noTest>
	| messageString currentMessage responseMessage |
	messageString := 'You are a helpful math tutor. Guide the user through the solution step by step for the equation 8x + 7 = -23'.
	
	currentMessage := self currentChat createUserMessage.
	currentMessage 
		addInputMagritteObject: (GtLMarkdown new
			content: messageString)
		named: 'Markdown'.
		
	currentMessage addResponseFormat: (GtLResponseMagritteFormat new
		name: 'MathReasoning'; 
		modelClass: GtLDemoMathReasoning).
	
	responseMessage := self currentChat sendMessage: currentMessage.
	
	self
		waitForChatRunIsDoneThen: [ self assert: self currentChat messages size equals: 2 ].
	
	^ self currentChat
]

{ #category : #'examples - calls' }
GtLChatOpenAILiveExamples >> messageWithFormatCallExample_mathTutor_magritteSchema_delegatedStepTypes [
	<gtExample>
	<noTest>
	| messageString currentMessage responseMessage |
	messageString := 'You are a helpful math tutor. Guide the user through the solution step by step for the equation 8x + 7 = -23. Make sure to have an explanation and an output step'.
	
	currentMessage := self currentChat createUserMessage.
	currentMessage 
		addInputMagritteObject: (GtLMarkdown new
			content: messageString)
		named: 'Markdown'.
		
	currentMessage addResponseFormat: (GtLResponseMagritteFormat new
		name: 'MathReasoning'; 
		modelClass: GtLDemoMathReasoningWithDelegatedSteps).
	
	responseMessage := self currentChat sendMessage: currentMessage.
	
	self
		waitForChatRunIsDoneThen: [ self assert: self currentChat messages size equals: 2 ].
	
	^ self currentChat
]

{ #category : #'examples - calls' }
GtLChatOpenAILiveExamples >> messageWithFormatCallExample_mathTutor_magritteSchema_multipleStepTypes [
	<gtExample>
	<noTest>
	| messageString currentMessage responseMessage |
	messageString := 'You are a helpful math tutor. Guide the user through the solution step by step for the equation 8x + 7 = -23. Make sure to have an explanation and an output step'.

	currentMessage := self currentChat createUserMessage.
	currentMessage
		addInputMagritteObject: (GtLMarkdown new content: messageString)
		named: 'Markdown'.

	currentMessage
		addResponseFormat: (GtLResponseMagritteFormat new
				name: 'MathReasoning';
				modelClass: GtLDemoMathReasoningWithDifferentSteps).

	responseMessage := self currentChat sendMessage: currentMessage.

	self
		waitForChatRunIsDoneThen: [ self assert: self currentChat messages size equals: 2 ].

	^ self currentChat
]

{ #category : #'examples - calls' }
GtLChatOpenAILiveExamples >> messageWithImages [
	<gtExample>
	<noTest>
	| messageString responseMessage fileReference |
	messageString := 'What do you see in the picture?'.

	fileReference := BlElement new
		background: Color red;
		exportAsPNG.
	responseMessage := self currentChat
		markdownResponse;
		sendWith: [ :m | 
			m
				markdown: messageString;
				images: {fileReference} ].
	
	self
		waitForChatRunIsDoneThen: [ self assert: self currentChat messages size equals: 2 ].

	^ self currentChat
]

{ #category : #'examples - calls' }
GtLChatOpenAILiveExamples >> messageWithInputObjectExample [
	<gtExample>
	<noTest>
	| messageString currentMessage responseMessage |
	messageString := 'Explain this object'.

	currentMessage := self currentChat createUserMessage.
	currentMessage
		addInputMagritteObject: (GtLMarkdown new content: messageString)
		named: 'Markdown'.
	currentMessage
		addPlainInputObject: (GtABCartoonAddressBookExample >> #cartoonAddressBook) gtExample returnValue
		named: 'Object'.

	currentMessage tools: (GtLTools withAll: {GtLToolForClassLookup new}).
	currentMessage addResponseFormatForMagritte: GtLMarkdown named: 'Markdown'.

	responseMessage := self currentChat sendMessage: currentMessage.

	self
		waitForChatRunIsDoneThen: [ self assert: self currentChat messages size >= 2 ].

	^ self currentChat
]

{ #category : #'examples - calls' }
GtLChatOpenAILiveExamples >> messageWithToolCallExample [
	<gtExample>
	<noTest>
	| chat  |
	chat := self currentChat.
	chat tools: (GtLTools withAll: {GtLToolForClassLookup new}).
	chat markdownResponse.
	chat sendMarkdown: 'Use tools and give me a description of the class BlElement'.
	self waitForChatRunIsDoneThen: [ 
		self assert: self currentChat messages size equals: 2 ].
	^ chat
]

{ #category : #'examples - calls' }
GtLChatOpenAILiveExamples >> messageWithToolCallExample_magritteMarkdown [
	<gtExample>
	<noTest>
	| messageString currentMessage responseMessage |
	messageString := 'Use tools and give me a description of the class BlElement'.

	currentMessage := self currentChat createUserMessage.
	currentMessage
		addInputMagritteObject: (GtLMarkdown new content: messageString)
		named: 'Markdown'.

	currentMessage tools: (GtLTools withAll: {GtLToolForClassLookup new}).
	currentMessage addResponseFormatForMagritte: GtLMarkdown named: 'Markdown'.

	responseMessage := self currentChat sendMessage: currentMessage.

	self
		waitForChatRunIsDoneThen: [ self assert: self currentChat messages size equals: 2 ].

	^ self currentChat
]

{ #category : #utils }
GtLChatOpenAILiveExamples >> waitForChatCompletion [
	self currentChat provider executions last wait
]

{ #category : #utils }
GtLChatOpenAILiveExamples >> waitForChatCompletion: anInteger then: aBlock [
	"Wait for a chat completion a given number of times."
	self isSynchronous ifFalse: [ ^ self ].
	
	anInteger timesRepeat: [ self waitForChatCompletion ].
	aBlock value
]

{ #category : #utils }
GtLChatOpenAILiveExamples >> waitForChatRunIsDone [
	| semaphore timeout |
	semaphore := Semaphore new.

	self currentChat announcer weak
		when: GtLlmThreadRunIsDoneAnnouncement
		send: #signal
		to: semaphore.

	timeout := semaphore waitTimeoutSeconds: 120.

	self currentChat announcer unsubscribe: semaphore.

	self assert: timeout not description: [ 'Chat run was not finished on time' ].
]

{ #category : #utils }
GtLChatOpenAILiveExamples >> waitForChatRunIsDoneThen: aBlock [
	"Wait for a chat to complete."

	self isSynchronous ifFalse: [ ^ self ].

	self waitForChatRunIsDone.
	aBlock value
]
