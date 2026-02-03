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
	#category : 'Gt4LlmCore-Examples-OpenAI'
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

{ #category : #examples }
GtLChatOpenAILiveExamples >> howAreYouCallExample_withStringSchema [
	<gtExample>
	<noTest>
	| responseMessage |
	responseMessage := self currentChat
			sendWith: [ :message | 
				message
					markdown: 'How are you?';
					addResponseFormat: (GtLResponseStringFormat new name: 'Response') ].

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

{ #category : #examples }
GtLChatOpenAILiveExamples >> messageExample_lepiterPage_improveSingleTextSnippet [
	<gtExample>
	<noTest>
	| lepiterPage responseMessage |
	lepiterPage := LeDatabasesRegistry defaultLogicalDatabase
		pageNamed: 'Releaser'.
	
	responseMessage := self currentChat
		sendWith: [ :message |
			message
				markdown: 'Improve the content of the first snippet in this page. Use a LepiterTransformation to express the change.';
				addInputModel: (GtLLepiterPageInputModel new
					name: lepiterPage title;
					model: lepiterPage);
				addResponseFormat: (GtLResponseMagritteFormat new
					name: 'LepiterTransformations';
					modelClass: GtLLepiterTransformations) ].
	
	self
		waitForChatRunIsDoneThen: [ self assert: self currentChat messages size equals: 2 ].
	
	^ self currentChat
]

{ #category : #examples }
GtLChatOpenAILiveExamples >> messageExample_lepiterPage_improveSnippets [
	<gtExample>
	<noTest>
	| lepiterPage responseMessage |
	lepiterPage := LeDatabasesRegistry defaultLogicalDatabase pageNamed: 'Releaser'.

	responseMessage := self currentChat
			sendWith: [ :message | 
				message
					tools: GtLTools gtSearch , GtLTools leSearch;
					markdown: 'Improve the content of the snippets in this lepiter page. Use change transformations to express the changes.';
					addInputModel: (GtLLepiterPageInputModel new
							name: lepiterPage title;
							model: lepiterPage);
					addResponseFormat: (GtLResponseMagritteFormat new
							name: 'ChangeTransformations';
							modelClass: GtLChangeTransformations) ].

	self
		waitForChatRunIsDoneThen: [ self assert: self currentChat messages size > 2 ].

	^ self currentChat
]

{ #category : #examples }
GtLChatOpenAILiveExamples >> messageExample_lepiterPage_improveTextSnippets [
	<gtExample>
	<noTest>
	| lepiterPage responseMessage |
	lepiterPage := LeDatabasesRegistry defaultLogicalDatabase
		pageNamed: 'Releaser'.
	
	responseMessage := self currentChat
		sendWith: [ :message |
			message
				markdown: 'Improve the content of the text snippets in this lepiter page. Use Lepiter transformations to express the changes.';
				addInputModel: (GtLLepiterPageInputModel new
					name: lepiterPage title;
					model: lepiterPage);
				addResponseFormat: (GtLResponseMagritteFormat new
					name: 'LepiterTransformations';
					modelClass: GtLLepiterTransformations) ].
	
	self
		waitForChatRunIsDoneThen: [ 
			self assert: self currentChat messages size equals: 2 ].
	
	^ self currentChat
]

{ #category : #examples }
GtLChatOpenAILiveExamples >> messageExample_lepiterPage_locatePageUid [
	<gtExample>
	<noTest>
	| lepiterPage responseMessage |
	lepiterPage := LeDatabasesRegistry defaultLogicalDatabase
		pageNamed: 'An example of moldable logging using Beacon'.
	
	responseMessage := self currentChat
		sendWith: [ :message |
			message
				markdown: 'Return the id of this lepiter page.';
				addInputModel: (GtLLepiterPageInputModel new
					name: lepiterPage title;
					model: lepiterPage);
				addResponseFormat: (GtLResponseStringFormat new
					name: 'uid') ].
	"Page ID is e203cda7-b896-0d00-8c81-252704a2e9a0"
	
	self
		waitForChatRunIsDoneThen: [ 
			self assert: self currentChat messages size equals: 2 ].
	
	^ self currentChat
]

{ #category : #examples }
GtLChatOpenAILiveExamples >> messageExample_lepiterPage_locateSnippetUid [
	<gtExample>
	<noTest>
	| lepiterPage responseMessage |
	lepiterPage := LeDatabasesRegistry defaultLogicalDatabase
		pageNamed: 'An example of moldable logging using Beacon'.
	
	responseMessage := self currentChat
		sendWith: [ :message |
			message
				markdown: 'Return the uid of the fourth snippet in the page. Take nesting of snippets into account when counting snippets';
				addInputModel: (GtLLepiterPageInputModel new
					name: lepiterPage title;
					model: lepiterPage);
				addResponseFormat: (GtLResponseMagritteFormat new
					name: 'uid';
					modelClass: LeUID) ].
	"Fourth uid should be nYByMyTODQCyFRtBDMk7GQ=="
	
	self
		waitForChatRunIsDoneThen: [ 
			self assert: self currentChat messages size equals: 2 ].
	
	^ self currentChat
]

{ #category : #examples }
GtLChatOpenAILiveExamples >> messageExample_lepiterPage_summarize [
	<gtExample>
	<noTest>
	| lepiterPage responseMessage |
	lepiterPage := LeDatabasesRegistry defaultLogicalDatabase
		pageNamed: 'An example of moldable logging using Beacon'.
	
	responseMessage := self currentChat
		sendWith: [ :message |
			message
				markdown: 'Create a summary of this lepiter page.';
				addInputModel: (GtLLepiterPageInputModel new
					name: lepiterPage title;
					model: lepiterPage);
				addResponseFormat: (GtLResponseMagritteFormat new
					name: 'Summary';
					modelClass: GtLMarkdown) ].
	
	self
		waitForChatRunIsDoneThen: [ self assert: self currentChat messages size equals: 2 ].
	
	^ self currentChat
]

{ #category : #examples }
GtLChatOpenAILiveExamples >> messageExample_magritteMarkdown_codeChanges [
	<gtExample>
	<noTest>
	| responseMessage |
	
	responseMessage := self currentChat
		sendWith: [ :message |
			message
				markdown: 'Create a class for a Person with a first and last name. Create a printing method. Use CodeTransformations to express the changes.';
				addResponseFormat: (GtLResponseMagritteFormat new
					name: 'CodeTransformations';
					modelClass: GtLCodeTransformations) ].
	
	self
		waitForChatRunIsDoneThen: [ self assert: self currentChat messages size equals: 2 ].
	
	^ self currentChat
]

{ #category : #examples }
GtLChatOpenAILiveExamples >> messageExample_magritteMarkdown_codeChanges_refactorings [
	<gtExample>
	<noTest>
	| model responseMessage |
	model := RBNamespace new.
	
	responseMessage := self currentChat
		sendWith: [ :message |
			message
				tools: (GtLTools withAll: {
					GtLRefactoringToolForClassSearch new model: model.
					GtLRefactoringToolForClassSubclasses new model: model.
					GtLRefactoringToolForClassLookup new model: model.
					GtLRefactoringToolForClassReferences new model: model.
					GtLRefactoringToolForMethodReferences new model: model.
					GtLRefactoringToolForMethodImplementors new model: model.
					GtLRefactoringToolForMethodSource new model: model });
				markdown: 'Push up common methods and slots from the subclasses in the DiffVisitor class. Use CodeTransformations.';
				addResponseFormat: (GtLResponseMagritteFormat new
					name: 'CodeTransformations';
					modelClass: GtLCodeTransformations) ].
	
	^ responseMessage
]

{ #category : #examples }
GtLChatOpenAILiveExamples >> messageWithFormatCallExample [
	<gtExample>
	<noTest>
	| responseMessage |
	
	responseMessage := self currentChat
		sendWith: [ :message |
			message
				markdown: 'Return a list of the most popular programming languages.';
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
		}')) ) ].
	
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

{ #category : #examples }
GtLChatOpenAILiveExamples >> messageWithFormatCallExample_mathTutor_magritteSchema [
	<gtExample>
	<noTest>
	| responseMessage |
	
	responseMessage := self currentChat
		sendWith: [ :message |
			message
				markdown: 'You are a helpful math tutor. Guide the user through the solution step by step for the equation 8x + 7 = -23';
				addResponseFormat: (GtLResponseMagritteFormat new
					name: 'MathReasoning'; 
					modelClass: GtLDemoMathReasoning) ].
	
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

{ #category : #examples }
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
				images: { fileReference } ].

	self
		waitForChatRunIsDoneThen: [ self assert: self currentChat messages size equals: 2 ].

	^ self currentChat
]

{ #category : #examples }
GtLChatOpenAILiveExamples >> messageWithInputObjectExample [
	<gtExample>
	<noTest>
	| responseMessage |
	
	responseMessage := self currentChat
		sendWith: [ :message |
			message
				markdown: 'Explain this object';
				addPlainInputObject: (GtABCartoonAddressBookExample >> #cartoonAddressBook) gtExample returnValue
					named: 'Object';
				tools: (GtLTools withAll: {GtLToolForClassLookup new});
				addResponseFormatForMagritte: GtLMarkdown named: 'Markdown' ].
	
	self
		waitForChatRunIsDoneThen: [ self assert: self currentChat messages size >= 2 ].
	
	^ self currentChat
]

{ #category : #examples }
GtLChatOpenAILiveExamples >> messageWithPdf [
	<gtExample>
	<noTest>
	| messageString responseMessage fileReference |
	messageString := 'What is in the PDF?'.

	fileReference := 'paper.pdf' asFileReference.
	fileReference
		ensureDelete;
		binaryWriteStreamDo: [ :s | 
			| contents |
			contents := ZnClient new get: 'https://arxiv.org/pdf/2409.00514'.
			s nextPutAll: contents ].
	responseMessage := self currentChat
			markdownResponse;
			sendWith: [ :m | 
				m
					markdown: messageString;
					pdfs: {fileReference} ].

	self
		waitForChatRunIsDoneThen: [ self assert: self currentChat messages size equals: 2 ].

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

{ #category : #examples }
GtLChatOpenAILiveExamples >> messageWithToolCallThenCompactionExample [
	<gtExample>

	<noTest>
	| chat |
	chat := self currentChat.
	chat tools: (GtLTools withAll: {GtLToolForClassLookup new}).
	chat markdownResponse.
	chat sendMarkdown: 'Use tools and give me a description of the class BlElement'.
	self
		waitForChatRunIsDoneThen: [ self assert: self currentChat messages size equals: 2. ].
"	chat compact."
"	self
		waitForChatRunIsDoneThen: [ self assert: self currentChat messages size equals: 4.
			self assert: self currentChat messages last hasCompactionResponse.
			self assert: self currentChat messages last assistantMessage isAssistantRole ].
"
	^ chat
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
