Class {
	#name : #GtLOllamaMigrationExamples,
	#superclass : #GtLOllamaVersionEndpoint,
	#traits : 'TAssertable',
	#classTraits : 'TAssertable classTrait',
	#category : #'Gt4LlmModel-Examples'
}

{ #category : #examples }
GtLOllamaMigrationExamples >> gemma4Chat [
	"Answer the model and chat for a simple question put to Gemma4:31b.
	noTest as this assumes a local Ollama installation with llama 3.2 available."
	<gtExample>
	<noTest>
	| model chat |
	
	model := GtLModelFactory new ollama_gemma4_31b.
	chat := model provider chat.
	chat 
		reasoningEffort: #none;
		sendString: 'Hi, who are you?'.
	^ { model. chat. }
]

{ #category : #examples }
GtLOllamaMigrationExamples >> gemma4ChatInstructions [
	"Check that instructions are passed through to the Ollama Completions endpoint."
	<gtExample>
	| model chat message entity messages |
	
	model := GtLModelFactory new ollama_gemma4.
	chat := model provider chat.
	chat instruction: 'the instructions' titled: 'heading'.
	message := GtLModelUserMessage new chat: self.
	message string: 'message'.
	message chat: chat.
	chat addUserMessage: message.
	entity := model userMessageEndpoint entityFromContext: model newEndpointContext.
	messages := entity at: 'messages'.
	self assert: (messages anySatisfy: [ :dict |
		(dict at: 'role') = 'system' and:
		[ (dict at: 'content') beginsWith: '# Explanations' ] ])
		description: 'entity missing system role (instructions) attribute'.
	^ entity
]

{ #category : #examples }
GtLOllamaMigrationExamples >> gemma4Image [
	"Answer the model and chat for a query and image with Gemma4:31b.
	noTest as this assumes a local Ollama installation with gemma4:31b available."
	<gtExample>
	<noTest>
	| image model chat msg |
	
	image := '/path/to/image.jpg' asFileReference.
	model := GtLModelFactory new ollama_gemma4_31b.
	chat := model provider chat.
	msg := chat createUserMessage.
	msg string: 'Please describe the attached image.'.
	msg images: { image }.
	chat sendMessage: msg.

	^ { model. chat. }
]

{ #category : #examples }
GtLOllamaMigrationExamples >> gemma4Instructions [
	"Answer the model and chat for a simple question put to Gemma4:31b.
	noTest as this assumes a local Ollama installation with llama 3.2 available."
	<gtExample>
	<noTest>
	| model chat |
	
	model := GtLModelFactory new ollama_gemma4_31b.
	chat := model provider chat.
	chat gtPageExplanation: 'Examples by example'.
	chat 
		reasoningEffort: #none;
		sendString: 'Hi, who are you?'.
	^ { model. chat. }
]

{ #category : #examples }
GtLOllamaMigrationExamples >> gemma4ToolChoice [
	"Check that instructions are passed through to the Ollama Completions endpoint."
	<gtExample>
	<noTest>
	| model chat message |
	
	model := GtLModelFactory new ollama_gemma4_31b.
	chat := model provider chat.
	chat tools: (GtLTools withAll: { GtLMagritteToolForMotd new. }).
	message := GtLModelUserMessage new chat: self.
	message string: 'Use the gtMotd tool to retrieve the GT Message Of The Day.'.
	message parameters at: 'tool_choice' put:
		{
		    'type' -> 'function'.
		    'function' -> { 'name' -> 'gtMotd' } asDictionary
	  } asDictionary.
	chat sendMessage: message.
	^ chat
]

{ #category : #examples }
GtLOllamaMigrationExamples >> gemma4Tools [
	"Check that instructions are passed through to the Ollama Completions endpoint."
	<gtExample>
	| model chat message entity tools tool |
	
	model := GtLModelFactory new ollama_gemma4.
	chat := model provider chat.
	chat tools: (GtLTools withAll: { GtLMagritteToolForMethodSource new. }).
	message := GtLModelUserMessage new chat: self.
	message string: 'message'.
	message chat: chat.
	chat addUserMessage: message.
	entity := model userMessageEndpoint entityFromContext: model newEndpointContext.
	tools := entity at: 'tools'.
	self assert: tools size equals: 1.
	tool := tools first.
	self assert: tool keys asSet equals: #('description' 'parameters' 'type' 'name') asSet.

	^ entity
]

{ #category : #examples }
GtLOllamaMigrationExamples >> llama3Chat [
	"Answer model and chat for a simple question for Llama 3.2.
	noTest as this assumes a local Ollama installation with llama 3.2 available."
	<gtExample>
	<noTest>
	| model chat |
	
	model := GtLModelFactory new ollama_llama3_2.
	chat := model provider chat.
	chat 
		reasoningEffort: false;
		sendString: 'Hi, who are you?'.
	^ { model. chat. }
]

{ #category : #examples }
GtLOllamaMigrationExamples >> llama3ChatInstructions [
	"Check that instructions are passed through to the Ollama Generate endpoint."
	<gtExample>
	| model chat message entity |
	
	model := GtLModelFactory new ollama_llama3_2.
	chat := model provider chat.
	chat instruction: 'the instructions' titled: 'heading'.
	message := GtLModelUserMessage new chat: self.
	message string: 'message'.
	message chat: chat.
	chat addUserMessage: message.
	entity := model userMessageEndpoint entityFromContext: model newEndpointContext.
	self assert: (entity includesKey: 'system')
		description: 'entity missing system (instructions) attribute'.
	self assert: ((entity at: 'system') beginsWith: '# Explanations')
		description: [ 'Unexpected instructions: ', (entity at: 'system') printString ].
	^ entity
]

{ #category : #examples }
GtLOllamaMigrationExamples >> llama3PageInstructions [
	"Answer model and chat for a simple question for Llama 3.2.
	noTest as this assumes a local Ollama installation with llama 3.2 available."
	<gtExample>
	<noTest>
	| model chat message entity |
	
	model := GtLModelFactory new ollama_llama3_2.
	chat := model provider chat.
	chat gtPageExplanation: 'Examples by example'.
	message := GtLModelUserMessage new chat: self.
	message string: 'message'.
	message chat: chat.
	chat addUserMessage: message.
	entity := model userMessageEndpoint entityFromContext: model newEndpointContext.
	self assert: (entity includesKey: 'system')
		description: 'entity missing system (instructions) attribute'.
	self assert: ((entity at: 'system') beginsWith: '# Explanations')
		description: [ 'Unexpected instructions: ', (entity at: 'system') printString ].
	^ entity
]

{ #category : #examples }
GtLOllamaMigrationExamples >> modelDetails [
	"Answer the model details of the running system.
	noTest as this assumes a local Ollama installation with llama 3.2 available."
	<gtExample>
	<noTest>
	| model |
	
	model := GtLModelFactory new ollama_llama3_2.
	^ model modelDetails.
]

{ #category : #examples }
GtLOllamaMigrationExamples >> modelNames [
	"Answer the provider version of the running system.
	noTest as this assumes a local Ollama installation with llama 3.2 available."
	<gtExample>
	<noTest>
	| model |
	
	model := GtLModelFactory new ollama.
	^ model availableModels keys.
]

{ #category : #examples }
GtLOllamaMigrationExamples >> ollamaCompletionsInvalidReasonsing [
	"Confirm the model parameter validation rejects an invalid reasoning effort"
	<gtExample>
	| model chat |
	
	model := GtLModelFactory new ollama_gemma4_31b.
	chat := model provider chat.
	self
		should: [ chat reasoningEffort: #fail ]
		raise: Error.
]

{ #category : #examples }
GtLOllamaMigrationExamples >> ollamaGenerateInvalidReasonsing [
	"Confirm the model parameter validation rejects an invalid reasoning effort"
	<gtExample>
	| model chat |
	
	model := GtLModelFactory new ollama_llama3_2.
	chat := model provider chat.
	self
		should: [ chat reasoningEffort: #fail ]
		raise: Error.
]

{ #category : #examples }
GtLOllamaMigrationExamples >> providerVersion [
	"Answer the provider version of the running system.
	noTest as this assumes a local Ollama installation with llama 3.2 available."
	<gtExample>
	<noTest>
	| model |
	
	model := GtLModelFactory new ollama_llama3_2.
	^ model providerVersion.
]

{ #category : #examples }
GtLOllamaMigrationExamples >> qwen36Chat [
	"Answer the model details of the running system.
	noTest as this assumes a local Ollama installation with llama 3.2 available."
	<gtExample>
	<noTest>
	| model chat |
	
	model := GtLModelFactory new ollama_qwen3_6.
	chat := model provider chat.
	chat sendString: 'Hi, who are you?'.
	^ { model. chat. }
]

{ #category : #examples }
GtLOllamaMigrationExamples >> qwen36ToolChoice [
	"Check that instructions are passed through to the Ollama Completions endpoint."
	<gtExample>
	<noTest>
	| model chat message |
	
	model := GtLModelFactory new ollama_qwen3_6.
	chat := model provider chat.
	chat tools: (GtLTools withAll: { GtLMagritteToolForMethodSource new. }).
	message := GtLModelUserMessage new chat: self.
	message string: 'Use the getCodeOfMethod tool to retrieve the source code for {{gtClass:GtLOllamaMigrationExamples>>llama3Chat}}.'.
	message parameters at: 'tool_choice' put:
		{
		    'type' -> 'function'.
		    'function' -> { 'name' -> 'getCodeOfMethod' } asDictionary
	  } asDictionary.
	chat sendMessage: message.
	^ chat
]

{ #category : #examples }
GtLOllamaMigrationExamples >> qwen3_6Image [
	"Answer the model and chat for a query and image with Gemma4:31b.
	noTest as this assumes a local Ollama installation with gemma4:31b available."
	<gtExample>
	<noTest>
	| model chat msg |
	
	model := GtLModelFactory new ollama_qwen3_6.
	chat := model provider chat.
	msg := chat createUserMessage.
	msg string: 'Please describe the attached image.'.
	msg images: { '/home/alistair/tmp/Photos/alistair/Photos/2025/08/25-08-02 17-43-10 1274.jpg' asFileReference }.
	chat sendMessage: msg.

	^ { model. chat. }
]

{ #category : #examples }
GtLOllamaMigrationExamples >> runningModels [
	"Answer the provider version of the running system.
	noTest as this assumes a local working Ollama installation."
	<gtExample>
	<noTest>
	| model |
	
	model := GtLModelFactory new ollama.
	^ model runningModels.
]
