Class {
	#name : #GtOllamaProvider,
	#superclass : #GtLlmProvider,
	#instVars : [
		'assistantWorking',
		'model',
		'client',
		'modelfile',
		'tools'
	],
	#category : #Gt4Ollama
}

{ #category : #'as yet unclassified' }
GtOllamaProvider >> addTool: aTool [
	tools add: aTool
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
GtOllamaProvider >> initialize [
	super initialize.

	assistantWorking := false.
	
	self initializeClient.
	
	tools := GtLlmToolsGroup new
]

{ #category : #'as yet unclassified' }
GtOllamaProvider >> initializeClient [
	client := GtOllamaClient new
]

{ #category : #'as yet unclassified' }
GtOllamaProvider >> instructions: aString [
	| internalModelName modelFile |
	internalModelName := 'gt-tutor-' , self model , '-' , self uuidClass new asString.
	modelFile := GtLlmModelFile new
			from: self model;
			system: aString.

	self client createModel: internalModelName withModelFile: modelFile.
	
	self modelfile: modelFile.

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

{ #category : #accessing }
GtOllamaProvider >> modelfile [
	^ modelfile
]

{ #category : #accessing }
GtOllamaProvider >> modelfile: anObject [
	modelfile := anObject
]

{ #category : #'as yet unclassified' }
GtOllamaProvider >> performToolCallsFor: aResult [
	aResult toolCalls
		do: [ :aToolCall | 
			| toolOutput |
			toolOutput := tools performToolCall: aToolCall.
			chat
				addMessage: (GtLlmToolMessage new
						toolCall: aToolCall;
						output: toolOutput) ]
]

{ #category : #'as yet unclassified' }
GtOllamaProvider >> sendAssistantMessage: aMessage [
	userMessageClass adoptInstance: aMessage.
	aMessage role: 'user'.
	self chat addMessage: aMessage.

	[ self triggerAssistant ] asAsyncPromise
]

{ #category : #'as yet unclassified' }
GtOllamaProvider >> status [
	^ assistantWorking
		ifTrue: [ GtLlmAssistantChatWorkingStatus new ]
		ifFalse: [ GtLlmAssistantChatReadyStatus new ]
]

{ #category : #'as yet unclassified' }
GtOllamaProvider >> triggerAssistant [
	| result |
	assistantWorking := true.

	self chat signalRunHasStarted.
	[ result := self client
			completeChatWithModel: self model
			andMessages: self chat messages
			andFormat: self format
			andTools: tools.

	self performToolCallsFor: result ]
		doWhileTrue: [ result toolCalls isNotEmpty ].

	self chat
		addMessage: (assistantMessageClass new
				content: result content;
				role: 'assistant';
				chat: self;
				rawData: result rawData).

	self chat signalRunIsDone.

	assistantWorking := false
]
