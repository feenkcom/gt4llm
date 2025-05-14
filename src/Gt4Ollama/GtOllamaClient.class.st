Class {
	#name : #GtOllamaClient,
	#superclass : #Object,
	#instVars : [
		'baseUrl',
		'history'
	],
	#category : #Gt4Ollama
}

{ #category : #accessing }
GtOllamaClient class >> defaultBaseUrl [
	^ 'http://localhost:11434/api' asZnUrl
]

{ #category : #accessing }
GtOllamaClient >> baseUrl [
	^ baseUrl
]

{ #category : #accessing }
GtOllamaClient >> baseUrl: anObject [
	baseUrl := anObject
]

{ #category : #accessing }
GtOllamaClient >> checkForErrors: aResponse [
	(aResponse isDictionary and: [aResponse includesKey: 'error'])
		ifTrue: [ ^ (GtOllamaError from: (aResponse at: 'error')) signal ].

	^ aResponse
]

{ #category : #accessing }
GtOllamaClient >> completeChatWithModel: aString andMessages: aCollection [
	^ GtOllamaCompleteChatAPIClient new
		client: self;
		model: aString;
		messages: aCollection;
		perform
]

{ #category : #accessing }
GtOllamaClient >> completeChatWithModel: aString andMessages: aCollection andFormat: aFormat [
	^ GtOllamaCompleteChatAPIClient new
		client: self;
		model: aString;
		messages: aCollection;
		format: aFormat;
		perform
]

{ #category : #accessing }
GtOllamaClient >> completeChatWithModel: aString andMessages: aCollection andFormat: aFormat andTools: tools [
	^ GtOllamaCompleteChatAPIClient new
		client: self;
		model: aString;
		messages: aCollection;
		format: aFormat;
		tools: tools;
		perform
]

{ #category : #accessing }
GtOllamaClient >> createModel: aString withModelFile: aModelFile [
	^ GtOllamaCreateModelClient new
		client: self;
		model: aString;
		modelFile: aModelFile;
		perform
]

{ #category : #accessing }
GtOllamaClient >> defaultBaseUrl [
	^ self class defaultBaseUrl
]

{ #category : #accessing }
GtOllamaClient >> deleteModel: aString [
	^ GtOllamaDeleteModelClient new
		client: self;
		model: aString;
		perform
]

{ #category : #accessing }
GtOllamaClient >> generateEmbeddingFor: aString [ 
		^ GtOllamaGenerateEmbeddingsAPIClient new
		client: self;
		input: aString;
		perform
]

{ #category : #accessing }
GtOllamaClient >> generateEmbeddingsWithModel: aModelString andInput: anInputString [
	^ GtOllamaGenerateEmbeddingsAPIClient new
		client: self;
		input: anInputString;
		model: aModelString;
		perform
]

{ #category : #accessing }
GtOllamaClient >> generateResponseWithModel: modelString andPrompt: promptString [

	^ GtOllamaGenerateResponseClient new
		client: self;
		model: modelString;
		prompt: promptString;
		perform
]

{ #category : #accessing }
GtOllamaClient >> generateResponseWithModel: modelString prompt: promptString andImages: anArrayOfStrings [
	^ GtOllamaGenerateResponseClient new
		client: self;
		model: modelString;
		prompt: promptString;
		images: anArrayOfStrings;
		perform
]

{ #category : #accessing }
GtOllamaClient >> get: aString [
	| aClient response |
	aClient := self initializeClient beOneShot.
	aClient url: self baseUrl / aString.


	response := aClient get.
	
	history add: (aClient request -> aClient response).
	
	^ response
]

{ #category : #accessing }
GtOllamaClient >> getModelInformationFor: aName [
	^ GtOllamaGetModelInformationAPIClient new
		client: self;
		model: aName;
		perform
]

{ #category : #'as yet unclassified' }
GtOllamaClient >> gtCallsFor: aView [
	<gtView>
	^ aView forward
		title: 'Calls';
		priority: 5;
		object: [ history ];
		view: #gtCallsFor:
]

{ #category : #accessing }
GtOllamaClient >> gtModelsFor: aView [
	<gtView>
	^ aView forward
		title: 'Models';
		priority: 1;
		object: [ self listModels ];
		view: #gtModelsFor:
]

{ #category : #accessing }
GtOllamaClient >> gtRunningModelsFor: aView [
	<gtView>
	^ aView forward
		title: 'Running models';
		priority: 2;
		object: [self listRunningModels];
		view: #gtModelsFor:
]

{ #category : #accessing }
GtOllamaClient >> initialize [
	super initialize.
	
	self baseUrl: self defaultBaseUrl.
	
	history := GtLlmRequestHistory new
]

{ #category : #accessing }
GtOllamaClient >> listModels [
	^ GtOllamaListModelsClient new
		client: self;
		perform
]

{ #category : #accessing }
GtOllamaClient >> listRunningModels [
	^ GtOllamaListRunningModelsClient new
		client: self;
		perform
]

{ #category : #accessing }
GtOllamaClient >> post: aString withEntity: anEntity [
	| aClient response |
	aClient := self initializeClient beOneShot.
	aClient url: self baseUrl / aString.

	aClient contents: anEntity.

	response := aClient post.
	
	history add: (aClient request -> aClient response).
	
	^ response
]

{ #category : #accessing }
GtOllamaClient >> pullModel: aString [ 
	^ GtOllamaPullModelClient new
		client: self;
		model: aString;
		perform
]

{ #category : #'as yet unclassified' }
GtOllamaClient >> pushModel: aString [ 
	^ GtOllamaPushModelClient new
		client: self;
		model: aString;
		perform
]
