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

	aResponse isDictionary ifFalse: [ ^ aResponse ].
	aResponse at: 'error' ifPresent: [ :errorDetails |
		GtLOllamaError signal: errorDetails ].
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
