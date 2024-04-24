Class {
	#name : #GtOllamaClient,
	#superclass : #Object,
	#instVars : [
		'baseUrl'
	],
	#category : #'Gt4Ollama-Chat'
}

{ #category : #accessing }
GtOllamaClient >> baseUrl [
	^ baseUrl
]

{ #category : #accessing }
GtOllamaClient >> baseUrl: anObject [
	baseUrl := anObject
]

{ #category : #accessing }
GtOllamaClient >> checkForErrors: aResponse [
	(aResponse includesKey: 'error')
		ifTrue: [ ^ (GtOllamaError from: (aResponse at: 'error')) signal ].

	^ aResponse
]

{ #category : #accessing }
GtOllamaClient >> completeChatWithModel: aString andMessages: aCollection [
	^ GtOllamaCompleteChatAPIClient new
		client: self;
		model: aString;
		messages: aCollection;
		perform
]

{ #category : #accessing }
GtOllamaClient >> defaultBaseUrl [
	^ 'http://localhost:11434/api' asZnUrl
]

{ #category : #accessing }
GtOllamaClient >> get: aString [
	| aClient |
	aClient := self initializeClient beOneShot.
	aClient url: self baseUrl / aString.

	^ self checkForErrors: aClient get
]

{ #category : #accessing }
GtOllamaClient >> initialize [
	super initialize.
	
	self baseUrl: self defaultBaseUrl
]

{ #category : #accessing }
GtOllamaClient >> initializeClient [
	| aClient |
	aClient := ZnClient new.
	aClient forJsonREST.
	aClient timeout: 60.
	^ aClient
]

{ #category : #accessing }
GtOllamaClient >> listModels [
	^ GtOllamaListModelsClient new
		client: self;
		perform
]

{ #category : #accessing }
GtOllamaClient >> post: aString withEntity: anEntity [
	| aClient |
	aClient := self initializeClient beOneShot.
	aClient url: self baseUrl / aString.

	aClient contents: anEntity.

	^ self checkForErrors: aClient post
]

{ #category : #accessing }
GtOllamaClient >> postStreaming: aString withEntity: anEntity [
	| aClient aResult |
	aClient := self initializeClient
			accept: 'application/x-ndjson';
			contentReader: [ :entity | 
				| jsonStream |
				jsonStream := NeoJSONReader on: entity readStream.
				Array
					streamContents: [ :out | [ jsonStream atEnd ] whileFalse: [ out nextPut: jsonStream next ] ] ].
	aClient url: self baseUrl / aString.

	aClient contents: anEntity.

	aResult := aClient post.

	aResult size > 0 ifTrue: [ self checkForErrors: aResult first ].

	^ aResult
]

{ #category : #accessing }
GtOllamaClient >> pullModel: aString [ 
	^ GtOllamaPullModelClient new
		client: self;
		model: aString;
		perform
]
