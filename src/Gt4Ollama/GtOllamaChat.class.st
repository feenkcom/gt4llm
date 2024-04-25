Class {
	#name : #GtOllamaChat,
	#superclass : #GtLlmChat,
	#category : #'Gt4Ollama-Chat'
}

{ #category : #accessing }
GtOllamaChat >> ensureModel [
	client pullModel: self model
]

{ #category : #accessing }
GtOllamaChat >> initializeClient [
	client := GtOllamaClient new
]

{ #category : #accessing }
GtOllamaChat >> initializeMessages [
	messages := GtLlmMessagesGroup new
]

{ #category : #accessing }
GtOllamaChat >> sendMessage: aMessage [
	| result |
	messages add: (GtLlmUserMessage new content: aMessage).

	result := client completeChatWithModel: self model andMessages: messages.

	self addMessage: result
]
