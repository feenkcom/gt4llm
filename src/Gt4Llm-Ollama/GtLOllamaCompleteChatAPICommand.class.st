Class {
	#name : #GtLOllamaCompleteChatAPICommand,
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
GtLOllamaCompleteChatAPICommand >> entity [
	"Send a message to Ollama using the 'generate' api.
	See https://docs.ollama.com/api/generate"
	| entity someMessages |

	"Ollama generate only accepts a single user message."
	self assert: (self messages items count: #isUserMessage) = 1
		description: 'Only a single message is currently supported'.
	someMessages := Array
			streamContents: [ :aStream | 
				self messages
					messagesDo: [ :eachMessage | aStream nextPut: eachMessage serializeForOllamaGenerateMessagesAPI ] ].

	entity := {'stream' -> false.
			'model' -> self model.
			 } asDictionary.
	someMessages do: [ :msg |
		entity addAll: msg ].
	"self format ifNotNil: [ entity at: 'format' put: self format ]."
	"(self tools isNotNil and: [ self tools isNotEmpty ])
		ifTrue: [ entity at: 'tools' put: (self tools collect: [ :aTool | aTool schema ]) ]."
	self instructions ifNotNil: 
		[ entity at: 'system' put: 
			self instructions instructionString ].
	^ entity
]

{ #category : #accessing }
GtLOllamaCompleteChatAPICommand >> format [
	^ format
]

{ #category : #accessing }
GtLOllamaCompleteChatAPICommand >> format: anObject [
	format := anObject
]

{ #category : #accessing }
GtLOllamaCompleteChatAPICommand >> instructions [
	^ instructions
]

{ #category : #accessing }
GtLOllamaCompleteChatAPICommand >> instructions: aString [
	instructions := aString
]

{ #category : #accessing }
GtLOllamaCompleteChatAPICommand >> messages [
	^ messages ifNil: [ #() ]
]

{ #category : #accessing }
GtLOllamaCompleteChatAPICommand >> messages: aCollection [
	messages := aCollection
]

{ #category : #accessing }
GtLOllamaCompleteChatAPICommand >> model [
	^ model
]

{ #category : #accessing }
GtLOllamaCompleteChatAPICommand >> model: anObject [
	model := anObject
]

{ #category : #api }
GtLOllamaCompleteChatAPICommand >> request [
	<return: #GtLRequestResponse>

	^ self client post: '/generate' withEntity: self entity
]

{ #category : #api }
GtLOllamaCompleteChatAPICommand >> serializationClass [
	^ GtLOllamaClientMessage
]

{ #category : #accessing }
GtLOllamaCompleteChatAPICommand >> tools [
	^ tools
]

{ #category : #accessing }
GtLOllamaCompleteChatAPICommand >> tools: aCollection [
	tools := aCollection
]
