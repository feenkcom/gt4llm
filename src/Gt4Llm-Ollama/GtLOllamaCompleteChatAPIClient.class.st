Class {
	#name : #GtLOllamaCompleteChatAPIClient,
	#superclass : #GtLOllamaEndpointClient,
	#instVars : [
		'messages',
		'model',
		'format',
		'tools',
		'instructions'
	],
	#category : #'Gt4Llm-Ollama-Client'
}

{ #category : #api }
GtLOllamaCompleteChatAPIClient >> entity [
	| entity someMessages |
	someMessages := OrderedCollection
			streamContents: [ :aStream | 
				self messages
					messagesDo: [ :eachMessage | aStream nextPut: eachMessage serializeForOllamaMessagesAPI ] ].

	entity := {'stream' -> false.
			'model' -> self model.
			'messages' -> someMessages} asDictionary.
	self format ifNotNil: [ entity at: 'format' put: self format ].
	self tools
		ifNotNil: [ entity at: 'tools' put: (self tools collect: [ :aTool | aTool schema ]) ].
	self instructions
		ifNotNil: [ (entity at: 'messages')
				addFirst: {'role' -> 'system'.
						'content' -> self instructions instructionString} asDictionary ].
	^ entity
]

{ #category : #accessing }
GtLOllamaCompleteChatAPIClient >> format [
	^ format
]

{ #category : #accessing }
GtLOllamaCompleteChatAPIClient >> format: anObject [
	format := anObject
]

{ #category : #accessing }
GtLOllamaCompleteChatAPIClient >> instructions [
	^ instructions
]

{ #category : #accessing }
GtLOllamaCompleteChatAPIClient >> instructions: aString [
	instructions := aString
]

{ #category : #accessing }
GtLOllamaCompleteChatAPIClient >> messages [
	^ messages ifNil: [ #() ]
]

{ #category : #accessing }
GtLOllamaCompleteChatAPIClient >> messages: aCollection [
	messages := aCollection
]

{ #category : #accessing }
GtLOllamaCompleteChatAPIClient >> model [
	^ model
]

{ #category : #accessing }
GtLOllamaCompleteChatAPIClient >> model: anObject [
	model := anObject
]

{ #category : #api }
GtLOllamaCompleteChatAPIClient >> request [
	| response result requestResponse |
	response := self client post: '/chat' withEntity: self entity.
	result := self serializationClass from: response.
	requestResponse := GtLRequestResponse new
		request: self entity;
		response: response;
		result: result.
	result requestResponse: requestResponse.
	^ result
]

{ #category : #api }
GtLOllamaCompleteChatAPIClient >> serializationClass [
	^ GtLOllamaThreadMessage
]

{ #category : #accessing }
GtLOllamaCompleteChatAPIClient >> tools [
	^ tools
]

{ #category : #accessing }
GtLOllamaCompleteChatAPIClient >> tools: aCollection [
	tools := aCollection
]
