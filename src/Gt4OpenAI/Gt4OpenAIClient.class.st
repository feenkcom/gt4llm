Class {
	#name : #Gt4OpenAIClient,
	#superclass : #Object,
	#instVars : [
		'client',
		'baseUrl',
		'apiKey'
	],
	#category : #'Gt4OpenAI-Client'
}

{ #category : #accessing }
Gt4OpenAIClient >> apiKey: anApiKey [
	apiKey := anApiKey.

	client setBearerAuthentication: apiKey
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
	client url: self baseUrl / aUrl.

	^ self checkForErrors: client get
]

{ #category : #accessing }
Gt4OpenAIClient >> initialize [
	super initialize.
	
	self initializeClient.
	self baseUrl: self defaultBaseUrl
]

{ #category : #accessing }
Gt4OpenAIClient >> initializeClient [
	client := ZnClient new.
	client forJsonREST.
	client headerAt: 'OpenAI-Beta' put: 'assistants=v1'.
	client timeout: 60
]

{ #category : #accessing }
Gt4OpenAIClient >> listModels [
	^ Gt4OpenAIListModelsAPIClient new
		client: self;
		perform
]

{ #category : #accessing }
Gt4OpenAIClient >> post: aString withEntity: anEntity [
	client url: self baseUrl / aString.

	client contents: anEntity.

	^ self checkForErrors: client post
]

{ #category : #accessing }
Gt4OpenAIClient >> postFile: aString withEntity: anEntity [
	client url: self baseUrl / aString.

	client entity: anEntity.

	^ self checkForErrors: client post
]

{ #category : #accessing }
Gt4OpenAIClient >> uploadFile: aFileReference withPurpose: aString [ 
	^ Gt4OpenAIUploadFileAPIClient new
		client: self;
		file: aFileReference;
		purpose: aString;
		perform
]
