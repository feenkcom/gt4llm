Class {
	#name : #GtLAnthropicClient,
	#superclass : #Object,
	#instVars : [
		'baseUrl',
		'apiKey',
		'version',
		'history'
	],
	#classVars : [
		'ApiKeyFile'
	],
	#category : #'Gt4Llm-Anthropic-Client'
}

{ #category : #'as yet unclassified' }
GtLAnthropicClient class >> apiKeyFile [
	^ ApiKeyFile
]

{ #category : #'as yet unclassified' }
GtLAnthropicClient class >> apiKeyFileContents [
	^ ApiKeyFile contents trimBoth
]

{ #category : #'as yet unclassified' }
GtLAnthropicClient class >> defaultApiKeyFile [
	^ FileLocator home / '.secrets' / 'anthropic-api-key.txt'
]

{ #category : #'as yet unclassified' }
GtLAnthropicClient class >> initialize [
	ApiKeyFile := self defaultApiKeyFile
]

{ #category : #'as yet unclassified' }
GtLAnthropicClient class >> withApiKeyFromClipboard [
	^ self new apiKey: Clipboard clipboardText
]

{ #category : #'as yet unclassified' }
GtLAnthropicClient class >> withApiKeyFromFile [
	^ self new apiKey: self apiKeyFileContents
]

{ #category : #accessing }
GtLAnthropicClient >> addHistoryRequestResponse: aClient [
	<return: #GtLRequestResponse>
	^ history addRequest: aClient request response: aClient response
]

{ #category : #accessing }
GtLAnthropicClient >> apiKey [
	^ apiKey
]

{ #category : #accessing }
GtLAnthropicClient >> apiKey: anObject [
	apiKey := anObject
]

{ #category : #accessing }
GtLAnthropicClient >> baseUrl [
	^ baseUrl
]

{ #category : #accessing }
GtLAnthropicClient >> baseUrl: anObject [
	baseUrl := anObject
]

{ #category : #'as yet unclassified' }
GtLAnthropicClient >> checkForErrors: aResponse [
	((aResponse includesKey: 'error')
		and: [ ((aResponse at: 'error') isKindOf: NeoJSONObject)
				and: [ (aResponse at: 'error') includesKey: 'message' ] ])
		ifTrue: [ ^ (GtAnthropicError from: (aResponse at: 'error')) signal ].

	^ aResponse
]

{ #category : #'as yet unclassified' }
GtLAnthropicClient >> defaultBaseUrl [
	^ 'https://api.anthropic.com/v1/' asZnUrl
]

{ #category : #'as yet unclassified' }
GtLAnthropicClient >> defaultVersion [
	^ '2023-06-01'
]

{ #category : #'as yet unclassified' }
GtLAnthropicClient >> generateResponseWithModel: aString messages: aCollection maxTokens: aNumber instructions: aSystemPrompt tools: tools andFormat: aFormat [ 
	^ GtLAnthropicCompleteChatAPICommand new
		client: self;
		model: aString;
		messages: aCollection;
		maxTokens: aNumber;
		tools: tools;
		system: aSystemPrompt;
		format: aFormat;
		perform
]

{ #category : #'as yet unclassified' }
GtLAnthropicClient >> get: aUrl [
	^ self get: aUrl withParams: {}
]

{ #category : #'as yet unclassified' }
GtLAnthropicClient >> get: aUrl withParams: aListOfAssocs [
	| aClient response |
	aClient := self initializeClient.
	aClient url: self baseUrl / aUrl.
	aListOfAssocs do: [ :aPair | aClient queryAt: aPair key put: aPair value ].

	aClient entity: nil.

	response := aClient get.

	history addRequest: aClient request response: aClient response.

	^ self checkForErrors: response
]

{ #category : #'as yet unclassified' }
GtLAnthropicClient >> gtCallsFor: aView [
	<gtView>
	^ aView forward
		title: 'Calls';
		priority: 5;
		object: [ history ];
		view: #gtCallsFor:
]

{ #category : #'as yet unclassified' }
GtLAnthropicClient >> gtModelsFor: aView [
	<gtView>
	^ aView forward
		title: 'Models';
		priority: 1;
		object: [ self listModels ];
		view: #gtViewModelsFor:
]

{ #category : #'as yet unclassified' }
GtLAnthropicClient >> gtViewCallsWithTokensFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Tokens by call';
		priority: 10;
		items: [ (history collect: [ :each | each -> each resultUsageDetails ])
				reject: [ :each | each value isNil ] ];
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

{ #category : #'as yet unclassified' }
GtLAnthropicClient >> initialize [
	super initialize.
	
	self baseUrl: self defaultBaseUrl.
	self version: self defaultVersion.
	
	history := GtLRequestHistory new
]

{ #category : #'as yet unclassified' }
GtLAnthropicClient >> initializeClient [
	| aClient |
	aClient := ZnClient new.
	aClient forJsonREST.
	aClient timeout: 600.
	aClient headerAt: 'x-api-key' put: apiKey.
	aClient headerAt: 'anthropic-version' put: self version.
	aClient headerAt: 'anthropic-beta' put: 'structured-outputs-2025-11-13'.
	^ aClient
]

{ #category : #'as yet unclassified' }
GtLAnthropicClient >> listModels [
	^ GtAnthropicListModelsAPIClient new
		client: self;
		perform
]

{ #category : #'as yet unclassified' }
GtLAnthropicClient >> post: aUrl withEntity: anEntity [
	| aClient result requestResponse |
	aClient := self initializeClient.
	aClient url: self baseUrl / aUrl.

	aClient contents: anEntity.

	result := aClient post.
	requestResponse := self addHistoryRequestResponse: aClient.
	requestResponse result: result.
	self checkForErrors: result.
	^ requestResponse
]

{ #category : #accessing }
GtLAnthropicClient >> version [
	^ version
]

{ #category : #accessing }
GtLAnthropicClient >> version: anObject [
	version := anObject
]
