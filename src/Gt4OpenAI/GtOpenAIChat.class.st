Class {
	#name : #GtOpenAIChat,
	#superclass : #GtLlmChat,
	#category : #'Gt4OpenAI-Chats'
}

{ #category : #accessing }
GtOpenAIChat class >> withApiKeyFromClipboard [
	<gtExample>
	^ self new apiKey: Clipboard clipboardText
]

{ #category : #accessing }
GtOpenAIChat class >> withApiKeyFromFile [
	<gtExample>
	^ self new apiKey: GtOpenAIClient apiKeyFileContents
]

{ #category : #accessing }
GtOpenAIChat >> apiKey: aString [
	client apiKey: aString
]

{ #category : #accessing }
GtOpenAIChat >> defaultModel [
	^ 'gpt-4o'
]

{ #category : #accessing }
GtOpenAIChat >> initialize [
	super initialize.
	
	model := self defaultModel
]

{ #category : #accessing }
GtOpenAIChat >> initializeClient [
	client := GtOpenAIClient new
]

{ #category : #accessing }
GtOpenAIChat >> initializeMessages [
	messages := GtOpenAIMessagesGroup new
]

{ #category : #accessing }
GtOpenAIChat >> maximumMessageSize [
	^ 30000
]

{ #category : #accessing }
GtOpenAIChat >> sendMessage: aMessage [
	| result output |
	output := aMessage.
	output size > self maximumMessageSize
		ifTrue: [ output := output first: self maximumMessageSize ].
	messages add: (GtLlmUserMessage new content: output).

	result := client completeChatWithModel: self model andMessages: messages.

	self addMessage: result choices first message
]

{ #category : #accessing }
GtOpenAIChat >> status [
	^ GtOpenAIAssistantChatReadyStatus new
]
