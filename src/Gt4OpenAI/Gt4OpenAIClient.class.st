Class {
	#name : #Gt4OpenAIClient,
	#superclass : #Object,
	#instVars : [
		'baseUrl',
		'apiKey'
	],
	#category : #'Gt4OpenAI-Client'
}

{ #category : #accessing }
Gt4OpenAIClient class >> withApiKeyFromClipboard [
	<gtExample>
	^ self new apiKey: Clipboard clipboardText
]

{ #category : #accessing }
Gt4OpenAIClient >> addMessage: aMessage toThread: aThreadId [
	^ Gt4OpenAIAddMessageToThreadAPIClient new
		client: self;
		message: aMessage;
		thread: aThreadId;
		perform
]

{ #category : #accessing }
Gt4OpenAIClient >> apiKey: anApiKey [
	apiKey := anApiKey
]

{ #category : #accessing }
Gt4OpenAIClient >> baseUrl [
	^ baseUrl
]

{ #category : #accessing }
Gt4OpenAIClient >> baseUrl: anObject [
	baseUrl := anObject asZnUrl
]

{ #category : #accessing }
Gt4OpenAIClient >> checkForErrors: aResponse [
	(aResponse includesKey: 'error')
		ifTrue: [ ^ (Gt4OpenAIError from: (aResponse at: 'error')) signal ].

	^ aResponse
]

{ #category : #'as yet unclassified' }
Gt4OpenAIClient >> completeChatWithModel: aString andMessages: aCollection [
	^ Gt4OpenAICompleteChatAPIClient new
		client: self;
		model: aString;
		messages: aCollection;
		perform
]

{ #category : #accessing }
Gt4OpenAIClient >> createAssistant: anAssistant [ 
	^ Gt4OpenAICreateAssistantAPIClient new
		client: self;
		assistant: anAssistant;
		perform
]

{ #category : #accessing }
Gt4OpenAIClient >> createAssistantFile: aFileId forAssistant: anAssistantId [ 
	^ Gt4OpenAICreateAssistantFileAPIClient new
		client: self;
		assistant: anAssistantId;
		file: aFileId;
		perform
]

{ #category : #accessing }
Gt4OpenAIClient >> createRunForThread: aThreadId usingAssistant: anAssistantId [
	^ Gt4OpenAICreateThreadRunAPIClient new
		client: self;
		assistant: anAssistantId;
		thread: aThreadId;
		perform
]

{ #category : #accessing }
Gt4OpenAIClient >> createThreadWithMessages: aListOfMessages [ 
	^ Gt4OpenAICreateThreadAPIClient new
		client: self;
		messages: aListOfMessages;
		perform
]

{ #category : #default }
Gt4OpenAIClient >> defaultBaseUrl [
	^ 'https://api.openai.com/v1' asZnUrl
]

{ #category : #accessing }
Gt4OpenAIClient >> generateEmbeddingWithModel: aString andInput: anInputString [
	^ Gt4OpenAIGenerateEmbeddingAPIClient new
		client: self;
		model: aString;
		input: anInputString;
		perform
]

{ #category : #accessing }
Gt4OpenAIClient >> get: aUrl [
	| aClient |
	aClient := self initializeClient.
	aClient url: self baseUrl / aUrl.
	
	aClient entity: nil.

	^ self checkForErrors: aClient get
]

{ #category : #accessing }
Gt4OpenAIClient >> getFile: aFileId [
	^ Gt4OpenAIGetFileAPIClient new
		client: self;
		file: aFileId;
		perform
]

{ #category : #accessing }
Gt4OpenAIClient >> getRun: aRunId forThread: aThreadId [
	^ Gt4OpenAIGetThreadRunAPIClient new
		client: self;
		run: aRunId;
		thread: aThreadId;
		perform
]

{ #category : #accessing }
Gt4OpenAIClient >> initialize [
	super initialize.

	self baseUrl: self defaultBaseUrl
]

{ #category : #accessing }
Gt4OpenAIClient >> initializeClient [
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
Gt4OpenAIClient >> listMessagesForThread: aThreadId [ 
	^ Gt4OpenAIListThreadMessagesAPIClient new
		client: self;
		thread: aThreadId;
		perform
]

{ #category : #accessing }
Gt4OpenAIClient >> listModels [
	^ Gt4OpenAIListModelsAPIClient new
		client: self;
		perform
]

{ #category : #accessing }
Gt4OpenAIClient >> post: aString withEntity: anEntity [
	| aClient |
	aClient := self initializeClient.
	aClient url: self baseUrl / aString.

	aClient contents: anEntity.

	^ self checkForErrors: aClient post
]

{ #category : #accessing }
Gt4OpenAIClient >> postFile: aString withEntity: anEntity [
	| aClient |
	aClient := self initializeClient.
	aClient url: self baseUrl / aString.

	aClient entity: anEntity.

	^ self checkForErrors: aClient post
]

{ #category : #accessing }
Gt4OpenAIClient >> uploadFile: aFileReference withPurpose: aString [ 
	^ Gt4OpenAIUploadFileAPIClient new
		client: self;
		file: aFileReference;
		purpose: aString;
		perform
]
