Class {
	#name : #GtLModelClient,
	#superclass : #Object,
	#instVars : [
		'baseUrl',
		'history',
		'clientBuilder'
	],
	#category : #'Gt4LlmModel-Client'
}

{ #category : #accessing }
GtLModelClient class >> defaultBaseUrl [
	^ self subclassResponsibility
]

{ #category : #private }
GtLModelClient >> addHistoryRequestResponse: aClient [
	<return: #GtLRequestResponse>
	
	^ history addRequest: aClient request response: aClient response
]

{ #category : #accessing }
GtLModelClient >> apiClientWithModel: aGtLModel andMessages: aCollection andFormat: aFormat andTools: someTools andInstructions: aStringOrNil [

	^ GtLModelApiUserCommand new
		client: self;
		model: aGtLModel;
		messages: aCollection;
		format: aFormat;
		tools: someTools;
		instructions: aStringOrNil
]

{ #category : #accessing }
GtLModelClient >> assistantMessageClass [

	^ GtLModelAssistantMessage
]

{ #category : #accessing }
GtLModelClient >> baseUrl [
	^ baseUrl
]

{ #category : #accessing }
GtLModelClient >> baseUrl: aZnUrl [

	baseUrl := aZnUrl
]

{ #category : #private }
GtLModelClient >> checkForErrors: aResponse [

	aResponse isDictionary ifFalse: [ ^ aResponse ].
	aResponse at: 'error' ifPresent: [ :errorDetails |
		GtLOllamaError signal: errorDetails ].
	^ aResponse
]

{ #category : #accessing }
GtLModelClient >> clientBuilder [
	^ clientBuilder
]

{ #category : #accessing }
GtLModelClient >> clientBuilder: anObject [
	clientBuilder := anObject
]

{ #category : #api }
GtLModelClient >> completeChatWithModel: aGtLModel andMessages: aCollection andFormat: aFormat andTools: someTools andInstructions: aStringOrNil [

	^ (self 
		apiClientWithModel: aGtLModel 
		andMessages: aCollection 
		andFormat: aFormat 
		andTools: someTools 
		andInstructions: aStringOrNil)
			perform
]

{ #category : #api }
GtLModelClient >> get: aString [
	| aClient result requestResponse |
	aClient := self initializeClient beOneShot.
	aClient url: self baseUrl / aString.
	result := aClient get.
	requestResponse := self addHistoryRequestResponse: aClient.
	requestResponse result: result.
	^ requestResponse
]

{ #category : #ui }
GtLModelClient >> gtCallsFor: aView [
	<gtView>
	^ aView forward
		title: 'History calls';
		object: [ history ];
		view: #gtCallsFor:
]

{ #category : #accessing }
GtLModelClient >> history [
	^ history
]

{ #category : #initialization }
GtLModelClient >> initialize [
	super initialize.
	history := GtLRequestHistory new.
	clientBuilder := GtLOpenAIClientZincBuilder new.
	self baseUrl: self class defaultBaseUrl.
]

{ #category : #initialization }
GtLModelClient >> initializeClient [

	^ clientBuilder create
]

{ #category : #api }
GtLModelClient >> post: aString withEntity: anEntity [
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
