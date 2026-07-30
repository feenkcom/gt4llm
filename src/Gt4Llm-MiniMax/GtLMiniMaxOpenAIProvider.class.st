Class {
	#name : #GtLMiniMaxOpenAIProvider,
	#superclass : #GtLProvider,
	#instVars : [
		'client',
		'executions',
		'modelName',
		'compactionStrategy'
	],
	#category : #'Gt4Llm-MiniMax'
}

{ #category : #testing }
GtLMiniMaxOpenAIProvider class >> isConnectable [
	^ GtLMiniMaxOpenAIClient apiKeyFile exists
]

{ #category : #'as yet unclassified' }
GtLMiniMaxOpenAIProvider class >> knownConnectors [

	^ {
		GtLConnection new
			providerClass: self;
		label: 'MiniMax-M3';
			model: 'MiniMax-M3'.
		GtLConnection new
			providerClass: self;
		label: 'MiniMax-M2.7';
			model: 'MiniMax-M2.7'.
		GtLConnection new
			providerClass: self;
		label: 'MiniMax-M2.5';
			model: 'MiniMax-M2.5'.
			GtLConnection new
			providerClass: self;
		label: 'MiniMax-M2.1';
			model: 'MiniMax-M2.1'.
		} 
]

{ #category : #accessing }
GtLMiniMaxOpenAIProvider class >> providerName [
	^ 'MiniMax provider'
]

{ #category : #'instance creation' }
GtLMiniMaxOpenAIProvider class >> withApiKeyFromClipboard [
	^ self new apiKey: Clipboard clipboardText
]

{ #category : #'instance creation' }
GtLMiniMaxOpenAIProvider class >> withApiKeyFromFile [
	^ self new apiKey: GtLMiniMaxOpenAIClient apiKeyFileContents
]

{ #category : #'instance creation' }
GtLMiniMaxOpenAIProvider class >> withDefaultSetup [
	^ self withApiKeyFromFile
]

{ #category : #accessing }
GtLMiniMaxOpenAIProvider >> apiKey: aString [
	client apiKey: aString
]

{ #category : #configuring }
GtLMiniMaxOpenAIProvider >> beWithApiCompaction [
	compactionStrategy := GtLApiCompactionStrategy forProvider: self.
	compactionStrategy thresholdTokensLimit: self compactionTokensThreshold.
]

{ #category : #configuring }
GtLMiniMaxOpenAIProvider >> beWithNoCompaction [
	compactionStrategy := GtLNoCompactionStrategy forProvider: self
]

{ #category : #configuring }
GtLMiniMaxOpenAIProvider >> beWithPromptCompaction [
	compactionStrategy := GtLPromptCompactionStrategy forProvider: self.
	compactionStrategy thresholdTokensLimit: self compactionTokensThreshold.
]

{ #category : #accessing }
GtLMiniMaxOpenAIProvider >> client [
	^ client
]

{ #category : #'client calls' }
GtLMiniMaxOpenAIProvider >> clientGenerateCompactionResponse: anInputMessage [
	^client 
				generateCompactResponseWithModel: self modelName 
				messages: self relevantChatMessages 
				instructions: nil
]

{ #category : #'client calls' }
GtLMiniMaxOpenAIProvider >> clientGenerateModelResponse: anInputMessage [
	^self 
			clientGenerateModelResponse: anInputMessage 
			messages: self relevantChatMessages
]

{ #category : #'client calls' }
GtLMiniMaxOpenAIProvider >> clientGenerateModelResponse: anInputMessage messages: aCollectionOfMessages [
	^client
			generateResponseWithModel: self modelName
			messages: aCollectionOfMessages
			instructions: anInputMessage completeInstructionString
			tools: anInputMessage tools
			andFormat: (anInputMessage hasFormats
				ifTrue: [ anInputMessage formatDescriptionsJsonSchemaWithAllRequired ]
				ifFalse: [ nil ])
			isStreaming: false 
]

{ #category : #configuring }
GtLMiniMaxOpenAIProvider >> compactionTokensThreshold [
	^ 220000
]

{ #category : #utils }
GtLMiniMaxOpenAIProvider >> createAPICompactionMessage [  
	| message |
	message := self chat createUserMessage.
	message
		configureWithCompactionExecution;
		addResponseFormatForMagritte: GtLChatCompactedData named: 'Compaction';
		markdown: 'You are performing a CONTEXT CHECKPOINT COMPACTION. Create a handoff summary for another LLM that will resume the task.'.
	^ message
]

{ #category : #accessing }
GtLMiniMaxOpenAIProvider >> defaultAssistantMessageClass [
	^ GtLOpenAIAssistantMessage
]

{ #category : #accessing }
GtLMiniMaxOpenAIProvider >> defaultUserMessageClass [
	^ GtLOpenAIUserMessage
]

{ #category : #'private - execution' }
GtLMiniMaxOpenAIProvider >> ensureContextCompactionIfNeeded [
	compactionStrategy requestCompactionIfNeeded.
]

{ #category : #'private - execution' }
GtLMiniMaxOpenAIProvider >> executeAsyncMessage: anInputMessage [
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
GtLMiniMaxOpenAIProvider >> executeNextMessage: anInputMessage [
	| result |

	result := anInputMessage executionStrategy
		ifNil: [ self clientGenerateModelResponse: anInputMessage ]
		ifNotNil: [ :aMessageExecutionStrategy |
			aMessageExecutionStrategy executeMessage: anInputMessage with: self ].
	anInputMessage requestResponse: result requestResponse.
	
	^result
]

{ #category : #'private - execution' }
GtLMiniMaxOpenAIProvider >> executeNextPromtCompactionMessage: anInputMessage [
	| relevantMessages result |

	relevantMessages := self relevantChatMessages 
		copyForIndependentRequestInChat: self chat.
	relevantMessages addLastExecutionMessage: anInputMessage.
		
	result := self 
		clientGenerateModelResponse: anInputMessage
		messages: relevantMessages.
	anInputMessage requestResponse: result requestResponse.
	
	^result
]

{ #category : #accessing }
GtLMiniMaxOpenAIProvider >> executions [
	^ executions
]

{ #category : #views }
GtLMiniMaxOpenAIProvider >> gtExecutionsFor: aView [
	<gtView>
	^ aView list
		title: 'Executions';
		items: [ executions ];
		priority: 10
]

{ #category : #views }
GtLMiniMaxOpenAIProvider >> gtSpawnClientFor: anAction [
	<gtAction>
	^ anAction button
		icon: BrGlamorousVectorIcons inspect;
		label: 'Client';
		tooltip: 'Spawn client';
		action: [ :button | button phlow spawnObject: client ]
]

{ #category : #views }
GtLMiniMaxOpenAIProvider >> gtViewCallsWithTokensFor: aView [
	<gtView>
	^(aView forward)
		title: 'API calls and tokens';
		priority: 1;
		object: [client];
		view: #gtViewCallsWithTokensFor:
]

{ #category : #initialization }
GtLMiniMaxOpenAIProvider >> initialize [
	super initialize.
	
	modelName := nil.	"set when the provider is built"
	client := GtLMiniMaxOpenAIClient new.
	executions := OrderedCollection new.
	
	self beWithApiCompaction.
]

{ #category : #accessing }
GtLMiniMaxOpenAIProvider >> model [
	"Answer a model matching the receiver's characteristics"
	<return: #GtLLlmModel>

	^ GtLModelFactory new openAi_responses
		name: modelName
]

{ #category : #accessing }
GtLMiniMaxOpenAIProvider >> modelName [
	^ modelName
]

{ #category : #accessing }
GtLMiniMaxOpenAIProvider >> modelName: aString [
	modelName := aString
]

{ #category : #'private - execution' }
GtLMiniMaxOpenAIProvider >> performToolCallsIn: result with: activeTools [
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
						domainObject := activeTools 
							performToolCall: aToolCall
							inContext: (self createToolExecutionContext).
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

{ #category : #copying }
GtLMiniMaxOpenAIProvider >> postCopyForIndependentRequest [
	super postCopyForIndependentRequest.
	
	client := client copy.
	compactionStrategy := compactionStrategy copy.
	executions := OrderedCollection new.
]

{ #category : #printing }
GtLMiniMaxOpenAIProvider >> printOn: aStream [
	aStream
		nextPutAll: self class providerName;
		nextPut: $(;
		nextPutAll: self modelName;
		nextPutAll: ', ';
		nextPutAll: (self state ifNotNil: #label) asString;
		nextPut: $)
]

{ #category : #'private - execution' }
GtLMiniMaxOpenAIProvider >> processNextMessage: anInputMessage [
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
GtLMiniMaxOpenAIProvider >> relevantChatMessages [
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
GtLMiniMaxOpenAIProvider >> responseTypeForResult: aResult fromInputMessage: anInputMessage [ 
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
GtLMiniMaxOpenAIProvider >> sendAPICompactionMessage [  
	^self chat sendMessage:  self createAPICompactionMessage
]

{ #category : #accessing }
GtLMiniMaxOpenAIProvider >> serializeToolMessageForResponse: aToolMessage [
	^ aToolMessage serializeForOpenAIResponsesAPI
]
