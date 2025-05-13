Class {
	#name : #GtOllamaProvider,
	#superclass : #GtLlmProvider,
	#instVars : [
		'assistantWorking',
		'model',
		'client',
		'modelfile',
		'tools',
		'files'
	],
	#classVars : [
		'DefaultModel'
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
GtOllamaProvider class >> providerName [
	^ 'Ollama'
]

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
GtOllamaProvider >> defaultAssistantMessageClass [
	^ self chat messageClassForOllama
]

{ #category : #'as yet unclassified' }
GtOllamaProvider >> defaultUserMessageClass [
	^ self chat messageClassForOllama
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
	aString isEmptyOrNil ifTrue: [^ self].

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

{ #category : #'as yet unclassified' }
GtOllamaProvider >> modelName [
	^ self modelfile
		ifNil: [ self model ]
		ifNotNil: [ :aFile | aFile directives first text ]
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
GtOllamaProvider >> printOn: aStream [
	aStream
		nextPutAll: self class providerName;
		nextPut: $(;
		nextPutAll: (self modelfile
				ifNil: [ self model ]
				ifNotNil: [ self modelName ]);
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
			andTools: tools.

	self performToolCallsFor: result ]
		doWhileTrue: [ result toolCalls isNotEmpty ].

	self chat
		addMessage: (self assistantMessageClass new
				content: result content;
				role: 'assistant';
				chat: self;
				rawData: result rawData).

	self chat signalRunIsDone.

	assistantWorking := false
]
