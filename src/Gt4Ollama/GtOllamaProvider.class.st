Class {
	#name : #GtOllamaProvider,
	#superclass : #GtLlmProvider,
	#instVars : [
		'assistantWorking',
		'model',
		'client',
		'tools',
		'files',
		'executions',
		'instructions'
	],
	#classVars : [
		'DefaultModel',
		'IsConnectable'
	],
	#category : #Gt4Ollama
}

{ #category : #'as yet unclassified' }
GtOllamaProvider class >> default [
	^ [ self new model: self defaultModel ]
]

{ #category : #'as yet unclassified' }
GtOllamaProvider class >> defaultModel [
	^ DefaultModel ifNil: [ DefaultModel := 'llama3.1' ]
]

{ #category : #'as yet unclassified' }
GtOllamaProvider class >> initialize [
	IsConnectable := false
]

{ #category : #'as yet unclassified' }
GtOllamaProvider class >> markConnectable [
	IsConnectable := true
]

{ #category : #'as yet unclassified' }
GtOllamaProvider class >> markNonconnectable [
	IsConnectable := false
]

{ #category : #'as yet unclassified' }
GtOllamaProvider class >> providerName [
	^ 'Ollama'
]

{ #category : #'as yet unclassified' }
GtOllamaProvider >> addTool: aTool [
	tools add: aTool
]

{ #category : #'as yet unclassified' }
GtOllamaProvider >> baseUrl: aUrl [
	self client baseUrl: aUrl
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
	^ self chat messageClassForOllama
]

{ #category : #'as yet unclassified' }
GtOllamaProvider >> defaultUserMessageClass [
	^ self chat messageClassForOllama
]

{ #category : #'as yet unclassified' }
GtOllamaProvider >> executions [
	^ executions
]

{ #category : #accessing }
GtOllamaProvider >> files [
	^ files
]

{ #category : #accessing }
GtOllamaProvider >> files: anObject [
	files := anObject
]

{ #category : #'as yet unclassified' }
GtOllamaProvider >> gtToolsFor: aView [
	<gtView>
	^ aView forward
		title: 'Tools';
		priority: 5;
		object: [ tools ];
		view: #gtItemsFor:
]

{ #category : #'as yet unclassified' }
GtOllamaProvider >> initialize [
	super initialize.

	assistantWorking := false.
	executions := OrderedCollection new.
	
	self initializeClient.
	
	tools := GtLlmToolsGroup new
]

{ #category : #'as yet unclassified' }
GtOllamaProvider >> initializeClient [
	client := GtOllamaClient new
]

{ #category : #'as yet unclassified' }
GtOllamaProvider >> instructions [
	^ instructions
]

{ #category : #'as yet unclassified' }
GtOllamaProvider >> instructions: aString [
	instructions := aString
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
GtOllamaProvider >> modelName [
	^ self model
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
						output: toolOutput) ].
	self chat signalRunHasUpdated
]

{ #category : #'as yet unclassified' }
GtOllamaProvider >> printOn: aStream [
	aStream
		nextPutAll: self class providerName;
		nextPut: $(;
		nextPutAll: self modelName;
		nextPut: $)
]

{ #category : #'as yet unclassified' }
GtOllamaProvider >> sendAssistantMessage: aMessage [
    | userMessage |
	userMessage := self userMessageClass new merge: aMessage.
	userMessage role: 'user'.
	self chat addMessage: userMessage.

	self asyncWait
]

{ #category : #'as yet unclassified' }
GtOllamaProvider >> sendFiles: aCollection withMessage: aString [
	| userMessage |
	userMessage := self userMessageClass new
			content: aString;
			images: (aCollection collect: [ :aFile | aFile binaryContents base64Encoded ]);
			role: 'user';
			chat: self.

	self chat addMessage: userMessage.

	self asyncWait
]

{ #category : #'as yet unclassified' }
GtOllamaProvider >> status [
	^ assistantWorking
		ifTrue: [ GtLlmAssistantChatWorkingStatus new ]
		ifFalse: [ GtLlmAssistantChatReadyStatus new ]
]

{ #category : #accessing }
GtOllamaProvider >> tools [
	^ tools
]

{ #category : #accessing }
GtOllamaProvider >> tools: anObject [
	tools := anObject
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
			andTools: tools
			andInstructions: self instructions.

	self performToolCallsFor: result ] doWhileTrue: [ result toolCalls isNotEmpty ].

	self chat
		addMessage: (self assistantMessageClass new
				content: result content;
				role: 'assistant';
				model: self modelName;
				chat: self;
				rawData: result rawData).

	self chat signalRunIsDone.

	assistantWorking := false
]
