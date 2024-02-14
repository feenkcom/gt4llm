Class {
	#name : #GtOpenAIChat,
	#superclass : #Object,
	#instVars : [
		'client',
		'messages',
		'model'
	],
	#category : #'Gt4OpenAI-Chats'
}

{ #category : #accessing }
GtOpenAIChat class >> withApiKeyFromClipboard [
	<gtExample>
	^ self new apiKey: Clipboard clipboardText
]

{ #category : #accessing }
GtOpenAIChat >> addMessage: aMessage [
	messages add: aMessage
]

{ #category : #accessing }
GtOpenAIChat >> apiKey: aString [
	client apiKey: aString
]

{ #category : #accessing }
GtOpenAIChat >> client [
	^ client
]

{ #category : #accessing }
GtOpenAIChat >> client: anObject [
	client := anObject
]

{ #category : #accessing }
GtOpenAIChat >> gtMessagesFor: aView [
	<gtView>
	^ aView forward
		title: 'Messages';
		priority: 1;
		object: [ self messages ];
		view: #gtMessagesFor:
]

{ #category : #accessing }
GtOpenAIChat >> gtWriteFor: aView [
	<gtView>
	^ aView textEditor
		title: 'Write';
		priority: 2;
		text: [ 'Write a message here' ];
		actionButtonIcon: BrGlamorousVectorIcons play
			tooltip: 'Send'
			action: [ :aButton | 
				aButton parent parent parent parent
					allChildrenBreadthFirstDetect: [ :anElement | anElement isKindOf: BrEditor ]
					ifFound: [ :anEditor | 
						self sendMessage: anEditor text asString.
						anEditor text: '' ] ]
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
GtOpenAIChat >> messages [
	^ messages
]

{ #category : #accessing }
GtOpenAIChat >> messages: anObject [
	messages := anObject
]

{ #category : #accessing }
GtOpenAIChat >> model [
	^ model
]

{ #category : #accessing }
GtOpenAIChat >> model: anObject [
	model := anObject
]

{ #category : #accessing }
GtOpenAIChat >> sendMessage: aMessage [
	| result |
	messages add: (GtOpenAIUserMessage new content: aMessage).

	result := client completeChatWithModel: self model andMessages: messages.

	messages add: result choices first message
]
