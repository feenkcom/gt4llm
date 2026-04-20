Class {
	#name : #GtLOllamaGenerateExamples,
	#superclass : #Object,
	#category : 'Gt4Llm-Ollama-Examples'
}

{ #category : #accessing }
GtLOllamaGenerateExamples class >> jpgImage [
	| jpg |
	
	jpg := FileSystem memory root / 'image.jpg'.
	PluginBasedJPEGReadWriter 
		putForm: (Smalltalk ui icons iconNamed: 'arrowUp') 
		onFileNamed: jpg.
	^ jpg.
]

{ #category : #examples }
GtLOllamaGenerateExamples >> assistantMessage [
	<gtExample>
	| message result |
	result := GtLOllamaClientMessage from: {
		'model' -> 'llama3.2'.
		'response' -> 'Hello'
		} asDictionary.
	message := GtLOllamaAssistantMessage new initializeFromResult: result.
	self assert: message isAssistantRole.
	self assert: message contentText = 'Hello'.
	^ message
]

{ #category : #examples }
GtLOllamaGenerateExamples >> chatWithProvider [
	<gtExample>
	| chat |
	chat := GtLChat new.
	chat provider: GtLOllamaProvider default.
	self assert: chat provider class = GtLOllamaProvider.
	^ chat
]

{ #category : #examples }
GtLOllamaGenerateExamples >> userMessage [
	<gtExample>
	| chat message |
	chat := self chatWithProvider.
	message := chat createUserMessage.
	self assert: message isUserRole.
	self assert: message class = GtLOllamaUserMessage.
	^ message
]

{ #category : #examples }
GtLOllamaGenerateExamples >> userMessagePlainEncoding [
	<gtExample>
	| chat message provider messages apiClient entity |
	
	chat := self chatWithProvider.
	message := chat createUserMessage.
	message prompt: 'Hi!'.
	message chat: chat.
	chat addUserMessage: message.
	provider := chat provider.
	provider configureForGenerateApi.
	provider privateExecutionState: provider state scheduled running.
	messages := provider relevantChatMessages.
	apiClient := provider client
		apiClientWithModel: 'gemma4' 
		andMessages: messages 
		andFormat: 'json' 
		andTools: message tools 
		andInstructions: message instructions.
	entity := apiClient entity.
	self assert: entity size equals: 5.
	self assert: (entity at: 'model') equals: 'gemma4'.
	self assert: (entity at: 'stream') equals: false.
	self assert: (entity at: 'prompt') equals: 'Hi!'.
	self assert: (entity at: 'system')
		equals: message instructions instructionString.
	
	^ entity
]

{ #category : #examples }
GtLOllamaGenerateExamples >> userMessagePlainImageEncoding [
	<gtExample>
	| chat message provider messages apiClient entity images |
	
	chat := self chatWithProvider.
	message := chat createUserMessage.
	message prompt: 'Hi!'.
	message images: { self class jpgImage}.
	message chat: chat.
	chat addUserMessage: message.
	provider := chat provider.
	provider configureForGenerateApi.
	provider privateExecutionState: provider state scheduled running.
	messages := provider relevantChatMessages.
	apiClient := provider client
		apiClientWithModel: 'gemma4' 
		andMessages: messages 
		andFormat: 'json' 
		andTools: message tools 
		andInstructions: message instructions.
	entity := apiClient entity.
	self assert: entity size equals: 5.
	self assert: (entity at: 'model') equals: 'gemma4'.
	self assert: (entity at: 'stream') equals: false.
	self assert: (entity at: 'prompt') equals: 'Hi!'.
	images := entity at: 'images'.
	self assert: images isArray.
	self assert: images size equals: 1.
	
	^ entity
]
