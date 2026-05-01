Class {
	#name : #GtLOpenAIEntityExamples,
	#superclass : #Object,
	#category : 'Gt4Llm-OpenAI-Examples'
}

{ #category : #examples }
GtLOpenAIEntityExamples >> chatWithProvider [
	<gtExample>
	| chat |
	chat := GtLChat new.
	chat provider: GtLOpenAIProvider new.
	self assert: chat provider class = GtLOpenAIProvider.
	^ chat
]

{ #category : #examples }
GtLOpenAIEntityExamples >> userMessageMarkdownEncoding [
	<gtExample>
	| chat message provider apiClient entity |
	
	chat := self chatWithProvider.
	message := chat createUserMessage.
	message markdown: 'Hi!'.
	message chat: chat.
	chat addUserMessage: message.
	provider := chat provider.
	provider privateExecutionState: provider state scheduled running.
	apiClient := provider client
		apiClientWithModel: 'gpt123'
		messages: message
		instructions: message completeInstructionString
		tools: message tools
		andFormat: (message hasFormats
				ifTrue: [ message formatDescriptionsJsonSchemaWithAllRequired ]
				ifFalse: [ nil ])
		isStreaming: false.
	entity := apiClient buildEntity.
	self assert: entity size equals: 4.
	self assert: (entity at: 'model') equals: 'gpt123'.
	self assert: (entity at: 'stream') equals: false.
	self assert: (entity at: 'instructions') equals: message completeInstructionString.
	
	^ entity
]
