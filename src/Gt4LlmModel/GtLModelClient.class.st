Class {
	#name : #GtLModelClient,
	#superclass : #Object,
	#instVars : [
		'baseUrl',
		'history',
		'clientBuilder',
		'apiKey'
	],
	#classInstVars : [
		'apiKeyFile'
	],
	#category : #'Gt4LlmModel-Client'
}

{ #category : #accessing }
GtLModelClient class >> apiKeyFile [
	^ apiKeyFile ifNil: [ self defaultApiKeyFile ]
]

{ #category : #accessing }
GtLModelClient class >> apiKeyFile: anObject [
	apiKeyFile := anObject
]

{ #category : #accessing }
GtLModelClient class >> apiKeyFileContents [

	^ self apiKeyFile exists 
		ifTrue: [ self apiKeyFile contents trimBoth ] 
		ifFalse: [ '' ]
]

{ #category : #accessing }
GtLModelClient class >> defaultApiKeyFile [
	^ self subclassResponsibility
]

{ #category : #accessing }
GtLModelClient class >> defaultBaseUrl [
	^ self subclassResponsibility
]

{ #category : #'instance creation' }
GtLModelClient class >> withApiKeyFromClipboard [

	^ self new loadApiKeyFromClipboard
]

{ #category : #'instance creation' }
GtLModelClient class >> withApiKeyFromFile [
	^ self new loadApiKeyFromFile
]

{ #category : #private }
GtLModelClient >> addHistoryRequestResponse: aClient [
	<return: #GtLRequestResponse>
	
	^ history addRequest: aClient request response: aClient response
]

{ #category : #accessing }
GtLModelClient >> apiClientWithModel: aGtLModel andMessages: aCollection andFormat: aFormat andTools: someTools andInstructions: aStringOrNil [

	^ GtLModelApiUserCommand new
		client: self;
		model: aGtLModel;
		messages: aCollection;
		format: aFormat;
		tools: someTools;
		instructions: aStringOrNil
]

{ #category : #accessing }
GtLModelClient >> apiKey [
	^ apiKey
]

{ #category : #accessing }
GtLModelClient >> apiKey: anObject [
	apiKey := anObject
]

{ #category : #accessing }
GtLModelClient >> assistantMessageClass [

	^ GtLModelAssistantMessage
]

{ #category : #accessing }
GtLModelClient >> baseUrl [
	^ baseUrl
]

{ #category : #accessing }
GtLModelClient >> baseUrl: aZnUrl [

	baseUrl := aZnUrl
]

{ #category : #private }
GtLModelClient >> checkForErrors: aResponse [
	"Check the supplied response for errors.
	The Ollama OpenAI Responses endpoint will include the error key but provide a nil value even on success."
	
	aResponse isDictionary ifFalse: [ ^ aResponse ].
	aResponse at: 'error' ifPresent: [ :errorDetails |
		errorDetails ifNotNil:
			[ GtLOllamaError signal: errorDetails asString ] ].
	^ aResponse
]

{ #category : #accessing }
GtLModelClient >> clientBuilder [
	^ clientBuilder
]

{ #category : #accessing }
GtLModelClient >> clientBuilder: anObject [
	clientBuilder := anObject
]

{ #category : #api }
GtLModelClient >> completeChatWithModel: aGtLModel andMessages: aCollection andFormat: aFormat andTools: someTools andInstructions: aStringOrNil [

	^ (self 
		apiClientWithModel: aGtLModel 
		andMessages: aCollection 
		andFormat: aFormat 
		andTools: someTools 
		andInstructions: aStringOrNil)
			perform
]

{ #category : #api }
GtLModelClient >> delete: aString withEntity: anEntity [
	<return: #GtLRequestResponse>

	^ self delete: aString withEntity: anEntity decodeResponse: true
]

{ #category : #api }
GtLModelClient >> delete: aString withEntity: anEntity decodeResponse: aBoolean [
	<return: #GtLRequestResponse>
	| aClient result requestResponse |
	aClient := self initializeClient.
	aClient url: self baseUrl / aString.
	aBoolean ifFalse:
		[ aClient contentReader: nil ].
	result := aClient 
		method: #DELETE;
		contents: anEntity;
		execute.
	requestResponse := self addHistoryRequestResponse: aClient.
	requestResponse result: result.
	self checkForErrors: result.
	^ requestResponse
]

{ #category : #api }
GtLModelClient >> get: aString [
	| aClient result requestResponse |
	aClient := self initializeClient beOneShot.
	aClient url: self baseUrl / aString.
	result := aClient get.
	requestResponse := self addHistoryRequestResponse: aClient.
	requestResponse result: result.
	^ requestResponse
]

{ #category : #ui }
GtLModelClient >> gtCallsFor: aView [
	<gtView>
	^ aView forward
		title: 'History calls';
		object: [ history ];
		view: #gtCallsFor:
]

{ #category : #ui }
GtLModelClient >> gtViewCallsWithTokensFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Tokens by call';
		priority: 10;
		items: [ self usageDetails ];
		column: 'URL' text: [ :each | each key request url ];
		column: 'Request'
			text: [ :each | each key request method ]
			width: 100;
		column: 'Response'
			text: [ :each | 
				String
					streamContents: [ :out | each key response statusLine writeOn: out ] ]
			width: 150;
		column: 'Input tokens'
			text: [ :each | each value inputTokens ]
			width: 100;
		column: 'Output tokens'
			text: [ :each | each value outputTokens ]
			width: 100;
		send: #key
]

{ #category : #accessing }
GtLModelClient >> history [
	^ history
]

{ #category : #initialization }
GtLModelClient >> initialize [
	super initialize.
	history := GtLRequestHistory new.
	clientBuilder := GtLOpenAIClientZincBuilder new.
	self baseUrl: self class defaultBaseUrl.
]

{ #category : #initialization }
GtLModelClient >> initializeClient [

	^ clientBuilder
		apiKey: apiKey;
		create
]

{ #category : #initialization }
GtLModelClient >> loadApiKeyFromClipboard [

	self apiKey: Clipboard clipboardText
]

{ #category : #initialization }
GtLModelClient >> loadApiKeyFromFile [

	self apiKey: self class apiKeyFileContents
]

{ #category : #api }
GtLModelClient >> post: aString withEntity: anEntity [
	<return: #GtLRequestResponse>
	| aClient result requestResponse |
	aClient := self initializeClient.
	aClient url: self baseUrl / aString.
	aClient contents: anEntity.
	result := aClient post.
	requestResponse := self addHistoryRequestResponse: aClient.
	requestResponse result: result.
	self checkForErrors: result.
	^ requestResponse
]

{ #category : #ui }
GtLModelClient >> usageDetails [

	^ (history collect: [ :each | each -> each resultUsageDetails ])
				reject: [ :each | each value isNil ]
]
