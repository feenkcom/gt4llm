Class {
	#name : #GtLOllamaOpenAiClient,
	#superclass : #GtLOllamaClient,
	#category : 'Gt4Llm-Ollama-Client'
}

{ #category : #'as yet unclassified' }
GtLOllamaOpenAiClient class >> defaultBaseUrl [
	^ 'http://localhost:11434/v1' asZnUrl
]

{ #category : #'as yet unclassified' }
GtLOllamaOpenAiClient >> apiClientWithModel: aString andMessages: aCollection andFormat: aFormat andTools: someTools andInstructions: aStringOrNil [

	^ GtLOllamaOpenAiChatAPICommand new
		client: self;
		model: aString;
		messages: aCollection;
		format: aFormat;
		tools: someTools;
		instructions: aStringOrNil
]

{ #category : #'as yet unclassified' }
GtLOllamaOpenAiClient >> assistantMessageClass [

	^ GtLOllamaOpenAiAssistantMessage
]

{ #category : #views }
GtLOllamaOpenAiClient >> gtCallsFor: aView [
	<gtView>
	^ aView forward
		title: 'History calls';
		object: [ history ];
		view: #gtCallsFor:
]
