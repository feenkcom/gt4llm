Class {
	#name : #GtLOpenAIClient,
	#superclass : #Object,
	#instVars : [
		'baseUrl',
		'apiKey',
		'history'
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
	^ ApiKeyFile contents trimBoth
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
	history add: aClient request -> aClient response
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
		ifTrue: [ ^ (GtLOpenAIError from: (aResponse at: 'error')) signal ].

	^ aResponse
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
	| aClient response |
	aClient := self initializeClient.
	aClient url: self baseUrl / aUrl.
	aClient entity: nil.
	response := aClient delete.
	self addHistoryRequestResponse: aClient.
	^ response
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
	| aClient response |
	aClient := self initializeClient.
	aClient url: self baseUrl / aUrl.
	aListOfAssocs do: [ :aPair | aClient queryAt: aPair key put: aPair value ].
	aClient entity: nil.
	response := aClient get.
	self addHistoryRequestResponse: aClient.
	^ self checkForErrors: response
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

{ #category : #'as yet unclassified' }
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

{ #category : #accessing }
GtLOpenAIClient >> initialize [
	super initialize.
	history := GtLRequestHistory new.
	self baseUrl: self defaultBaseUrl
]

{ #category : #'gt - extensions' }
GtLOpenAIClient >> initializeClient [
	| aClient |
	aClient := ZnClient new.
	aClient forJsonREST.
	aClient headerAt: 'OpenAI-Beta' put: 'assistants=v2'.
	aClient timeout: 1200.
	aClient setBearerAuthentication: apiKey.
	^ aClient
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
	| aClient response |
	aClient := self initializeClient.
	aClient url: self baseUrl / aString.
	aClient contents: anEntity.
	response := aClient post.
	self addHistoryRequestResponse: aClient.
	^ self checkForErrors: response
]

{ #category : #accessing }
GtLOpenAIClient >> postFile: aString withEntity: anEntity [
	| aClient response |
	aClient := self initializeClient.
	aClient url: self baseUrl / aString.
	aClient entity: anEntity.
	response := aClient post.
	self addHistoryRequestResponse: aClient.
	^ self checkForErrors: response
]

{ #category : #'gt - extensions' }
GtLOpenAIClient >> postStreaming: aString withEntity: anEntity [
	| aClient response |
	aClient := self initializeClient
			streaming: true;
			contentReader: nil.
	aClient url: self baseUrl / aString.
	aClient contents: anEntity.
	response := aClient post.

	self addHistoryRequestResponse: aClient.

	^ response
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
