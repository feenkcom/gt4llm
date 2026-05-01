Class {
	#name : #GtLOllamaOpenAiExamples,
	#superclass : #Object,
	#category : 'Gt4Llm-Ollama-Examples'
}

{ #category : #examples }
GtLOllamaOpenAiExamples >> assistantMessage [
	<gtExample>
	| message result |
	result := GtLOllamaResponse from: {
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
	chat provider reasoningEffort: #none.
	message := chat createUserMessage.
	message string: 'Hi!'.
	message chat: chat.
	chat addUserMessage: message.
	chat instructions
		sectionNamed: 'xyz123'
		ifAbsent: [ :aSection |
			aSection addString: 'abc123' ].
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
	self assert: entity size equals: 5.
	self assert: (entity at: 'model') equals: 'gemma4'.
	self assert: (entity at: 'stream') equals: false.
	self assert: (entity at: 'reasoning_effort') equals: #none.
	entityMessages := entity at: 'messages'.
	self assert: entityMessages size equals: 2.
	entityMessage := entityMessages first.
	self assert: (entityMessage at: 'role') equals: 'user'.
	entityContent := (entityMessage at: 'content') first.
	self assert: (entityContent at: 'type')
		equals: 'text'.

	entityMessage := entityMessages second.
	self assert: (entityMessage at: 'role') equals: 'system'.
	entityContent := (entityMessage at: 'content').
	self assert: entityContent class equals: GtLInstructionComposite.

	^ entity
]

{ #category : #examples }
GtLOllamaOpenAiExamples >> userMessagePlainImageEncoding [
	<gtExample>
	| chat message provider messages apiClient entity images |
	
	chat := self chatWithProvider.
	message := chat createUserMessage.
	message string: 'Hi!'.
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
	self assert: (entity at: 'prompt') equals: '"Hi!"'.
	images := entity at: 'images'.
	self assert: images isArray.
	self assert: images size equals: 1.
	
	^ entity
]
