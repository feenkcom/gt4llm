Class {
	#name : #GtOpenAIProvider,
	#superclass : #GtLlmProvider,
	#instVars : [
		'model',
		'client',
		'assistantWorking'
	],
	#category : #Gt4OpenAI
}

{ #category : #'as yet unclassified' }
GtOpenAIProvider class >> default [
	^ [ self withApiKeyFromFile ]
]

{ #category : #'as yet unclassified' }
GtOpenAIProvider class >> isConnectable [
	^ GtOpenAIClient apiKeyFile exists
]

{ #category : #'as yet unclassified' }
GtOpenAIProvider class >> providerName [
	^ 'OpenAI Chat'
]

{ #category : #'as yet unclassified' }
GtOpenAIProvider class >> withApiKeyFromFile [
	^ self new apiKey: GtOpenAIClient apiKeyFileContents
]

{ #category : #accessing }
GtOpenAIProvider >> apiKey: aString [
	client apiKey: aString
]

{ #category : #accessing }
GtOpenAIProvider >> chat: anObject [
	chat := anObject
]

{ #category : #'as yet unclassified' }
GtOpenAIProvider >> client [
	^ client
]

{ #category : #'as yet unclassified' }
GtOpenAIProvider >> defaultAssistantMessageClass [
	^ self chat messageClassForOpenAI
]

{ #category : #'as yet unclassified' }
GtOpenAIProvider >> defaultModel [
	^ 'gpt-4.1'
]

{ #category : #'as yet unclassified' }
GtOpenAIProvider >> defaultUserMessageClass [
	^ self chat messageClassForOpenAI
]

{ #category : #'as yet unclassified' }
GtOpenAIProvider >> initialize [
	super initialize.
	
	model := self defaultModel.
	assistantWorking := false.
	
	self initializeClient
]

{ #category : #'as yet unclassified' }
GtOpenAIProvider >> initializeClient [
	client := GtOpenAIClient new
]

{ #category : #'as yet unclassified' }
GtOpenAIProvider >> maximumMessageSize [
	^ 30000
]

{ #category : #accessing }
GtOpenAIProvider >> model [
	^ model
]

{ #category : #accessing }
GtOpenAIProvider >> model: anObject [
	model := anObject
]

{ #category : #'as yet unclassified' }
GtOpenAIProvider >> modelName [
	^ model
]

{ #category : #'as yet unclassified' }
GtOpenAIProvider >> printOn: aStream [
	aStream
		nextPutAll: self class providerName;
		nextPut: $(;
		nextPutAll: self model;
		nextPut: $)
]

{ #category : #'as yet unclassified' }
GtOpenAIProvider >> sendAssistantMessage: aMessage [
	aMessage serializeInline.
	self chat addMessage: aMessage.
	self triggerAssistant
]

{ #category : #'as yet unclassified' }
GtOpenAIProvider >> status [
	^ assistantWorking
		ifTrue: [ GtLlmAssistantChatWorkingStatus new ]
		ifFalse: [ GtLlmAssistantChatReadyStatus new ]
]

{ #category : #'as yet unclassified' }
GtOpenAIProvider >> triggerAssistant [
	| result |
	self chat signalRunHasStarted.
	assistantWorking := true.

	result := client
			completeChatWithModel: self model
			andMessages: self chat messages.

	self chat
		addMessage: (self assistantMessageClass new
				content: result choices first message content;
				model: self model;
				role: 'assistant').

	assistantWorking := false.
	self chat signalRunIsDone
]
