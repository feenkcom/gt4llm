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

{ #category : #'as yet unclassified' }
Gt4OpenAIClient >> completeChatWithModel: aString andMessages: aCollection [
	^ Gt4OpenAICompleteChatAPIClient new
		client: self;
		model: aString;
		messages: aCollection;
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
	client url: self baseUrl/ aUrl.
	
	^ client get
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

	^ client post
]
