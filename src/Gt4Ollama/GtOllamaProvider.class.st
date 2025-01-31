Class {
	#name : #GtOllamaProvider,
	#superclass : #Object,
	#instVars : [
		'assistantWorking',
		'chat',
		'model',
		'client',
		'format'
	],
	#category : #'Gt4Ollama-Providers'
}

{ #category : #accessing }
GtOllamaProvider >> chat [
	^ chat
]

{ #category : #accessing }
GtOllamaProvider >> chat: anObject [
	chat := anObject
]

{ #category : #accessing }
GtOllamaProvider >> client [
	^ client
]

{ #category : #accessing }
GtOllamaProvider >> client: anObject [
	client := anObject
]

{ #category : #accessing }
GtOllamaProvider >> format [
	^ format
]

{ #category : #accessing }
GtOllamaProvider >> format: anObject [
	format := anObject
]

{ #category : #'as yet unclassified' }
GtOllamaProvider >> gtTriggerAssistantActionFor: anAction [
	<gtAction>
	^ anAction button
		priority: 1;
		tooltip: 'Trigger';
		icon: BrGlamorousVectorIcons refresh;
		action: [ self triggerAssistant ]
]

{ #category : #'as yet unclassified' }
GtOllamaProvider >> initialize [
	super initialize.

	assistantWorking := false.
	
	self initializeClient
]

{ #category : #'as yet unclassified' }
GtOllamaProvider >> initializeClient [
	client := GtOllamaClient new
]

{ #category : #accessing }
GtOllamaProvider >> model [
	^ model
]

{ #category : #accessing }
GtOllamaProvider >> model: anObject [
	model := anObject.
	
	"ignore pulling errors that occur on local models. worst case is we’ll get an issue later when trying to chat"
	[ self client pullModel: model ] on: Error do: [  ]
]

{ #category : #'as yet unclassified' }
GtOllamaProvider >> sendAssistantMessage: aMessage [
	self chat
		addMessage: (GtLlmUserMessage new
				content: aMessage contentText;
				chat: self).

	self triggerAssistant
]

{ #category : #'as yet unclassified' }
GtOllamaProvider >> sendMessage: aMessage [
	self
		sendAssistantMessage: (GtLlmUserMessage new
				content: aMessage;
				chat: self)
]

{ #category : #'as yet unclassified' }
GtOllamaProvider >> status [
	^ assistantWorking
		ifTrue: [ GtOpenAIAssistantChatWorkingStatus new ]
		ifFalse: [ GtOpenAIAssistantChatReadyStatus new ]
]

{ #category : #'as yet unclassified' }
GtOllamaProvider >> triggerAssistant [
	| result |
	assistantWorking := true.

	self chat signalRunHasStarted.
	result := self client
			completeChatWithModel: self model
			andMessages: self chat messages
			andFormat: self format.

	self chat addMessage: (result asLlmMessage chat: self).

	self chat signalRunIsDone.

	assistantWorking := false
]
