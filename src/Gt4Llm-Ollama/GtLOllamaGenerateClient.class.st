Class {
	#name : #GtLOllamaGenerateClient,
	#superclass : #GtLOllamaClient,
	#category : #'Gt4Llm-Ollama-Client'
}

{ #category : #'as yet unclassified' }
GtLOllamaGenerateClient >> assistantMessageClass [

	^ GtLOllamaGenerateAssistantMessage
]

{ #category : #'as yet unclassified' }
GtLOllamaGenerateClient >> serializeToolMessageForResponse: aToolMessage [
	^aToolMessage serializeForOllamaGenerateMessagesAPI
]
