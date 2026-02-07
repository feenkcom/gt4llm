Class {
	#name : #GtLChatOpenAILiveExamples,
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
	#category : #'Gt4LlmCore-Examples-OpenAI'
}

{ #category : #'api - settings' }
GtLChatOpenAILiveExamples class >> beLiveAsynchronous [
	self isLive: true.
	self isSynchronous: false.
]

{ #category : #'api - settings' }
GtLChatOpenAILiveExamples class >> beLiveSynchronous [
	self isLive: true.
	self isSynchronous: true.
]

{ #category : #'api - settings' }
GtLChatOpenAILiveExamples class >> beStubAsynchronous [
	self isLive: false.
	self isSynchronous: false.
]

{ #category : #'api - settings' }
GtLChatOpenAILiveExamples class >> beStubSynchronous [
	self isLive: false.
	self isSynchronous: true.
]

{ #category : #cleanup }
GtLChatOpenAILiveExamples class >> cleanUp: aggressive [
	aggressive ifTrue: [ self reset ]
]

{ #category : #'api - settings' }
GtLChatOpenAILiveExamples class >> isLive [
	"Return true if an example should be execute against a real OpenAI server.
	Return false, if a stub client should be used."

	^ IsLive ifNil: [ IsLive := false ]
]

{ #category : #'api - settings' }
GtLChatOpenAILiveExamples class >> isLive: aBoolean [
	"Set to true if you want to communicate with the real OpenAI server.
	Set to false, if you want to use a stub client."

	IsLive := aBoolean
]

{ #category : #'api - settings' }
GtLChatOpenAILiveExamples class >> isSynchronous [
	"Return true if an example should wait for a chat completion, false otherwise.
	I am an utility settings to easily demo written examples, without waiting for a chat to complete."

	^ IsSynchronous ifNil: [ IsSynchronous := true ]
]

{ #category : #'api - settings' }
GtLChatOpenAILiveExamples class >> isSynchronous: aBoolean [
	"Set true if an example should wait for a chat completion, false otherwise.
	I am an utility settings to easily demo written examples, without waiting for a chat to complete."

	IsSynchronous := aBoolean
]

{ #category : #'api - settings' }
GtLChatOpenAILiveExamples class >> reset [
	IsLive := nil.
	IsSynchronous := nil
]

{ #category : #'examples - calls' }
GtLChatOpenAILiveExamples >> chatWithTwoBasicMessages [
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
GtLChatOpenAILiveExamples >> createChat [
	<gtExample>
	<noTest>
	| newChat provider |
	newChat := GtLChat new.

	provider := self createProvider.
	newChat provider: provider.

	^ newChat
]

{ #category : #'examples - basic' }
GtLChatOpenAILiveExamples >> createGpt51CodexConnection [
	<gtExample>
	<noTest>
	^ GtLConnection new
		providerClass: GtLOpenAIProvider;
		label: 'GPT 5.1 Codex';
		model: 'gpt-5.1-codex'
]

{ #category : #'examples - basic' }
GtLChatOpenAILiveExamples >> createProvider [
	<gtExample>
	| aProvider |
	aProvider := self createGpt51CodexConnection buildBareProvider.

	self isLive
		ifFalse: [ aProvider client clientBuilder: GtLOpenAIClientStubBuilder new ].

	^ aProvider
]

{ #category : #'examples - basic' }
GtLChatOpenAILiveExamples >> currentChat [
	<gtExample>
	<noTest>
	^ theChat ifNil: [ theChat := self createChat ]
]

{ #category : #'examples - calls' }
GtLChatOpenAILiveExamples >> howAreYouCallExample [
	"Ready for stub execution"
	<gtExample>
	| responseMessage  |
	responseMessage := self currentChat sendMarkdown: 'How are you?'.
	
	self stubResponses: [ self howAreYouCallExample_stub_responses ].
	
	self
		waitForChatRunIsDoneThen: [ self assert: self currentChat messages size equals: 2 ].
	
	^ self currentChat
]

{ #category : #responses }
GtLChatOpenAILiveExamples >> howAreYouCallExample_stub_responses [
	^ (Array new: 1)
		at: 1
			put: (ZnResponse basicNew
					instVarAt: 1
						put: (ZnHeaders basicNew
								instVarAt: 1
									put: (ZnMultiValueDictionary new
											add: 'Date' -> 'Sat, 07 Feb 2026 00:48:08 GMT';
											add: 'Content-Type' -> 'application/json';
											add: 'Content-Length' -> '3231';
											add: 'Connection' -> 'keep-alive';
											add: 'Openai-Version' -> '2020-10-01';
											add: 'Openai-Organization' -> 'stub-organization';
											add: 'Openai-Project' -> 'proj_Xa38iMibhZ7D9IdfWF7jgeK7';
											add: 'X-Request-Id' -> 'req_8985563658f84e4ebde8ebc64dbda823';
											add: 'Openai-Processing-Ms' -> '975';
											add: 'Cf-Cache-Status' -> 'DYNAMIC';
											add: 'Strict-Transport-Security' -> 'max-age=31536000; includeSubDomains; preload';
											add: 'X-Content-Type-Options' -> 'nosniff';
											add: 'Opeanai-Project' -> 'proj_1';
											yourself);
								yourself);
					instVarAt: 2
						put: (ZnStringEntity basicNew
								instVarAt: 1
									put: (ZnMimeType basicNew
											instVarAt: 1 put: 'application';
											instVarAt: 2 put: 'json';
											instVarAt: 3 put: nil;
											yourself);
								instVarAt: 2 put: 3231;
								instVarAt: 3
									put: '{
  "id": "resp_056d399c0b21cc810069868bc75e848190affdb7abfdd19e62",
  "object": "response",
  "created_at": 1770425287,
  "status": "completed",
  "background": false,
  "billing": {
    "payer": "developer"
  },
  "completed_at": 1770425288,
  "error": null,
  "frequency_penalty": 0.0,
  "incomplete_details": null,
  "instructions": "\n# Input descriptions\rThe inputs provided follow the descriptions below\n## Markdown\r{\n\t\"type\" : \"object\",\n\t\"properties\" : {\n\t\t\"content\" : {\n\t\t\t\"type\" : \"string\",\n\t\t\t\"description\" : \"The Markdown format with a few extensions.\\rIn plain Markdown text, annotate entities as follows:\\r- Smalltalk classes using {{gtClass:ClassName}}, where `ClassName` is the name of the class to be referenced.\\r- Smalltalk methods using {{gtMethod:ClassName>>#methodName}}, where `ClassName` is the name of the class and `methodName` is the name of the method.\\r\\rFor code use three backticks sections. DO NOT annotate entities in code sections.\\r\\rDenote code snippet in Smalltalk with:\\r```smalltalk\\rPoint x: 1 y: 10\\r```\\r\\rDenote a Smalltalk method with:\\r```smalltalk-method\\rSomeClass>>someMethodWithArgument: val\\r\\t^ self + val\\r```\\r\\rDenote the definition of a new Smalltalk class in the form of a script:\\r```smalltalk\\rObject subclass: #SomeClass\\r\\tinstanceVariableNames: ''someSlotA someSlotB''\\r\\tclassVariableNames: ''\\r\\tpackage: ''SomePackage''\\r```\\rDenote SmaCC grammar definitions as:\\r```smacc-grammar\\r%root FileNode;\\r<line>\\r\\t: [^\\\\r\\\\n]+\\r\\t;\\r<newLine>\\r\\t: \\\\r | \\\\n | \\\\r\\\\n\\r\\t;\\rFile\\r\\t: Lines {{FileNode}}\\r\\t;\\rLines\\r\\t: Line\\r\\t| Lines <newLine> Line\\r\\t;\\rLine\\r\\t: \\r\\t| <line> ''line''\\r\\t;\\r```\\r\"\n\t\t}\n\t},\n\t\"required\" : [\n\t\t\"content\"\n\t],\n\t\"additionalProperties\" : false\n}",
  "max_output_tokens": null,
  "max_tool_calls": null,
  "model": "gpt-5.1-codex",
  "output": [
    {
      "id": "rs_056d399c0b21cc810069868bc7b8e481908b09bbf9d10259db",
      "type": "reasoning",
      "summary": []
    },
    {
      "id": "msg_056d399c0b21cc810069868bc7d5c88190b947dc0f3252a656",
      "type": "message",
      "status": "completed",
      "content": [
        {
          "type": "output_text",
          "annotations": [],
          "logprobs": [],
          "text": "I''m doing well, thanks for asking! How can I assist you today?"
        }
      ],
      "role": "assistant"
    }
  ],
  "parallel_tool_calls": true,
  "presence_penalty": 0.0,
  "previous_response_id": null,
  "prompt_cache_key": null,
  "prompt_cache_retention": null,
  "reasoning": {
    "effort": "medium",
    "summary": null
  },
  "safety_identifier": null,
  "service_tier": "default",
  "store": true,
  "temperature": 1.0,
  "text": {
    "format": {
      "type": "text"
    },
    "verbosity": "medium"
  },
  "tool_choice": "auto",
  "tools": [],
  "top_logprobs": 0,
  "top_p": 1.0,
  "truncation": "disabled",
  "usage": {
    "input_tokens": 452,
    "input_tokens_details": {
      "cached_tokens": 0
    },
    "output_tokens": 32,
    "output_tokens_details": {
      "reasoning_tokens": 0
    },
    "total_tokens": 484
  },
  "user": null,
  "metadata": {}
}';
								instVarAt: 4
									put: (ZnUTF8Encoder basicNew
											instVarAt: 1 put: nil;
											yourself);
								yourself);
					instVarAt: 3
						put: (ZnStatusLine basicNew
								instVarAt: 1 put: 'HTTP/1.1';
								instVarAt: 2 put: 200;
								instVarAt: 3 put: 'OK';
								yourself);
					yourself);
		yourself
]

{ #category : #examples }
GtLChatOpenAILiveExamples >> howAreYouCallExample_withStringSchema [
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

{ #category : #examples }
GtLChatOpenAILiveExamples >> howAreYouCallExample_withStringSchema_stub_responses [
	^ (Array new: 1)
		at: 1
			put: (ZnResponse basicNew
					instVarAt: 1
						put: (ZnHeaders basicNew
								instVarAt: 1
									put: (ZnMultiValueDictionary new
											add: 'Date' -> 'Sat, 07 Feb 2026 00:49:43 GMT';
											add: 'Content-Type' -> 'application/json';
											add: 'Content-Length' -> '3569';
											add: 'Connection' -> 'keep-alive';
											add: 'Openai-Version' -> '2020-10-01';
											add: 'Openai-Organization' -> 'stub-organization';
											add: 'Openai-Project' -> 'proj_Xa38iMibhZ7D9IdfWF7jgeK7';
											add: 'X-Request-Id' -> 'req_f8d288a4f1c242ce8556877f810543a0';
											add: 'Openai-Processing-Ms' -> '682';
											add: 'Cf-Cache-Status' -> 'DYNAMIC';
											add: 'Strict-Transport-Security' -> 'max-age=31536000; includeSubDomains; preload';
											add: 'X-Content-Type-Options' -> 'nosniff';
											add: 'Opeanai-Project' -> 'proj_1';
											yourself);
								yourself);
					instVarAt: 2
						put: (ZnStringEntity basicNew
								instVarAt: 1
									put: (ZnMimeType basicNew
											instVarAt: 1 put: 'application';
											instVarAt: 2 put: 'json';
											instVarAt: 3 put: nil;
											yourself);
								instVarAt: 2 put: 3569;
								instVarAt: 3
									put: '{
  "id": "resp_00a41a8a5d9498cd0069868c26ffdc81a29c7296566bc39d66",
  "object": "response",
  "created_at": 1770425383,
  "status": "completed",
  "background": false,
  "billing": {
    "payer": "developer"
  },
  "completed_at": 1770425383,
  "error": null,
  "frequency_penalty": 0.0,
  "incomplete_details": null,
  "instructions": "\n# Input descriptions\rThe inputs provided follow the descriptions below\n## Markdown\r{\n\t\"type\" : \"object\",\n\t\"properties\" : {\n\t\t\"content\" : {\n\t\t\t\"type\" : \"string\",\n\t\t\t\"description\" : \"The Markdown format with a few extensions.\\rIn plain Markdown text, annotate entities as follows:\\r- Smalltalk classes using {{gtClass:ClassName}}, where `ClassName` is the name of the class to be referenced.\\r- Smalltalk methods using {{gtMethod:ClassName>>#methodName}}, where `ClassName` is the name of the class and `methodName` is the name of the method.\\r\\rFor code use three backticks sections. DO NOT annotate entities in code sections.\\r\\rDenote code snippet in Smalltalk with:\\r```smalltalk\\rPoint x: 1 y: 10\\r```\\r\\rDenote a Smalltalk method with:\\r```smalltalk-method\\rSomeClass>>someMethodWithArgument: val\\r\\t^ self + val\\r```\\r\\rDenote the definition of a new Smalltalk class in the form of a script:\\r```smalltalk\\rObject subclass: #SomeClass\\r\\tinstanceVariableNames: ''someSlotA someSlotB''\\r\\tclassVariableNames: ''\\r\\tpackage: ''SomePackage''\\r```\\rDenote SmaCC grammar definitions as:\\r```smacc-grammar\\r%root FileNode;\\r<line>\\r\\t: [^\\\\r\\\\n]+\\r\\t;\\r<newLine>\\r\\t: \\\\r | \\\\n | \\\\r\\\\n\\r\\t;\\rFile\\r\\t: Lines {{FileNode}}\\r\\t;\\rLines\\r\\t: Line\\r\\t| Lines <newLine> Line\\r\\t;\\rLine\\r\\t: \\r\\t| <line> ''line''\\r\\t;\\r```\\r\"\n\t\t}\n\t},\n\t\"required\" : [\n\t\t\"content\"\n\t],\n\t\"additionalProperties\" : false\n}",
  "max_output_tokens": null,
  "max_tool_calls": null,
  "model": "gpt-5.1-codex",
  "output": [
    {
      "id": "rs_00a41a8a5d9498cd0069868c2742e081a2bd3553ea265e9db7",
      "type": "reasoning",
      "summary": []
    },
    {
      "id": "msg_00a41a8a5d9498cd0069868c27649c81a2aa1c8542869c16b2",
      "type": "message",
      "status": "completed",
      "content": [
        {
          "type": "output_text",
          "annotations": [],
          "logprobs": [],
          "text": "{\"Response\":\"I''m doing well, thank you! How can I help you today?\"}"
        }
      ],
      "role": "assistant"
    }
  ],
  "parallel_tool_calls": true,
  "presence_penalty": 0.0,
  "previous_response_id": null,
  "prompt_cache_key": null,
  "prompt_cache_retention": null,
  "reasoning": {
    "effort": "medium",
    "summary": null
  },
  "safety_identifier": null,
  "service_tier": "default",
  "store": true,
  "temperature": 1.0,
  "text": {
    "format": {
      "type": "json_schema",
      "description": null,
      "name": "JsonSchema",
      "schema": {
        "type": "object",
        "properties": {
          "Response": {
            "type": "string"
          }
        },
        "required": [
          "Response"
        ],
        "additionalProperties": false
      },
      "strict": true
    },
    "verbosity": "medium"
  },
  "tool_choice": "auto",
  "tools": [],
  "top_logprobs": 0,
  "top_p": 1.0,
  "truncation": "disabled",
  "usage": {
    "input_tokens": 474,
    "input_tokens_details": {
      "cached_tokens": 0
    },
    "output_tokens": 36,
    "output_tokens_details": {
      "reasoning_tokens": 0
    },
    "total_tokens": 510
  },
  "user": null,
  "metadata": {}
}';
								instVarAt: 4
									put: (ZnUTF8Encoder basicNew
											instVarAt: 1 put: nil;
											yourself);
								yourself);
					instVarAt: 3
						put: (ZnStatusLine basicNew
								instVarAt: 1 put: 'HTTP/1.1';
								instVarAt: 2 put: 200;
								instVarAt: 3 put: 'OK';
								yourself);
					yourself);
		yourself
]

{ #category : #testing }
GtLChatOpenAILiveExamples >> isLive [
	"Return true if an example should be execute against a real OpenAI server.
	Return false, if a stub client should be used."

	^ isLive ifNil: [ self class isLive ]
]

{ #category : #'api - initialization' }
GtLChatOpenAILiveExamples >> isLive: aBoolean [
	isLive := aBoolean
]

{ #category : #testing }
GtLChatOpenAILiveExamples >> isSynchronous [
	"Return true if an example should wait for a chat completion, false otherwise.
	I am an utility settings to easily demo written examples, without waiting for a chat to complete."

	^ isSynchronous ifNil: [ self class isSynchronous ]
]

{ #category : #'api - initialization' }
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
GtLChatOpenAILiveExamples >> messageWithToolCallExample_magritteMarkdown [
	"Ready for stub execution"
	<gtExample>
	| messageString currentMessage responseMessage |
	messageString := 'Use tools and give me a description of the class BlElement'.

	self stubResponses: [ self messageWithToolCallExample_magritteMarkdown_stub_responses ].
	
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

{ #category : #responses }
GtLChatOpenAILiveExamples >> messageWithToolCallExample_magritteMarkdown_stub_responses [
	^ (Array new: 2)
		at: 1
			put: (ZnResponse basicNew
					instVarAt: 1
						put: (ZnHeaders basicNew
								instVarAt: 1
									put: (ZnMultiValueDictionary new
											add: 'Date' -> 'Fri, 06 Feb 2026 22:56:38 GMT';
											add: 'Content-Type' -> 'application/json';
											add: 'Content-Length' -> '5244';
											add: 'Connection' -> 'keep-alive';
											add: 'Openai-Version' -> '2020-10-01';
											add: 'Openai-Organization' -> 'stub-organization';
											add: 'Openai-Project' -> 'proj_Xa38iMibhZ7D9IdfWF7jgeK7';
											add: 'X-Request-Id' -> 'req_43950f88158a4e6697c6a9e8f224655f';
											add: 'Openai-Processing-Ms' -> '1078';
											add: 'Cf-Cache-Status' -> 'DYNAMIC';
											add: 'Strict-Transport-Security' -> 'max-age=31536000; includeSubDomains; preload';
											add: 'X-Content-Type-Options' -> 'nosniff';
											add: 'Opeanai-Project' -> 'proj_1';
											yourself);
								yourself);
					instVarAt: 2
						put: (ZnStringEntity basicNew
								instVarAt: 1
									put: (ZnMimeType basicNew
											instVarAt: 1 put: 'application';
											instVarAt: 2 put: 'json';
											instVarAt: 3 put: nil;
											yourself);
								instVarAt: 2 put: 5244;
								instVarAt: 3
									put: '{
  "id": "resp_0f9f715d7a63a7d800698671a5445c81979a852be03d6da09b",
  "object": "response",
  "created_at": 1770418597,
  "status": "completed",
  "background": false,
  "billing": {
    "payer": "developer"
  },
  "completed_at": 1770418598,
  "error": null,
  "frequency_penalty": 0.0,
  "incomplete_details": null,
  "instructions": "\n# Input descriptions\rThe inputs provided follow the descriptions below\n## Markdown\r{\n\t\"type\" : \"object\",\n\t\"properties\" : {\n\t\t\"content\" : {\n\t\t\t\"type\" : \"string\",\n\t\t\t\"description\" : \"The Markdown format with a few extensions.\\rIn plain Markdown text, annotate entities as follows:\\r- Smalltalk classes using {{gtClass:ClassName}}, where `ClassName` is the name of the class to be referenced.\\r- Smalltalk methods using {{gtMethod:ClassName>>#methodName}}, where `ClassName` is the name of the class and `methodName` is the name of the method.\\r\\rFor code use three backticks sections. DO NOT annotate entities in code sections.\\r\\rDenote code snippet in Smalltalk with:\\r```smalltalk\\rPoint x: 1 y: 10\\r```\\r\\rDenote a Smalltalk method with:\\r```smalltalk-method\\rSomeClass>>someMethodWithArgument: val\\r\\t^ self + val\\r```\\r\\rDenote the definition of a new Smalltalk class in the form of a script:\\r```smalltalk\\rObject subclass: #SomeClass\\r\\tinstanceVariableNames: ''someSlotA someSlotB''\\r\\tclassVariableNames: ''\\r\\tpackage: ''SomePackage''\\r```\\rDenote SmaCC grammar definitions as:\\r```smacc-grammar\\r%root FileNode;\\r<line>\\r\\t: [^\\\\r\\\\n]+\\r\\t;\\r<newLine>\\r\\t: \\\\r | \\\\n | \\\\r\\\\n\\r\\t;\\rFile\\r\\t: Lines {{FileNode}}\\r\\t;\\rLines\\r\\t: Line\\r\\t| Lines <newLine> Line\\r\\t;\\rLine\\r\\t: \\r\\t| <line> ''line''\\r\\t;\\r```\\r\"\n\t\t}\n\t},\n\t\"required\" : [\n\t\t\"content\"\n\t],\n\t\"additionalProperties\" : false\n}",
  "max_output_tokens": null,
  "max_tool_calls": null,
  "model": "gpt-5.1-codex",
  "output": [
    {
      "id": "rs_0f9f715d7a63a7d800698671a5c8448197aff3248271aeb2f6",
      "type": "reasoning",
      "summary": []
    },
    {
      "id": "fc_0f9f715d7a63a7d800698671a604d88197b69613b4988e78a0",
      "type": "function_call",
      "status": "completed",
      "arguments": "{\"className\":\"BlElement\"}",
      "call_id": "call_fOoykBCsENqFFNFF6kuvMcX7",
      "name": "lookupClass"
    }
  ],
  "parallel_tool_calls": true,
  "presence_penalty": 0.0,
  "previous_response_id": null,
  "prompt_cache_key": null,
  "prompt_cache_retention": null,
  "reasoning": {
    "effort": "medium",
    "summary": null
  },
  "safety_identifier": null,
  "service_tier": "default",
  "store": true,
  "temperature": 1.0,
  "text": {
    "format": {
      "type": "json_schema",
      "description": null,
      "name": "JsonSchema",
      "schema": {
        "type": "object",
        "properties": {
          "Markdown": {
            "type": "object",
            "properties": {
              "content": {
                "type": "string",
                "description": "The Markdown format with a few extensions.\rIn plain Markdown text, annotate entities as follows:\r- Smalltalk classes using {{gtClass:ClassName}}, where `ClassName` is the name of the class to be referenced.\r- Smalltalk methods using {{gtMethod:ClassName>>#methodName}}, where `ClassName` is the name of the class and `methodName` is the name of the method.\r\rFor code use three backticks sections. DO NOT annotate entities in code sections.\r\rDenote code snippet in Smalltalk with:\r```smalltalk\rPoint x: 1 y: 10\r```\r\rDenote a Smalltalk method with:\r```smalltalk-method\rSomeClass>>someMethodWithArgument: val\r\t^ self + val\r```\r\rDenote the definition of a new Smalltalk class in the form of a script:\r```smalltalk\rObject subclass: #SomeClass\r\tinstanceVariableNames: ''someSlotA someSlotB''\r\tclassVariableNames: ''\r\tpackage: ''SomePackage''\r```\rDenote SmaCC grammar definitions as:\r```smacc-grammar\r%root FileNode;\r<line>\r\t: [^\\r\\n]+\r\t;\r<newLine>\r\t: \\r | \\n | \\r\\n\r\t;\rFile\r\t: Lines {{FileNode}}\r\t;\rLines\r\t: Line\r\t| Lines <newLine> Line\r\t;\rLine\r\t: \r\t| <line> ''line''\r\t;\r```\r"
              }
            },
            "required": [
              "content"
            ],
            "additionalProperties": false
          }
        },
        "required": [
          "Markdown"
        ],
        "additionalProperties": false
      },
      "strict": true
    },
    "verbosity": "medium"
  },
  "tool_choice": "auto",
  "tools": [
    {
      "type": "function",
      "description": "Get the details of a class as JSON.",
      "name": "lookupClass",
      "parameters": {
        "additionalProperties": false,
        "properties": {
          "className": {
            "type": "string"
          }
        },
        "type": "object",
        "required": [
          "className"
        ]
      },
      "strict": true
    }
  ],
  "top_logprobs": 0,
  "top_p": 1.0,
  "truncation": "disabled",
  "usage": {
    "input_tokens": 877,
    "input_tokens_details": {
      "cached_tokens": 0
    },
    "output_tokens": 34,
    "output_tokens_details": {
      "reasoning_tokens": 0
    },
    "total_tokens": 911
  },
  "user": null,
  "metadata": {}
}';
								instVarAt: 4
									put: (ZnUTF8Encoder basicNew
											instVarAt: 1 put: nil;
											yourself);
								yourself);
					instVarAt: 3
						put: (ZnStatusLine basicNew
								instVarAt: 1 put: 'HTTP/1.1';
								instVarAt: 2 put: 200;
								instVarAt: 3 put: 'OK';
								yourself);
					yourself);
		at: 2
			put: (ZnResponse basicNew
					instVarAt: 1
						put: (ZnHeaders basicNew
								instVarAt: 1
									put: (ZnMultiValueDictionary new
											add: 'Date' -> 'Fri, 06 Feb 2026 22:56:45 GMT';
											add: 'Content-Type' -> 'application/json';
											add: 'Content-Length' -> '7502';
											add: 'Connection' -> 'keep-alive';
											add: 'Openai-Version' -> '2020-10-01';
											add: 'Openai-Organization' -> 'stub-organization';
											add: 'Openai-Project' -> 'proj_Xa38iMibhZ7D9IdfWF7jgeK7';
											add: 'X-Request-Id' -> 'req_d0835c54da834a1fb4c4f2d65ac5d754';
											add: 'Openai-Processing-Ms' -> '6605';
											add: 'Cf-Cache-Status' -> 'DYNAMIC';
											add: 'Strict-Transport-Security' -> 'max-age=31536000; includeSubDomains; preload';
											add: 'X-Content-Type-Options' -> 'nosniff';
											add: 'Opeanai-Project' -> 'proj_1';
											yourself);
								yourself);
					instVarAt: 2
						put: (ZnStringEntity basicNew
								instVarAt: 1
									put: (ZnMimeType basicNew
											instVarAt: 1 put: 'application';
											instVarAt: 2 put: 'json';
											instVarAt: 3 put: nil;
											yourself);
								instVarAt: 2 put: 7502;
								instVarAt: 3
									put: '{
  "id": "resp_0c7620bc8505c63c00698671a6d65881958c845ad3b51cfad0",
  "object": "response",
  "created_at": 1770418598,
  "status": "completed",
  "background": false,
  "billing": {
    "payer": "developer"
  },
  "completed_at": 1770418605,
  "error": null,
  "frequency_penalty": 0.0,
  "incomplete_details": null,
  "instructions": "\n# Input descriptions\rThe inputs provided follow the descriptions below\n## Markdown\r{\n\t\"type\" : \"object\",\n\t\"properties\" : {\n\t\t\"content\" : {\n\t\t\t\"type\" : \"string\",\n\t\t\t\"description\" : \"The Markdown format with a few extensions.\\rIn plain Markdown text, annotate entities as follows:\\r- Smalltalk classes using {{gtClass:ClassName}}, where `ClassName` is the name of the class to be referenced.\\r- Smalltalk methods using {{gtMethod:ClassName>>#methodName}}, where `ClassName` is the name of the class and `methodName` is the name of the method.\\r\\rFor code use three backticks sections. DO NOT annotate entities in code sections.\\r\\rDenote code snippet in Smalltalk with:\\r```smalltalk\\rPoint x: 1 y: 10\\r```\\r\\rDenote a Smalltalk method with:\\r```smalltalk-method\\rSomeClass>>someMethodWithArgument: val\\r\\t^ self + val\\r```\\r\\rDenote the definition of a new Smalltalk class in the form of a script:\\r```smalltalk\\rObject subclass: #SomeClass\\r\\tinstanceVariableNames: ''someSlotA someSlotB''\\r\\tclassVariableNames: ''\\r\\tpackage: ''SomePackage''\\r```\\rDenote SmaCC grammar definitions as:\\r```smacc-grammar\\r%root FileNode;\\r<line>\\r\\t: [^\\\\r\\\\n]+\\r\\t;\\r<newLine>\\r\\t: \\\\r | \\\\n | \\\\r\\\\n\\r\\t;\\rFile\\r\\t: Lines {{FileNode}}\\r\\t;\\rLines\\r\\t: Line\\r\\t| Lines <newLine> Line\\r\\t;\\rLine\\r\\t: \\r\\t| <line> ''line''\\r\\t;\\r```\\r\"\n\t\t}\n\t},\n\t\"required\" : [\n\t\t\"content\"\n\t],\n\t\"additionalProperties\" : false\n}",
  "max_output_tokens": null,
  "max_tool_calls": null,
  "model": "gpt-5.1-codex",
  "output": [
    {
      "id": "rs_0c7620bc8505c63c00698671a7605c8195bf612ed82343c4c2",
      "type": "reasoning",
      "summary": []
    },
    {
      "id": "msg_0c7620bc8505c63c00698671a7b54c819592289a72f7d60965",
      "type": "message",
      "status": "completed",
      "content": [
        {
          "type": "output_text",
          "annotations": [],
          "logprobs": [],
          "text": "{\"Markdown\":{\"content\":\"{{gtClass:BlElement}} is the root building block for every visual node in the Bloc framework. It models interactive UI elements that can be composed hierarchically via parent/children relationships, guaranteeing a single parent per child and signaling {{gtClass:BlAlreadyAddedAsChildError}} for duplicate insertions.\\n\\n### Visual configuration\\nThe class exposes core styling knobs:\\n- Backgrounds described by {{gtClass:BlBackground}} (see {{gtClass:BlBackgroundExamples}}).\\n- Borders via {{gtClass:BlBorder}} (see {{gtClass:BlBorderExamples}}).\\n- Opacity controls with illustrated scenarios in {{gtClass:BlOpacityExamples}}.\\nAdditional properties cover size, theme, elevation, outlines (insets/outsets), and composition layers.\\n\\n### Composition & layout\\nInstances manage a collection of child elements and provide a rich API for tree manipulation (e.g., {{gtMethod:BlElement>>#addChild:}}, {{gtMethod:BlElement>>#addChildFirst:}}, removal helpers, sibling traversal, anchoring, and querying). Layout behavior is delegated to pluggable {{gtClass:BlLayout}} strategies, while geometry is handled by {{gtClass:BlElementGeometry}} subclasses governing bounds, clipping, and transformations. Measuring, laying out, and painting are coordinated through methods such as `measureSafely:`, `applyLayoutIn:context:`, and `fullPaintOn:offset:`.\\n\\n### Interaction & state\\n{{gtClass:BlElement}} supports focus handling (`requestFocus`, `beFocusable`), event dispatch and filtering (`addEventHandlerOn:do:`, `buildEventDispatchChain:`), cursor management, and shortcuts. It can host \u201captitudes\u201d and \u201clooks\u201d to attach behaviors or styles, interact with {{gtClass:BlSpace}} via `attachToSceneGraph`, and export visual output (PNG, SVG, PDF, Sparta forms).\\n\\n### Extensibility\\nWith numerous slots (layout, constraints, transformation, visuals, task queue, theme, user data, etc.) and lifecycle callbacks (`onAddedToSceneGraph`, `onTransformationChanged`, `onLayoutDone`, \u2026), {{gtClass:BlElement}} offers a comprehensive foundation for building custom Bloc widgets that need fine-grained control over rendering, input, and composition.\"}}"
        }
      ],
      "role": "assistant"
    }
  ],
  "parallel_tool_calls": true,
  "presence_penalty": 0.0,
  "previous_response_id": null,
  "prompt_cache_key": null,
  "prompt_cache_retention": null,
  "reasoning": {
    "effort": "medium",
    "summary": null
  },
  "safety_identifier": null,
  "service_tier": "default",
  "store": true,
  "temperature": 1.0,
  "text": {
    "format": {
      "type": "json_schema",
      "description": null,
      "name": "JsonSchema",
      "schema": {
        "type": "object",
        "properties": {
          "Markdown": {
            "type": "object",
            "properties": {
              "content": {
                "type": "string",
                "description": "The Markdown format with a few extensions.\rIn plain Markdown text, annotate entities as follows:\r- Smalltalk classes using {{gtClass:ClassName}}, where `ClassName` is the name of the class to be referenced.\r- Smalltalk methods using {{gtMethod:ClassName>>#methodName}}, where `ClassName` is the name of the class and `methodName` is the name of the method.\r\rFor code use three backticks sections. DO NOT annotate entities in code sections.\r\rDenote code snippet in Smalltalk with:\r```smalltalk\rPoint x: 1 y: 10\r```\r\rDenote a Smalltalk method with:\r```smalltalk-method\rSomeClass>>someMethodWithArgument: val\r\t^ self + val\r```\r\rDenote the definition of a new Smalltalk class in the form of a script:\r```smalltalk\rObject subclass: #SomeClass\r\tinstanceVariableNames: ''someSlotA someSlotB''\r\tclassVariableNames: ''\r\tpackage: ''SomePackage''\r```\rDenote SmaCC grammar definitions as:\r```smacc-grammar\r%root FileNode;\r<line>\r\t: [^\\r\\n]+\r\t;\r<newLine>\r\t: \\r | \\n | \\r\\n\r\t;\rFile\r\t: Lines {{FileNode}}\r\t;\rLines\r\t: Line\r\t| Lines <newLine> Line\r\t;\rLine\r\t: \r\t| <line> ''line''\r\t;\r```\r"
              }
            },
            "required": [
              "content"
            ],
            "additionalProperties": false
          }
        },
        "required": [
          "Markdown"
        ],
        "additionalProperties": false
      },
      "strict": true
    },
    "verbosity": "medium"
  },
  "tool_choice": "auto",
  "tools": [
    {
      "type": "function",
      "description": "Get the details of a class as JSON.",
      "name": "lookupClass",
      "parameters": {
        "additionalProperties": false,
        "properties": {
          "className": {
            "type": "string"
          }
        },
        "type": "object",
        "required": [
          "className"
        ]
      },
      "strict": true
    }
  ],
  "top_logprobs": 0,
  "top_p": 1.0,
  "truncation": "disabled",
  "usage": {
    "input_tokens": 4321,
    "input_tokens_details": {
      "cached_tokens": 3712
    },
    "output_tokens": 520,
    "output_tokens_details": {
      "reasoning_tokens": 0
    },
    "total_tokens": 4841
  },
  "user": null,
  "metadata": {}
}';
								instVarAt: 4
									put: (ZnUTF8Encoder basicNew
											instVarAt: 1 put: nil;
											yourself);
								yourself);
					instVarAt: 3
						put: (ZnStatusLine basicNew
								instVarAt: 1 put: 'HTTP/1.1';
								instVarAt: 2 put: 200;
								instVarAt: 3 put: 'OK';
								yourself);
					yourself);
		yourself
]

{ #category : #'examples - calls' }
GtLChatOpenAILiveExamples >> messageWithToolCallExample_stub_responses [
	^ (Array new: 2)
		at: 1
			put: (ZnResponse basicNew
					instVarAt: 1
						put: (ZnHeaders basicNew
								instVarAt: 1
									put: (ZnMultiValueDictionary new
											add: 'Date' -> 'Sat, 07 Feb 2026 00:26:48 GMT';
											add: 'Content-Type' -> 'application/json';
											add: 'Content-Length' -> '5244';
											add: 'Connection' -> 'keep-alive';
											add: 'Openai-Version' -> '2020-10-01';
											add: 'Openai-Organization' -> 'stub-organization';
											add: 'Openai-Project' -> 'proj_Xa38iMibhZ7D9IdfWF7jgeK7';
											add: 'X-Request-Id' -> 'req_959ee53043ef483890f58a1e2e9c0aa3';
											add: 'Openai-Processing-Ms' -> '1063';
											add: 'Cf-Cache-Status' -> 'DYNAMIC';
											add: 'Strict-Transport-Security' -> 'max-age=31536000; includeSubDomains; preload';
											add: 'X-Content-Type-Options' -> 'nosniff';
											add: 'Opeanai-Project' -> 'proj_1';
											yourself);
								yourself);
					instVarAt: 2
						put: (ZnStringEntity basicNew
								instVarAt: 1
									put: (ZnMimeType basicNew
											instVarAt: 1 put: 'application';
											instVarAt: 2 put: 'json';
											instVarAt: 3 put: nil;
											yourself);
								instVarAt: 2 put: 5244;
								instVarAt: 3
									put: '{
  "id": "resp_0b54c5d8fe204ba400698686c7a62081a38e6eeed443e1feed",
  "object": "response",
  "created_at": 1770424007,
  "status": "completed",
  "background": false,
  "billing": {
    "payer": "developer"
  },
  "completed_at": 1770424008,
  "error": null,
  "frequency_penalty": 0.0,
  "incomplete_details": null,
  "instructions": "\n# Input descriptions\rThe inputs provided follow the descriptions below\n## Markdown\r{\n\t\"type\" : \"object\",\n\t\"properties\" : {\n\t\t\"content\" : {\n\t\t\t\"type\" : \"string\",\n\t\t\t\"description\" : \"The Markdown format with a few extensions.\\rIn plain Markdown text, annotate entities as follows:\\r- Smalltalk classes using {{gtClass:ClassName}}, where `ClassName` is the name of the class to be referenced.\\r- Smalltalk methods using {{gtMethod:ClassName>>#methodName}}, where `ClassName` is the name of the class and `methodName` is the name of the method.\\r\\rFor code use three backticks sections. DO NOT annotate entities in code sections.\\r\\rDenote code snippet in Smalltalk with:\\r```smalltalk\\rPoint x: 1 y: 10\\r```\\r\\rDenote a Smalltalk method with:\\r```smalltalk-method\\rSomeClass>>someMethodWithArgument: val\\r\\t^ self + val\\r```\\r\\rDenote the definition of a new Smalltalk class in the form of a script:\\r```smalltalk\\rObject subclass: #SomeClass\\r\\tinstanceVariableNames: ''someSlotA someSlotB''\\r\\tclassVariableNames: ''\\r\\tpackage: ''SomePackage''\\r```\\rDenote SmaCC grammar definitions as:\\r```smacc-grammar\\r%root FileNode;\\r<line>\\r\\t: [^\\\\r\\\\n]+\\r\\t;\\r<newLine>\\r\\t: \\\\r | \\\\n | \\\\r\\\\n\\r\\t;\\rFile\\r\\t: Lines {{FileNode}}\\r\\t;\\rLines\\r\\t: Line\\r\\t| Lines <newLine> Line\\r\\t;\\rLine\\r\\t: \\r\\t| <line> ''line''\\r\\t;\\r```\\r\"\n\t\t}\n\t},\n\t\"required\" : [\n\t\t\"content\"\n\t],\n\t\"additionalProperties\" : false\n}",
  "max_output_tokens": null,
  "max_tool_calls": null,
  "model": "gpt-5.1-codex",
  "output": [
    {
      "id": "rs_0b54c5d8fe204ba400698686c8265c81a38740e17adbce1614",
      "type": "reasoning",
      "summary": []
    },
    {
      "id": "fc_0b54c5d8fe204ba400698686c8522c81a39b21be0cafe064a6",
      "type": "function_call",
      "status": "completed",
      "arguments": "{\"className\":\"BlElement\"}",
      "call_id": "call_46kiQYzYolj90fLiG4ahXTiK",
      "name": "lookupClass"
    }
  ],
  "parallel_tool_calls": true,
  "presence_penalty": 0.0,
  "previous_response_id": null,
  "prompt_cache_key": null,
  "prompt_cache_retention": null,
  "reasoning": {
    "effort": "medium",
    "summary": null
  },
  "safety_identifier": null,
  "service_tier": "default",
  "store": true,
  "temperature": 1.0,
  "text": {
    "format": {
      "type": "json_schema",
      "description": null,
      "name": "JsonSchema",
      "schema": {
        "type": "object",
        "properties": {
          "Markdown": {
            "type": "object",
            "properties": {
              "content": {
                "type": "string",
                "description": "The Markdown format with a few extensions.\rIn plain Markdown text, annotate entities as follows:\r- Smalltalk classes using {{gtClass:ClassName}}, where `ClassName` is the name of the class to be referenced.\r- Smalltalk methods using {{gtMethod:ClassName>>#methodName}}, where `ClassName` is the name of the class and `methodName` is the name of the method.\r\rFor code use three backticks sections. DO NOT annotate entities in code sections.\r\rDenote code snippet in Smalltalk with:\r```smalltalk\rPoint x: 1 y: 10\r```\r\rDenote a Smalltalk method with:\r```smalltalk-method\rSomeClass>>someMethodWithArgument: val\r\t^ self + val\r```\r\rDenote the definition of a new Smalltalk class in the form of a script:\r```smalltalk\rObject subclass: #SomeClass\r\tinstanceVariableNames: ''someSlotA someSlotB''\r\tclassVariableNames: ''\r\tpackage: ''SomePackage''\r```\rDenote SmaCC grammar definitions as:\r```smacc-grammar\r%root FileNode;\r<line>\r\t: [^\\r\\n]+\r\t;\r<newLine>\r\t: \\r | \\n | \\r\\n\r\t;\rFile\r\t: Lines {{FileNode}}\r\t;\rLines\r\t: Line\r\t| Lines <newLine> Line\r\t;\rLine\r\t: \r\t| <line> ''line''\r\t;\r```\r"
              }
            },
            "required": [
              "content"
            ],
            "additionalProperties": false
          }
        },
        "required": [
          "Markdown"
        ],
        "additionalProperties": false
      },
      "strict": true
    },
    "verbosity": "medium"
  },
  "tool_choice": "auto",
  "tools": [
    {
      "type": "function",
      "description": "Get the details of a class as JSON.",
      "name": "lookupClass",
      "parameters": {
        "additionalProperties": false,
        "properties": {
          "className": {
            "type": "string"
          }
        },
        "type": "object",
        "required": [
          "className"
        ]
      },
      "strict": true
    }
  ],
  "top_logprobs": 0,
  "top_p": 1.0,
  "truncation": "disabled",
  "usage": {
    "input_tokens": 877,
    "input_tokens_details": {
      "cached_tokens": 0
    },
    "output_tokens": 30,
    "output_tokens_details": {
      "reasoning_tokens": 0
    },
    "total_tokens": 907
  },
  "user": null,
  "metadata": {}
}';
								instVarAt: 4
									put: (ZnUTF8Encoder basicNew
											instVarAt: 1 put: nil;
											yourself);
								yourself);
					instVarAt: 3
						put: (ZnStatusLine basicNew
								instVarAt: 1 put: 'HTTP/1.1';
								instVarAt: 2 put: 200;
								instVarAt: 3 put: 'OK';
								yourself);
					yourself);
		at: 2
			put: (ZnResponse basicNew
					instVarAt: 1
						put: (ZnHeaders basicNew
								instVarAt: 1
									put: (ZnMultiValueDictionary new
											add: 'Date' -> 'Sat, 07 Feb 2026 00:26:59 GMT';
											add: 'Content-Type' -> 'application/json';
											add: 'Content-Length' -> '8555';
											add: 'Connection' -> 'keep-alive';
											add: 'Openai-Version' -> '2020-10-01';
											add: 'Openai-Organization' -> 'stub-organization';
											add: 'Openai-Project' -> 'proj_Xa38iMibhZ7D9IdfWF7jgeK7';
											add: 'X-Request-Id' -> 'req_ef39079139fc4c1b981d6c670474ee9c';
											add: 'Openai-Processing-Ms' -> '10061';
											add: 'Cf-Cache-Status' -> 'DYNAMIC';
											add: 'Strict-Transport-Security' -> 'max-age=31536000; includeSubDomains; preload';
											add: 'X-Content-Type-Options' -> 'nosniff';
											add: 'Opeanai-Project' -> 'proj_1';
											yourself);
								yourself);
					instVarAt: 2
						put: (ZnStringEntity basicNew
								instVarAt: 1
									put: (ZnMimeType basicNew
											instVarAt: 1 put: 'application';
											instVarAt: 2 put: 'json';
											instVarAt: 3 put: nil;
											yourself);
								instVarAt: 2 put: 8555;
								instVarAt: 3
									put: '{
  "id": "resp_081ef4e0fdf451eb00698686c964cc8195925e92a7aec32f9a",
  "object": "response",
  "created_at": 1770424009,
  "status": "completed",
  "background": false,
  "billing": {
    "payer": "developer"
  },
  "completed_at": 1770424019,
  "error": null,
  "frequency_penalty": 0.0,
  "incomplete_details": null,
  "instructions": "\n# Input descriptions\rThe inputs provided follow the descriptions below\n## Markdown\r{\n\t\"type\" : \"object\",\n\t\"properties\" : {\n\t\t\"content\" : {\n\t\t\t\"type\" : \"string\",\n\t\t\t\"description\" : \"The Markdown format with a few extensions.\\rIn plain Markdown text, annotate entities as follows:\\r- Smalltalk classes using {{gtClass:ClassName}}, where `ClassName` is the name of the class to be referenced.\\r- Smalltalk methods using {{gtMethod:ClassName>>#methodName}}, where `ClassName` is the name of the class and `methodName` is the name of the method.\\r\\rFor code use three backticks sections. DO NOT annotate entities in code sections.\\r\\rDenote code snippet in Smalltalk with:\\r```smalltalk\\rPoint x: 1 y: 10\\r```\\r\\rDenote a Smalltalk method with:\\r```smalltalk-method\\rSomeClass>>someMethodWithArgument: val\\r\\t^ self + val\\r```\\r\\rDenote the definition of a new Smalltalk class in the form of a script:\\r```smalltalk\\rObject subclass: #SomeClass\\r\\tinstanceVariableNames: ''someSlotA someSlotB''\\r\\tclassVariableNames: ''\\r\\tpackage: ''SomePackage''\\r```\\rDenote SmaCC grammar definitions as:\\r```smacc-grammar\\r%root FileNode;\\r<line>\\r\\t: [^\\\\r\\\\n]+\\r\\t;\\r<newLine>\\r\\t: \\\\r | \\\\n | \\\\r\\\\n\\r\\t;\\rFile\\r\\t: Lines {{FileNode}}\\r\\t;\\rLines\\r\\t: Line\\r\\t| Lines <newLine> Line\\r\\t;\\rLine\\r\\t: \\r\\t| <line> ''line''\\r\\t;\\r```\\r\"\n\t\t}\n\t},\n\t\"required\" : [\n\t\t\"content\"\n\t],\n\t\"additionalProperties\" : false\n}",
  "max_output_tokens": null,
  "max_tool_calls": null,
  "model": "gpt-5.1-codex",
  "output": [
    {
      "id": "rs_081ef4e0fdf451eb00698686c9e5608195aeac21785f40011f",
      "type": "reasoning",
      "summary": []
    },
    {
      "id": "msg_081ef4e0fdf451eb00698686cd03988195ae298c562777c094",
      "type": "message",
      "status": "completed",
      "content": [
        {
          "type": "output_text",
          "annotations": [],
          "logprobs": [],
          "text": "{\"Markdown\":{\"content\":\"{{gtClass:BlElement}} is the core visual building block in Bloc. Every visual widget you place in a scene graph is ultimately a subclass or instance of this class, making it the foundation for composition, layout, styling, and event handling across the framework.\\n\\n### Position in the hierarchy\\n- Superclass: {{gtClass:Object}}\\n- Package: Bloc\\n\\n### Responsibilities\\n- **Visual properties** \u2013 manages background, border, opacity, elevation, visibility, clipping, and effects. For example, backgrounds are defined through {{gtClass:BlBackground}} instances (see {{gtClass:BlBackgroundExamples}}), while borders rely on {{gtClass:BlBorder}} (with more details in {{gtClass:BlBorderExamples}}). Opacity behavior is illustrated in {{gtClass:BlOpacityExamples}}.\\n- **Composition** \u2013 enforces the 1:N parent-to-children relationship. It prevents the same child from belonging to multiple parents by signaling {{gtClass:BlAlreadyAddedAsChildError}} when misused.\\n- **Layout & geometry** \u2013 coordinates measurement and positioning through {{gtClass:BlLayout}} strategies and associated {{gtClass:BlElementGeometry}} objects. Specialized examples are covered in {{gtClass:BlGeometryVisualAndLayoutBoundsExamples}} and other layout documentation.\\n- **Event handling** \u2013 dispatches and filters events through its `eventDispatcher`, manages focusability, and propagates repaint/layout requests.\\n- **Scene-graph integration** \u2013 handles attaching/detaching from spaces, theme propagation, task queues, and compositing requirements.\\n\\n### Key instance variables\\n- `parent`, `children`, `bounds`, `constraints`, `layout`, `transformation`, `eventDispatcher`, `visuals`, `theme`, `flags`, `taskQueue`, `userData`, among others. These slots capture the state needed for composition, layout, rendering, and user-defined metadata.\\n\\n### Notable API highlights\\n- **Child management**: {{gtMethod:BlElement>>#addChild:}}, {{gtMethod:BlElement>>#addChildFirst:}}, {{gtMethod:BlElement>>#removeChild:}}, and related helpers (e.g., `childAt:`, `childrenDo:`) organize the element hierarchy.\\n- **Layout & measurement**: methods like {{gtMethod:BlElement>>#measure:}}, {{gtMethod:BlElement>>#applyLayoutIn:}}, {{gtMethod:BlElement>>#requestLayout}}, and {{gtMethod:BlElement>>#layout}} coordinate the measurement pipeline.\\n- **Rendering**: {{gtMethod:BlElement>>#drawOnSpartaCanvas:}}, {{gtMethod:BlElement>>#paintMeAndChildrenOn:offset:}}, plus helpers for background/border editors (`editorForBackground`, `editorForBorder`, etc.).\\n- **Focus & events**: {{gtMethod:BlElement>>#requestFocus}}, `beFocusable`, `hasFocus`, `addEventHandler:on:`, `fireEvent:` support interactive behavior.\\n\\n### Example\\n```smalltalk\\n| parent child |\\nparent := BlElement new\\n\\tbackground: Color veryVeryLightGray;\\n\\tsize: 100@100.\\nchild := BlElement new\\n\\tbackground: Color red lighter;\\n\\tsize: 50@50.\\nparent addChild: child.\\n```\\n\\nIn summary, {{gtClass:BlElement}} encapsulates the essential mechanisms for creating, composing, and rendering Bloc user interfaces, serving as the gateway to layout strategies, rendering customization, and event-driven behavior across the toolkit.\"}}"
        }
      ],
      "role": "assistant"
    }
  ],
  "parallel_tool_calls": true,
  "presence_penalty": 0.0,
  "previous_response_id": null,
  "prompt_cache_key": null,
  "prompt_cache_retention": null,
  "reasoning": {
    "effort": "medium",
    "summary": null
  },
  "safety_identifier": null,
  "service_tier": "default",
  "store": true,
  "temperature": 1.0,
  "text": {
    "format": {
      "type": "json_schema",
      "description": null,
      "name": "JsonSchema",
      "schema": {
        "type": "object",
        "properties": {
          "Markdown": {
            "type": "object",
            "properties": {
              "content": {
                "type": "string",
                "description": "The Markdown format with a few extensions.\rIn plain Markdown text, annotate entities as follows:\r- Smalltalk classes using {{gtClass:ClassName}}, where `ClassName` is the name of the class to be referenced.\r- Smalltalk methods using {{gtMethod:ClassName>>#methodName}}, where `ClassName` is the name of the class and `methodName` is the name of the method.\r\rFor code use three backticks sections. DO NOT annotate entities in code sections.\r\rDenote code snippet in Smalltalk with:\r```smalltalk\rPoint x: 1 y: 10\r```\r\rDenote a Smalltalk method with:\r```smalltalk-method\rSomeClass>>someMethodWithArgument: val\r\t^ self + val\r```\r\rDenote the definition of a new Smalltalk class in the form of a script:\r```smalltalk\rObject subclass: #SomeClass\r\tinstanceVariableNames: ''someSlotA someSlotB''\r\tclassVariableNames: ''\r\tpackage: ''SomePackage''\r```\rDenote SmaCC grammar definitions as:\r```smacc-grammar\r%root FileNode;\r<line>\r\t: [^\\r\\n]+\r\t;\r<newLine>\r\t: \\r | \\n | \\r\\n\r\t;\rFile\r\t: Lines {{FileNode}}\r\t;\rLines\r\t: Line\r\t| Lines <newLine> Line\r\t;\rLine\r\t: \r\t| <line> ''line''\r\t;\r```\r"
              }
            },
            "required": [
              "content"
            ],
            "additionalProperties": false
          }
        },
        "required": [
          "Markdown"
        ],
        "additionalProperties": false
      },
      "strict": true
    },
    "verbosity": "medium"
  },
  "tool_choice": "auto",
  "tools": [
    {
      "type": "function",
      "description": "Get the details of a class as JSON.",
      "name": "lookupClass",
      "parameters": {
        "additionalProperties": false,
        "properties": {
          "className": {
            "type": "string"
          }
        },
        "type": "object",
        "required": [
          "className"
        ]
      },
      "strict": true
    }
  ],
  "top_logprobs": 0,
  "top_p": 1.0,
  "truncation": "disabled",
  "usage": {
    "input_tokens": 4321,
    "input_tokens_details": {
      "cached_tokens": 0
    },
    "output_tokens": 989,
    "output_tokens_details": {
      "reasoning_tokens": 192
    },
    "total_tokens": 5310
  },
  "user": null,
  "metadata": {}
}';
								instVarAt: 4
									put: (ZnUTF8Encoder basicNew
											instVarAt: 1 put: nil;
											yourself);
								yourself);
					instVarAt: 3
						put: (ZnStatusLine basicNew
								instVarAt: 1 put: 'HTTP/1.1';
								instVarAt: 2 put: 200;
								instVarAt: 3 put: 'OK';
								yourself);
					yourself);
		yourself
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

{ #category : #'examples - basic' }
GtLChatOpenAILiveExamples >> stubResponses: aBlock [ 
	"Execute the given aBlock only in stub mode"
	
	| someResponses |
	self isLive ifTrue: [ ^ self ].
	
	someResponses := aBlock value.
	
	self currentChat provider client clientBuilder responses: someResponses asOrderedCollection
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
