Class {
	#name : #GtLOllamaClient,
	#superclass : #Object,
	#instVars : [
		'baseUrl',
		'history',
		'reasoningEffort'
	],
	#category : 'Gt4Llm-Ollama-Client'
}

{ #category : #defaults }
GtLOllamaClient class >> defaultBaseUrl [
	^ 'http://localhost:11434/api' asZnUrl
]

{ #category : #private }
GtLOllamaClient >> addHistoryRequestResponse: aClient [
	<return: #GtLRequestResponse>
	^ history addRequest: aClient request response: aClient response
]

{ #category : #api }
GtLOllamaClient >> addThinkingTo: anEntity [
	"Add the receiver's configured reasoning effort to the supplied entity dictionary."

	reasoningEffort ifNil: [ ^ self ].
	anEntity at: 'reasoning_effort' put: reasoningEffort.
]

{ #category : #api }
GtLOllamaClient >> apiClientWithModel: aString andMessages: aCollection andFormat: aFormat andTools: someTools andInstructions: aStringOrNil [

	^ GtLOllamaCompleteChatAPICommand new
		client: self;
		model: aString;
		messages: aCollection;
		format: aFormat;
		tools: someTools;
		instructions: aStringOrNil
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

	^ (self 
		apiClientWithModel: aString 
		andMessages: aCollection 
		andFormat: aFormat 
		andTools: someTools 
		andInstructions: aStringOrNil)
			perform
]

{ #category : #private }
GtLOllamaClient >> get: aString [
	| aClient result requestResponse |
	aClient := self initializeClient beOneShot.
	aClient url: self baseUrl / aString.
	result := aClient get.
	requestResponse := self addHistoryRequestResponse: aClient.
	requestResponse result: result.
	^ requestResponse
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
	<return: #GtLRequestResponse>
	| aClient result requestResponse |
	aClient := self initializeClient beOneShot.
	aClient url: self baseUrl / aString.
	aClient contents: anEntity.
	result := aClient post.
	requestResponse := self addHistoryRequestResponse: aClient.
	requestResponse result: result.
	^ requestResponse
]

{ #category : #accessing }
GtLOllamaClient >> reasoningEffort [
	^ reasoningEffort
]

{ #category : #accessing }
GtLOllamaClient >> reasoningEffort: aSymbol [
	| namedLevels |
	
	namedLevels := #(nil #none #low #medium #high).
	(namedLevels includes: aSymbol) ifFalse:
		[ self error: 'Reasoning effort must be one of ', namedLevels printString, ', not ', aSymbol printString ].
	reasoningEffort := aSymbol
]
