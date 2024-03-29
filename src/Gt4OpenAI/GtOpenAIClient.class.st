Class {
	#name : #GtOpenAIClient,
	#superclass : #Object,
	#instVars : [
		'baseUrl',
		'apiKey'
	],
	#category : #'Gt4OpenAI-Client'
}

{ #category : #accessing }
GtOpenAIClient class >> withApiKeyFromClipboard [
	<gtExample>
	^ self new apiKey: Clipboard clipboardText
]

{ #category : #accessing }
GtOpenAIClient >> addMessage: aMessage toThread: aThreadId [
	^ GtOpenAIAddMessageToThreadAPIClient new
		client: self;
		message: aMessage;
		thread: aThreadId;
		perform
]

{ #category : #accessing }
GtOpenAIClient >> apiKey: anApiKey [
	apiKey := anApiKey
]

{ #category : #accessing }
GtOpenAIClient >> baseUrl [
	^ baseUrl
]

{ #category : #accessing }
GtOpenAIClient >> baseUrl: anObject [
	baseUrl := anObject asZnUrl
]

{ #category : #accessing }
GtOpenAIClient >> checkForErrors: aResponse [
	(aResponse includesKey: 'error')
		ifTrue: [ ^ (GtOpenAIError from: (aResponse at: 'error')) signal ].

	^ aResponse
]

{ #category : #'as yet unclassified' }
GtOpenAIClient >> completeChatWithModel: aString andMessages: aCollection [
	^ GtOpenAICompleteChatAPIClient new
		client: self;
		model: aString;
		messages: aCollection;
		perform
]

{ #category : #accessing }
GtOpenAIClient >> createAssistant: anAssistant [ 
	^ GtOpenAICreateAssistantAPIClient new
		client: self;
		assistant: anAssistant;
		perform
]

{ #category : #accessing }
GtOpenAIClient >> createAssistantFile: aFileId forAssistant: anAssistantId [ 
	^ GtOpenAICreateAssistantFileAPIClient new
		client: self;
		assistant: anAssistantId;
		file: aFileId;
		perform
]

{ #category : #accessing }
GtOpenAIClient >> createRunForThread: aThreadId usingAssistant: anAssistantId [
	^ GtOpenAICreateThreadRunAPIClient new
		client: self;
		assistant: anAssistantId;
		thread: aThreadId;
		perform
]

{ #category : #accessing }
GtOpenAIClient >> createThreadWithMessages: aListOfMessages [ 
	^ GtOpenAICreateThreadAPIClient new
		client: self;
		messages: aListOfMessages;
		perform
]

{ #category : #default }
GtOpenAIClient >> defaultBaseUrl [
	^ 'https://api.openai.com/v1' asZnUrl
]

{ #category : #accessing }
GtOpenAIClient >> delete: aUrl [
	| aClient |
	aClient := self initializeClient.
	aClient url: self baseUrl / aUrl.
	
	aClient entity: nil.

	^ self checkForErrors: aClient delete
]

{ #category : #accessing }
GtOpenAIClient >> deleteAssistant: anAssistantId [
	^ GtOpenAIDeleteAssistantAPIClient new
		client: self;
		assistant: anAssistantId;
		perform
]

{ #category : #accessing }
GtOpenAIClient >> deleteFile: aFileId [
	^ GtOpenAIDeleteFileAPIClient new
		client: self;
		file: aFileId;
		perform
]

{ #category : #accessing }
GtOpenAIClient >> generateEmbeddingWithModel: aString andInput: anInputString [
	^ GtOpenAIGenerateEmbeddingAPIClient new
		client: self;
		model: aString;
		input: anInputString;
		perform
]

{ #category : #accessing }
GtOpenAIClient >> get: aUrl [
	| aClient |
	aClient := self initializeClient.
	aClient url: self baseUrl / aUrl.
	
	aClient entity: nil.

	^ self checkForErrors: aClient get
]

{ #category : #accessing }
GtOpenAIClient >> getFile: aFileId [
	^ GtOpenAIGetFileAPIClient new
		client: self;
		file: aFileId;
		perform
]

{ #category : #accessing }
GtOpenAIClient >> getRun: aRunId forThread: aThreadId [
	^ GtOpenAIGetThreadRunAPIClient new
		client: self;
		run: aRunId;
		thread: aThreadId;
		perform
]

{ #category : #accessing }
GtOpenAIClient >> initialize [
	super initialize.

	self baseUrl: self defaultBaseUrl
]

{ #category : #accessing }
GtOpenAIClient >> initializeClient [
	| aClient |
	aClient := ZnClient new.
	aClient forJsonREST.
	aClient headerAt: 'OpenAI-Beta' put: 'assistants=v1'.
	aClient timeout: 60.
	aClient setBearerAuthentication: apiKey.
	aClient beOneShot.
	^ aClient
]

{ #category : #accessing }
GtOpenAIClient >> listMessagesForThread: aThreadId [ 
	^ GtOpenAIListThreadMessagesAPIClient new
		client: self;
		thread: aThreadId;
		perform
]

{ #category : #accessing }
GtOpenAIClient >> listModels [
	^ GtOpenAIListModelsAPIClient new
		client: self;
		perform
]

{ #category : #accessing }
GtOpenAIClient >> post: aString withEntity: anEntity [
	| aClient |
	aClient := self initializeClient.
	aClient url: self baseUrl / aString.

	aClient contents: anEntity.

	^ self checkForErrors: aClient post
]

{ #category : #accessing }
GtOpenAIClient >> postFile: aString withEntity: anEntity [
	| aClient |
	aClient := self initializeClient.
	aClient url: self baseUrl / aString.

	aClient entity: anEntity.

	^ self checkForErrors: aClient post
]

{ #category : #accessing }
GtOpenAIClient >> uploadFile: aFileReference withPurpose: aString [ 
	^ GtOpenAIUploadFileAPIClient new
		client: self;
		file: aFileReference;
		purpose: aString;
		perform
]
