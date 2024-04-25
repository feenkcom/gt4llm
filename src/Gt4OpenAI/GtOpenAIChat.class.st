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
GtOpenAIChat >> apiKey: aString [
	client apiKey: aString
]

{ #category : #accessing }
GtOpenAIChat >> initialize [
	super initialize.
	
	self initializeClient.
	self initializeMessages
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

	messages add: result choices first message
]
