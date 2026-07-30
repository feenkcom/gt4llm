Class {
	#name : #GtLMiniMaxOpenAIClient,
	#superclass : #Object,
	#instVars : [
		'baseUrl',
		'apiKey',
		'history',
		'clientBuilder'
	],
	#classVars : [
		'ApiKeyFile'
	],
	#category : #'Gt4Llm-MiniMax-Client'
}

{ #category : #accessing }
GtLMiniMaxOpenAIClient class >> apiKeyFile [
	^ ApiKeyFile
]

{ #category : #accessing }
GtLMiniMaxOpenAIClient class >> apiKeyFile: aFile [
	ApiKeyFile := aFile.
	GtLMiniMaxOpenAIProvider notifyProviderConnectabilityChanged
]

{ #category : #accessing }
GtLMiniMaxOpenAIClient class >> apiKeyFileContents [
	^ ApiKeyFile exists 
		ifTrue: [ ApiKeyFile contents trimBoth ] 
		ifFalse: [ '' ]
]

{ #category : #accessing }
GtLMiniMaxOpenAIClient class >> defaultApiKeyFile [
	<gtExample>
	^ FileLocator home / '.secrets' / 'minimax-api-key.txt'
]

{ #category : #accessing }
GtLMiniMaxOpenAIClient class >> initialize [
	ApiKeyFile := self defaultApiKeyFile
]

{ #category : #accessing }
GtLMiniMaxOpenAIClient class >> new [
	^ self basicNew initialize
]

{ #category : #'gt - extensions' }
GtLMiniMaxOpenAIClient class >> withApiKeyFromClipboard [
	^ self new apiKey: Clipboard clipboardText
]

{ #category : #accessing }
GtLMiniMaxOpenAIClient class >> withApiKeyFromFile [
	^ self new apiKey: self apiKeyFileContents
]

{ #category : #accessing }
GtLMiniMaxOpenAIClient >> addHistoryRequestResponse: aClient [
	<return: #GtLRequestResponse>
	^ history addRequest: aClient request response: aClient response
]

{ #category : #accessing }
GtLMiniMaxOpenAIClient >> addMessage: aMessage toThread: aThreadId [
	^ GtLOpenAIAddMessageToThreadAPICommand new
		client: self;
		message: aMessage;
		thread: aThreadId;
		perform
]

{ #category : #'as yet unclassified' }
GtLMiniMaxOpenAIClient >> apiClientWithModel: aString messages: aCollection instructions: anInstruction tools: aCollectionOfTools andFormat: aFormat isStreaming: aBoolean [

	^ GtLOpenAIGenerateResponseAPICommand new
		client: self;
		model: aString;
		messages: aCollection;
		instructions: anInstruction;
		tools: aCollectionOfTools;
		format: aFormat;
		isStreaming: aBoolean
]

{ #category : #'as yet unclassified' }
GtLMiniMaxOpenAIClient >> apiKey [
	^ apiKey
]

{ #category : #accessing }
GtLMiniMaxOpenAIClient >> apiKey: anApiKey [
	apiKey := anApiKey
]

{ #category : #accessing }
GtLMiniMaxOpenAIClient >> apiKeyFile: aFile [
	ApiKeyFile := aFile.
	GtLMiniMaxOpenAIProvider notifyProviderConnectabilityChanged
]

{ #category : #accessing }
GtLMiniMaxOpenAIClient >> baseUrl [
	^ baseUrl
]

{ #category : #accessing }
GtLMiniMaxOpenAIClient >> baseUrl: anObject [
	baseUrl := anObject asZnUrl
]

{ #category : #accessing }
GtLMiniMaxOpenAIClient >> checkForErrors: aResponse [
	((aResponse includesKey: 'error')
		and: [ ((aResponse at: 'error') isKindOf: Collection)
				and: [ (aResponse at: 'error') includesKey: 'message' ] ])
		ifTrue: [ (GtLOpenAIError from: (aResponse at: 'error')) signal ].
]

{ #category : #'api - initialization' }
GtLMiniMaxOpenAIClient >> clientBuilder [
	"For testing purposes only."

	^ clientBuilder
]

{ #category : #accessing }
GtLMiniMaxOpenAIClient >> clientBuilder: aGtLOpenAIClientZincBuilder [
	"For testing purposes only."

	clientBuilder := aGtLOpenAIClientZincBuilder
]

{ #category : #'as yet unclassified' }
GtLMiniMaxOpenAIClient >> completeChatWithModel: aString andMessages: aCollection [
	^ GtLOpenAICompleteChatAPICommand new
		client: self;
		model: aString;
		messages: aCollection;
		perform
]

{ #category : #accessing }
GtLMiniMaxOpenAIClient >> createFineTuningJobOnModel: aModelName withFile: aFileId [
	^ GtLOpenAICreateFineTuningJobAPICommand new
		client: self;
		model: aModelName;
		file: aFileId;
		perform
]

{ #category : #accessing }
GtLMiniMaxOpenAIClient >> createRunForThread: aThreadId usingAssistant: anAssistantId [
	^ GtLOpenAICreateThreadRunAPICommand new
		client: self;
		assistant: anAssistantId;
		thread: aThreadId;
		perform
]

{ #category : #accessing }
GtLMiniMaxOpenAIClient >> createRunForThread: aThreadId usingAssistant: anAssistantId andResponseFormat: aFormat [
	^ GtLOpenAICreateThreadRunAPICommand new
		client: self;
		assistant: anAssistantId;
		thread: aThreadId;
		responseFormat: aFormat;
		perform
]

{ #category : #accessing }
GtLMiniMaxOpenAIClient >> createThreadWithMessages: aListOfMessages [ 
	^ GtLOpenAICreateThreadAPICommand new
		client: self;
		messages: aListOfMessages;
		perform
]

{ #category : #accessing }
GtLMiniMaxOpenAIClient >> createVectorStoreNamed: aName withFiles: aCollectionOfFileIds [
	^ GtLOpenAICreateVectorStoreAPICommand new
		client: self;
		name: aName;
		files: aCollectionOfFileIds;
		perform
]

{ #category : #defaults }
GtLMiniMaxOpenAIClient >> defaultApiKeyFile [
	^ FileLocator home / '.secrets' / 'minimax-api-key.txt'
]

{ #category : #default }
GtLMiniMaxOpenAIClient >> defaultBaseUrl [
	^ 'https://api.minimax.io/v1' asZnUrl
]

{ #category : #accessing }
GtLMiniMaxOpenAIClient >> delete: aUrl [
	<return: #GtLRequestResponse>
	| aClient result requestResponse |
	aClient := self initializeClient.
	aClient url: self baseUrl / aUrl.
	aClient entity: nil.
	result := aClient delete.
	requestResponse := self addHistoryRequestResponse: aClient.
	requestResponse result: result.
	^ requestResponse
]

{ #category : #accessing }
GtLMiniMaxOpenAIClient >> deleteAssistant: anAssistantId [
	^ GtLOpenAIDeleteAssistantAPICommand new
		client: self;
		assistant: anAssistantId;
		perform
]

{ #category : #accessing }
GtLMiniMaxOpenAIClient >> deleteFile: aFileId [
	^ GtLOpenAIDeleteFileAPICommand new
		client: self;
		file: aFileId;
		perform
]

{ #category : #'as yet unclassified' }
GtLMiniMaxOpenAIClient >> deleteModel: aModel [ 
	^ GtLOpenAIDeleteModelAPICommand new
		client: self;
		model: aModel;
		perform
]

{ #category : #accessing }
GtLMiniMaxOpenAIClient >> deleteVectorStore: anId [
	^ GtLOpenAIDeleteVectorStoreAPICommand new
		client: self;
		vectorStore: anId;
		perform
]

{ #category : #'as yet unclassified' }
GtLMiniMaxOpenAIClient >> generateCompactResponseWithModel: aString messages: aCollection instructions: anInstruction [
	^ GtLOpenAICompactAPICommand new
		client: self;
		model: aString;
		messages: aCollection;
		instructions: anInstruction;
		perform 
]

{ #category : #accessing }
GtLMiniMaxOpenAIClient >> generateEmbeddingsWithModel: aString andInput: anInputString [
	^ GtLOpenAIGenerateEmbeddingAPICommand new
		client: self;
		model: aString;
		input: anInputString;
		perform
]

{ #category : #'as yet unclassified' }
GtLMiniMaxOpenAIClient >> generateResponseWithModel: aString andMessages: aCollection [
	^ GtLOpenAIGenerateResponseAPICommand new
		client: self;
		model: aString;
		messages: aCollection;
		perform 
]

{ #category : #'as yet unclassified' }
GtLMiniMaxOpenAIClient >> generateResponseWithModel: aString messages: aCollection instructions: anInstruction tools: aCollectionOfTools andFormat: aFormat [
	^ GtLOpenAIGenerateResponseAPICommand new
		client: self;
		model: aString;
		messages: aCollection;
		instructions: anInstruction;
		tools: aCollectionOfTools;
		format: aFormat;
		perform 
]

{ #category : #'as yet unclassified' }
GtLMiniMaxOpenAIClient >> generateResponseWithModel: aString messages: aCollection instructions: anInstruction tools: aCollectionOfTools andFormat: aFormat isStreaming: aBoolean [

	^ (self apiClientWithModel: aString messages: aCollection instructions: anInstruction tools: aCollectionOfTools andFormat: aFormat isStreaming: aBoolean)
		perform 
]

{ #category : #accessing }
GtLMiniMaxOpenAIClient >> get: aUrl [
	^ self get: aUrl withParams: {}
]

{ #category : #accessing }
GtLMiniMaxOpenAIClient >> get: aUrl withParams: aListOfAssocs [
	<return: #GtLRequestResponse>
	| aClient result requestResponse |
	aClient := self initializeClient.
	aClient url: self baseUrl / aUrl.
	aListOfAssocs do: [ :aPair | aClient queryAt: aPair key put: aPair value ].
	aClient entity: nil.
	result := aClient get.
	requestResponse := self addHistoryRequestResponse: aClient.
	requestResponse result: result.
	self checkForErrors: result.
	^ requestResponse
]

{ #category : #accessing }
GtLMiniMaxOpenAIClient >> getFile: aFileId [
	^ GtLOpenAIGetFileAPICommand new
		client: self;
		file: aFileId;
		perform
]

{ #category : #accessing }
GtLMiniMaxOpenAIClient >> getFileContents: aFileId [
	^ GtLOpenAIGetFileContentsAPICommand new
		client: self;
		file: aFileId;
		perform
]

{ #category : #accessing }
GtLMiniMaxOpenAIClient >> getFineTuningCheckpointsForJob: anId [
	^ GtLOpenAIGetFineTuningCheckpointsForJobAPICommand new
		client: self;
		job: anId;
		perform
]

{ #category : #accessing }
GtLMiniMaxOpenAIClient >> getFineTuningEventsForJob: anId [
	^ GtLOpenAIGetFineTuningEventsForJobAPICommand new
		client: self;
		job: anId;
		perform
]

{ #category : #accessing }
GtLMiniMaxOpenAIClient >> getFineTuningJob: anId [
	^ GtLOpenAIGetFineTuningJobAPICommand new
		client: self;
		job: anId;
		perform
]

{ #category : #accessing }
GtLMiniMaxOpenAIClient >> getRun: aRunId forThread: aThreadId [
	^ GtLOpenAIGetThreadRunAPICommand new
		client: self;
		run: aRunId;
		thread: aThreadId;
		perform
]

{ #category : #'gt - extensions' }
GtLMiniMaxOpenAIClient >> gtCallsFor: aView [
	<gtView>
	^ aView forward
		title: 'Calls';
		priority: 0;
		object: [ history ];
		view: #gtCallsFor:
]

{ #category : #accessing }
GtLMiniMaxOpenAIClient >> gtModelsFor: aView [
	<gtView>
	^ aView forward
		title: 'Models';
		priority: 1;
		object: [ self listModels ];
		view: #gtViewModelsFor:
]

{ #category : #'as yet unclassified' }
GtLMiniMaxOpenAIClient >> gtViewCallsWithTokensFor: aView [
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

{ #category : #accessing }
GtLMiniMaxOpenAIClient >> history [

	^ history
]

{ #category : #accessing }
GtLMiniMaxOpenAIClient >> initialize [
	super initialize.
	history := GtLRequestHistory new.
	clientBuilder := GtLOpenAIClientZincBuilder new.
	self baseUrl: self defaultBaseUrl
]

{ #category : #'private - communication' }
GtLMiniMaxOpenAIClient >> initializeClient [
	^ clientBuilder
		apiKey: apiKey;
		create
]

{ #category : #accessing }
GtLMiniMaxOpenAIClient >> listFiles [
	^ GtLOpenAIListFilesAPICommand new
		client: self;
		perform
]

{ #category : #accessing }
GtLMiniMaxOpenAIClient >> listMessagesForThread: aThreadId [ 
	^ GtLOpenAIListThreadMessagesAPICommand new
		client: self;
		thread: aThreadId;
		perform
]

{ #category : #accessing }
GtLMiniMaxOpenAIClient >> listModels [
	^ GtLOpenAIListModelsAPICommand new
		client: self;
		perform
]

{ #category : #accessing }
GtLMiniMaxOpenAIClient >> listVectorStores [
	^ GtLOpenAIListVectorStoresAPICommand new
		client: self;
		perform
]

{ #category : #'api - initialization' }
GtLMiniMaxOpenAIClient >> loadApiKeyFromFile [

	self apiKey: self class apiKeyFileContents
]

{ #category : #accessing }
GtLMiniMaxOpenAIClient >> post: aString withEntity: anEntity [
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

{ #category : #copying }
GtLMiniMaxOpenAIClient >> postCopy [
	super postCopy.
	
	history := history class new addAll: history.
]

{ #category : #accessing }
GtLMiniMaxOpenAIClient >> postFile: aString withEntity: anEntity [
	<return: #GtLRequestResponse>
	| aClient result requestResponse |
	aClient := self initializeClient.
	aClient url: self baseUrl / aString.
	aClient entity: anEntity.
	result := aClient post.
	requestResponse := self addHistoryRequestResponse: aClient.
	requestResponse result: result.
	self checkForErrors: result.
	^ requestResponse
]

{ #category : #'gt - extensions' }
GtLMiniMaxOpenAIClient >> postStreaming: aString withEntity: anEntity [
	<return: #GtLRequestResponse>
	| aClient result requestResponse |
	aClient := self initializeClient
			streaming: true;
			contentReader: nil.
	aClient url: self baseUrl / aString.
	aClient contents: anEntity.
	result := aClient post.

	requestResponse := self addHistoryRequestResponse: aClient.
	requestResponse result: result.
	^ requestResponse
]

{ #category : #'as yet unclassified' }
GtLMiniMaxOpenAIClient >> submitToolOutputs: output toThread: aThreadId anRun: aRunId [ 
	^ GtLOpenAISubmitToolOutputsAPICommand new
		client: self;
		thread: aThreadId;
		run: aRunId;
		outputs: output;
		perform
]

{ #category : #accessing }
GtLMiniMaxOpenAIClient >> uploadFile: aFileReference withPurpose: aString [ 
	^ GtLOpenAIUploadFileAPICommand new
		client: self;
		file: aFileReference;
		purpose: aString;
		perform
]
