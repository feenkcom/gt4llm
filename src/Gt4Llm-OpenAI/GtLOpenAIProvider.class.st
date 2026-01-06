Class {
	#name : #GtLOpenAIProvider,
	#superclass : #GtLProvider,
	#instVars : [
		'model',
		'client',
		'assistantWorking',
		'isStreaming',
		'executions',
		'tools'
	],
	#category : #'Gt4Llm-OpenAI'
}

{ #category : #'as yet unclassified' }
GtLOpenAIProvider class >> default [
	^ [ self withApiKeyFromFile ]
]

{ #category : #'as yet unclassified' }
GtLOpenAIProvider class >> isConnectable [
	^ GtLOpenAIClient apiKeyFile exists
]

{ #category : #'as yet unclassified' }
GtLOpenAIProvider class >> providerName [
	^ 'OpenAI Chat'
]

{ #category : #'instance creation' }
GtLOpenAIProvider class >> withApiKeyFromClipboard [
	^ self new apiKey: Clipboard clipboardText
]

{ #category : #'as yet unclassified' }
GtLOpenAIProvider class >> withApiKeyFromFile [
	^ self new apiKey: GtLOpenAIClient apiKeyFileContents
]

{ #category : #accessing }
GtLOpenAIProvider >> apiKey: aString [
	client apiKey: aString
]

{ #category : #'as yet unclassified' }
GtLOpenAIProvider >> beNotStreaming [
	isStreaming := false
]

{ #category : #'as yet unclassified' }
GtLOpenAIProvider >> beStreaming [
	isStreaming := true
]

{ #category : #'as yet unclassified' }
GtLOpenAIProvider >> client [
	^ client
]

{ #category : #'as yet unclassified' }
GtLOpenAIProvider >> defaultAssistantMessageClass [
	^ GtLOpenAIAssistantMessage
]

{ #category : #'as yet unclassified' }
GtLOpenAIProvider >> defaultModel [
	^ 'gpt-4.1'
]

{ #category : #'as yet unclassified' }
GtLOpenAIProvider >> defaultUserMessageClass [
	^ GtLOpenAIUserMessage
]

{ #category : #actions }
GtLOpenAIProvider >> executeWait [
	| aSecondPromise aFuture aFirstPromise |
	aFuture := [ | result aMessage currentMessage |
		currentMessage := self chat messages last currentMessage.
		result := client
				generateResponseWithModel: self model
				messages: self chat messages
				instructions: currentMessage buildCompleteInstructions
				tools: currentMessage tools
				andFormat: (currentMessage hasFormats
						ifTrue: [ currentMessage formatDescriptionsJsonSchema ]
						ifFalse: [ nil ])
				isStreaming: isStreaming.

		result hasToolCalls
			ifTrue: [ self performToolCallsIn: result with: currentMessage tools ]
			ifFalse: [ aMessage := isStreaming
						ifTrue: [ self streamingMessageFrom: result ]
						ifFalse: [ self assistantMessageClass new
								model: self model;
								merge: (result output detect: [ :anOutput | (anOutput rawData at: 'type') = 'message' ]) ].

				self chat addAssistantMessage: aMessage.
				self chat signalRunIsDone.
				aMessage ] ] asAsyncFuture.
	aFirstPromise := aFuture
			await: (AsyncFutureExecutionConfiguration new
					customGroup: #OpenAI;
					lowPriority).
	aSecondPromise := aFirstPromise
			then: [ :aMessage |
				assistantWorking := false.
				aMessage ]
			otherwise: [ :anError | 
				| aMessage |
				assistantWorking := false.
				aMessage := GtLErrorMessage freeze: anError.
				self chat addErrorMessage: aMessage.
				self chat signalRunIsDone.
				aMessage ].
	executions add: aSecondPromise.
]

{ #category : #'as yet unclassified' }
GtLOpenAIProvider >> executions [
	^ executions
]

{ #category : #'as yet unclassified' }
GtLOpenAIProvider >> format: anObject [
	super format: anObject.
	
	self beNotStreaming
]

{ #category : #'as yet unclassified' }
GtLOpenAIProvider >> gtExecutionsFor: aView [
	<gtView>
	^ aView list
		title: 'Executions';
		items: [ executions ];
		priority: 10
]

{ #category : #'as yet unclassified' }
GtLOpenAIProvider >> handleToolCall: aToolCall [
	| toolOutput newMessage |
	chat removeLastMessage.
	newMessage := GtLToolMessage new toolCall: aToolCall.	"chat
		addMessage: (GtOpenAIRawToolMessage new
				toolCall: aToolCall;
				rawData: aToolCall rawData)."
	chat addToolMessage: newMessage.
	toolOutput := tools performToolCall: aToolCall.
	newMessage output: toolOutput.
"	chat
		addMessage: (GtLlmToolMessage new
				toolCall: aToolCall;
				output: toolOutput).
"
	self chat signalRunHasUpdated.

	^ self executeWait
]

{ #category : #'as yet unclassified' }
GtLOpenAIProvider >> initialize [
	super initialize.
	
	model := self defaultModel.
	assistantWorking := false.
	
	self initializeClient.
	
	executions := OrderedCollection new.
	isStreaming := true
]

{ #category : #'as yet unclassified' }
GtLOpenAIProvider >> initializeClient [
	client := GtLOpenAIClient new
]

{ #category : #'as yet unclassified' }
GtLOpenAIProvider >> isStreaming: aBoolean [
	isStreaming := aBoolean
]

{ #category : #'as yet unclassified' }
GtLOpenAIProvider >> maximumMessageSize [
	^ 30000
]

{ #category : #accessing }
GtLOpenAIProvider >> model [
	^ model
]

{ #category : #accessing }
GtLOpenAIProvider >> model: anObject [
	model := anObject
]

{ #category : #'as yet unclassified' }
GtLOpenAIProvider >> modelName [
	^ model
]

{ #category : #accessing }
GtLOpenAIProvider >> performToolCallsIn: result with: activeTools [
	| toolOutputs |
	toolOutputs := result toolCalls
			collect: [ :aToolCall | 
				| toolOutput newMessage|
				newMessage := GtLToolMessage new
							toolCall: aToolCall.
				"chat
					addMessage: (GtOpenAIRawToolMessage new
							rawData: aToolCall responseInput)."
				chat addToolMessage: newMessage.
				toolOutput := activeTools performToolCall: aToolCall.
				newMessage output: toolOutput
"				chat
					addMessage: (GtLlmToolMessage new
							toolCall: aToolCall;
							output: toolOutput)" ].

	self chat signalRunHasUpdated.

	^ self executeWait
]

{ #category : #'as yet unclassified' }
GtLOpenAIProvider >> printOn: aStream [
	aStream
		nextPutAll: self class providerName;
		nextPut: $(;
		nextPutAll: self model;
		nextPut: $)
]

{ #category : #'as yet unclassified' }
GtLOpenAIProvider >> sendFiles: aListOfFileReferences withMessage: aString [
	self
		sendAssistantMessage: (self userMessageClass new
				content: {{'type' -> 'input_text'.
							'text' -> aString} asDictionary}
						, (aListOfFileReferences
								collect: [ :aFileReference | 
									{'type' -> 'input_image'.
										'image_url'
											-> ('data:image/jpeg;base64,' , aFileReference binaryContents base64Encoded)}
										asDictionary ]);
				role: 'user';
				chat: self)
]

{ #category : #'as yet unclassified' }
GtLOpenAIProvider >> sendMessage: aMessage [
	self triggerAssistant
]

{ #category : #'as yet unclassified' }
GtLOpenAIProvider >> status [
	^ assistantWorking
		ifTrue: [ GtLlmAssistantChatWorkingStatus new ]
		ifFalse: [ GtLlmAssistantChatReadyStatus new ]
]

{ #category : #utils }
GtLOpenAIProvider >> streamingMessageFrom: aResult [
	| aMessage |
	aResult provider: self.

	aMessage := self assistantMessageClass new
			role: 'assistant';
			model: self model;
			content: ''.
	aResult notifyOnOutput: aMessage.

	^ aMessage
]

{ #category : #'as yet unclassified' }
GtLOpenAIProvider >> triggerAssistant [
	self chat signalRunHasStarted.
	assistantWorking := true.

	self executeWait
]
