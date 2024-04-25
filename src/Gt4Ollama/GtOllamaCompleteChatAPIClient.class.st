Class {
	#name : #GtOllamaCompleteChatAPIClient,
	#superclass : #GtLlmEndpointClient,
	#instVars : [
		'messages',
		'model'
	],
	#category : #'Gt4Ollama-Chat'
}

{ #category : #accessing }
GtOllamaCompleteChatAPIClient >> messages [
	^ messages
]

{ #category : #accessing }
GtOllamaCompleteChatAPIClient >> messages: anObject [
	messages := anObject
]

{ #category : #accessing }
GtOllamaCompleteChatAPIClient >> model [
	^ model
]

{ #category : #accessing }
GtOllamaCompleteChatAPIClient >> model: anObject [
	model := anObject
]

{ #category : #accessing }
GtOllamaCompleteChatAPIClient >> request [
	^ self client
		postStreaming: '/chat'
		withEntity: {'model' -> self model.
				'messages' -> (self messages collect: #serialize)} asDictionary
]

{ #category : #accessing }
GtOllamaCompleteChatAPIClient >> serializationClass [
	^ GtOllamaAssistantMessage
]
