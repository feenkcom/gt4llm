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
Gt4OpenAIClient >> createAssistantFile: aFile forAssistant: anAssistant [ 
	^ Gt4OpenAICreateAssistantFileAPIClient new
		client: self;
		assistant: anAssistant;
		file: aFile;
		perform
]

{ #category : #accessing }
Gt4OpenAIClient >> createRunForThread: aThread usingAssistant: anAssistant [
	^ Gt4OpenAICreateThreadRunAPIClient new
		client: self;
		assistant: anAssistant;
		thread: aThread;
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
Gt4OpenAIClient >> getRun: aRun forThread: aThread [
	^ Gt4OpenAIGetThreadRunAPIClient new
		client: self;
		run: aRun;
		thread: aThread;
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
Gt4OpenAIClient >> listMessagesForThread: aThread [ 
	^ Gt4OpenAIListThreadMessagesAPIClient new
		client: self;
		thread: aThread;
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
