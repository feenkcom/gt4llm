Class {
	#name : 'GtOpenAIClient',
	#superclass : 'Object',
	#instVars : [
		'baseUrl',
		'apiKey'
	],
	#classVars : [
		'ApiKeyFile'
	],
	#category : 'Gt4OpenAI'
}

{ #category : 'accessing' }
GtOpenAIClient class >> apiKeyFile [
	^ ApiKeyFile
]

{ #category : 'accessing' }
GtOpenAIClient class >> apiKeyFile: aFile [
	ApiKeyFile := aFile
]

{ #category : 'accessing' }
GtOpenAIClient class >> apiKeyFileContents [
	^ ApiKeyFile contents trimBoth
]

{ #category : 'accessing' }
GtOpenAIClient class >> defaultApiKeyFile [
	^ FileLocator home / '.secrets' / 'open-ai-api-key.txt'
]

{ #category : 'accessing' }
GtOpenAIClient class >> initialize [
	ApiKeyFile := self defaultApiKeyFile
]

{ #category : 'accessing' }
GtOpenAIClient class >> new [
	^ self basicNew initialize
]

{ #category : 'accessing' }
GtOpenAIClient class >> withApiKeyFromFile [
	^ self new apiKey: self apiKeyFileContents
]

{ #category : 'accessing' }
GtOpenAIClient >> addMessage: aMessage toThread: aThreadId [
	^ GtOpenAIAddMessageToThreadAPIClient new
		client: self;
		message: aMessage;
		thread: aThreadId;
		perform
]

{ #category : 'as yet unclassified' }
GtOpenAIClient >> apiKey [
	^ apiKey
]

{ #category : 'accessing' }
GtOpenAIClient >> apiKey: anApiKey [
	apiKey := anApiKey
]

{ #category : 'accessing' }
GtOpenAIClient >> baseUrl [
	^ baseUrl
]

{ #category : 'accessing' }
GtOpenAIClient >> baseUrl: anObject [
	baseUrl := anObject asZnUrl
]

{ #category : 'accessing' }
GtOpenAIClient >> checkForErrors: aResponse [
	((aResponse includesKey: 'error')
		and: [ ((aResponse at: 'error') isKindOf: Collection)
				and: [ (aResponse at: 'error') includesKey: 'message' ] ])
		ifTrue: [ ^ (GtOpenAIError from: (aResponse at: 'error')) signal ].

	^ aResponse
]

{ #category : 'as yet unclassified' }
GtOpenAIClient >> completeChatWithModel: aString andMessages: aCollection [
	^ GtOpenAICompleteChatAPIClient new
		client: self;
		model: aString;
		messages: aCollection;
		perform
]

{ #category : 'accessing' }
GtOpenAIClient >> createAssistant: anAssistant [ 
	^ GtOpenAICreateAssistantAPIClient new
		client: self;
		assistant: anAssistant;
		perform
]

{ #category : 'accessing' }
GtOpenAIClient >> createFineTuningJobOnModel: aModelName withFile: aFileId [
	^ GtOpenAICreateFineTuningJobAPIClient new
		client: self;
		model: aModelName;
		file: aFileId;
		perform
]

{ #category : 'accessing' }
GtOpenAIClient >> createRunForThread: aThreadId usingAssistant: anAssistantId [
	^ GtOpenAICreateThreadRunAPIClient new
		client: self;
		assistant: anAssistantId;
		thread: aThreadId;
		perform
]

{ #category : 'accessing' }
GtOpenAIClient >> createRunForThread: aThreadId usingAssistant: anAssistantId andResponseFormat: aFormat [
	^ GtOpenAICreateThreadRunAPIClient new
		client: self;
		assistant: anAssistantId;
		thread: aThreadId;
		responseFormat: aFormat;
		perform
]

{ #category : 'accessing' }
GtOpenAIClient >> createThreadWithMessages: aListOfMessages [ 
	^ GtOpenAICreateThreadAPIClient new
		client: self;
		messages: aListOfMessages;
		perform
]

{ #category : 'accessing' }
GtOpenAIClient >> createVectorStoreNamed: aName withFiles: aCollectionOfFileIds [
	^ GtOpenAICreateVectorStoreAPIClient new
		client: self;
		name: aName;
		files: aCollectionOfFileIds;
		perform
]

{ #category : 'default' }
GtOpenAIClient >> defaultBaseUrl [
	^ 'https://api.openai.com/v1' asZnUrl
]

{ #category : 'accessing' }
GtOpenAIClient >> delete: aUrl [
	| aClient |
	aClient := self initializeClient.
	aClient url: self baseUrl / aUrl.
	
	aClient entity: nil.

	^ self checkForErrors: aClient delete
]

{ #category : 'accessing' }
GtOpenAIClient >> deleteAssistant: anAssistantId [
	^ GtOpenAIDeleteAssistantAPIClient new
		client: self;
		assistant: anAssistantId;
		perform
]

{ #category : 'accessing' }
GtOpenAIClient >> deleteFile: aFileId [
	^ GtOpenAIDeleteFileAPIClient new
		client: self;
		file: aFileId;
		perform
]

{ #category : 'as yet unclassified' }
GtOpenAIClient >> deleteModel: aModel [ 
	^ GtOpenAIDeleteModelAPIClient new
		client: self;
		model: aModel;
		perform
]

{ #category : 'accessing' }
GtOpenAIClient >> deleteVectorStore: anId [
	^ GtOpenAIDeleteVectorStoreAPIClient new
		client: self;
		vectorStore: anId;
		perform
]

{ #category : 'accessing' }
GtOpenAIClient >> generateEmbeddingsWithModel: aString andInput: anInputString [
	^ GtOpenAIGenerateEmbeddingAPIClient new
		client: self;
		model: aString;
		input: anInputString;
		perform
]

{ #category : 'accessing' }
GtOpenAIClient >> get: aUrl [
	^ self get: aUrl withParams: {}
]

{ #category : 'accessing' }
GtOpenAIClient >> get: aUrl withParams: aListOfAssocs [
	| aClient |
	aClient := self initializeClient.
	aClient url: self baseUrl / aUrl.
	aListOfAssocs do: [ :aPair | aClient queryAt: aPair key put: aPair value ].

	aClient entity: nil.

	^ self checkForErrors: aClient get
]

{ #category : 'accessing' }
GtOpenAIClient >> getFile: aFileId [
	^ GtOpenAIGetFileAPIClient new
		client: self;
		file: aFileId;
		perform
]

{ #category : 'accessing' }
GtOpenAIClient >> getFileContents: aFileId [
	^ GtOpenAIGetFileContentsAPIClient new
		client: self;
		file: aFileId;
		perform
]

{ #category : 'accessing' }
GtOpenAIClient >> getFineTuningCheckpointsForJob: anId [
	^ GtOpenAIGetFineTuningCheckpointsForJobAPIClient new
		client: self;
		job: anId;
		perform
]

{ #category : 'accessing' }
GtOpenAIClient >> getFineTuningEventsForJob: anId [
	^ GtOpenAIGetFineTuningEventsForJobAPIClient new
		client: self;
		job: anId;
		perform
]

{ #category : 'accessing' }
GtOpenAIClient >> getFineTuningJob: anId [
	^ GtOpenAIGetFineTuningJobAPIClient new
		client: self;
		job: anId;
		perform
]

{ #category : 'accessing' }
GtOpenAIClient >> getRun: aRunId forThread: aThreadId [
	^ GtOpenAIGetThreadRunAPIClient new
		client: self;
		run: aRunId;
		thread: aThreadId;
		perform
]

{ #category : 'accessing' }
GtOpenAIClient >> gtModelsFor: aView [
	<gtView>
	^ aView forward
		title: 'Models';
		priority: 1;
		object: [ self listModels ];
		view: #gtViewModelsFor:
]

{ #category : 'accessing' }
GtOpenAIClient >> initialize [
	super initialize.

	self baseUrl: self defaultBaseUrl
]

{ #category : 'accessing' }
GtOpenAIClient >> listAssistants [
	^ GtOpenAIListAssistantsAPIClient new
		client: self;
		perform
]

{ #category : 'accessing' }
GtOpenAIClient >> listFiles [
	^ GtOpenAIListFilesAPIClient new
		client: self;
		perform
]

{ #category : 'accessing' }
GtOpenAIClient >> listMessagesForThread: aThreadId [ 
	^ GtOpenAIListThreadMessagesAPIClient new
		client: self;
		thread: aThreadId;
		perform
]

{ #category : 'accessing' }
GtOpenAIClient >> listModels [
	^ GtOpenAIListModelsAPIClient new
		client: self;
		perform
]

{ #category : 'accessing' }
GtOpenAIClient >> listVectorStores [
	^ GtOpenAIListVectorStoresAPIClient new
		client: self;
		perform
]

{ #category : 'accessing' }
GtOpenAIClient >> post: aString withEntity: anEntity [
	| aClient |
	aClient := self initializeClient.
	aClient url: self baseUrl / aString.

	aClient contents: anEntity.

	^ self checkForErrors: aClient post
]

{ #category : 'accessing' }
GtOpenAIClient >> postFile: aString withEntity: anEntity [
	| aClient |
	aClient := self initializeClient.
	aClient url: self baseUrl / aString.

	aClient entity: anEntity.

	^ self checkForErrors: aClient post
]

{ #category : 'as yet unclassified' }
GtOpenAIClient >> submitToolOutputs: output toThread: aThreadId anRun: aRunId [ 
	^ GtOpenAISubmitToolOutputsAPIClient new
		client: self;
		thread: aThreadId;
		run: aRunId;
		outputs: output;
		perform
]

{ #category : 'accessing' }
GtOpenAIClient >> uploadFile: aFileReference withPurpose: aString [ 
	^ GtOpenAIUploadFileAPIClient new
		client: self;
		file: aFileReference;
		purpose: aString;
		perform
]
