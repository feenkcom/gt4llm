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

{ #category : #examples }
GtLChatOpenAILiveExamples >> createChat [
	<gtExample>
	| newChat provider |
	newChat := GtLChat new.
	
	provider := self createGpt51CodexConnection	buildProvider.
	newChat provider: provider.
	
	^ newChat
]

{ #category : #examples }
GtLChatOpenAILiveExamples >> createGpt51CodexConnection [
	<gtExample>
	^ GtLConnection new
		providerClass: GtLOpenAIProvider;
		label: 'GPT 5.1 Codex';
		model: 'gpt-5.1-codex';
		addOption: 'isStreaming' withValue: false
]

{ #category : #examples }
GtLChatOpenAILiveExamples >> currentChat [
	<gtExample>
	
	^ theChat ifNil: [
			theChat := self createChat ]
]

{ #category : #'examples - calls' }
GtLChatOpenAILiveExamples >> howAreYouCallExample [
	<gtExample>
	| responseMessage  |
	responseMessage := self currentChat sendPlainMessage: 'How are you?'.
	
	self
		waitForChatRunIsDoneThen: [ self assert: self currentChat messages size equals: 2 ].
	
	^ self currentChat
]

{ #category : #'examples - calls' }
GtLChatOpenAILiveExamples >> howAreYouCallExample_withStringSchema [
	<gtExample>
	| messageString currentMessage responseMessage  |
	messageString := 'How are you?'.
	
	currentMessage := self currentChat createUserMessage.
	currentMessage 
		addMagritteInputObject: (GtLMarkdown new
			content: messageString)
		named: 'Markdown'.
		
	currentMessage addSchemaDescription: (GtLResponseStringFormat new
			name: 'Respose').
	
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
GtLChatOpenAILiveExamples >> messageExample_magritteMarkdown_codeChanges [
	<gtExample>
	| messageString currentMessage responseMessage |
	messageString :='Create a class for a Person with a first and last name. Create a printing method. Use CodeTransformations to express the changes.'.

	currentMessage := self currentChat createUserMessage.
	currentMessage 
		addMagritteInputObject: (GtLMarkdown new
			content: messageString)
		named: 'Markdown'.
	currentMessage
		addSchemaDescription: (GtLResponseMagritteFormat new
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
	currentMessage := chat createUserMessage.
	currentMessage
		addMagritteInputObject: (GtLMarkdown new
				content: 'Pull up common methods and slots in the DiffVisitor class. Use CodeTransformations.')
		named: 'Markdown'.
	chat
		tools: (GtLToolsGroup
				withAll: {GtLRefactoringToolForClassSearch new model: model.
						GtLRefactoringToolForClassSubclasses new model: model.
						GtLRefactoringToolForClassLookup new model: model.
						GtLRefactoringToolForClassReferences new model: model.
						GtLRefactoringToolForMethodReferences new model: model.
						GtLRefactoringToolForMethodImplementors new model: model.
						GtLRefactoringToolForMethodSource new model: model}).
	chat
		addMagriteResponseDescriptionForClass: GtLMarkdown
		named: 'Markdown'.
	chat
		addMagriteResponseDescriptionForClass: GtLCodeTransformations
		named: 'CodeTransformations'.
	responseMessage := chat sendMessage: currentMessage.

	^ chat
]

{ #category : #'examples - calls' }
GtLChatOpenAILiveExamples >> messageWithFormatCallExample [
	<gtExample>
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
		addSchemaDescription: (GtLResponseJsonSchemaFormat new
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
		waitForChatRunIsDoneThen: [ self assert: self currentChat messages size equals: 2.
			self assert: (self currentChat messages at: 2) isFailure ].

	^ self currentChat
]

{ #category : #'examples - calls' }
GtLChatOpenAILiveExamples >> messageWithFormatCallExample_mathTutor_jsonString [
	<gtExample>
	| messageString currentMessage responseMessage |
	messageString := 'You are a helpful math tutor. Guide the user through the solution step by step for the equation 8x + 7 = -23'.
	
	currentMessage := self currentChat createUserMessage.
	currentMessage 
		addMagritteInputObject: (GtLMarkdown new
			content: messageString)
		named: 'Markdown'.
		
	currentMessage addSchemaDescription: (GtLResponseJsonSchemaFormat new
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
	| messageString currentMessage responseMessage |
	messageString := 'You are a helpful math tutor. Guide the user through the solution step by step for the equation 8x + 7 = -23'.
	
	currentMessage := self currentChat createUserMessage.
	currentMessage 
		addMagritteInputObject: (GtLMarkdown new
			content: messageString)
		named: 'Markdown'.
		
	currentMessage addSchemaDescription: (GtLResponseMagritteFormat new
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
	| messageString currentMessage responseMessage |
	messageString := 'You are a helpful math tutor. Guide the user through the solution step by step for the equation 8x + 7 = -23. Make sure to have an explanation and an output step'.
	
	currentMessage := self currentChat createUserMessage.
	currentMessage 
		addMagritteInputObject: (GtLMarkdown new
			content: messageString)
		named: 'Markdown'.
		
	currentMessage addSchemaDescription: (GtLResponseMagritteFormat new
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
	| messageString currentMessage responseMessage |
	messageString := 'You are a helpful math tutor. Guide the user through the solution step by step for the equation 8x + 7 = -23. Make sure to have an explanation and an output step'.

	currentMessage := self currentChat createUserMessage.
	currentMessage
		addMagritteInputObject: (GtLMarkdown new content: messageString)
		named: 'Markdown'.

	currentMessage
		addSchemaDescription: (GtLResponseMagritteFormat new
				name: 'MathReasoning';
				modelClass: GtLDemoMathReasoningWithDifferentSteps).

	responseMessage := self currentChat sendMessage: currentMessage.

	self
		waitForChatRunIsDoneThen: [ self assert: self currentChat messages size equals: 2 ].

	^ self currentChat
]

{ #category : #'examples - calls' }
GtLChatOpenAILiveExamples >> messageWithInputObjectExample [
	<gtExample>
	| messageString currentMessage responseMessage |
	messageString := 'Explain this object'.
	
	currentMessage := self currentChat createUserMessage.
	currentMessage 
		addMagritteInputObject: (GtLMarkdown new
			content: messageString)
		named: 'Markdown'.
	currentMessage 
		addPlainInputObject: (GtABCartoonAddressBookExample>>#cartoonAddressBook)
			gtExample returnValue
		named: 'Object'.
	
	currentMessage tools: (GtLToolsGroup withAll: {GtLToolForClassLookup new}).
	currentMessage
		addMagriteResponseDescriptionForClass: GtLMarkdown
		named: 'Markdown' .

	responseMessage := self currentChat sendMessage: currentMessage.

	self
		waitForChatRunIsDoneThen: [ self assert: self currentChat messages size >= 2 ].

	^ self currentChat
]

{ #category : #'examples - calls' }
GtLChatOpenAILiveExamples >> messageWithToolCallExample [
	<gtExample>
	| messageString currentMessage responseMessage  |
	messageString := 'Use tools and give me a description of the class BlElement'.
	
	currentMessage := self currentChat createUserMessage.
	currentMessage 
		addMagritteInputObject: (GtLMarkdown new
			content: messageString)
		named: 'Markdown'.
	
	currentMessage tools: (GtLToolsGroup withAll: {GtLToolForClassLookup new}).
	currentMessage addSchemaDescription: (GtLResponseMarkdownFormat new
			name: 'Description').
	
	responseMessage := self currentChat sendMessage: currentMessage.
	
	self
		waitForChatRunIsDoneThen: [ self assert: self currentChat messages size equals: 3 ].
	
	^ self currentChat
]

{ #category : #'examples - calls' }
GtLChatOpenAILiveExamples >> messageWithToolCallExample_magritteMarkdown [
	<gtExample>
	| messageString currentMessage responseMessage |
	messageString := 'Use tools and give me a description of the class BlElement'.

	currentMessage := self currentChat createUserMessage.
	currentMessage
		addMagritteInputObject: (GtLMarkdown new content: messageString)
		named: 'Markdown'.
	
	currentMessage tools: (GtLToolsGroup withAll: {GtLToolForClassLookup new}).
	currentMessage
		addMagriteResponseDescriptionForClass: GtLMarkdown
		named: 'Markdown'.

	responseMessage := self currentChat sendMessage: currentMessage.

	self
		waitForChatRunIsDoneThen: [ self assert: self currentChat messages size equals: 3 ].

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
