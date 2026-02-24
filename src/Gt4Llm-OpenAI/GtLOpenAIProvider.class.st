Class {
	#name : #GtLOpenAIProvider,
	#superclass : #GtLProvider,
	#instVars : [
		'client',
		'executions',
		'tools',
		'modelName',
		'compactionStrategy'
	],
	#category : #'Gt4Llm-OpenAI'
}

{ #category : #testing }
GtLOpenAIProvider class >> isConnectable [
	^ GtLOpenAIClient apiKeyFile exists
]

{ #category : #accessing }
GtLOpenAIProvider class >> providerName [
	^ 'OpenAI provider'
]

{ #category : #'instance creation' }
GtLOpenAIProvider class >> withApiKeyFromClipboard [
	^ self new apiKey: Clipboard clipboardText
]

{ #category : #'instance creation' }
GtLOpenAIProvider class >> withApiKeyFromFile [
	^ self new apiKey: GtLOpenAIClient apiKeyFileContents
]

{ #category : #'instance creation' }
GtLOpenAIProvider class >> withDefaultSetup [
	^ self withApiKeyFromFile
]

{ #category : #accessing }
GtLOpenAIProvider >> apiKey: aString [
	client apiKey: aString
]

{ #category : #configuring }
GtLOpenAIProvider >> beWithApiCompaction [
	compactionStrategy := GtLApiCompactionStrategy forProvider: self.
	compactionStrategy thresholdTokensLimit: self compactionTokensThreshold.
]

{ #category : #configuring }
GtLOpenAIProvider >> beWithNoCompaction [
	compactionStrategy := GtLNoCompactionStrategy forProvider: self
]

{ #category : #configuring }
GtLOpenAIProvider >> beWithPromptCompaction [
	compactionStrategy := GtLPromptCompactionStrategy forProvider: self.
	compactionStrategy thresholdTokensLimit: self compactionTokensThreshold.
]

{ #category : #accessing }
GtLOpenAIProvider >> client [
	^ client
]

{ #category : #'client calls' }
GtLOpenAIProvider >> clientGenerateCompactionResponse: anInputMessage [
	^client 
				generateCompactResponseWithModel: self modelName 
				messages: self relevantChatMessages 
				instructions: nil
]

{ #category : #'client calls' }
GtLOpenAIProvider >> clientGenerateModelResponse: anInputMessage [
	^self 
			clientGenerateModelResponse: anInputMessage 
			messages: self relevantChatMessages
]

{ #category : #'client calls' }
GtLOpenAIProvider >> clientGenerateModelResponse: anInputMessage messages: aCollectionOfMessages [
	^client
			generateResponseWithModel: self modelName
			messages: aCollectionOfMessages
			instructions: anInputMessage completeInstructionString
			tools: anInputMessage tools
			andFormat: (anInputMessage hasFormats
				ifTrue: [ anInputMessage formatDescriptionsJsonSchema ]
				ifFalse: [ nil ])
			isStreaming: false 
]

{ #category : #configuring }
GtLOpenAIProvider >> compactionTokensThreshold [
	^ 220000
]

{ #category : #utils }
GtLOpenAIProvider >> createAPICompactionMessage [  
	| message |
	message := self chat createUserMessage.
	message
		configureWithCompactionExecution;
		addResponseFormatForMagritte: GtLChatCompactedData named: 'Compaction';
		markdown: 'You are performing a CONTEXT CHECKPOINT COMPACTION. Create a handoff summary for another LLM that will resume the task.'.
	^ message
]

{ #category : #accessing }
GtLOpenAIProvider >> defaultAssistantMessageClass [
	^ GtLOpenAIAssistantMessage
]

{ #category : #accessing }
GtLOpenAIProvider >> defaultUserMessageClass [
	^ GtLOpenAIUserMessage
]

{ #category : #'private - execution' }
GtLOpenAIProvider >> ensureContextCompactionIfNeeded [
	compactionStrategy requestCompactionIfNeeded.
]

{ #category : #'private - execution' }
GtLOpenAIProvider >> executeAsyncMessage: anInputMessage [
	<return: #TAsyncPromise>
	| anErrorHandlerPromise aFuture aFirstPromise |
	self privateExecutionState: self state scheduled.
	aFuture := [ 
		self privateExecutionState: self state running.
		self ensureContextCompactionIfNeeded.
		self processNextMessage: anInputMessage ] asAsyncFuture.
	aFirstPromise := aFuture await: GtLOpenAISettings futureExecutionConfiguration.
	anErrorHandlerPromise := aFirstPromise
			then: [ :aProcessedMessage | 
				self privateExecutionState: self state finished.
				self flag: #todo. "Remove signalRunIsDone"
				self chat signalRunIsDone.
				aProcessedMessage ]
			otherwise: [ :anError | 
				| anErrorMessage |
				anErrorMessage := GtLErrorMessage new
						freeze: anError;
						inputMessage: anInputMessage.
				self chat addErrorMessage: anErrorMessage.
				self privateExecutionState: self state finished.
				self flag: #todo. "Remove signalRunIsDone"
				self chat signalRunIsDone.
				anErrorMessage ].
	executions add: anErrorHandlerPromise.
	^ anErrorHandlerPromise
]

{ #category : #'private - execution' }
GtLOpenAIProvider >> executeNextMessage: anInputMessage [
	| result |

	result := anInputMessage executionStrategy
		ifNil: [ self clientGenerateModelResponse: anInputMessage ]
		ifNotNil: [ :aMessageExecutionStrategy |
			aMessageExecutionStrategy executeMessage: anInputMessage with: self ].
	anInputMessage requestResponse: result requestResponse.
	
	^result
]

{ #category : #'private - execution' }
GtLOpenAIProvider >> executeNextPromtCompactionMessage: anInputMessage [
	| relevantMessages result |

	relevantMessages := self relevantChatMessages copyForIndependentRequest.
	relevantMessages addLastExecutionMessage: anInputMessage.
		
	result := self 
		clientGenerateModelResponse: anInputMessage
		messages: relevantMessages.
	anInputMessage requestResponse: result requestResponse.
	
	^result
]

{ #category : #accessing }
GtLOpenAIProvider >> executions [
	^ executions
]

{ #category : #views }
GtLOpenAIProvider >> gtExecutionsFor: aView [
	<gtView>
	^ aView list
		title: 'Executions';
		items: [ executions ];
		priority: 10
]

{ #category : #views }
GtLOpenAIProvider >> gtSpawnClientFor: anAction [
	<gtAction>
	^ anAction button
		icon: BrGlamorousVectorIcons inspect;
		label: 'Client';
		tooltip: 'Spawn client';
		action: [ :button | button phlow spawnObject: client ]
]

{ #category : #views }
GtLOpenAIProvider >> gtViewCallsWithTokensFor: aView [
	<gtView>
	^(aView forward)
		title: 'API calls and tokens';
		priority: 1;
		object: [client];
		view: #gtViewCallsWithTokensFor:
]

{ #category : #'private - execution' }
GtLOpenAIProvider >> handleToolCall: aToolCall [
	| toolMessage |
	chat removeLastMessage.
	toolMessage := GtLToolMessage new 
		toolCall: aToolCall.
	toolMessage chat: chat.
	toolMessage beRunningExecutionState.
	[ |domainObject|
		domainObject := tools performToolCall: aToolCall.
		toolMessage output: domainObject ]
			ensure: [ toolMessage beFinishedExecutionState ].
	self chat signalRunHasUpdated.
	
	"Let's review this when isStreaming works (is used).
	Do we need to call #executeAsyncMessage: 
	or can we call #processNextMessage:?"
	self flag: #todo.
	self executeAsyncMessage: toolMessage
]

{ #category : #initialization }
GtLOpenAIProvider >> initialize [
	super initialize.
	
	modelName := nil.	"set when the provider is built"
	client := GtLOpenAIClient new.
	executions := OrderedCollection new.
	
	self beWithPromptCompaction.
]

{ #category : #accessing }
GtLOpenAIProvider >> modelName [
	^ modelName
]

{ #category : #accessing }
GtLOpenAIProvider >> modelName: aString [
	modelName := aString
]

{ #category : #'private - execution' }
GtLOpenAIProvider >> performToolCallsIn: result with: activeTools [
	<return: #GtLOpenAIProviderProcessedMessage or: nil>
	| toolMessages |
	
	self ensureContextCompactionIfNeeded.
	
	toolMessages := result toolCalls asArray
			withIndexCollect: [ :aToolCall :anIndex | 
				| toolMessage |
				toolMessage := GtLToolMessage new 
					toolCall: aToolCall;
					requestResponse: (GtLToolPreviousRequestResponse new
						previousRequestResponse: result requestResponse;
						toolCallIndex: anIndex).
				chat addToolMessage: toolMessage.
				self state
					ifCanContinue: [ toolMessage beRunningExecutionState.
						[ |domainObject|
						domainObject := activeTools performToolCall: aToolCall.
						toolMessage output: domainObject ]
							ensure: [ toolMessage beFinishedExecutionState ] ]
					ifDisabled: [ toolMessage beSkippedExecutionState ].
				
				toolMessage ].
	self chat signalRunHasUpdated.
	
	"We send all chat messages, so it is enough to process just the last tool message.
	See: `GtLOpenAIGenerateResponseAPICommand>>#buildEntity`."
	toolMessages ifEmpty: [ ^ nil ].
	^ self processNextMessage: toolMessages last.
]

{ #category : #printing }
GtLOpenAIProvider >> printOn: aStream [
	aStream
		nextPutAll: self class providerName;
		nextPut: $(;
		nextPutAll: self modelName;
		nextPutAll: ', ';
		nextPutAll: (self state ifNotNil: #label) asString;
		nextPut: $)
]

{ #category : #'private - execution' }
GtLOpenAIProvider >> processNextMessage: anInputMessage [
	<return: #GtLOpenAIProviderProcessedMessage or: nil>
	| result outputMessage anotherMessage |
	self state ifCanContinue: [  ] ifDisabled: [ ^ nil ].

	result := self executeNextMessage: anInputMessage.
	result hasToolCalls
		ifTrue: [ 
			anotherMessage := self 
				performToolCallsIn: result 
				with: anInputMessage tools ]
		ifFalse: [ 
			outputMessage := self
					responseTypeForResult: result
					fromInputMessage: anInputMessage.
			self chat addAssistantMessage: outputMessage.
			self chat signalRunIsDone ].

	^ GtLOpenAIProviderProcessedMessage new
		inputMessage: anInputMessage;
		result: result;
		isStreaming: false;
		anotherProcessedMessage: anotherMessage;
		outputMessage: outputMessage
]

{ #category : #'private - execution' }
GtLOpenAIProvider >> relevantChatMessages [
	| relevantMessages |
	relevantMessages := self chat messages
			messagesSelect: [:each | each isAssistantRole and: [each hasCompactionResponse]].
	^relevantMessages isEmpty
		ifTrue: [self chat messages]
		ifFalse: [
			self chat messages 
				messagesBeforeMatching: [:each | each isUserRole]
				andAllWithAndAfter: relevantMessages last]
]

{ #category : #'private - execution' }
GtLOpenAIProvider >> responseTypeForResult: aResult fromInputMessage: anInputMessage [ 
	| newMessage |
	newMessage := ((anInputMessage isCompactionRequest
		ifTrue: [ GtLOpenAICompactionMessage ]
		ifFalse: [self assistantMessageClass])) new.
		
	newMessage
			modelName: self modelName;
			initializeFromResult: aResult.
			
	^ newMessage
]

{ #category : #utils }
GtLOpenAIProvider >> sendAPICompactionMessage [  
	^self chat sendMessage:  self createAPICompactionMessage
]
