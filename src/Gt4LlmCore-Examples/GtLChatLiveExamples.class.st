Class {
	#name : #GtLChatLiveExamples,
	#superclass : #Object,
	#instVars : [
		'theChat',
		'isSynchronous',
		'isLive'
	],
	#classVars : [
		'IsLive',
		'IsSynchronous'
	],
	#category : #'Gt4LlmCore-Examples'
}

{ #category : #'api - settings' }
GtLChatLiveExamples class >> beLiveAsynchronous [
	self isLive: true.
	self isSynchronous: false.
]

{ #category : #'api - settings' }
GtLChatLiveExamples class >> beLiveSynchronous [
	self isLive: true.
	self isSynchronous: true.
]

{ #category : #'api - settings' }
GtLChatLiveExamples class >> beStubAsynchronous [
	self isLive: false.
	self isSynchronous: false.
]

{ #category : #'api - settings' }
GtLChatLiveExamples class >> beStubSynchronous [
	self isLive: false.
	self isSynchronous: true.
]

{ #category : #cleanup }
GtLChatLiveExamples class >> cleanUp: aggressive [
	aggressive ifTrue: [ self reset ]
]

{ #category : #testing }
GtLChatLiveExamples class >> isAbstract [
	^ self name = #GtLChatLiveExamples
]

{ #category : #'api - settings' }
GtLChatLiveExamples class >> isLive [
	"Return true if an example should be execute against a real OpenAI server.
	Return false, if a stub client should be used."

	^ IsLive ifNil: [ IsLive := false ]
]

{ #category : #'api - settings' }
GtLChatLiveExamples class >> isLive: aBoolean [
	"Set to true if you want to communicate with the real OpenAI server.
	Set to false, if you want to use a stub client."

	IsLive := aBoolean
]

{ #category : #'api - settings' }
GtLChatLiveExamples class >> isSynchronous [
	"Return true if an example should wait for a chat completion, false otherwise.
	I am an utility settings to easily demo written examples, without waiting for a chat to complete."

	^ IsSynchronous ifNil: [ IsSynchronous := true ]
]

{ #category : #'api - settings' }
GtLChatLiveExamples class >> isSynchronous: aBoolean [
	"Set true if an example should wait for a chat completion, false otherwise.
	I am an utility settings to easily demo written examples, without waiting for a chat to complete."

	IsSynchronous := aBoolean
]

{ #category : #'api - settings' }
GtLChatLiveExamples class >> reset [
	IsLive := nil.
	IsSynchronous := nil
]

{ #category : #'examples - calls' }
GtLChatLiveExamples >> chatWithTwoBasicMessages [
	<gtExample>
	<noTest>
	| chat |
	chat := self currentChat.
	chat sendMarkdown: 'Write a script for adding 2 and 40 in Smalltalk'.

	self waitForChatRunIsDone.
	self assert: self currentChat messages size equals: 2.

	chat sendMarkdown: 'Extend the script to multiply the overall result by 10'.

	self
		waitForChatRunIsDoneThen: [ self assert: self currentChat messages size equals: 4 ].

	^ self currentChat
]

{ #category : #'examples - basic' }
GtLChatLiveExamples >> createChat [
	<gtExample>
	<noTest>
	| newChat provider |
	newChat := GtLChat new.

	provider := self createProvider.
	newChat provider: provider.

	^ newChat
]

{ #category : #'examples - basic' }
GtLChatLiveExamples >> createProvider [
	<gtExample>
	^ nil
]

{ #category : #'examples - basic' }
GtLChatLiveExamples >> currentChat [
	<gtExample>
	<noTest>
	^ theChat ifNil: [ theChat := self createChat ]
]

{ #category : #'examples - calls' }
GtLChatLiveExamples >> howAreYouCallExample [
	"Ready for stub execution"
	<gtExample>
	| responseMessage  |
	responseMessage := self currentChat sendMarkdown: 'How are you?'.
	
	self stubResponses: [ self howAreYouCallExample_stub_responses ].
	
	self
		waitForChatRunIsDoneThen: [ 
			self assert: self currentChat messages size equals: 2 ].
	
	^ self currentChat
]

{ #category : #'examples - calls' }
GtLChatLiveExamples >> howAreYouCallExample_stub_responses [
	^ Array new
]

{ #category : #examples }
GtLChatLiveExamples >> howAreYouCallExample_withStringSchema [
	"Ready for stub execution"
	<gtExample>
	| responseMessage |
	self stubResponses: [ self howAreYouCallExample_withStringSchema_stub_responses ].
	
	responseMessage := self currentChat
			sendWith: [ :message | 
				message
					markdown: 'How are you?';
					addResponseFormat: (GtLResponseStringFormat new name: 'Response') ].

	self
		waitForChatRunIsDoneThen: [ self assert: self currentChat messages size equals: 2 ].

	^ self currentChat
]

{ #category : #'examples - calls' }
GtLChatLiveExamples >> howAreYouCallExample_withStringSchema_stub_responses [
	^ Array new
]

{ #category : #testing }
GtLChatLiveExamples >> isLive [
	"Return true if an example should be execute against a real OpenAI server.
	Return false, if a stub client should be used."

	^ isLive ifNil: [ self class isLive ]
]

{ #category : #'api - initialization' }
GtLChatLiveExamples >> isLive: aBoolean [
	isLive := aBoolean
]

{ #category : #testing }
GtLChatLiveExamples >> isSynchronous [
	"Return true if an example should wait for a chat completion, false otherwise.
	I am an utility settings to easily demo written examples, without waiting for a chat to complete."

	^ isSynchronous ifNil: [ self class isSynchronous ]
]

{ #category : #'api - initialization' }
GtLChatLiveExamples >> isSynchronous: aBoolean [
	isSynchronous := aBoolean
]

{ #category : #utils }
GtLChatLiveExamples >> mathResponseSchemaForMathTutor [
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
GtLChatLiveExamples >> messageExample_lepiterPage_improveSingleTextSnippet [
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
GtLChatLiveExamples >> messageExample_lepiterPage_improveSnippets [
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
GtLChatLiveExamples >> messageExample_lepiterPage_improveTextSnippets [
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
GtLChatLiveExamples >> messageExample_lepiterPage_locatePageUid [
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
GtLChatLiveExamples >> messageExample_lepiterPage_locateSnippetUid [
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
GtLChatLiveExamples >> messageExample_lepiterPage_summarize [
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
GtLChatLiveExamples >> messageExample_magritteMarkdown_codeChanges [
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
GtLChatLiveExamples >> messageExample_magritteMarkdown_codeChanges_refactorings [
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
GtLChatLiveExamples >> messageWithFormatCallExample [
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
GtLChatLiveExamples >> messageWithFormatCallExample_mathTutor_jsonString [
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
GtLChatLiveExamples >> messageWithFormatCallExample_mathTutor_magritteSchema [
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
GtLChatLiveExamples >> messageWithFormatCallExample_mathTutor_magritteSchema_delegatedStepTypes [
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
GtLChatLiveExamples >> messageWithFormatCallExample_mathTutor_magritteSchema_multipleStepTypes [
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
GtLChatLiveExamples >> messageWithImages [
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
GtLChatLiveExamples >> messageWithInputObjectExample [
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
GtLChatLiveExamples >> messageWithPdf [
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
GtLChatLiveExamples >> messageWithToolCallExample [
	"Ready for stub execution"
	<gtExample>
	| chat  |
	
	self stubResponses: [ self messageWithToolCallExample_stub_responses ].
	
	chat := self currentChat.
	chat tools: (GtLTools withAll: {GtLToolForClassLookup new}).
	chat markdownResponse.
	chat sendMarkdown: 'Use tools and give me a description of the class BlElement'.
	self waitForChatRunIsDoneThen: [ 
		self assert: self currentChat messages size equals: 2 ].
	^ chat
]

{ #category : #'examples - calls' }
GtLChatLiveExamples >> messageWithToolCallExample_lepiterToolSearch [
	"Ready for stub execution"
	<gtExample>
	<noTest>
	| chat  |
	
	chat := self currentChat.
	chat tools: (GtLTools withAll: {GtLToolForSearchForLepiterPages new}).
	chat markdownResponse.
	chat sendMarkdown: 'Give a short summary of the lepiter page "Moldable Development exercises"'.
	
	self waitForChatRunIsDoneThen: [ 
		self assert: self currentChat messages size equals: 2 ].
		
	^ chat
]

{ #category : #'examples - calls' }
GtLChatLiveExamples >> messageWithToolCallExample_magritteMarkdown [
	"Ready for stub execution"
	<gtExample>
	| messageString currentMessage responseMessage |
	messageString := 'Use tools and give me a description of the class BlElement'.
	self
		stubResponses: [ self messageWithToolCallExample_magritteMarkdown_stub_responses ].
	currentMessage := self currentChat createUserMessage.
	currentMessage tools: (GtLTools withAll: {GtLToolForClassLookup new}).
	currentMessage addResponseFormatForMagritte: GtLMarkdown named: 'Markdown'.
	currentMessage
		addInputMagritteObject: (GtLMarkdown new content: messageString)
		named: 'Markdown'.
	responseMessage := self currentChat sendMessage: currentMessage.
	self assert: self currentChat messages size equals: 2.
	self assert: self currentChat isFinishedSuccesss not.
	self assert: self currentChat messages last executionMessages isEmpty.
	self
		waitForChatRunIsDoneThen: [ self assert: self currentChat messages size equals: 2 ].
	self assert: self currentChat isFinishedSuccesss.
	^ self currentChat messages last
]

{ #category : #'examples - calls' }
GtLChatLiveExamples >> messageWithToolCallExample_magritteMarkdown_stub_responses [
	^ Array new
]

{ #category : #'examples - calls' }
GtLChatLiveExamples >> messageWithToolCallExample_stub_responses [
	^ Array new
]

{ #category : #examples }
GtLChatLiveExamples >> messageWithToolCallThenCompactionExample [
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

{ #category : #'examples - calls' }
GtLChatLiveExamples >> messageWithWorldScreenshotTool [
	<gtExample>
	<noTest>
	| chat |
	
	chat := self currentChat.
	chat tools: (GtLTools withAll: {GtLToolForWorldScreenshot new}).
	chat markdownResponse.
	chat sendMarkdown: 'Explain what you see on the windows using the given tool'.
	
	self waitForChatRunIsDoneThen: [ 
		self assert: self currentChat messages size equals: 2 ].
		
	^ chat
]

{ #category : #'examples - basic' }
GtLChatLiveExamples >> stubResponses: aBlock [ 
	"Execute the given aBlock only in stub mode"
	
	| someResponses |
	self isLive ifTrue: [ ^ self ].
	
	someResponses := aBlock value.
	
	self currentChat provider client clientBuilder responses: someResponses asOrderedCollection
]

{ #category : #utils }
GtLChatLiveExamples >> waitForChatCompletion [
	self currentChat provider executions last wait
]

{ #category : #utils }
GtLChatLiveExamples >> waitForChatCompletion: anInteger then: aBlock [
	"Wait for a chat completion a given number of times."
	self isSynchronous ifFalse: [ ^ self ].
	
	anInteger timesRepeat: [ self waitForChatCompletion ].
	aBlock value
]

{ #category : #utils }
GtLChatLiveExamples >> waitForChatRunIsDone [
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
GtLChatLiveExamples >> waitForChatRunIsDoneThen: aBlock [
	"Wait for a chat to complete."

	self isSynchronous ifFalse: [ ^ self ].

	self waitForChatRunIsDone.
	aBlock value
]
