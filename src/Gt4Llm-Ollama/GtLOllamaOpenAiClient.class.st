Class {
	#name : #GtLOllamaOpenAiClient,
	#superclass : #GtLOllamaClient,
	#category : 'Gt4Llm-Ollama-Client'
}

{ #category : #accessing }
GtLOllamaOpenAiClient class >> defaultBaseUrl [
	^ 'http://localhost:11434/v1' asZnUrl
]

{ #category : #api }
GtLOllamaOpenAiClient >> apiClientWithModel: aString andMessages: aCollection andFormat: aFormat andTools: someTools andInstructions: aStringOrNil [

	^ GtLOllamaOpenAiChatAPICommand new
		client: self;
		model: aString;
		messages: aCollection;
		format: aFormat;
		tools: someTools;
		instructions: aStringOrNil
]

{ #category : #accessing }
GtLOllamaOpenAiClient >> assistantMessageClass [

	^ GtLOllamaOpenAiAssistantMessage
]

{ #category : #serialization }
GtLOllamaOpenAiClient >> serializeToolMessageForResponse: aToolMessage [
	^aToolMessage serializeForOllamaOpenAiMessagesAPI
]
