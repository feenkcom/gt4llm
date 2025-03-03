Class {
	#name : #GtOllamaClient,
	#superclass : #Object,
	#instVars : [
		'baseUrl'
	],
	#category : #Gt4Ollama
}

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
	(aResponse includesKey: 'error')
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
	^ 'http://localhost:11434/api' asZnUrl
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
GtOllamaClient >> get: aString [
	| aClient |
	aClient := self initializeClient beOneShot.
	aClient url: self baseUrl / aString.

	^ self checkForErrors: aClient get
]

{ #category : #accessing }
GtOllamaClient >> getModelInformationFor: aName [
	^ GtOllamaGetModelInformationAPIClient new
		client: self;
		model: aName;
		perform
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
	
	self baseUrl: self defaultBaseUrl
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
	| aClient |
	aClient := self initializeClient beOneShot.
	aClient url: self baseUrl / aString.

	aClient contents: anEntity.

	^ self checkForErrors: aClient post
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
