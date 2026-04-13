Class {
	#name : #GtLOllamaClient,
	#superclass : #Object,
	#instVars : [
		'baseUrl',
		'history'
	],
	#category : #'Gt4Llm-Ollama-Client'
}

{ #category : #defaults }
GtLOllamaClient class >> defaultBaseUrl [
	^ 'http://localhost:11434/api' asZnUrl
]

{ #category : #accessing }
GtLOllamaClient >> baseUrl [
	^ baseUrl
]

{ #category : #accessing }
GtLOllamaClient >> baseUrl: anObject [
	baseUrl := anObject
]

{ #category : #private }
GtLOllamaClient >> checkForErrors: aResponse [
	(aResponse isDictionary and: [ aResponse includesKey: 'error' ])
		ifTrue: [ GtLOllamaError signal: (aResponse at: 'error') ].
	^ aResponse
]

{ #category : #api }
GtLOllamaClient >> completeChatWithModel: aString andMessages: aCollection andFormat: aFormat andTools: someTools andInstructions: aStringOrNil [
	^ GtLOllamaCompleteChatAPIClient new
		client: self;
		model: aString;
		messages: aCollection;
		format: aFormat;
		tools: someTools;
		instructions: aStringOrNil;
		perform
]

{ #category : #private }
GtLOllamaClient >> get: aString [
	| aClient response |
	aClient := self initializeClient beOneShot.
	aClient url: self baseUrl / aString.
	response := aClient get.
	history add: (aClient request -> aClient response).
	^ response
]

{ #category : #accessing }
GtLOllamaClient >> history [
	^ history
]

{ #category : #initialization }
GtLOllamaClient >> initialize [
	super initialize.
	self baseUrl: self class defaultBaseUrl.
	history := GtLRequestHistory new
]

{ #category : #private }
GtLOllamaClient >> initializeClient [
	| aClient |
	aClient := ZnClient new.
	aClient forJsonREST.
	aClient timeout: 600.
	^ aClient
]

{ #category : #private }
GtLOllamaClient >> post: aString withEntity: anEntity [
	| aClient response |
	aClient := self initializeClient beOneShot.
	aClient url: self baseUrl / aString.
	aClient contents: anEntity.
	response := aClient post.
	history add: (aClient request -> aClient response).
	^ response
]
