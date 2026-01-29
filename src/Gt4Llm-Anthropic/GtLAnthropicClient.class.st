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
	#category : 'Gt4Llm-Anthropic-Client'
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
GtLAnthropicClient >> completeChatWithModel: aString messages: aCollection andMaxTokens: anInteger [
	^ self
		completeChatWithModel: aString
		messages: aCollection
		maxTokens: anInteger
		system: nil
		andTools: nil
]

{ #category : #'as yet unclassified' }
GtLAnthropicClient >> completeChatWithModel: aString messages: aCollection maxTokens: aNumber system: aSystemPrompt andTools: tools [
	^ GtLAnthropicCompleteChatAPICommand new
		client: self;
		model: aString;
		messages: aCollection;
		maxTokens: aNumber;
		tools: tools;
		system: aSystemPrompt;
		perform
]

{ #category : #'as yet unclassified' }
GtLAnthropicClient >> completeChatWithModel: aString messages: aCollection maxTokens: aNumber system: aSystemPrompt format: aFormat andTools: tools [
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
GtLAnthropicClient >> defaultBaseUrl [
	^ 'https://api.anthropic.com/v1/' asZnUrl
]

{ #category : #'as yet unclassified' }
GtLAnthropicClient >> defaultVersion [
	^ '2023-06-01'
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

	history add: aClient request -> aClient response.

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
	| aClient response |
	aClient := self initializeClient.
	aClient url: self baseUrl / aUrl.

	aClient contents: anEntity.

	response := aClient post.

	history add: aClient request -> aClient response.

	^ self checkForErrors: response
]

{ #category : #accessing }
GtLAnthropicClient >> version [
	^ version
]

{ #category : #accessing }
GtLAnthropicClient >> version: anObject [
	version := anObject
]
