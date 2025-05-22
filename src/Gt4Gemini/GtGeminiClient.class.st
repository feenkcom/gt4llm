Class {
	#name : #GtGeminiClient,
	#superclass : #Object,
	#instVars : [
		'baseUrl',
		'apiKey',
		'history'
	],
	#classVars : [
		'ApiKeyFile'
	],
	#category : #Gt4Gemini
}

{ #category : #'as yet unclassified' }
GtGeminiClient class >> apiKeyFile [
	^ ApiKeyFile
]

{ #category : #'as yet unclassified' }
GtGeminiClient class >> apiKeyFileContents [
	^ ApiKeyFile contents trimBoth
]

{ #category : #'as yet unclassified' }
GtGeminiClient class >> defaultApiKeyFile [
	^ FileLocator home / '.secrets' / 'gemini-api-key.txt'
]

{ #category : #'as yet unclassified' }
GtGeminiClient class >> initialize [
	ApiKeyFile := self defaultApiKeyFile
]

{ #category : #'as yet unclassified' }
GtGeminiClient class >> withApiKeyFromClipboard [
	^ self new apiKey: Clipboard clipboardText
]

{ #category : #'as yet unclassified' }
GtGeminiClient class >> withApiKeyFromFile [
	^ self new apiKey: self apiKeyFileContents
]

{ #category : #accessing }
GtGeminiClient >> apiKey [
	^ apiKey
]

{ #category : #accessing }
GtGeminiClient >> apiKey: anObject [
	apiKey := anObject
]

{ #category : #accessing }
GtGeminiClient >> baseUrl [
	^ baseUrl
]

{ #category : #accessing }
GtGeminiClient >> baseUrl: anObject [
	baseUrl := anObject
]

{ #category : #'as yet unclassified' }
GtGeminiClient >> checkForErrors: aResponse [
	((aResponse includesKey: 'error')
		and: [ ((aResponse at: 'error') isKindOf: NeoJSONObject)
				and: [ (aResponse at: 'error') includesKey: 'message' ] ])
		ifTrue: [ ^ (GtGeminiError from: (aResponse at: 'error')) signal ].

	^ aResponse
]

{ #category : #'as yet unclassified' }
GtGeminiClient >> defaultBaseUrl [
	^ 'https://generativelanguage.googleapis.com/v1beta/' asZnUrl
]

{ #category : #accessing }
GtGeminiClient >> generateContents: aListOfMessages withModel: aModelName [
	^ GtGeminiGenerateContentsAPIClient new
		client: self;
		messages: aListOfMessages;
		model: aModelName;
		perform
]

{ #category : #accessing }
GtGeminiClient >> generateContents: aListOfMessages withModel: aModelName systemInstructions: instructions tools: aListOfTools andFormat: aFormat [
	^ GtGeminiGenerateContentsAPIClient new
		client: self;
		messages: aListOfMessages;
		model: aModelName;
		instructions: instructions;
		tools: aListOfTools;
		format: aFormat;
		perform
]

{ #category : #'as yet unclassified' }
GtGeminiClient >> get: aUrl [
	^ self get: aUrl withParams: {}
]

{ #category : #'as yet unclassified' }
GtGeminiClient >> get: aUrl withParams: aListOfAssocs [
	| aClient response |
	aClient := self initializeClient.
	aClient url: self baseUrl / aUrl.
	aClient queryAt: 'key' put: apiKey.
	aListOfAssocs do: [ :aPair | aClient queryAt: aPair key put: aPair value ].

	aClient entity: nil.

	response := aClient get.

	history add: aClient request -> aClient response.

	^ self checkForErrors: response
]

{ #category : #'as yet unclassified' }
GtGeminiClient >> gtCallsFor: aView [
	<gtView>
	^ aView forward
		title: 'Calls';
		priority: 5;
		object: [ history ];
		view: #gtCallsFor:
]

{ #category : #'as yet unclassified' }
GtGeminiClient >> gtModelsFor: aView [
	<gtView>
	^ aView forward
		title: 'Models';
		priority: 1;
		object: [ self listModels ];
		view: #gtViewModelsFor:
]

{ #category : #'as yet unclassified' }
GtGeminiClient >> initialize [
	super initialize.
	
	self baseUrl: self defaultBaseUrl.
	
	history := GtLlmRequestHistory new
]

{ #category : #'as yet unclassified' }
GtGeminiClient >> initializeClient [
	| aClient |
	aClient := ZnClient new.
	aClient forJsonREST.
	aClient timeout: 600.
	^ aClient
]

{ #category : #'as yet unclassified' }
GtGeminiClient >> listModels [
	^ GtGeminiListModelsAPIClient new
		client: self;
		perform
]

{ #category : #'as yet unclassified' }
GtGeminiClient >> post: aUrl withEntity: anEntity [
	| aClient response |
	aClient := self initializeClient.
	aClient url: self baseUrl / aUrl.
	aClient queryAt: 'key' put: apiKey.

	aClient contents: anEntity.

	response := aClient post.

	history add: aClient request -> aClient response.

	^ self checkForErrors: response
]
