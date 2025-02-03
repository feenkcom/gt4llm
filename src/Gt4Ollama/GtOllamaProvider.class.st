Class {
	#name : #GtOllamaProvider,
	#superclass : #Object,
	#instVars : [
		'assistantWorking',
		'chat',
		'model',
		'client',
		'format',
		'userMessageClass',
		'assistantMessageClass'
	],
	#category : #'Gt4Ollama-Providers'
}

{ #category : #accessing }
GtOllamaProvider >> assistantMessageClass [
	^ assistantMessageClass
]

{ #category : #accessing }
GtOllamaProvider >> assistantMessageClass: anObject [
	assistantMessageClass := anObject
]

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

{ #category : #'as yet unclassified' }
GtOllamaProvider >> defaultAssistantMessageClass [
	^ GtLlmAssistantMessage
]

{ #category : #'as yet unclassified' }
GtOllamaProvider >> defaultUserMessageClass [
	^ GtLlmUserMessage
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
	userMessageClass := self defaultUserMessageClass.
	assistantMessageClass := self defaultAssistantMessageClass.
	
	self initializeClient
]

{ #category : #'as yet unclassified' }
GtOllamaProvider >> initializeClient [
	client := GtOllamaClient new
]

{ #category : #'as yet unclassified' }
GtOllamaProvider >> instructions: aString [
	| internalModelName modelFile |
	internalModelName := 'gt-tutor-' , self model , '-' , UUID new asString.
	modelFile := GtLlmModelFile new
			from: self model;
			system: aString.

	self client createModel: internalModelName withModelFile: modelFile.

	self model: internalModelName
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
		addMessage: aMessage.

	self triggerAssistant
]

{ #category : #'as yet unclassified' }
GtOllamaProvider >> sendMessage: aMessage [
	self
		sendAssistantMessage: (userMessageClass new
				content: aMessage;
				chat: self)
]

{ #category : #'as yet unclassified' }
GtOllamaProvider >> status [
	^ assistantWorking
		ifTrue: [ GtOpenAIAssistantChatWorkingStatus new ]
		ifFalse: [ GtLlmAssistantChatReadyStatus new ]
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

	self chat
		addMessage: (assistantMessageClass new
				content: result content;
				chat: self).

	self chat signalRunIsDone.

	assistantWorking := false
]

{ #category : #accessing }
GtOllamaProvider >> userMessageClass [
	^ userMessageClass
]

{ #category : #accessing }
GtOllamaProvider >> userMessageClass: anObject [
	userMessageClass := anObject
]
