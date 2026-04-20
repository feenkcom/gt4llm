Class {
	#name : #GtLOllamaOpenAiChatAPICommand,
	#superclass : #GtLOllamaEndpointCommand,
	#instVars : [
		'messages',
		'model',
		'format',
		'tools',
		'instructions'
	],
	#category : 'Gt4Llm-Ollama-Client'
}

{ #category : #api }
GtLOllamaOpenAiChatAPICommand >> entity [
	| entity input |
	input := OrderedCollection new.
	self messages
		messagesDo: [ :aMessage | 
			aMessage isToolMessage
				ifTrue: [ aMessage toolCall isFinished
						ifTrue: [ input add: aMessage toolCall responseInputForOpenAIResponsesAPI.
							input add: aMessage serializeForOllamaOpenAiMessagesAPI ] ]
				ifFalse: [ input add: aMessage serializeForOllamaOpenAiMessagesAPI ] ].
	entity := {'model' -> self model.
			'stream' -> false.
			'messages' -> input asArray} asDictionary.

	"format appears to be ignored by Ollama, to be investigated further.
	format
		ifNotNil: [ entity
				at: 'response_format'
				put: {'type' -> 'json_schema'.
							'json_schema' -> format} asDictionary ]."

	"tools isEmptyOrNil
		ifFalse: [ entity
				at: 'tools'
				put: (self tools collect: [ :aTool | aTool functionOpenAI ]) ].

	instructions ifNotNil: [ entity at: 'instructions' put: instructions ]."

	^ entity
]

{ #category : #accessing }
GtLOllamaOpenAiChatAPICommand >> format [
	^ format
]

{ #category : #accessing }
GtLOllamaOpenAiChatAPICommand >> format: anObject [
	format := anObject
]

{ #category : #accessing }
GtLOllamaOpenAiChatAPICommand >> instructions [
	^ instructions
]

{ #category : #accessing }
GtLOllamaOpenAiChatAPICommand >> instructions: aString [
	instructions := aString
]

{ #category : #accessing }
GtLOllamaOpenAiChatAPICommand >> messages [
	^ messages ifNil: [ #() ]
]

{ #category : #accessing }
GtLOllamaOpenAiChatAPICommand >> messages: aCollection [
	messages := aCollection
]

{ #category : #accessing }
GtLOllamaOpenAiChatAPICommand >> model [
	^ model
]

{ #category : #accessing }
GtLOllamaOpenAiChatAPICommand >> model: anObject [
	model := anObject
]

{ #category : #api }
GtLOllamaOpenAiChatAPICommand >> request [
	<return: #GtLRequestResponse>

	^ self client post: '/chat/completions' withEntity: self entity
]

{ #category : #api }
GtLOllamaOpenAiChatAPICommand >> serializationClass [
	^ GtLOllamaClientMessage
]

{ #category : #accessing }
GtLOllamaOpenAiChatAPICommand >> tools [
	^ tools
]

{ #category : #accessing }
GtLOllamaOpenAiChatAPICommand >> tools: aCollection [
	tools := aCollection
]
