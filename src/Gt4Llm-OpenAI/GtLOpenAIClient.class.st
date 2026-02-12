Class {
	#name : #GtLOpenAIClient,
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
	#category : #'Gt4Llm-OpenAI'
}

{ #category : #accessing }
GtLOpenAIClient class >> apiKeyFile [
	^ ApiKeyFile
]

{ #category : #accessing }
GtLOpenAIClient class >> apiKeyFile: aFile [
	ApiKeyFile := aFile
]

{ #category : #accessing }
GtLOpenAIClient class >> apiKeyFileContents [
	^ ApiKeyFile exists 
		ifTrue: [ ApiKeyFile contents trimBoth ] 
		ifFalse: [ '' ]
]

{ #category : #accessing }
GtLOpenAIClient class >> defaultApiKeyFile [
	<gtExample>
	^ FileLocator home / '.secrets' / 'open-ai-api-key.txt'
]

{ #category : #accessing }
GtLOpenAIClient class >> initialize [
	ApiKeyFile := self defaultApiKeyFile
]

{ #category : #accessing }
GtLOpenAIClient class >> new [
	^ self basicNew initialize
]

{ #category : #'gt - extensions' }
GtLOpenAIClient class >> withApiKeyFromClipboard [
	^ self new apiKey: Clipboard clipboardText
]

{ #category : #accessing }
GtLOpenAIClient class >> withApiKeyFromFile [
	^ self new apiKey: self apiKeyFileContents
]

{ #category : #accessing }
GtLOpenAIClient >> addHistoryRequestResponse: aClient [
	<return: #GtLRequestResponse>
	^ history addRequest: aClient request response: aClient response
]

{ #category : #accessing }
GtLOpenAIClient >> addMessage: aMessage toThread: aThreadId [
	^ GtLOpenAIAddMessageToThreadAPICommand new
		client: self;
		message: aMessage;
		thread: aThreadId;
		perform
]

{ #category : #'as yet unclassified' }
GtLOpenAIClient >> apiKey [
	^ apiKey
]

{ #category : #accessing }
GtLOpenAIClient >> apiKey: anApiKey [
	apiKey := anApiKey
]

{ #category : #accessing }
GtLOpenAIClient >> baseUrl [
	^ baseUrl
]

{ #category : #accessing }
GtLOpenAIClient >> baseUrl: anObject [
	baseUrl := anObject asZnUrl
]

{ #category : #accessing }
GtLOpenAIClient >> checkForErrors: aResponse [
	((aResponse includesKey: 'error')
		and: [ ((aResponse at: 'error') isKindOf: Collection)
				and: [ (aResponse at: 'error') includesKey: 'message' ] ])
		ifTrue: [ (GtLOpenAIError from: (aResponse at: 'error')) signal ].
]

{ #category : #'api - initialization' }
GtLOpenAIClient >> clientBuilder [
	"For testing purposes only."

	^ clientBuilder
]

{ #category : #'api - initialization' }
GtLOpenAIClient >> clientBuilder: aGtLOpenAIClientStubBuilder [
	"For testing purposes only."

	clientBuilder := aGtLOpenAIClientStubBuilder
]

{ #category : #'as yet unclassified' }
GtLOpenAIClient >> completeChatWithModel: aString andMessages: aCollection [
	^ GtLOpenAICompleteChatAPICommand new
		client: self;
		model: aString;
		messages: aCollection;
		perform
]

{ #category : #accessing }
GtLOpenAIClient >> createFineTuningJobOnModel: aModelName withFile: aFileId [
	^ GtLOpenAICreateFineTuningJobAPICommand new
		client: self;
		model: aModelName;
		file: aFileId;
		perform
]

{ #category : #accessing }
GtLOpenAIClient >> createRunForThread: aThreadId usingAssistant: anAssistantId [
	^ GtLOpenAICreateThreadRunAPICommand new
		client: self;
		assistant: anAssistantId;
		thread: aThreadId;
		perform
]

{ #category : #accessing }
GtLOpenAIClient >> createRunForThread: aThreadId usingAssistant: anAssistantId andResponseFormat: aFormat [
	^ GtLOpenAICreateThreadRunAPICommand new
		client: self;
		assistant: anAssistantId;
		thread: aThreadId;
		responseFormat: aFormat;
		perform
]

{ #category : #accessing }
GtLOpenAIClient >> createThreadWithMessages: aListOfMessages [ 
	^ GtLOpenAICreateThreadAPICommand new
		client: self;
		messages: aListOfMessages;
		perform
]

{ #category : #accessing }
GtLOpenAIClient >> createVectorStoreNamed: aName withFiles: aCollectionOfFileIds [
	^ GtLOpenAICreateVectorStoreAPICommand new
		client: self;
		name: aName;
		files: aCollectionOfFileIds;
		perform
]

{ #category : #default }
GtLOpenAIClient >> defaultBaseUrl [
	^ 'https://api.openai.com/v1' asZnUrl
]

{ #category : #accessing }
GtLOpenAIClient >> delete: aUrl [
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
GtLOpenAIClient >> deleteAssistant: anAssistantId [
	^ GtLOpenAIDeleteAssistantAPICommand new
		client: self;
		assistant: anAssistantId;
		perform
]

{ #category : #accessing }
GtLOpenAIClient >> deleteFile: aFileId [
	^ GtLOpenAIDeleteFileAPICommand new
		client: self;
		file: aFileId;
		perform
]

{ #category : #'as yet unclassified' }
GtLOpenAIClient >> deleteModel: aModel [ 
	^ GtLOpenAIDeleteModelAPICommand new
		client: self;
		model: aModel;
		perform
]

{ #category : #accessing }
GtLOpenAIClient >> deleteVectorStore: anId [
	^ GtLOpenAIDeleteVectorStoreAPICommand new
		client: self;
		vectorStore: anId;
		perform
]

{ #category : #'as yet unclassified' }
GtLOpenAIClient >> generateCompactResponseWithModel: aString messages: aCollection instructions: anInstruction [
	^ GtLOpenAICompactAPICommand new
		client: self;
		model: aString;
		messages: aCollection;
		instructions: anInstruction;
		perform 
]

{ #category : #accessing }
GtLOpenAIClient >> generateEmbeddingsWithModel: aString andInput: anInputString [
	^ GtLOpenAIGenerateEmbeddingAPICommand new
		client: self;
		model: aString;
		input: anInputString;
		perform
]

{ #category : #'as yet unclassified' }
GtLOpenAIClient >> generateResponseWithModel: aString andMessages: aCollection [
	^ GtLOpenAIGenerateResponseAPICommand new
		client: self;
		model: aString;
		messages: aCollection;
		perform 
]

{ #category : #'as yet unclassified' }
GtLOpenAIClient >> generateResponseWithModel: aString messages: aCollection instructions: anInstruction tools: aCollectionOfTools andFormat: aFormat [
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
GtLOpenAIClient >> generateResponseWithModel: aString messages: aCollection instructions: anInstruction tools: aCollectionOfTools andFormat: aFormat isStreaming: aBoolean [
	^ GtLOpenAIGenerateResponseAPICommand new
		client: self;
		model: aString;
		messages: aCollection;
		instructions: anInstruction;
		tools: aCollectionOfTools;
		format: aFormat;
		isStreaming: aBoolean;
		perform 
]

{ #category : #accessing }
GtLOpenAIClient >> get: aUrl [
	^ self get: aUrl withParams: {}
]

{ #category : #accessing }
GtLOpenAIClient >> get: aUrl withParams: aListOfAssocs [
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
GtLOpenAIClient >> getFile: aFileId [
	^ GtLOpenAIGetFileAPICommand new
		client: self;
		file: aFileId;
		perform
]

{ #category : #accessing }
GtLOpenAIClient >> getFileContents: aFileId [
	^ GtLOpenAIGetFileContentsAPICommand new
		client: self;
		file: aFileId;
		perform
]

{ #category : #accessing }
GtLOpenAIClient >> getFineTuningCheckpointsForJob: anId [
	^ GtLOpenAIGetFineTuningCheckpointsForJobAPICommand new
		client: self;
		job: anId;
		perform
]

{ #category : #accessing }
GtLOpenAIClient >> getFineTuningEventsForJob: anId [
	^ GtLOpenAIGetFineTuningEventsForJobAPICommand new
		client: self;
		job: anId;
		perform
]

{ #category : #accessing }
GtLOpenAIClient >> getFineTuningJob: anId [
	^ GtLOpenAIGetFineTuningJobAPICommand new
		client: self;
		job: anId;
		perform
]

{ #category : #accessing }
GtLOpenAIClient >> getRun: aRunId forThread: aThreadId [
	^ GtLOpenAIGetThreadRunAPICommand new
		client: self;
		run: aRunId;
		thread: aThreadId;
		perform
]

{ #category : #'gt - extensions' }
GtLOpenAIClient >> gtCallsFor: aView [
	<gtView>
	^ aView forward
		title: 'Calls';
		priority: 0;
		object: [ history ];
		view: #gtCallsFor:
]

{ #category : #accessing }
GtLOpenAIClient >> gtModelsFor: aView [
	<gtView>
	^ aView forward
		title: 'Models';
		priority: 1;
		object: [ self listModels ];
		view: #gtViewModelsFor:
]

{ #category : #'as yet unclassified' }
GtLOpenAIClient >> gtViewCallsWithTokensFor: aView [
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
GtLOpenAIClient >> initialize [
	super initialize.
	history := GtLRequestHistory new.
	clientBuilder := GtLOpenAIClientZincBuilder new.
	self baseUrl: self defaultBaseUrl
]

{ #category : #'private - communication' }
GtLOpenAIClient >> initializeClient [
	^ clientBuilder
		apiKey: apiKey;
		create
]

{ #category : #accessing }
GtLOpenAIClient >> listFiles [
	^ GtLOpenAIListFilesAPICommand new
		client: self;
		perform
]

{ #category : #accessing }
GtLOpenAIClient >> listMessagesForThread: aThreadId [ 
	^ GtLOpenAIListThreadMessagesAPICommand new
		client: self;
		thread: aThreadId;
		perform
]

{ #category : #accessing }
GtLOpenAIClient >> listModels [
	^ GtLOpenAIListModelsAPICommand new
		client: self;
		perform
]

{ #category : #accessing }
GtLOpenAIClient >> listVectorStores [
	^ GtLOpenAIListVectorStoresAPICommand new
		client: self;
		perform
]

{ #category : #accessing }
GtLOpenAIClient >> post: aString withEntity: anEntity [
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

{ #category : #accessing }
GtLOpenAIClient >> postFile: aString withEntity: anEntity [
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
GtLOpenAIClient >> postStreaming: aString withEntity: anEntity [
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
GtLOpenAIClient >> submitToolOutputs: output toThread: aThreadId anRun: aRunId [ 
	^ GtLOpenAISubmitToolOutputsAPICommand new
		client: self;
		thread: aThreadId;
		run: aRunId;
		outputs: output;
		perform
]

{ #category : #accessing }
GtLOpenAIClient >> uploadFile: aFileReference withPurpose: aString [ 
	^ GtLOpenAIUploadFileAPICommand new
		client: self;
		file: aFileReference;
		purpose: aString;
		perform
]
