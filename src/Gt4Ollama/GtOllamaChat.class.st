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
GtOllamaChat >> model: aModelName [
	super model: aModelName.
	
	self ensureModel
]

{ #category : #accessing }
GtOllamaChat >> sendMessage: aMessage [
	messages
		addFirst: (GtLlmUserMessage new
				content: aMessage;
				chat: self).
	self triggerAssistant
]

{ #category : #accessing }
GtOllamaChat >> status [
	^ GtOpenAIAssistantChatReadyStatus new
]

{ #category : #accessing }
GtOllamaChat >> triggerAssistant [
	| result |
	result := client
			completeChatWithModel: self model
			andMessages: messages reversed.

	self addMessage: (result asLlmMessage chat: self)
]
