Class {
	#name : #Gt4OpenAIChat,
	#superclass : #Object,
	#instVars : [
		'client',
		'messages',
		'model'
	],
	#category : #'Gt4OpenAI-Chats'
}

{ #category : #accessing }
Gt4OpenAIChat >> addMessage: aMessage [
	messages add: aMessage
]

{ #category : #accessing }
Gt4OpenAIChat >> apiKey: aString [
	client apiKey: aString
]

{ #category : #accessing }
Gt4OpenAIChat >> client [
	^ client
]

{ #category : #accessing }
Gt4OpenAIChat >> client: anObject [
	client := anObject
]

{ #category : #accessing }
Gt4OpenAIChat >> gtMessagesFor: aView [
	<gtView>
	^ aView forward
		title: 'Messages';
		priority: 1;
		object: [ self messages ];
		view: #gtMessagesFor:
]

{ #category : #accessing }
Gt4OpenAIChat >> gtWriteFor: aView [
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
Gt4OpenAIChat >> initialize [
	super initialize.
	
	self initializeClient.
	self initializeMessages
]

{ #category : #accessing }
Gt4OpenAIChat >> initializeClient [
	client := Gt4OpenAIClient new
]

{ #category : #accessing }
Gt4OpenAIChat >> initializeMessages [
	messages := Gt4OpenAIMessagesGroup new
]

{ #category : #accessing }
Gt4OpenAIChat >> messages [
	^ messages
]

{ #category : #accessing }
Gt4OpenAIChat >> messages: anObject [
	messages := anObject
]

{ #category : #accessing }
Gt4OpenAIChat >> model [
	^ model
]

{ #category : #accessing }
Gt4OpenAIChat >> model: anObject [
	model := anObject
]

{ #category : #accessing }
Gt4OpenAIChat >> sendMessage: aMessage [
	| result |
	messages add: (Gt4OpenAIUserMessage new content: aMessage).

	result := client completeChatWithModel: self model andMessages: messages.

	messages add: result choices first message
]
