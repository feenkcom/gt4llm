Class {
	#name : #GtLModelClient,
	#superclass : #GtLOllamaClient,
	#category : 'Gt4Llm-Ollama-Client'
}

{ #category : #accessing }
GtLModelClient class >> defaultBaseUrl [
	^ 'http://localhost:11434' asZnUrl
]

{ #category : #accessing }
GtLModelClient >> apiClientWithModel: aGtLModel andMessages: aCollection andFormat: aFormat andTools: someTools andInstructions: aStringOrNil [

	^ GtLModelApiUserCommand new
		client: self;
		model: aGtLModel;
		messages: aCollection;
		format: aFormat;
		tools: someTools;
		instructions: aStringOrNil
]

{ #category : #accessing }
GtLModelClient >> assistantMessageClass [

	^ GtLModelAssistantMessage
]
