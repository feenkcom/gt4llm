Class {
	#name : #GtOllamaChat,
	#superclass : #GtLlmChat,
	#instVars : [
		'assistantWorking'
	],
	#category : #'Gt4Ollama-Chat'
}

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

{ #category : #accessing }
GtOllamaChat >> sendMessage: aMessage [
	messages
		addFirst: (GtLlmUserMessage new
				content: aMessage;
				chat: self).
	self triggerAssistant
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
			andMessages: messages reversed.

	self addMessage: (result asLlmMessage chat: self).

	assistantWorking := false
]
