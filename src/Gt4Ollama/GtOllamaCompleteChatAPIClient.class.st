Class {
	#name : #GtOllamaCompleteChatAPIClient,
	#superclass : #GtLlmEndpointClient,
	#instVars : [
		'messages',
		'model',
		'format'
	],
	#category : #'Gt4Ollama-Chat'
}

{ #category : #accessing }
GtOllamaCompleteChatAPIClient >> entity [
	| entity |
	entity := {'model' -> self model.
			'messages' -> (self messages collect: #serialize)} asDictionary.

	self format ifNotNil: [ entity at: 'format' put: self format ].

	^ entity
]

{ #category : #accessing }
GtOllamaCompleteChatAPIClient >> format [
	^ format
]

{ #category : #accessing }
GtOllamaCompleteChatAPIClient >> format: anObject [
	format := anObject
]

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
	^ self client postStreaming: '/chat' withEntity: self entity
]

{ #category : #accessing }
GtOllamaCompleteChatAPIClient >> serializationClass [
	^ GtOllamaAssistantMessage
]
