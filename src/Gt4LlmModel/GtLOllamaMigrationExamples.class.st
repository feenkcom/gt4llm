Class {
	#name : #GtLOllamaMigrationExamples,
	#superclass : #Object,
	#traits : 'TAssertable',
	#classTraits : 'TAssertable classTrait',
	#instVars : [
		'semaphore'
	],
	#category : #'Gt4LlmModel-Examples'
}

{ #category : #examples }
GtLOllamaMigrationExamples >> gemma4Chat [
	"Answer the model and chat for a simple question put to Gemma4:31b.
	noTest as this assumes a local Ollama installation with llama 3.2 available."
	<gtExample>
	<noTest>
	| model chat |
	
	semaphore := Semaphore new.
	model := GtLModelFactory new ollama_completions: 'gemma4:e4b'.
	chat := self newChatFromModel: model.
	chat
		reasoningEffort: #none;
		sendString: 'Hi, who are you?'.
	self waitTimeoutSeconds: 60.

	^ { model. chat. }
]

{ #category : #examples }
GtLOllamaMigrationExamples >> gemma4Image [
	"Answer the model and chat for a query and image with Gemma4:31b.
	noTest as this assumes a local Ollama installation with gemma4:31b available."
	<gtExample>
	<noTest>
	| image model chat msg |
	
	semaphore := Semaphore new.
	image := '/home/alistair/tmp/Photos/alistair/Photos/2025/08/25-08-02 17-43-26 1276.jpg' asFileReference.
	model := GtLModelFactory new ollama_completions: 'gemma4:e4b'.
	chat := self newChatFromModel: model.
	msg := chat createUserMessage.
	msg string: 'Please describe the attached image.'.
	msg images: { image }.
	chat sendMessage: msg.
	self waitTimeoutSeconds: 60.

	^ { model. chat. }
]

{ #category : #examples }
GtLOllamaMigrationExamples >> gemma4Instructions [
	"Answer the model and chat for a simple question put to Gemma4:31b.
	noTest as this assumes a local Ollama installation with llama 3.2 available."
	<gtExample>
	<noTest>
	| model chat |
	
	semaphore := Semaphore new.
	model := GtLModelFactory new ollama_completions: 'gemma4:e4b'.
	chat := self newChatFromModel: model.
	chat gtPageExplanation: 'Examples by example'.
	chat 
		reasoningEffort: #none;
		sendString: 'What is an example method?'.
	self waitTimeoutSeconds: 60.

	^ { model. chat. }
]

{ #category : #examples }
GtLOllamaMigrationExamples >> gemma4ToolChoice [
	"Check that instructions are passed through to the Ollama Completions endpoint.
	To be fixed."
	<gtExample>
	<noTest>
	| model chat message |
	
	model := GtLModelFactory new ollama_completions: 'gemma4:e4b'.
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
	| model chat message entity tools tool command function endpoint context |
	
	model := GtLModelFactory new ollama_completions.
	chat := model provider chat.
	chat tools: (GtLTools withAll: { GtLMagritteToolForMethodSource new. }).
	message := GtLModelUserMessage new chat: chat.
	message string: 'message'.
	message chat: chat.
	chat addUserMessage: message.
	command := model client
		apiClientWithModel: model
		andMessages: chat messages
		andFormat: nil
		andTools: chat tools
		andInstructions: chat instructions.
	endpoint := model userMessageEndpoint.
	context := (endpoint newContextForModel: model)
		chat: chat;
		command: command.
	entity := endpoint entityFromContext: context.
	tools := entity at: 'tools'.
	self assert: tools size equals: 1.
	tool := tools first.
	self assert: tool keys asSet equals: #('function' 'type') asSet.
	function := tool at: 'function'.
	self assert: function keys asSet equals: #('description' 'parameters' 'type' 'name') asSet.

	^ entity
]

{ #category : #examples }
GtLOllamaMigrationExamples >> llama3Chat [
	"Answer model and chat for a simple question for Llama 3.2.
	noTest as this assumes a local Ollama installation with llama 3.2 available."
	<gtExample>
	<noTest>
	| model chat |
	
	semaphore := Semaphore new.
	model := GtLModelFactory new ollama_llama3_2.
	chat := self newChatFromModel: model.
	chat 
		reasoningEffort: false;
		sendString: 'Hi, who are you?'.
	self waitTimeoutSeconds: 60.
	^ { model. chat. }
]

{ #category : #examples }
GtLOllamaMigrationExamples >> llama3ChatInstructions [
	"Check that instructions are passed through to the Ollama Generate endpoint."
	<gtExample>
	| model chat message entity endpoint context|
	
	model := GtLModelFactory new ollama_llama3_2.
	chat := model provider chat.
	chat instruction: 'the instructions' titled: 'heading'.
	message := GtLModelUserMessage new chat: chat.
	message string: 'message'.
	message chat: chat.
	chat addUserMessage: message.
	endpoint := model userMessageEndpoint.
	context := (endpoint newContextForModel: model)
		chat: chat.
	entity := endpoint entityFromContext: context.
	self assert: (entity includesKey: 'system')
		description: 'entity missing system (instructions) attribute'.
	self assert: ((entity at: 'system') beginsWith: '# Explanations')
		description: [ 'Unexpected instructions: ', (entity at: 'system') printString ].
	^ entity
]

{ #category : #examples }
GtLOllamaMigrationExamples >> llama3PageInstructions [
	"Answer model and chat for a simple question for Llama 3.2."
	<gtExample>
	| model chat message entity endpoint context |
	
	model := GtLModelFactory new ollama_llama3_2.
	chat := model provider chat.
	chat gtPageExplanation: 'Examples by example'.
	message := GtLModelUserMessage new chat: chat.
	message string: 'message'.
	message chat: chat.
	chat addUserMessage: message.
	endpoint := model userMessageEndpoint.
	context := endpoint newContextForModel: model.
	entity := endpoint entityFromContext: context.
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
	^ model provider modelDetails.
]

{ #category : #examples }
GtLOllamaMigrationExamples >> modelNames [
	"Answer the provider version of the running system.
	noTest as this assumes a local Ollama installation with llama 3.2 available."
	<gtExample>
	<noTest>
	| model |
	
	model := GtLModelFactory new ollama.
	^ model provider availableModels keys.
]

{ #category : #private }
GtLOllamaMigrationExamples >> newChatFromModel: model [
	"Answer a new chat configured and signal the receiver's semaphore when it goes idle."
	| chat |
	
	chat := model provider chat.
	chat
		when: GtLChatExecutionStateChanged
		send: #signalSemaphoreOnFinished:
		to: self.
	^ chat
]

{ #category : #examples }
GtLOllamaMigrationExamples >> ollamaCompletionsChatInstructions [
	"Check that instructions are passed through to the Ollama Completions endpoint."
	<gtExample>
	| model chat message entity messages command endpoint context |
	
	model := GtLModelFactory new ollama_completions.
	chat := model provider chat.
	chat instruction: 'the instructions' titled: 'heading'.
	message := GtLModelUserMessage new chat: chat.
	message string: 'message'.
	message chat: chat.
	chat addUserMessage: message.
	command := model client
		apiClientWithModel: model
		andMessages: chat messages
		andFormat: nil
		andTools: chat tools
		andInstructions: chat instructions.
	endpoint := model userMessageEndpoint.
	context := endpoint newContextForModel: model.
	context 
		chat: chat;
		command: command.
	entity := endpoint entityFromContext: context.
	messages := entity at: 'messages'.
	self assert: (messages anySatisfy: [ :dict |
		(dict at: 'role') = 'system' and:
		[ (dict at: 'content') beginsWith: '# Explanations' ] ])
		description: 'entity missing system role (instructions) attribute'.
	^ entity
]

{ #category : #examples }
GtLOllamaMigrationExamples >> ollamaCompletionsInvalidReasonsing [
	"Confirm the model parameter validation rejects an invalid reasoning effort"
	<gtExample>
	| model chat |
	
	model := GtLModelFactory new ollama_completions: 'gemma4:e4b'.
	chat := model provider chat.
	self
		should: [ chat reasoningEffort: #fail ]
		raise: Error
		withExceptionDo: [ :ex |
			self assert: (ex messageText beginsWith: 'Invalid reasoning value') ].
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
		raise: Error
		withExceptionDo: [ :ex |
			self assert: (ex messageText beginsWith: 'Invalid reasoning value') ].
]

{ #category : #examples }
GtLOllamaMigrationExamples >> providerVersion [
	"Answer the provider version of the running system.
	noTest as this assumes a local Ollama installation with llama 3.2 available."
	<gtExample>
	<noTest>
	| model |
	
	model := GtLModelFactory new ollama_llama3_2.
	^ model provider providerVersion.
]

{ #category : #examples }
GtLOllamaMigrationExamples >> runningModels [
	"Answer the provider version of the running system.
	noTest as this assumes a local working Ollama installation."
	<gtExample>
	<noTest>
	| model |
	
	model := GtLModelFactory new ollama.
	^ model provider runningModels.
]

{ #category : #private }
GtLOllamaMigrationExamples >> signalSemaphore [

	semaphore signal.
]

{ #category : #private }
GtLOllamaMigrationExamples >> signalSemaphoreOnFinished: aStateChange [

	aStateChange state
		ifCanStop: [] 
		ifStopping: [] 
		ifIdle: [ semaphore signal ].
]

{ #category : #examples }
GtLOllamaMigrationExamples >> waitTimeoutSeconds: anInteger [
	"Wait on the receiver's semaphore for the specified number of seconds.
	Raise an error on timeout."

	(semaphore waitTimeoutSeconds: 60) ifTrue:
		[ self error: 'The chat didn''t go idle within ', anInteger asString, ' seconds' ].
]
