Class {
	#name : #GtLOllamaOpenAiExamples,
	#superclass : #Object,
	#category : #'Gt4Llm-Ollama-Examples'
}

{ #category : #examples }
GtLOllamaOpenAiExamples >> assistantMessage [
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
GtLOllamaOpenAiExamples >> chatWithProvider [
	<gtExample>
	| chat |
	chat := GtLChat new.
	chat provider: GtLOllamaProvider default.
	self assert: chat provider class = GtLOllamaProvider.
	^ chat
]

{ #category : #examples }
GtLOllamaOpenAiExamples >> userMessage [
	<gtExample>
	| chat message |
	chat := self chatWithProvider.
	message := chat createUserMessage.
	self assert: message isUserRole.
	self assert: message class = GtLOllamaUserMessage.
	^ message
]

{ #category : #examples }
GtLOllamaOpenAiExamples >> userMessagePlainEncoding [
	<gtExample>
	| chat message provider messages apiClient entity entityMessages entityMessage entityContent |
	
	chat := self chatWithProvider.
	chat provider configureForOpenAiCompatibility.
	message := chat createUserMessage.
	message string: 'Hi!'.
	message chat: chat.
	chat addUserMessage: message.
	provider := chat provider.
	provider privateExecutionState: provider state scheduled running.
	messages := provider relevantChatMessages.
	apiClient := provider client
		apiClientWithModel: 'gemma4' 
		andMessages: messages 
		andFormat: 'json' 
		andTools: message tools 
		andInstructions: message instructions.
	entity := apiClient entity.
	self assert: entity size equals: 3.
	self assert: (entity at: 'model') equals: 'gemma4'.
	self assert: (entity at: 'stream') equals: false.
	entityMessages := entity at: 'messages'.
	self assert: entityMessages size equals: 1.
	entityMessage := entityMessages first.
	self assert: (entityMessage at: 'role') equals: 'user'.
	entityContent := (entityMessage at: 'content') first.
	self assert: (entityContent at: 'type')
		equals: 'text'.

	^ entity
]

{ #category : #examples }
GtLOllamaOpenAiExamples >> userMessagePlainImageEncoding [
	<gtExample>
	| chat message provider messages apiClient entity images |
	
	chat := self chatWithProvider.
	message := chat createUserMessage.
	message prompt: 'Hi!'.
	message images: { GtLOllamaGenerateExamples jpgImage}.
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
