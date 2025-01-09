Class {
	#name : #GtOllamaChat,
	#superclass : #GtLlmChat,
	#instVars : [
		'assistantWorking',
		'format'
	],
	#category : #'Gt4Ollama-Chat'
}

{ #category : #accessing }
GtOllamaChat >> format [
	^ format
]

{ #category : #accessing }
GtOllamaChat >> format: anObject [
	format := anObject
]

{ #category : #accessing }
GtOllamaChat >> gtTriggerAssistantActionFor: anAction [
	<gtAction>
	^ anAction button
		priority: 1;
		tooltip: 'Trigger';
		icon: BrGlamorousVectorIcons refresh;
		action: [ self triggerAssistant ]
]

{ #category : #accessing }
GtOllamaChat >> initialize [
	super initialize.

	assistantWorking := false
]

{ #category : #accessing }
GtOllamaChat >> initializeClient [
	client := GtOllamaClient new
]

{ #category : #accessing }
GtOllamaChat >> initializeMessages [
	messages := GtLlmMessagesGroup new
]

{ #category : #'as yet unclassified' }
GtOllamaChat >> model: aModel [
	super model: aModel.
	
	"ignore pulling errors that occur on local models. worst case is we’ll get an issue later when trying to chat"
	[ self client pullModel: aModel ] on: Error do: [  ]
]

{ #category : #'as yet unclassified' }
GtOllamaChat >> sendAssistantMessage: aMessage [
	messages
		addFirst: (GtLlmUserMessage new
				content: aMessage contentText;
				chat: self).

	self triggerAssistant
]

{ #category : #accessing }
GtOllamaChat >> sendMessage: aMessage [
	self
		sendAssistantMessage: (GtLlmUserMessage new
				content: aMessage;
				chat: self)
]

{ #category : #accessing }
GtOllamaChat >> status [
	^ assistantWorking
		ifTrue: [ GtOpenAIAssistantChatWorkingStatus new ]
		ifFalse: [ GtOpenAIAssistantChatReadyStatus new ]
]

{ #category : #accessing }
GtOllamaChat >> triggerAssistant [
	| result |
	assistantWorking := true.

	self announcer announce: (GtOpenAIThreadRunStartedAnnouncement new run: self).

	result := client
			completeChatWithModel: self model
			andMessages: messages reversed
			andFormat: self format.

	self addMessage: (result asLlmMessage chat: self).

	assistantWorking := false
]
