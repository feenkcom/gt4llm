Class {
	#name : #GtOpenAIProvider,
	#superclass : #Object,
	#instVars : [
		'model',
		'client',
		'chat'
	],
	#category : #'Gt4OpenAI-Providers'
}

{ #category : #'as yet unclassified' }
GtOpenAIProvider class >> withApiKeyFromClipboard [
	^ self new apiKey: Clipboard clipboardText
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
GtOpenAIProvider >> chat [
	^ chat
]

{ #category : #accessing }
GtOpenAIProvider >> chat: anObject [
	chat := anObject
]

{ #category : #'as yet unclassified' }
GtOpenAIProvider >> defaultModel [
	^ 'gpt-4o'
]

{ #category : #'as yet unclassified' }
GtOpenAIProvider >> initialize [
	super initialize.
	
	model := self defaultModel.
	
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
GtOpenAIProvider >> sendAssistantMessage: aMessage [
	| result |
	aMessage serializeInline.
	self chat addMessage: aMessage.

	self chat signalRunHasStarted.

	result := client
			completeChatWithModel: self model
			andMessages: self chat messages.

	self chat addMessage: result choices first message.

	self chat signalRunIsDone
]

{ #category : #'as yet unclassified' }
GtOpenAIProvider >> sendMessage: aMessage [
	| output |
	output := aMessage.
	output size > self maximumMessageSize
		ifTrue: [ output := output first: self maximumMessageSize ].
	self
		sendAssistantMessage: (GtLlmUserMessage new
				content: output;
				chat: self)
]

{ #category : #'as yet unclassified' }
GtOpenAIProvider >> status [
	^ GtLlmAssistantChatReadyStatus new
]
