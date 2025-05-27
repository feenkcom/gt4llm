Class {
	#name : #GtOllamaCompleteChatAPIClient,
	#superclass : #GtLlmEndpointClient,
	#instVars : [
		'messages',
		'model',
		'format',
		'tools'
	],
	#category : #Gt4Ollama
}

{ #category : #accessing }
GtOllamaCompleteChatAPIClient >> entity [
	| entity |
	entity := {'stream' -> false.
			'model' -> self model.
			'messages' -> (self messages collect: [ :aMessage | aMessage serialize ])}
			asDictionary.

	self format ifNotNil: [ entity at: 'format' put: self format ].
	self tools
		ifNotNil: [ entity at: 'tools' put: (self tools collect: [ :aTool | aTool serialize ]) ].

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
	^ self client post: '/chat' withEntity: self entity
]

{ #category : #accessing }
GtOllamaCompleteChatAPIClient >> serializationClass [
	^ GtOllamaThreadMessage
]

{ #category : #accessing }
GtOllamaCompleteChatAPIClient >> tools [
	^ tools
]

{ #category : #accessing }
GtOllamaCompleteChatAPIClient >> tools: anObject [
	tools := anObject
]
