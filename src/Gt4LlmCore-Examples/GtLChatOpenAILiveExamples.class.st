Class {
	#name : #GtLChatOpenAILiveExamples,
	#superclass : #Object,
	#instVars : [
		'theChat'
	],
	#category : #'Gt4LlmCore-Examples'
}

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
	
	self waitForChatCompletion.
	self assert: self currentChat messages size equals: 2.
	
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
	
	self waitForChatCompletion.
	self assert: self currentChat messages size equals: 2.
	
	^ self currentChat
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
	messageString :='Create a class for a Person with a first and last name'.

	currentMessage := self currentChat createUserMessage.
	currentMessage 
		addMagritteInputObject: (GtLMarkdown new
			content: messageString)
		named: 'Markdown'.
		
	currentMessage
		addSchemaDescription: (GtLResponseMagritteFormat new
				name: 'Markdown';
				modelClass: GtLMarkdown);
		addSchemaDescription: (GtLResponseMagritteFormat new
				name: 'CodeTransformations';
				modelClass: GtLCodeTransformations).

	responseMessage := self currentChat sendMessage: currentMessage.

	self waitForChatCompletion.
	self assert: self currentChat messages size equals: 2.

	^ self currentChat
]

{ #category : #'examples - calls' }
GtLChatOpenAILiveExamples >> messageWithFormatCallExample [
	<gtExample>
	| messageString currentMessage responseMessage |
	messageString := 'Return a list of the most populate programming languages.'.
	
	currentMessage := self currentChat createUserMessage.
	currentMessage 
		addInputModel: (GtLJsonSchemaInputModel new
			name: 'String';
			model: messageString;
			schema: (NeoJSONSchema new 
				json: (NeoJSONObject fromString: '{
				"type" : "string"
				}'))).
	
	currentMessage addSchemaDescription: (GtLResponseJsonSchemaFormat new
		name: 'List';
		schema: (NeoJSONSchema new 
			json: (NeoJSONObject fromString: '{
			"type" : "array",
			"items" : {
				"type" : "string"
			},
			"additionalProperties": false
		}'))).
	
	responseMessage := self currentChat sendMessage: currentMessage.
	
	self waitForChatCompletion.
	self waitForChatCompletion.
	self assert: self currentChat messages size equals: 2.
	
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
	
	self waitForChatCompletion.
	self waitForChatCompletion.
	self assert: self currentChat messages size equals: 2.
	
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
	
	self waitForChatCompletion.
	self waitForChatCompletion.
	self assert: self currentChat messages size equals: 2.
	
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
	
	self waitForChatCompletion.
	self waitForChatCompletion.
	self assert: self currentChat messages size equals: 2.
	
	^ self currentChat
]

{ #category : #'examples - calls' }
GtLChatOpenAILiveExamples >> messageWithFormatCallExample_mathTutor_magritteSchema_multipleStepTypes [
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
		modelClass: GtLDemoMathReasoningWithDifferentSteps).
	
	responseMessage := self currentChat sendMessage: currentMessage.
	
	self waitForChatCompletion.
	self waitForChatCompletion.
	self assert: self currentChat messages size equals: 2.
	
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
	
	currentMessage tools: (GtLToolsGroup withAll: {GtLlmToolForClassLookup new}).
	currentMessage
		addMagriteResponseDescriptionForClass: GtLMarkdown
		named: 'Markdown' .

	responseMessage := self currentChat sendMessage: currentMessage.

	self waitForChatCompletion.
	self waitForChatCompletion.
	self assert: self currentChat messages size equals: 3.

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
	
	currentMessage tools: (GtLToolsGroup withAll: {GtLlmToolForClassLookup new}).
	currentMessage addSchemaDescription: (GtLResponseMarkdownFormat new
			name: 'Description').
	
	responseMessage := self currentChat sendMessage: currentMessage.
	
	self waitForChatCompletion.
	self waitForChatCompletion.
	self assert: self currentChat messages size equals: 3.
	
	^ self currentChat
]

{ #category : #'examples - calls' }
GtLChatOpenAILiveExamples >> messageWithToolCallExample_magritteMarkdown [
	<gtExample>
	| messageString currentMessage responseMessage |
	messageString := 'Use tools and give me a description of the class BlElement'.
	
	currentMessage := self currentChat createUserMessage.
	currentMessage 
		addMagritteInputObject: (GtLMarkdown new
			content: messageString)
		named: 'Markdown'.
	
	currentMessage tools: (GtLToolsGroup withAll: {GtLlmToolForClassLookup new}).
	currentMessage
		addMagriteResponseDescriptionForClass: GtLMarkdown
		named: 'Markdown' .

	responseMessage := self currentChat sendMessage: currentMessage.

	self waitForChatCompletion.
	self waitForChatCompletion.
	self assert: self currentChat messages size equals: 3.

	^ self currentChat
]

{ #category : #utils }
GtLChatOpenAILiveExamples >> waitForChatCompletion [
	self currentChat provider executions last wait
]
